import 'dart:async';
import 'package:mobx/mobx.dart';

import 'package:premiere_league_v2/screens/home/model/home_club_model.dart';

import '../../../components/api_services/api_client.dart';
import '../../../components/base/base_controller.dart';
import '../../../components/config/app_route.dart';
import '../../../components/util/command_query.dart';
import '../../../main.dart';

class HomeController extends BaseController {
  final ApiClient _api;
  late final dummyTeamFCCommand = CommandQuery.create(_getListTeamFC);
  final totalTeam = Observable<int>(0);
  final isLoading = Observable<bool>(false);
  final searchQuery = Observable<String>('');

  List<HomeClubModel> _filteredTeams = [];

  HomeController(this._api);

  // Code to get all the FootBall Club in Premiere League
  FutureOr<List<HomeClubModel>> _getListTeamFC() async {
    isLoading.value = true;
    final List<HomeClubModel> teamList =
        await _api.getApiFootballClubs().then((value) {
      return value?.map((e) => HomeClubModel.fromJson(e)).toList() ?? [];
    });
    totalTeam.value = teamList.length;
    _filteredTeams = teamList;
    isLoading.value = false;
    return teamList;
  }

  // To see the detail of the football team
  void onTapItemFootBall(String team) {
    AppNav.navigator.pushNamed(
      AppRoute.teamFcDetailScreen,
      arguments: team,
    );
  }

  @action
  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
    _filterTeams(); // panggil method untuk memfilter tim
  }

  void _filterTeams() {
    final List<HomeClubModel> allTeams = dummyTeamFCCommand.onData ?? [];
    _filteredTeams = allTeams
        .where((team) =>
            team.team?.toLowerCase().contains(searchQuery.value) ?? false)
        .toList();
  }

  // go to Favorite Page
  void onTapFavScreen() {
    AppNav.navigator.pushNamed(
      AppRoute.favTeamFcScreen,
    );
  }

  // Getter to access filtered teams
  List<HomeClubModel> get filteredTeams => _filteredTeams;
}
