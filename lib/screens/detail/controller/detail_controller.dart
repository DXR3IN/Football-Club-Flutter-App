import 'dart:async';
import 'package:premiere_league_v2/screens/favorite/controller/favorite_helper.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/components/notification_service/local_notification_service.dart';
import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/screens/detail/model/player_model.dart';
import 'package:mobx/mobx.dart';

class DetailController extends BaseController {
  final ApiClient _api;
  final FavoriteHelper _favoriteService;
  final String _team;

  DetailController(this._api, this._team)
      : _favoriteService = FavoriteHelper() {
    _initializeFavoriteStatus();
  }

  // Observable properties
  final isFavorite = Observable<bool>(false);

  // Command queries
  late final dummyDetailClubModel =
      CommandQuery.createWithParam<String, ClubModel>(_fetchTeamById);

  late final dummyPlayerCommand =
      CommandQuery.createWithParam<String, List<PlayerModel>>(_fetchPlayers);

  late final favoriteCommand =
      CommandQuery.createWithParam<ClubModel, Future<void>>(_toggleFavorite);

  // Private methods to handle API and business logic
  Future<ClubModel> _fetchTeamById(String team) async {
    try {
      final response = await _api.getApiFootballClubById(team);
      if (response != null && response.isNotEmpty) {
        final teamData = response[0]; 
        print("Team name: ${teamData['name']}"); 

        // Assuming you have a method to convert Map to ClubModel
        return ClubModel.fromJson(teamData); // Use your conversion method
      } else {
        throw Exception("No teams found.");
      }
    } catch (e) {
      throw Exception("Error fetching team: $e");
    }
  }

  FutureOr<List<PlayerModel>> _fetchPlayers(String id) async {
    try {
      final response = await _api.getApiPlayer(id);
      return response?.map((e) => PlayerModel.fromJson(e)).toList() ?? [];
    } catch (e) {
      throw Exception('Error fetching players: $e');
    }
  }

  // Initialize the favorite status when the controller is created
  void _initializeFavoriteStatus() async {
    final favoriteStatus = await _favoriteService.isFavorite(_team);
    runInAction(() {
      isFavorite.value = favoriteStatus;
    });
  }

  // Toggle favorite status and show appropriate notification
  Future<void> _toggleFavorite(ClubModel team) async {
    final currentStatus = isFavorite.value;

    if (currentStatus) {
      await _removeFromFavorites(team);
      _showNotification(team, 'Not your favorite', 'Removed from favorites');
    } else {
      await _addToFavorites(team);
      _showNotification(team, 'Your new favorite', 'Added to favorites');
    }

    runInAction(() {
      isFavorite.value = !currentStatus;
    });
  }

  // Helper methods for adding/removing favorites
  Future<void> _addToFavorites(ClubModel team) async {
    try {
      await _favoriteService.addFavorite(team);
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  Future<void> _removeFromFavorites(ClubModel team) async {
    try {
      await _favoriteService.removeFavorite(team.idTeam!);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  // Helper method for showing notifications
  void _showNotification(ClubModel team, String title, String body) {
    LocalNotificationService().showLocalNotification(
      id: 1,
      title: title,
      body: body,
      payload: team.team,
    );
  }
}
