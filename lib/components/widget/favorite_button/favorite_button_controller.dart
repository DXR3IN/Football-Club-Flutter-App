import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/notification_service/local_notification_service.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/favorite_handler.dart';

class FavoriteButtonController extends BaseController {
  final FavoriteHandler _favoriteHandler;
  final String? _team;

  FavoriteButtonController(this._team) : _favoriteHandler = FavoriteHandler();

  // Observable properties
  final isFavorite = Observable<bool>(false);

  late final favoriteCommand =
      CommandQuery.createWithParam<ClubModel, Future<void>>(_toggleFavorite);

  // Initialize the favorite status when the controller is created
  void initializeFavoriteStatus() async {
    if (_team == null) {
      return;
    }
    final favoriteStatus = await _favoriteHandler.isFavorite(_team);
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
      await _favoriteHandler.saveFavoriteTeam(team.team!);
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  Future<void> _removeFromFavorites(ClubModel team) async {
    try {
      await _favoriteHandler.removeFavoriteTeam(team.team!);
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
