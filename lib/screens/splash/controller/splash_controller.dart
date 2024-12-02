import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/config/app_route.dart';
import 'package:premiere_league_v2/main.dart';

class SplashController extends BaseController {
  late AppLinks _appLinks;
  @override
  void onInit() {
    _checkForDeepLink();
    _delay();
    Future.delayed(Duration.zero, () => _checkForDeepLink());
    FlutterNativeSplash.remove();
    super.onInit();
  }

  void _checkForDeepLink() async {
    _appLinks = AppLinks();
    final initialLink = await _appLinks.getInitialLinkString();
    if (initialLink != null) {
      logger.i('Initial Deep Link: $initialLink');
      _handleDeepLink(initialLink);
    }
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
  void onDispose() {}

  void _delay() {
    logger.i("splash 2");
    Future.delayed(const Duration(seconds: 4))
        .then((_) => AppNav.navigator.pushNamedAndRemoveUntil(
              AppRoute.main,
              (route) => false,
            ));
  }
}
