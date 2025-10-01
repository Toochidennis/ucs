import 'package:flutter/material.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';

class AppTheme {
  // Light mode
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(AppColor.primary),
      onPrimary: const Color(AppColor.onPrimary),
      secondary: const Color(AppColor.secondary),
      onSecondary: const Color(AppColor.onSecondary),
      surface: const Color(AppColor.surface),
      onSurface: const Color(AppColor.onSurface),
      error: const Color(AppColor.error),
      onError: const Color(AppColor.onError),
    ),
    textTheme: TextTheme(
      headlineLarge: AppFont.titleLarge,
      headlineMedium: AppFont.titleMedium,
      headlineSmall: AppFont.titleSmall,
      titleMedium: AppFont.subtitle,
      bodyLarge: AppFont.bodyLarge,
      bodyMedium: AppFont.bodyMedium,
      bodySmall: AppFont.bodySmall,
      labelLarge: AppFont.button,
      labelSmall: AppFont.caption,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(AppColor.primary)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(AppColor.primary),
        foregroundColor: const Color(AppColor.onPrimary),
        textStyle: AppFont.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(AppColor.surface),
      selectedItemColor: const Color(AppColor.primary),
      unselectedItemColor: const Color(AppColor.onSurface),
      selectedLabelStyle: AppFont.bodySmall.copyWith(
        color: const Color(AppColor.primary),
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppFont.bodySmall.copyWith(
        color: const Color(AppColor.onSurface),
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  // Dark mode
  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: const Color(AppColor.primary),
      onPrimary: const Color(AppColor.onPrimary),
      secondary: const Color(AppColor.secondary),
      onSecondary: const Color(AppColor.onSecondary),
      surface: const Color(0xFF121212), // Dark surface
      onSurface: Colors.white70,
      error: const Color(AppColor.error),
      onError: const Color(AppColor.onError),
    ),
    textTheme: TextTheme(
      headlineLarge: AppFont.titleLarge.copyWith(color: Colors.white),
      headlineMedium: AppFont.titleMedium.copyWith(color: Colors.white),
      headlineSmall: AppFont.titleSmall.copyWith(color: Colors.white),
      titleMedium: AppFont.subtitle.copyWith(color: Colors.white70),
      bodyLarge: AppFont.bodyLarge.copyWith(color: Colors.white),
      bodyMedium: AppFont.bodyMedium.copyWith(color: Colors.white70),
      bodySmall: AppFont.bodySmall.copyWith(color: Colors.white60),
      labelLarge: AppFont.button.copyWith(color: Colors.white),
      labelSmall: AppFont.caption.copyWith(color: Colors.white54),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(AppColor.secondary)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(AppColor.secondary),
        foregroundColor: const Color(AppColor.onSecondary),
        textStyle: AppFont.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF121212),
      selectedItemColor: const Color(AppColor.secondary),
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: AppFont.bodySmall.copyWith(
        color: const Color(AppColor.secondary),
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppFont.bodySmall.copyWith(
        color: Colors.white70,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
