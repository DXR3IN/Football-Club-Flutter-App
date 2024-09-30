import 'package:premiere_league_v2/firebase_handler.dart';
import 'package:premiere_league_v2/main.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteHandler {
  static const String favoritesKey = "favorite_teams";

  Future<void> saveFavoriteTeam(String teamName) async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> favoriteTeams =
        prefs.getStringList(favoritesKey)?.toSet() ?? {};
    favoriteTeams.add(teamName);
    logger.i("one of the favoriteTeams : ${favoriteTeams}");
    await prefs.setStringList(favoritesKey, favoriteTeams.toList());
    FirebaseHandler.subscribeHandler(teamName);
  }

  Future<void> removeFavoriteTeam(String teamName) async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> favoriteTeams =
        prefs.getStringList(favoritesKey)?.toSet() ?? {};
    favoriteTeams.remove(teamName);
    await prefs.setStringList(favoritesKey, favoriteTeams.toList());
    FirebaseHandler.unsubcribeHandler(teamName);
  }

  Future<List<FavClubModel>> getFavoriteTeams(
      List<FavClubModel> allTeams) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTeams = prefs.getStringList(favoritesKey) ?? [];
    return allTeams.where((team) => favoriteTeams.contains(team.team)).toList();
  }

  Future<bool> isFavorite(String? teamName) async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> favoriteTeams =
        prefs.getStringList(favoritesKey)?.toSet() ?? {};
    return favoriteTeams.contains(teamName);
  }
}
