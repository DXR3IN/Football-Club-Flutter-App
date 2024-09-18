import 'package:flutter/material.dart';
import 'package:premiere_league_v2/components/model/club_model.dart';
import 'package:premiere_league_v2/screens/detail/presentation/detail_screen.dart';
import 'package:premiere_league_v2/screens/favorite/presentation/favorite_screen.dart';
import 'package:premiere_league_v2/screens/home/presentation/home_screen.dart';
import 'package:premiere_league_v2/screens/splash/presentation/splash_screeen.dart';

class AppRoute {
  // static const String splashScreen = "/";
  static const String teamFcListScreen = '/teamFcListScreen';
  static const String teamFcDetailScreen = '/teamFcDetailScreen';
  static const String favTeamFcScreen = '/favTeamFcScreen';
  static const String searchTeamFcScreen = '/searchTeamFcScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => getPage(settings));
  }

  static Widget getPage(RouteSettings settings) {
    var route = settings.name;
    switch (route) {
      // case splashScreen:
      //   return const SplashScreeen();
      case teamFcListScreen:
        return const HomeScreen();
      case teamFcDetailScreen:
        return DetailScreen(
          data: settings.arguments as ClubModel,
        );
      case favTeamFcScreen:
        return const FavoriteScreen();

      default:
        return const HomeScreen();
    }
  }
}
