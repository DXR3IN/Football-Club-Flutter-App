import 'dart:async';
import 'package:premiere_league_v2/components/api_services/favorite_helper.dart';
import 'package:premiere_league_v2/components/model/club_model.dart';
import 'package:premiere_league_v2/components/notification_service/local_notification_service.dart';

import '../../../components/api_services/api_client.dart';
import '../../../components/base/base_controller.dart';
import '../../../components/util/command_query.dart';
import '../../../components/model/player_model.dart';

import 'package:mobx/mobx.dart';

class DetailController extends BaseController {
  final ApiClient _api;
  final FavoriteHelper favoriteService;
  final ClubModel team;

  DetailController(this._api, this.team) : favoriteService = FavoriteHelper() {
    _initializeFavoriteStatus();
  }

  final isFavorite = Observable<bool>(false);

  late final dummyPlayerCommand =
      CommandQuery.createWithParam<String, List<PlayerModel>>(_getListPlayer);

  FutureOr<List<PlayerModel>> _getListPlayer(String id) async {
    return _api.getApiPlayer(id).then((value) {
      return value?.map((e) => PlayerModel.fromJson(e)).toList() ?? [];
    });
  }

  late final favoriteCommand =
      CommandQuery.createWithParam<ClubModel, Future<void>>(toggleFavorite);

  void _initializeFavoriteStatus() async {
    bool favoriteStatus = await favoriteService.isFavorite(team.idTeam!);
    runInAction(() {
      isFavorite.value = favoriteStatus;
    });
  }

  Future<void> toggleFavorite(ClubModel team) async {
    bool currentStatus = isFavorite.value;

    if (currentStatus) {
      await favoriteService.removeFavorite(team.idTeam!).then(
            (value) => Future.delayed(const Duration(seconds: 0)).then((s) {
              print(
                  "Attempting to show notification"); // Add this for debugging
              LocalNotificationService().showLocalNotification(
                id: 1,
                body: team.team,
                payload: "now",
                title: "Not your favorite",
              );
            }),
          );
    } else {
      await favoriteService.addFavorite(team).then(
            (value) => Future.delayed(const Duration(seconds: 1)).then((s) {
              print(
                  "Attempting to show notification"); // Add this for debugging
              LocalNotificationService().showLocalNotification(
                id: 1,
                body: team.team,
                payload: "now",
                title: "Your new favorite",
              );
            }),
          );
    }

    runInAction(() {
      isFavorite.value = !currentStatus;
    });

    await favoriteService.getFavoriteTeams();
  }
}
