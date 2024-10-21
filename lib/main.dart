import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/firebase_handler.dart';

import 'components/api_services/api_client.dart';
import 'components/config/app_const.dart';
import 'components/config/app_route.dart';
import 'components/config/app_theme.dart';
import 'components/util/network.dart';
import 'components/util/storage_util.dart';

final getIt = GetIt.instance;
// initialize firebase handler
final FirebaseHandler firebaseHandler = FirebaseHandler();

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
  static RouteObserver<PageRoute>? get routeObserver =>
      RouteObserver<PageRoute>();
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notification = message.notification;
  final notificationTitle = notification?.title ?? 'No Title';
  final id = message.data['id'] ?? 'No ID';

  logger.i("Handling a background message: $notificationTitle && $id");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await firebaseHandler.initializeFirebase();

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

  await firebaseHandler.initializeNotifications();
  await firebaseHandler.firebaseListener();
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
    super.initState();
    logger.i('MyApp initState');
    _checkForDeepLinkingWhenAppIsOpened();
  }

  void _checkForDeepLinkingWhenAppIsOpened() {
    final appLinks = AppLinks();
    // Listen to app links when the app is already running
    appLinks.uriLinkStream.listen((Uri? uri) {
      logger.i('Deep Link Stream: $uri');
      if (uri != null) {
        _handleDeepLink(uri.toString());
      }
    });
  }

  void _handleDeepLink(String link) {
    final uri = Uri.parse(link);
    final pathSegments = uri.pathSegments;

    logger.i('Handling deep link: $uri');

    if (pathSegments.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Ensure route observer is initialized
        final currentRoute = ModalRoute.of(AppNav.context)?.settings.name;
        logger.i('Current route: $currentRoute');

        // Only navigate if the deep link route is different from the current route
        if (pathSegments.length == 1 &&
            pathSegments.first == "home" &&
            currentRoute != AppRoute.teamFcListScreen) {
          logger.i('Navigating to home');
          AppNav.navigator.pushNamed(AppRoute.teamFcListScreen);
        } else if (pathSegments.length > 1 && pathSegments.first == "detail") {
          final teamName = pathSegments.last;
          if (currentRoute != AppRoute.teamFcDetailScreen) {
            logger.i('Navigating to detail: $teamName');
            AppNav.navigator
                .pushNamed(AppRoute.teamFcDetailScreen, arguments: teamName);
          }
        } else if (pathSegments.length == 1 &&
            pathSegments.first == "favorite" &&
            currentRoute != AppRoute.favTeamFcScreen) {
          logger.i("Navigating to favorite");
          AppNav.navigator.pushNamed(AppRoute.favTeamFcScreen);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.i("MyApp build");
    final appTheme = AppDefaultThemeData();
    return AppTheme(
      themeData: appTheme,
      child: MaterialApp(
        title: AppConst.appName,
        theme: appTheme.themeData(),
        initialRoute: AppRoute.splashScreen,
        onGenerateRoute: AppRoute.generateRoute,
        navigatorKey: AppNav._navigatorKey,
      ),
    );
  }
}
