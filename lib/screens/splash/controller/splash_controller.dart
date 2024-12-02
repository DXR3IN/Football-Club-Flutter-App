import 'package:app_links/app_links.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/config/app_route.dart';
import 'package:premiere_league_v2/main.dart';

class SplashController extends BaseController {
  late AppLinks _appLinks;
  @override
  void onInit() {
    FlutterNativeSplash.remove();
    _checkForDeepLink();
    _delay();
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

  void _handleDeepLink(String link) {
    final uri = Uri.parse(link);
    final pathSegments = uri.pathSegments;

    logger.i('Handling deep link: $uri');

    if (pathSegments.isNotEmpty) {
      if (pathSegments.length == 1 && pathSegments.first == "home") {
        logger.i('Navigating to home');
        AppNav.navigator.pushNamed(AppRoute.teamFcListScreen);
      } else if (pathSegments.length > 1 && pathSegments.first == "detail") {
        final teamName = pathSegments.last;
        logger.i('Navigating to detail: $teamName');
        AppNav.navigator
            .pushNamed(AppRoute.teamFcDetailScreen, arguments: teamName);
      } else if (pathSegments.length > 1 && pathSegments.first == "favorite") {
        logger.i("Navigating to favorite");
        AppNav.navigator.pushNamed(AppRoute.favTeamFcScreen);
      }
    }
  }

  @override
  void onDispose() {}

  void _delay() {
    logger.i("splash 2");
    Future.delayed(const Duration(seconds: 4))
        .then((_) => AppNav.navigator.pushReplacementNamed(AppRoute.main));
  }
}
