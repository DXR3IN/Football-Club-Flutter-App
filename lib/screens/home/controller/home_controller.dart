import 'dart:async';

import '../../../components/api_services/api_client.dart';
import '../../../components/base/base_controller.dart';
import '../../../components/config/app_route.dart';
import '../../../components/util/command_query.dart';
import '../../../main.dart';
import '../../../components/model/club_model.dart';

class HomeController extends BaseController {
  final ApiClient _api;
  late final dummyTeamFCCommand = CommandQuery.create(_getListTeamFC);

  HomeController(this._api);

  // Code to get all the FootBall Club in Premiere League
  FutureOr<List<ClubModel>> _getListTeamFC() async {
    return _api.getApiFootballClub().then((value) {
      return value?.map((e) => ClubModel.fromJson(e)).toList() ?? [];
    });
  }

  // To see the detail of the football team
  void onTapItemFootBall(ClubModel teamFootball) {
    AppNav.navigator
        .pushNamed(AppRoute.teamFcDetailScreen, arguments: teamFootball);
  }

  // go to Favorite Page
  void onTapFavScreen() {
    AppNav.navigator.pushNamed(AppRoute.favTeamFcScreen);
  }
}
