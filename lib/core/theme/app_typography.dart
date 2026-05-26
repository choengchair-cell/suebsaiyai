import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme => GoogleFonts.sarabunTextTheme().copyWith(
        displayLarge: GoogleFonts.sarabun(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
        displayMedium: GoogleFonts.sarabun(fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: GoogleFonts.sarabun(fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge: GoogleFonts.sarabun(fontSize: 32, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.sarabun(fontSize: 28, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.sarabun(fontSize: 24, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.sarabun(fontSize: 22, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.sarabun(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
        titleSmall: GoogleFonts.sarabun(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
        bodyLarge: GoogleFonts.sarabun(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyMedium: GoogleFonts.sarabun(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        bodySmall: GoogleFonts.sarabun(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        labelLarge: GoogleFonts.sarabun(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        labelMedium: GoogleFonts.sarabun(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.sarabun(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 1.5),
      );
}
