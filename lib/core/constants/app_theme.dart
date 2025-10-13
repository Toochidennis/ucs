import 'package:flutter/material.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.seed,
      brightness: Brightness.light,
      primary: AppColor.lightPrimary,
      onPrimary: AppColor.lightOnPrimary,
      secondary: AppColor.lightSecondary,
      onSecondary: AppColor.lightOnSecondary,
      background: AppColor.lightBackground,
      surface: AppColor.lightSurface,
      onSurface: AppColor.lightOnSurface,
      error: AppColor.lightError,
      onError: AppColor.lightOnError,
    ),
    textTheme: TextTheme(
      headlineLarge: AppFont.titleLarge.copyWith(color: AppColor.lightPrimary),
      headlineMedium: AppFont.titleMedium.copyWith(
        color: AppColor.lightPrimary,
      ),
      headlineSmall: AppFont.titleSmall.copyWith(
        color: AppColor.lightOnSurface,
      ),
      bodyLarge: AppFont.bodyLarge.copyWith(color: AppColor.lightOnSurface),
      bodyMedium: AppFont.bodyMedium.copyWith(color: AppColor.lightOnSurface),
      bodySmall: AppFont.bodySmall.copyWith(color: Colors.black54),
      labelLarge: AppFont.button.copyWith(color: Colors.white),
      labelSmall: AppFont.caption.copyWith(color: Colors.black54),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.lightPrimary.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.lightPrimary, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.lightPrimary,
        foregroundColor: AppColor.lightOnPrimary,
        textStyle: AppFont.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColor.lightSurface,
      selectedItemColor: AppColor.lightPrimary,
      unselectedItemColor: AppColor.lightOnSurface.withOpacity(0.7),
      selectedLabelStyle: AppFont.bodySmall.copyWith(
        color: AppColor.lightPrimary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppFont.bodySmall.copyWith(
        color: AppColor.lightOnSurface,
      ),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.seed,
      brightness: Brightness.dark,
      primary: AppColor.darkPrimary,
      onPrimary: AppColor.darkOnPrimary,
      secondary: AppColor.darkSecondary,
      onSecondary: AppColor.darkOnSecondary,
      background: AppColor.darkBackground,
      surface: AppColor.darkSurface,
      onSurface: AppColor.darkOnSurface,
      error: AppColor.darkError,
      onError: AppColor.darkOnError,
    ),
    textTheme: TextTheme(
      headlineLarge: AppFont.titleLarge.copyWith(color: Colors.white),
      headlineMedium: AppFont.titleMedium.copyWith(color: Colors.white),
      headlineSmall: AppFont.titleSmall.copyWith(color: Colors.white70),
      bodyLarge: AppFont.bodyLarge.copyWith(color: Colors.white),
      bodyMedium: AppFont.bodyMedium.copyWith(color: Colors.white70),
      bodySmall: AppFont.bodySmall.copyWith(color: Colors.white60),
      labelLarge: AppFont.button.copyWith(color: Colors.black),
      labelSmall: AppFont.caption.copyWith(color: Colors.white54),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.darkSecondary, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.darkSecondary,
        foregroundColor: AppColor.darkOnSecondary,
        textStyle: AppFont.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColor.darkSurface,
      selectedItemColor: AppColor.darkSecondary,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: AppFont.bodySmall.copyWith(
        color: AppColor.darkSecondary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppFont.bodySmall.copyWith(color: Colors.white70),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
