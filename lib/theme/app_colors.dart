import 'package:flutter/material.dart';

/// Central design-token file. Every screen pulls its colors from here so the
/// app stays visually consistent, and so dark/light mode is a single switch.
///
/// The brand gradient (Indigo -> Plum -> Crimson) comes straight from the
/// Shabab logo splash screen. Both themes are built around that same hue
/// family so light mode still "feels" like the same brand, just lifted onto
/// a bright surface instead of a dark one.
class AppColors {
  AppColors._();

  // ---- Brand gradient (shared by both themes; used for splash, headers,
  // hero cards, and the primary CTA gradient) ----
  static const Color brandIndigo = Color(0xFF1A1B6E);
  static const Color brandPlum = Color(0xFF5F1A5A);
  static const Color brandCrimson = Color(0xFFE31B23);

  static const List<Color> brandGradient = [brandIndigo, brandPlum, brandCrimson];

  static LinearGradient brandGradientDiagonal({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) =>
      LinearGradient(begin: begin, end: end, colors: brandGradient);

  // ---- Semantic status colors (same hues, both themes; only shade differs) ----
  static const Color successDark = Color(0xFF10B981);
  static const Color successLight = Color(0xFF059669);

  static const Color warningDark = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFB45309);

  static const Color dangerDark = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFDC2626);

  static const Color infoDark = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF2563EB);

  // ================= DARK THEME =================
  static const Color darkBg = Color(0xFF0A081D);
  static const Color darkSurface = Color(0xFF100D2D);
  static const Color darkSurfaceAlt = Color(0xFF161435);
  static const Color darkBorder = Color(0xFF2C2955);
  static const Color darkMuted = Color(0xFF94A3B8);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkPrimary = Color(0xFF6D6AF0); // lifted indigo, readable on dark
  static const Color darkAccent = Color(0xFFB4519E); // lifted plum

  // ================= LIGHT THEME =================
  // Bright, warm-neutral background (not stark white) so cards can pop with
  // a soft shadow instead of a hard border, and the brand indigo stays the
  // clear "this is Shabab" anchor color.
  static const Color lightBg = Color(0xFFF6F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFEFF1F8);
  static const Color lightBorder = Color(0xFFE3E6F0);
  static const Color lightMuted = Color(0xFF64748B);
  static const Color lightTextPrimary = Color(0xFF14132B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightPrimary = Color(0xFF35328F); // deep indigo, AA on white
  static const Color lightAccent = Color(0xFF8B2F6B); // deep plum, AA on white

  // Role badge tints — used consistently across all three home screens.
  static const Color roleMurabbi = Color(0xFF3B82F6);
  static const Color roleParkAdmin = Color(0xFFB4519E);
  static const Color roleCityMasul = Color(0xFFE31B23);
}
