import 'package:flutter/material.dart';
import 'package:premiere_league_v2/screens/navigation/navigation_widget.dart';
import 'package:premiere_league_v2/screens/detail/presentation/detail_screen.dart';
import 'package:premiere_league_v2/screens/favorite/presentation/favorite_screen.dart';
import 'package:premiere_league_v2/screens/home/presentation/home_screen.dart';
import 'package:premiere_league_v2/screens/settings/presentation/settings_screen.dart';
import 'package:premiere_league_v2/screens/splash/presentation/splash_screen.dart';

class AppRoute {
  static const String main = "/";
  static const String splashScreen = "/splashScreen";
  static const String teamFcListScreen = '/teamFcListScreen';
  static const String teamFcDetailScreen = '/teamFcDetailScreen';
  static const String favTeamFcScreen = '/favTeamFcScreen';
  static const String searchTeamFcScreen = '/searchTeamFcScreen';
  static const String settingsScreen = '/settingsScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => getPage(settings));
  }

  static Widget getPage(RouteSettings settings) {
    var route = settings.name;
    switch (route) {
      case splashScreen:
        return const SplashScreen();
      case teamFcListScreen:
        return const HomeScreen();
      case teamFcDetailScreen:
        return DetailScreen(team: settings.arguments as String);
      case favTeamFcScreen:
        return const FavoriteScreen();
      case settingsScreen:
        return const SettingsScreen();
      case main:
        return const NavigationWidget();
      default:
        return const NavigationWidget();
    }
  }
}
