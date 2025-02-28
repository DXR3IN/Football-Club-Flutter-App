import 'package:app_links/app_links.dart';
import 'package:drift/native.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/util/local_database/data_equipment.dart';
import 'package:premiere_league_v2/firebase_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:premiere_league_v2/localization_provider.dart';
import 'package:provider/provider.dart';

import 'components/api_services/api_client.dart';
import 'components/config/app_const.dart';
import 'components/config/app_route.dart';
import 'components/config/app_theme.dart';
import 'components/util/network.dart';
import 'components/util/storage_util.dart';

final getIt = GetIt.instance;
// initialize firebase handler
final FirebaseHandler firebaseHandler = FirebaseHandler();

final Logger logger = Logger(
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

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

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
  getIt
      .registerLazySingleton<Database>(() => Database(NativeDatabase.memory()));
  getIt.registerLazySingleton<LocalizationProvider>(
      () => LocalizationProvider());

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
  final _storage = getIt.get<IStorage>();
  final localizationProvider = getIt.get<LocalizationProvider>();

  @override
  void initState() {
    super.initState();
    logger.i('MyApp initState');
    _fetchLocale().then(
      (locale) => localizationProvider.setLocale(locale),
    );
    Future.delayed(Duration.zero, () => _checkForDeepLinkingWhenAppIsOpened());
  }

  Future<Locale> _fetchLocale() async {
    var prefs = await _storage.getLanguage();

    String languageCode = prefs?.split('-').firstOrNull ?? 'en';
    return Locale(languageCode);
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

  bool isRouteActive(String routeName) {
    bool isActive = false;
    AppNav.navigator.popUntil((route) {
      if (route.settings.name == routeName) {
        isActive = true;
      }
      return true;
    });
    return isActive;
  }

  bool _navigationTriggered = false;

  void _handleDeepLink(String link) {
    if (_navigationTriggered) return;
    _navigationTriggered = true;

    final uri = Uri.parse(link);
    final pathSegments = uri.pathSegments;

    logger.i('Handling deep link: $uri');

    if (pathSegments.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentRoute = ModalRoute.of(AppNav.context)?.settings.name;
        logger.i('Current route: $currentRoute');

        if (pathSegments.length == 1 &&
            pathSegments.first == "home" &&
            !isRouteActive(AppRoute.teamFcListScreen)) {
          logger.i('Navigating to home');
          AppNav.navigator.pushNamed(AppRoute.teamFcListScreen);
        } else if (pathSegments.length > 1 && pathSegments.first == "detail") {
          final teamName = pathSegments.last;
          if (!isRouteActive(AppRoute.teamFcDetailScreen)) {
            logger.i('Navigating to detail: $teamName');
            AppNav.navigator
                .pushNamed(AppRoute.teamFcDetailScreen, arguments: teamName);
          }
        } else if (pathSegments.length == 1 &&
            pathSegments.first == "favorite" &&
            !isRouteActive(AppRoute.favTeamFcScreen)) {
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt.get<LocalizationProvider>(),
        ),
      ],
      child: Consumer<LocalizationProvider>(
        builder: (context, localizationProvider, child) {
          return AppTheme(
            themeData: appTheme,
            child: MaterialApp(
              locale: localizationProvider.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              title: AppConst.appName,
              theme: appTheme.themeData(),
              initialRoute: AppRoute.splashScreen,
              onGenerateInitialRoutes: (String initialRoute) {
                return [
                  AppRoute.generateRoute(
                      const RouteSettings(name: AppRoute.splashScreen)),
                ];
              },
              onGenerateRoute: AppRoute.generateRoute,
              navigatorKey: AppNav._navigatorKey,
            ),
          );
        },
      ),
    );
  }
}
