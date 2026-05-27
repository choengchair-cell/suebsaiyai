import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suebsaiyai/core/theme/app_colors.dart';

class AppTypography {
  AppTypography._();

  // Noto Serif Thai for headings (matches --font-th in HTML)
  static TextStyle serifTh({
    double size = 16,
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.cream,
    double? height,
  }) =>
      GoogleFonts.notoSerifThai(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );

  // Sarabun for body (matches --font-body in HTML)
  static TextStyle body({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textLight,
    double? height,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.sarabun(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextTheme get textTheme => GoogleFonts.sarabunTextTheme().copyWith(
        displayLarge:  GoogleFonts.notoSerifThai(fontSize: 57, fontWeight: FontWeight.w600, color: AppColors.cream),
        displayMedium: GoogleFonts.notoSerifThai(fontSize: 45, fontWeight: FontWeight.w600, color: AppColors.cream),
        displaySmall:  GoogleFonts.notoSerifThai(fontSize: 36, fontWeight: FontWeight.w600, color: AppColors.cream),
        headlineLarge: GoogleFonts.notoSerifThai(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.cream),
        headlineMedium:GoogleFonts.notoSerifThai(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.cream),
        headlineSmall: GoogleFonts.notoSerifThai(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.cream),
        titleLarge:    GoogleFonts.notoSerifThai(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.cream),
        titleMedium:   GoogleFonts.sarabun(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.cream, letterSpacing: 0.15),
        titleSmall:    GoogleFonts.sarabun(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.cream, letterSpacing: 0.1),
        bodyLarge:     GoogleFonts.sarabun(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textLight, letterSpacing: 0.5, height: 1.9),
        bodyMedium:    GoogleFonts.sarabun(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textLight, letterSpacing: 0.25),
        bodySmall:     GoogleFonts.sarabun(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted, letterSpacing: 0.4),
        labelLarge:    GoogleFonts.sarabun(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.gold, letterSpacing: 3.5),
        labelMedium:   GoogleFonts.sarabun(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.gold, letterSpacing: 2.5),
        labelSmall:    GoogleFonts.sarabun(fontSize: 9,  fontWeight: FontWeight.w500, color: AppColors.textMuted, letterSpacing: 1.5),
      );
}
