import 'dart:async';

import 'package:premiere_league_v2/screens/home/model/home_club_model.dart';

import '../../../components/api_services/api_client.dart';
import '../../../components/base/base_controller.dart';
import '../../../components/config/app_route.dart';
import '../../../components/util/command_query.dart';
import '../../../main.dart';

class HomeController extends BaseController {
  final ApiClient _api;
  late final dummyTeamFCCommand = CommandQuery.create(_getListTeamFC);

  HomeController(this._api);

  // Code to get all the FootBall Club in Premiere League
  FutureOr<List<HomeClubModel>> _getListTeamFC() async {
    return _api.getApiFootballClubs().then((value) {
      return value?.map((e) => HomeClubModel.fromJson(e)).toList() ?? [];
    });
  }

  // To see the detail of the football team
  void onTapItemFootBall(String team, String idTeam) {
    AppNav.navigator.pushNamed(
      AppRoute.teamFcDetailScreen,
      arguments: {
        'team': team,
        'idTeam': idTeam,
      },
    );
  }

  // go to Favorite Page
  void onTapFavScreen() {
    AppNav.navigator.pushNamed(AppRoute.favTeamFcScreen);
  }
}
