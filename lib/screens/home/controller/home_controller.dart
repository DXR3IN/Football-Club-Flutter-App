import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/screens/home/model/home_club_model.dart';
import 'package:premiere_league_v2/screens/home/service/home_service.dart';

import '../../../components/config/app_route.dart';
import '../../../main.dart';

class HomeController extends BaseController {
  final HomeService _homeService = HomeService(getIt.get<ApiClient>());
  late final listFootballClubCommand = CommandQuery.create(_getListTeamFC);
  final ScrollController scrollController = ScrollController();

  // Total teams from API
  final totalTeam = Observable<int>(0);

  // Loading state
  final isLoading = Observable<bool>(false);

  // Search functionality
  final searchQuery = Observable<String>('');
  List<HomeClubModel> _filteredTeams = [];

  // Search bar focus state
  final isSearchBarFocused = Observable<bool>(false);
  final FocusNode searchBarFocusNode = FocusNode();

  HomeController() {
    searchBarFocusNode.addListener(() {
      final isFocused = searchBarFocusNode.hasFocus;
      isSearchBarFocused.value = isFocused;

      if (isFocused) {
        scrollToTop(); 
      }
    });
  }

  // Fetch Football Clubs from API using the service
  FutureOr<List<HomeClubModel>> _getListTeamFC() async {
    isLoading.value = true;
    final List<HomeClubModel> teamList = await _homeService.getFootballClubs();
    totalTeam.value = teamList.length;
    _filteredTeams = teamList;
    isLoading.value = false;
    return teamList;
  }

  // Update search query
  @action
  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
    _filterTeams();
  }

  // Filter teams based on search query
  void _filterTeams() {
    if (listFootballClubCommand.onData == null) {
      _filteredTeams = [];
      return;
    }

    final List<HomeClubModel> allTeams = listFootballClubCommand.onData!;
    _filteredTeams = searchQuery.value.isEmpty
        ? allTeams
        : allTeams.where((team) {
            return team.team?.toLowerCase().contains(searchQuery.value) ??
                false;
          }).toList();
  }

  // Scroll to top safely
  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Navigate to Favorite Page
  void onTapFavScreen() {
    AppNav.navigator.pushNamed(AppRoute.favTeamFcScreen);
  }

  // Navigate to Detail Page
  void onTapItemFootBall(String team) {
    AppNav.navigator.pushNamed(
      AppRoute.teamFcDetailScreen,
      arguments: team,
    );
  }

  // Navigate to Settings Page
  void onTapSettingsScreen() {
    AppNav.navigator.pushNamed(AppRoute.settingsScreen);
  }

  // Dispose resources
  void dispose() {
    searchBarFocusNode.dispose();
    scrollController.dispose();
  }

  // Getter for filtered teams
  List<HomeClubModel> get filteredTeams => _filteredTeams;
}
