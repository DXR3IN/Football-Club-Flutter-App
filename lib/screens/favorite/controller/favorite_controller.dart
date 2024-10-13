import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/favorite_handler.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart';

class FavoriteController extends ChangeNotifier {
  final FavoriteHandler _favoriteHandler = FavoriteHandler();

  List<FavClubModel> _favoriteTeams = [];
  List<FavClubModel> get favoriteTeams => _favoriteTeams;

  // Accepting list of teams passed as arguments
  FavoriteController();

  // CommandQuery to handle loading favorites
  late final favoriteCommand =
      CommandQuery.create<Null, List<FavClubModel>>(loadFavorites);

  // Load favorites based on the teams already passed
  Future<List<FavClubModel>> loadFavorites() async {
    _favoriteTeams = await _favoriteHandler.getFavoriteTeams();
    notifyListeners();
    return _favoriteTeams;
  }

  // Removing a team from favorites
  Future<void> removeFromFavorites(FavClubModel footbalTeam) async {
    await _favoriteHandler.removeFavoriteTeam(footbalTeam);
    await favoriteCommand.execute(); 
  }
}
