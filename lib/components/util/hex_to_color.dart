import 'package:flutter/material.dart';

Color hexToColor(String hexColor) {
  // Remove the '#' if it exists
  hexColor = hexColor.replaceAll('#', '');
  // If the string has 6 characters, prepend 'FF' for full opacity
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  } else {
    return const Color.fromARGB(255, 174, 106, 241);
  }
  return Color(int.parse('0x$hexColor'));
}
