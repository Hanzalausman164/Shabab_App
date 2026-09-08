import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(Color primaryText, Color secondaryText) {
    final base = GoogleFonts.robotoTextTheme();
    return base
        .copyWith(
          displayLarge: GoogleFonts.archivo(fontWeight: FontWeight.w800, color: primaryText),
          displayMedium: GoogleFonts.archivo(fontWeight: FontWeight.w800, color: primaryText),
          headlineLarge: GoogleFonts.archivo(fontWeight: FontWeight.w800, fontSize: 26, color: primaryText),
          headlineMedium: GoogleFonts.archivo(fontWeight: FontWeight.w700, fontSize: 22, color: primaryText),
          headlineSmall: GoogleFonts.archivo(fontWeight: FontWeight.w700, fontSize: 18, color: primaryText),
          titleLarge: GoogleFonts.archivo(fontWeight: FontWeight.w700, fontSize: 17, color: primaryText),
          titleMedium: GoogleFonts.archivo(fontWeight: FontWeight.w600, fontSize: 15, color: primaryText),
          titleSmall: GoogleFonts.archivo(fontWeight: FontWeight.w600, fontSize: 13, color: primaryText),
          bodyLarge: GoogleFonts.roboto(fontSize: 15, color: primaryText),
          bodyMedium: GoogleFonts.roboto(fontSize: 13.5, color: secondaryText),
          bodySmall: GoogleFonts.roboto(fontSize: 12, color: secondaryText),
          labelLarge: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 14, color: primaryText),
          labelMedium: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 12, color: secondaryText),
          labelSmall: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 11, color: secondaryText),
        )
        .apply(bodyColor: primaryText, displayColor: primaryText);
  }

  static ThemeData get dark {
    const bg = AppColors.darkBg;
    const surface = AppColors.darkSurface;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      primaryColor: AppColors.darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkAccent,
        surface: surface,
        error: AppColors.dangerDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
        onError: Colors.white,
      ),
      textTheme: _textTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),
      dividerColor: AppColors.darkBorder,
      cardColor: surface,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: GoogleFonts.archivo(
          fontWeight: FontWeight.w700,
          fontSize: 17,
          color: AppColors.darkTextPrimary,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceAlt,
        hintStyle: GoogleFonts.roboto(color: AppColors.darkMuted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
      splashFactory: InkRipple.splashFactory,
    );
  }

  static ThemeData get light {
    const bg = AppColors.lightBg;
    const surface = AppColors.lightSurface;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      primaryColor: AppColors.lightPrimary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightAccent,
        surface: surface,
        error: AppColors.dangerLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
        onError: Colors.white,
      ),
      textTheme: _textTheme(AppColors.lightTextPrimary, AppColors.lightTextSecondary),
      dividerColor: AppColors.lightBorder,
      cardColor: surface,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
        shadowColor: AppColors.lightPrimary.withValues(alpha: 0.08),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
        titleTextStyle: GoogleFonts.archivo(
          fontWeight: FontWeight.w700,
          fontSize: 17,
          color: AppColors.lightTextPrimary,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.lightMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceAlt,
        hintStyle: GoogleFonts.roboto(color: AppColors.lightMuted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
