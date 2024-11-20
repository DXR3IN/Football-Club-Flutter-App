import 'dart:async';

import 'package:premiere_league_v2/components/api_services/api_client.dart';
import 'package:premiere_league_v2/components/base/base_controller.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';
import 'package:premiere_league_v2/screens/detail/model/history_model.dart';

class HistoryController extends BaseController {
  final ApiClient _api;
  late final String idTeam;

  HistoryController(this._api, this.idTeam) {
    getLastEventByIdCommand.execute();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
    super.onDispose();
  }

  late final getLastEventByIdCommand =
      CommandQuery.create(_getLastEventByIdTeam);

  FutureOr<List<HistoryModel>?> _getLastEventByIdTeam() async {
    return await _api.getLastEventHomeByIdTeam(idTeam).then(
      (value) {
        return value
                ?.map(
                  (e) => HistoryModel.fromJson(e),
                )
                .toList() ??
            [];
      },
    );
  }
}
