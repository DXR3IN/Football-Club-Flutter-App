import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/notification_service/local_notification_service.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/favorite_handler.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart';

class FavoriteButtonController extends BaseController {
  final FavoriteHandler _favoriteHandler;
  final ClubModel? _footbalTeam;

  FavoriteButtonController(this._footbalTeam)
      : _favoriteHandler = FavoriteHandler();

  // Lazy initialization of favFootballTeam
  late final FavClubModel favFootballTeam = FavClubModel(
    idTeam: _footbalTeam!.idTeam,
    badge: _footbalTeam.badge,
    team: _footbalTeam.team,
  );

  // Observable properties
  final isFavorite = Observable<bool>(false);

  late final favoriteCommand =
      CommandQuery.createWithParam<FavClubModel, Future<void>>(_toggleFavorite);

  // Initialize the favorite status when the controller is created
  void initializeFavoriteStatus() async {
    if (_footbalTeam == null) {
      return;
    }

    final favoriteStatus = await _favoriteHandler.isFavorite(favFootballTeam);
    runInAction(() {
      isFavorite.value = favoriteStatus;
    });
  }

  // Toggle favorite status and show appropriate notification
  Future<void> _toggleFavorite(FavClubModel favFootballTeam) async {
    final currentStatus = isFavorite.value;

    if (currentStatus) {
      await _removeFromFavorites(favFootballTeam);
      _showNotification(favFootballTeam.idTeam!, 'Not your favorite',
          'Removed from favorites');
    } else {
      await _addToFavorites(favFootballTeam);
      _showNotification(
          favFootballTeam.idTeam!, 'Your new favorite', 'Added to favorites');
    }

    runInAction(() {
      isFavorite.value = !currentStatus;
    });
  }

  // Helper methods for adding/removing favorites
  Future<void> _addToFavorites(FavClubModel favFootballTeam) async {
    try {
      await _favoriteHandler.saveFavoriteTeam(favFootballTeam);
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  Future<void> _removeFromFavorites(FavClubModel favFootballTeam) async {
    try {
      await _favoriteHandler.removeFavoriteTeam(favFootballTeam);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  // Helper method for showing notifications
  void _showNotification(String idTeam, String title, String body) {
    LocalNotificationService().showLocalNotification(
      id: 1,
      title: title,
      body: body,
      payload: idTeam,
    );
  }
}
