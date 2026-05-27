import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suebsaiyai/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.brownDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        onPrimary: AppColors.brownDark,
        secondary: AppColors.goldLight,
        surface: AppColors.brownDark, // 👈 แก้ไขจาก background
        onSurface: AppColors.textLight, // 👈 แก้ไขจาก onBackground
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.notoSerifThai(
          color: AppColors.goldLight,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.sarabun(color: AppColors.textLight),
        bodyMedium: GoogleFonts.sarabun(color: AppColors.textLight),
        labelLarge: GoogleFonts.sarabun(color: AppColors.goldLight),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.goldLight),
        titleTextStyle: GoogleFonts.notoSerifThai(
          color: AppColors.goldLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.brownMid,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.gold.withOpacity(0.1)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        hintStyle: GoogleFonts.sarabun(color: AppColors.textMuted, fontSize: 14),
        labelStyle: GoogleFonts.sarabun(color: AppColors.goldLight, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.gold.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gold), // 👈 เติม const
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.brownDark,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // 👈 เติม const
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.sarabun(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.goldLight,
          side: const BorderSide(color: AppColors.goldLight), // 👈 เติม const
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.sarabun(fontSize: 14),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.brownMid,
        indicatorColor: AppColors.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) { // 👈 เปลี่ยนเป็น WidgetStateProperty
          if (states.contains(WidgetState.selected)) { // 👈 เปลี่ยนเป็น WidgetState
            return GoogleFonts.sarabun(color: AppColors.goldLight, fontSize: 12, fontWeight: FontWeight.bold);
          }
          return GoogleFonts.sarabun(color: AppColors.textMuted, fontSize: 12);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) { // 👈 เปลี่ยนเป็น WidgetStateProperty
          if (states.contains(WidgetState.selected)) { // 👈 เปลี่ยนเป็น WidgetState
            return const IconThemeData(color: AppColors.goldLight);
          }
          return const IconThemeData(color: AppColors.textMuted);
        }),
      ),
    );
  }
}
