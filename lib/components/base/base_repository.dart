import 'dart:convert';

import '../config/app_const.dart';

class BaseRepository {
  final String _errorMsgHandler = "Failed to load, please try again";

  mapToData(String event) {
    try {
      return jsonDecode(event);
    } catch (e) {
      if (AppConst.isDebuggable) {
        throw Exception(e);
      } else {
        throw Exception(_errorMsgHandler);
      }
    }
  }
}
