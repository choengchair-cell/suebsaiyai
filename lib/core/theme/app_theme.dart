import 'package:flutter/material.dart';
import 'package:suebsaiyai/core/theme/app_colors.dart';
import 'package:suebsaiyai/core/theme/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.gold,
          onPrimary: AppColors.textOnGold,
          primaryContainer: AppColors.primaryContainer,
          secondary: AppColors.goldLight,
          onSecondary: AppColors.textOnGold,
          surface: AppColors.brownMid,
          onSurface: AppColors.cream,
          background: AppColors.brownDark,
          onBackground: AppColors.cream,
          error: AppColors.error,
          errorContainer: AppColors.errorContainer,
        ),
        scaffoldBackgroundColor: AppColors.brownDark,
        textTheme: AppTypography.textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.cream,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
            color: AppColors.goldLight,
            fontFamily: 'NotoSerifThai',
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: AppColors.brownMid,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            side: BorderSide(color: AppColors.glassBorder.withOpacity(0.4)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.textOnGold,
            textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.04),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.cream,
            side: BorderSide(color: AppColors.cream.withOpacity(0.3)),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cream.withOpacity(0.06),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: AppColors.gold.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: AppColors.gold.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.gold),
          ),
          labelStyle: const TextStyle(color: AppColors.gold, fontSize: 12, letterSpacing: 1.5),
          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.gold.withOpacity(0.15),
          thickness: 1,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.primaryContainer,
          labelStyle: const TextStyle(color: AppColors.goldLight, fontSize: 11),
          side: BorderSide(color: AppColors.glassBorder),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: AppColors.brownMid,
          selectedIconTheme: IconThemeData(color: AppColors.goldLight),
          unselectedIconTheme: IconThemeData(color: AppColors.textMuted),
          selectedLabelTextStyle: TextStyle(color: AppColors.goldLight, fontSize: 12),
          unselectedLabelTextStyle: TextStyle(color: AppColors.textMuted, fontSize: 12),
          indicatorColor: AppColors.primaryContainer,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.brownMid,
          indicatorColor: AppColors.primaryContainer,
          iconTheme: MaterialStateProperty.resolveWith((states) => IconThemeData(
            color: states.contains(MaterialState.selected) ? AppColors.goldLight : AppColors.textMuted,
          )),
          labelTextStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
            color: states.contains(MaterialState.selected) ? AppColors.goldLight : AppColors.textMuted,
            fontSize: 11,
          )),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.brownMid,
          contentTextStyle: const TextStyle(color: AppColors.cream),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: AppColors.glassBorder),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
