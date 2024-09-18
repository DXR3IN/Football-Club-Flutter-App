import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/api_services/firebase_api.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _dependencyInjection();

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
  final LocalNotificationService notificationService =
      LocalNotificationService();
  await notificationService.initNotification();
  await Firebase.initializeApp();
  FirebaseApi firebaseApi = FirebaseApi();
  await firebaseApi.requestPermision();
}

class MyApp extends StatefulWidget {
  @override
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.onMessage.listen(
      (event) {
        if (event.notification != null) {
          print(event.notification!.title);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        if (event.notification != null) {
          print(event.notification!.title);
        }
      },
    );

    
    super.initState();
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
