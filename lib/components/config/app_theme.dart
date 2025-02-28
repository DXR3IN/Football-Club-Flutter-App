import 'package:flutter/material.dart';
import 'package:premiere_league_v2/components/config/app_style.dart';

class AppDefaultThemeData {
  var colorPrimary50 = const Color.fromARGB(255, 188, 4, 127);
  var colorPrimary100 = const Color.fromARGB(255, 167, 3, 112);
  var colorPrimary200 = const Color.fromARGB(255, 161, 2, 108);
  var colorPrimary300 = const Color.fromARGB(255, 175, 2, 117);
  var colorPrimary400 = const Color.fromARGB(255, 147, 2, 99);
  var colorPrimary500 = const Color.fromARGB(255, 159, 5, 108);
  var colorPrimary600 = const Color.fromARGB(255, 173, 4, 117);
  var colorPrimary700 = const Color.fromARGB(255, 127, 3, 85);
  var colorPrimary800 = const Color.fromARGB(255, 103, 3, 70);
  var colorPrimary900 = const Color.fromARGB(255, 106, 4, 72);

  var backgroundColor1 = const Color.fromARGB(255, 127, 3, 85);
  var backgroundColor2 = const Color.fromARGB(255, 103, 3, 70);
  var backgroundAlternativeColor1 = const Color(0xff0A0A0A);
  var textColor1 = const Color(0xff262626);
  var textColor2 = const Color(0xff2D2D2D);
  var textColor3 = const Color(0xff0A0A0A);
  var textAlternativeColor1 = const Color(0xffFFFFFF);

  var borderColor = const Color(0xffBFC2C4);
  var borderColor2 = const Color(0xff585858);

  Color get labelTextColor => textColor2;

  var dividerColor = const Color(0xffBFC2C4);

  var loginTitleFontSize = 14.0;

  Color get errorColor => colorPrimary500;

  var textButtonDisabledColor = const Color(0xffBFC2C4);

  OutlineInputBorder inputBorderTheme() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    );
  }

  ThemeData themeData() {
    return ThemeData(
        useMaterial3: false,
        textTheme: AppStyle.mainTextTheme,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(
            colorPrimary500.value,
            {
              50: colorPrimary50,
              100: colorPrimary100,
              200: colorPrimary200,
              300: colorPrimary300,
              400: colorPrimary400,
              500: colorPrimary500,
              600: colorPrimary600,
              700: colorPrimary700,
              800: colorPrimary800,
              900: colorPrimary900,
            },
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: inputBorderTheme(),
          focusedBorder: inputBorderTheme(),
          floatingLabelStyle: TextStyle(
            color: labelTextColor,
            fontWeight: FontWeight.w500,
          ),
          labelStyle: TextStyle(
            color: labelTextColor,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: const TextStyle(
            color: Color(0xff686D71),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(44),
            disabledForegroundColor: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            side: BorderSide(
              color: textColor3,
            ),
            foregroundColor: textColor3,
            minimumSize: const Size.fromHeight(44),
            disabledForegroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            disabledForegroundColor: textButtonDisabledColor,
          ),
        ));
  }
}

class AppTheme extends InheritedWidget {
  final AppDefaultThemeData themeData;
  const AppTheme({
    super.key,
    required this.themeData,
    required super.child,
  });

  static AppTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppTheme>();
  }

  @override
  bool updateShouldNotify(covariant AppTheme oldWidget) {
    return themeData != oldWidget.themeData;
  }
}

extension AppThemeExtension on BuildContext {
  AppDefaultThemeData get appTheme => AppTheme.of(this)!.themeData;
}
