import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDefaultThemeData {
  var colorPrimary50 = const Color(0xffffdddd);
  var colorPrimary100 = const Color(0xffffc0c0);
  var colorPrimary200 = const Color.fromARGB(255, 107, 5, 216);
  var colorPrimary300 = const Color.fromARGB(255, 94, 4, 189);
  var colorPrimary400 = const Color.fromARGB(255, 93, 4, 187);
  var colorPrimary500 = const Color.fromARGB(255, 67, 6, 166);
  var colorPrimary600 = const Color.fromARGB(255, 66, 3, 133);
  var colorPrimary700 = const Color.fromARGB(255, 61, 1, 124);
  var colorPrimary800 = const Color.fromARGB(255, 48, 1, 98);
  var colorPrimary900 = const Color.fromARGB(255, 39, 0, 82);

  var backgroundColor1 = const Color(0xffFFFFFF);
  var backgroundColor2 = const Color(0xfff2f2f2);
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
        textTheme: GoogleFonts.rethinkSansTextTheme(),
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
