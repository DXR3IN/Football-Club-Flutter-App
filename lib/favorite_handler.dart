import 'dart:convert';

import 'package:premiere_league_v2/firebase_handler.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteHandler {
  static const String favoritesKey = "favorite_teams";

  // save a string into FAVORITE
  Future<void> saveFavoriteTeam(FavClubModel footballTeam) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(favoritesKey) ?? [];

    // Serialize FavClubModel to JSON String
    favoriteTeams.add(jsonEncode(footballTeam.toJson()));

    logger.i("Favorite teams total: ${favoriteTeams.length}");
    await prefs.setStringList(favoritesKey, favoriteTeams);

    FirebaseHandler.subscribeHandler(footballTeam.team!);
  }

  // remove a string from FAVORITE
  Future<void> removeFavoriteTeam(FavClubModel premiereTeam) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(favoritesKey) ?? [];

    // Find and remove the team based on idTeam
    favoriteTeams.removeWhere((teamJson) {
      Map<String, dynamic> teamMap = jsonDecode(teamJson);
      return teamMap['idTeam'] == premiereTeam.idTeam;
    });

    await prefs.setStringList(favoritesKey, favoriteTeams);
    FirebaseHandler.unsubscribeHandler(premiereTeam.team!);
  }

  // get all the FAVORITE team
  Future<List<FavClubModel>> getFavoriteTeams() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(favoritesKey) ?? [];

    // Deserialize the list of JSON Strings into a list of FavClubModel objects
    return favoriteTeams
        .map((teamJson) => FavClubModel.fromJson(jsonDecode(teamJson)))
        .toList();
  }

  // checking if the team is in the favorites
  Future<bool> isFavorite(FavClubModel footballTeam) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(favoritesKey) ?? [];

    // Check if any team in favoriteTeams has the same idTeam
    return favoriteTeams.any((teamJson) {
      Map<String, dynamic> teamMap = jsonDecode(teamJson); // Decode each item
      return teamMap['idTeam'] == footballTeam.idTeam; // Compare the idTeam
    });
  }
}
