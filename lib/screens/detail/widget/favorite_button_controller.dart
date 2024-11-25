import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/notification_service/local_notification_service.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/favorite_handler.dart';
import 'package:premiere_league_v2/screens/detail/model/club_model.dart';
import 'package:premiere_league_v2/screens/favorite/model/fav_club_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteButtonController extends BaseController {
  final FavoriteHandler _favoriteHandler;
  final ClubModel? _footbalTeam;

  // Constructor
  FavoriteButtonController(this._footbalTeam)
      : _favoriteHandler = FavoriteHandler() {
    // Initialize favorite status on creation
    if (_footbalTeam != null) {
      initializeFavoriteStatus();
    }
  }

  // Lazy initialization of favFootballTeam
  late final FavClubModel favFootballTeam = FavClubModel(
    idTeam: _footbalTeam!.idTeam,
    badge: _footbalTeam.badge,
    team: _footbalTeam.team,
  );

  // Observable property
  final isFavorite = Observable<bool>(false);

  // Command for toggling favorite status
  late final favoriteCommand =
      CommandQuery.createWithParam<BuildContext, Future<void>>(_toggleFavorite);

  // Initialize the favorite status when the controller is created
  Future<void> initializeFavoriteStatus() async {
    try {
      final favoriteStatus = await _favoriteHandler.isFavorite(favFootballTeam);
      runInAction(() {
        isFavorite.value = favoriteStatus;
      });
    } catch (e) {
      print('Error initializing favorite status: $e');
    }
  }

  // Toggle favorite status and show appropriate notification
  Future<void> _toggleFavorite(BuildContext context) async {
    final currentStatus = isFavorite.value;
    final localizations = AppLocalizations.of(context)!;

    try {
      if (currentStatus) {
        await _removeFromFavorites(favFootballTeam);
        _showNotification(
          favFootballTeam.idTeam!,
          localizations.notifNotFav,
          localizations.bodyNotifNotFav(favFootballTeam.team!),
        );
      } else {
        await _addToFavorites(favFootballTeam);
        _showNotification(
          favFootballTeam.idTeam!,
          localizations.notifFav,
          localizations.bodyNotifFav(favFootballTeam.team!),
        );
      }

      runInAction(() {
        isFavorite.value = !currentStatus;
      });
    } catch (e) {
      print('Error toggling favorite status: $e');
    }
  }

  // Helper methods for adding/removing favorites
  Future<void> _addToFavorites(FavClubModel favFootballTeam) async {
    await _favoriteHandler.saveFavoriteTeam(favFootballTeam);
  }

  Future<void> _removeFromFavorites(FavClubModel favFootballTeam) async {
    await _favoriteHandler.removeFavoriteTeam(favFootballTeam);
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
