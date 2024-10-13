import 'package:app_links/app_links.dart';
import 'package:premiere_league_v2/components/config/app_route.dart';
import 'package:premiere_league_v2/main.dart';

class DeepLinkHandler {
  late AppLinks _appLinks;

  DeepLinkHandler() {
    _initDeepLinkHandling();
  }

  Future<void> _initDeepLinkHandling() async {
    _appLinks = AppLinks();

    // Listen to the initial deep link when the app is started
    final initialLink = await _appLinks.getInitialLinkString();
    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }

    // Listen to app links when the app is already running
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri.toString());
      }
    });
  }

  void _handleDeepLink(String link) {
    final uri = Uri.parse(link);
    final pathSegments = uri.pathSegments;

    // Check if the link is for the home page
    if (pathSegments.isNotEmpty && pathSegments[0] == 'home') {
      AppNav.navigator.pushNamed(AppRoute.teamFcListScreen);
    }

    // Check if the link is for the detail page and contains a team name
    else if (pathSegments.isNotEmpty && pathSegments[0] == 'detail') {
      if (pathSegments.length > 1) {
        final teamName = pathSegments[1];
        AppNav.navigator
            .pushNamed(AppRoute.teamFcDetailScreen, arguments: teamName);
      }
    }
  }
}
