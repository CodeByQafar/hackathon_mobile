import 'package:flutter/services.dart';
import 'colors.dart';
import 'package:flutter/material.dart';
import '../../../../gen/fonts.gen.dart';

class AppTheme {
  // ---------------- LIGHT THEME ----------------
  ThemeData get lightTheme => ThemeData(
        primaryColor: AppColors.cyanBlueAzure,
        primarySwatch: AppColors.cyanBlueAzure,

        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: _appBarThemeLight(),

        textTheme: _textThemeLight(),

        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,

        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (states) => Colors.transparent,
            ),
          ),
        ),

        dividerColor: AppColors.quickSilver,

        colorScheme: ColorScheme.light(
          primary: AppColors.cyanBlueAzure,
          secondary: AppColors.quickSilver,
          background: AppColors.white,
          surface: Colors.white,
          onPrimary: AppColors.white,
          onSecondary: AppColors.black,
          onBackground: AppColors.black,
          onSurface: AppColors.black,
        ),

        iconTheme: IconThemeData(color: AppColors.black),
      );

  // ---------------- DARK THEME ----------------
  ThemeData get darkTheme => ThemeData(
        primaryColor: AppColors.cyanBlueAzure,
        primarySwatch: AppColors.cyanBlueAzure,

        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: _appBarThemeDark(),

        textTheme: _textThemeDark(),

        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,

        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (states) => Colors.transparent,
            ),
          ),
        ),

        dividerColor: AppColors.darkBorder,

        colorScheme: const ColorScheme.dark(
          primary: AppColors.cyanBlueAzure,
          secondary: AppColors.darkAccent,
          background: AppColors.darkBackground,
          surface: AppColors.darkBackground,
          onPrimary: AppColors.white,
          onSecondary: AppColors.darkTextSecondary,
          onBackground: AppColors.darkTextPrimary,
          onSurface: AppColors.darkTextPrimary,
        ),

        iconTheme: IconThemeData(color: AppColors.darkIcon),

        cardColor: AppColors.darkBackground,
      );

  // ---------------- APP BAR LIGHT ----------------
  static AppBarTheme _appBarThemeLight() {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20.0,
        color: AppColors.black,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // ---------------- APP BAR DARK ----------------
  static AppBarTheme _appBarThemeDark() {
    return AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20.0,
        color: AppColors.darkTextPrimary,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.darkBackground,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.darkBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }
     TextTheme _textThemeLight() {
    return TextTheme(
      titleLarge: TextStyle(
        fontSize: 88.0,
        color: AppColors.white,
        fontFamily: FontFamily.bebasNeue,
       
      ),
      titleMedium: TextStyle(
        fontSize: 49.0,
        fontFamily: FontFamily.smoochSans,
        fontWeight: FontWeight.w700,
        color: AppColors.cyanBlueAzure,
      ),
      titleSmall: TextStyle(
        fontSize: 20.0,
        fontFamily: FontFamily.smoochSans,
        fontWeight: FontWeight.w700,
        color: AppColors.quickSilver,
      ),
      bodyLarge: TextStyle(
        fontSize: 30.0,
        fontFamily: FontFamily.smoochSans,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 22.0,
        color: Colors.black,
        fontFamily: FontFamily.smoochSans,
      ),
      bodySmall: TextStyle(
        fontSize: 20.0,
        color: AppColors.white,
        fontFamily: FontFamily.agencyFb,
      ),

      displayMedium: TextStyle(
        fontSize: 30.0,
        fontFamily: FontFamily.smoochSans,
        fontWeight: FontWeight.w700,
        color: AppColors.cyanBlueAzure,
      ),
    );
  }
 
  TextTheme _textThemeDark() {
    return TextTheme(
      titleLarge: TextStyle(
        fontSize: 88.0,
        color: AppColors.darkTextPrimary,
        fontFamily: FontFamily.bebasNeue,
      ),
      titleMedium: TextStyle(
        fontSize: 49.0,
        fontFamily: FontFamily.smoochSans,
        fontWeight: FontWeight.w700,
        color: AppColors.cyanBlueAzure,
      ),
      titleSmall: TextStyle(
        fontSize: 20.0,
        fontFamily: FontFamily.smoochSans,
        fontWeight: FontWeight.w700,
        color: AppColors.darkTextSecondary,
      ),
      bodyLarge: TextStyle(
        fontSize: 30.0,
        fontFamily: FontFamily.smoochSans,
        fontWeight: FontWeight.w700,
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 22.0,
        color: AppColors.darkTextSecondary,
        fontFamily: FontFamily.smoochSans,
      ),
      bodySmall: TextStyle(
        fontSize: 20.0,
        color: AppColors.darkTextPrimary,
        fontFamily: FontFamily.agencyFb,
      ),
      displayMedium: TextStyle(
        fontSize: 30.0,
        fontFamily: FontFamily.smoochSans,
        fontWeight: FontWeight.w700,
        color: AppColors.cyanBlueAzure,
      ),
    );
  }
}
