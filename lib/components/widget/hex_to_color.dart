import 'package:flutter/material.dart';

Color hexToColor(String hexColor) {
  // Remove the '#' if it exists
  hexColor = hexColor.replaceAll('#', '');
  // If the string has 6 characters, prepend 'FF' for full opacity
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }
  return Color(int.parse('0x$hexColor'));
}
