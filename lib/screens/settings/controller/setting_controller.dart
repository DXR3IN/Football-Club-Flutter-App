import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/config/app_const.dart';
import 'package:premiere_league_v2/components/util/storage_util.dart';
import 'package:premiere_league_v2/main.dart';

class SettingController {
  var storage = getIt.get<IStorage>();

  SettingController({IStorage? storage}) {
    this.storage = storage ?? getIt.get<IStorage>();
  }

  final isLang = Observable<int>(1);

  @action
  void setIsLang(int data) {   
    isLang.value = data;
  }

  Future<void> initializeData() async {
    final language = await storage.getLanguage();
    if (language == null || language.contains('en')) {
      isLang.value = 1;
    } else {
      isLang.value = 2;
    }
  }

  void saveLanguage(BuildContext context) {
    if (isLang.value == 1) {
      storage.setLanguage(AppConst.defaultLang);
      MyApp.setLocale(context, const Locale('en'));
    } else {
      storage.setLanguage(AppConst.indoLang);
      MyApp.setLocale(context, const Locale('id'));
    }
  }
}
