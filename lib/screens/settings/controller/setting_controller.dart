import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:premiere_league_v2/components/config/app_const.dart';
import 'package:premiere_league_v2/components/util/storage_util.dart';
import 'package:premiere_league_v2/localization_provider.dart';
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
    final localizationProvider = getIt.get<LocalizationProvider>();
    if (isLang.value == 1) {
      storage.setLanguage(AppConst.defaultLang);
      localizationProvider.setLocale(const Locale('en'));
    } else {
      storage.setLanguage(AppConst.indoLang);
      localizationProvider.setLocale(const Locale('id'));
    }
  }
}
