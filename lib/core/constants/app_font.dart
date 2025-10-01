import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';

class AppFont {
  // Titles / Headers
  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: const Color(AppColor.primary), // UNN Green
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(AppColor.primaryVariant), // Darker Green
      );

  static TextStyle get titleSmall => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: const Color(AppColor.onBackground), // Neutral text
      );

  // Subtitles
  static TextStyle get subtitle => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(AppColor.secondaryVariant), // Dark gold
      );

  // Body text
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: const Color(AppColor.onBackground), // Neutral black
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: const Color(AppColor.onSurface), // Dark gray
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: const Color(AppColor.onSurface), // Dark gray
      );

  // Buttons
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(AppColor.onPrimary), // White on green
      );

  // Status / Feedback
  static TextStyle get success => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(AppColor.success),
      );

  static TextStyle get warning => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(AppColor.warning),
      );

  static TextStyle get error => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(AppColor.error),
      );

  // Captions / Footnotes
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(AppColor.onSurface),
      );
}
