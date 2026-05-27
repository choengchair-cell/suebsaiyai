import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Brand palette (matches landing.html CSS variables) ───────────────────
  static const Color gold         = Color(0xFFC9922A);
  static const Color goldLight    = Color(0xFFE8B94A);
  static const Color goldPale     = Color(0xFFF5E6C0);

  static const Color brownDark    = Color(0xFF0D0800);
  static const Color brownMid     = Color(0xFF1A0F00);
  static const Color brownWarm    = Color(0xFF2D1A00);
  static const Color cream        = Color(0xFFF7F0E3);

  // ─── Glass / overlay ──────────────────────────────────────────────────────
  static const Color glassBorder  = Color(0x47C9922A);

  // ─── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary  = cream;
  static const Color textLight    = Color(0xD1F7F0E3);
  static const Color textMuted    = Color(0x80F7F0E3);
  static const Color textOnGold   = brownDark;

  // ─── Status chips ─────────────────────────────────────────────────────────
  static const Color draft        = Color(0xFF9E9E9E);
  static const Color submitted    = Color(0xFF2196F3);
  static const Color underReview  = Color(0xFFFF9800);
  static const Color approved     = Color(0xFF4CAF50);
  static const Color published    = goldLight;
  static const Color archived     = Color(0xFF795548);

  // ─── Semantic ─────────────────────────────────────────────────────────────
  static const Color error            = Color(0xFFCF6679);
  static const Color errorContainer   = Color(0xFF93000A);
  static const Color surface          = brownMid;
  static const Color background       = brownDark;

  // ─── AI indicator ─────────────────────────────────────────────────────────
  static const Color aiAccent         = Color(0xFFE8B94A);
  static const Color aiContainer      = Color(0x26C9922A);

  // ─── Material scheme aliases ───────────────────────────────────────────────
  static const Color primary          = gold;
  static const Color primaryLight     = goldLight;
  static const Color primaryContainer = Color(0x26C9922A);
  static const Color onPrimary        = brownDark;
  static const Color secondary        = goldPale;
  static const Color onSecondary      = brownDark;
}
