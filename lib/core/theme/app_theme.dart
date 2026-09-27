import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.primaryBlack,
      primaryColor: AppColors.primaryYellow,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryYellow,
        secondary: AppColors.brightYellow,
        surface: AppColors.charcoal,
        onSurface: AppColors.white,
        outline: AppColors.darkBorder,
        error: Colors.redAccent,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.elevatedSurface,
        hintStyle: GoogleFonts.manrope(
          color: AppColors.mutedWhite.withValues(alpha: 0.6),
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryYellow, width: 1.5),
        ),
      ),
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.manrope(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.white),
        displayMedium: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.white),
        titleLarge: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.white),
        titleMedium: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.white),
        titleSmall: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white),
        bodyLarge: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.white),
        bodyMedium: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.white),
        labelLarge: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.mutedWhite),
        labelSmall: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.mutedWhite),
      ),
      cardTheme: CardThemeData(
        color: AppColors.charcoal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlack,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.deepBlack,
        selectedItemColor: AppColors.primaryYellow,
        unselectedItemColor: AppColors.mutedWhite,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryYellow,
          foregroundColor: AppColors.deepBlack,
          textStyle: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}
