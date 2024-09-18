import 'package:flutter/material.dart';

extension AppContextExt on BuildContext {

  TextTheme getTextTheme() => Theme.of(this).textTheme;
}