import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/notification_service/permission.dart';
import 'package:premiere_league_v2/components/notification_service/local_notification_service.dart';

import 'components/api_services/api_client.dart';
import 'components/config/app_const.dart';
import 'components/config/app_route.dart';
import 'components/config/app_theme.dart';
import 'components/util/network.dart';
import 'components/util/storage_util.dart';

final getIt = GetIt.instance;

final logger = Logger(
  level: kDebugMode ? Level.all : Level.warning,
  output: MultiOutput([
    ConsoleOutput(),
  ]),
);

class AppNav {
  static final _navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? get maybeContext => _navigatorKey.currentContext;
  static BuildContext get context => maybeContext!;
  static NavigatorState get navigator => _navigatorKey.currentState!;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _dependencyInjection();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  mainContext.config = ReactiveConfig.main.clone(
    readPolicy: ReactiveReadPolicy.never,
    writePolicy: ReactiveWritePolicy.never,
  );

  runApp(const MyApp());
}

/// ====== DI Section =====
/// Add dependency here when you need to use/available for all feature
/// ====== end =======
Future _dependencyInjection() async {
  getIt.registerLazySingleton<IStorage>(() => SecureStorage());
  getIt.registerLazySingleton(() => Network.dioClient());
  getIt.registerLazySingleton(() => ApiClient(getIt()));

  // Initialize the local notification service
  final LocalNotificationService notificationService =
      LocalNotificationService();
  await notificationService.initNotification();

  // Initialize Firebase
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request permissions for notifications
  Permission firebaseApi = Permission();
  await firebaseApi.requestPermision();
}

class MyApp extends StatefulWidget {
  @override
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  @override
  void initState() {
    super.initState();

    // Initialize the local notification service (if needed)
    _initializeNotifications();

    // Listen to Firebase messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _localNotificationService.showLocalNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: message.notification!.title,
          body: message.notification!.body,
          payload: message.data['route'], 
        );
      }
    });

    // Handle messages when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("Notification clicked: ${message.notification!.title}");
        _handleNotificationNavigation(message);
      }
    });
  }

  Future<void> _initializeNotifications() async {
    await _localNotificationService.initNotification();
    FirebaseMessaging.instance.getToken().then((String? token) {
      print("Firebase Messaging Token: $token");
    });
  }

  // Handle the notification tap to navigate to a specific screen
  void _handleNotificationNavigation(RemoteMessage message) {
    String? route = message.data['route'];
    if (route != null && AppNav.maybeContext != null) {
      Navigator.pushNamed(AppNav.context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppDefaultThemeData();
    return AppTheme(
      themeData: appTheme,
      child: MaterialApp(
        title: AppConst.appName,
        theme: appTheme.themeData(),
        initialRoute: AppRoute.teamFcListScreen,
        onGenerateRoute: AppRoute.generateRoute,
        navigatorKey: AppNav._navigatorKey,
      ),
    );
  }
}
