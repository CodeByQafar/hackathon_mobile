import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const MaterialColor cyanBlueAzure =
      MaterialColor(0xffec1d25, <int, Color>{
        50: Color(0xffec1d25),
        100: Color(0xffec1d25),
        200: Color(0xffec1d25),
        300: Color(0xffec1d25),
        400: Color(0xffec1d25),
        500: Color(0xffec1d25),
        600: Color(0xffec1d25),
        700: Color(0xffec1d25),
        800: Color(0xffec1d25),
        900: Color(0xffec1d25),
      });

  static const Color quickSilver = MaterialColor(0xffA5A5A5, <int, Color>{
    50: Color(0xffA5A5A5),
    100: Color(0xffA5A5A5),
    200: Color(0xffA5A5A5),
    300: Color(0xffA5A5A5),
    400: Color(0xffA5A5A5),
    500: Color(0xffA5A5A5),
    600: Color(0xffA5A5A5),
    700: Color(0xffA5A5A5),
    800: Color(0xffA5A5A5),
    900: Color(0xffA5A5A5),
  });

  // Base colors
  static const Color cynicalBlack = Color(0xff171717);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // ********** DARK MODE — ALL COMPONENT BACKGROUNDS SAME **********

  /// Entire screen background, surface, card — unified color
  static const Color darkBackground = Color(0xff171717);


  /// Text colors
  static const Color darkTextPrimary = Color(0xffFFFFFF);
  static const Color darkTextSecondary = Color(0xffC8C8C8);

  /// Borders / dividers
  static const Color darkBorder = Color(0xff2E2E2E);

  /// Hover color
  static const Color darkHover = Color(0xff1E1E1E);

  /// Accent
  static const Color darkAccent = Color(0xffec1d25);

  /// Icons
  static const Color darkIcon = Color(0xffEDEDED);

  /// Disabled
  static const Color darkDisabled = Color(0xff555555);
}
