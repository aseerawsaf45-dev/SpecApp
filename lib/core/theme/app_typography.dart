import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Centralized premium typography system for AppSpecs.
/// Utilizes Plus Jakarta Sans for geometric luxury headlines/body,
/// and JetBrains Mono for mission-critical telemetry, timestamps, and codes.
class AppTypography {
  AppTypography._();

  // ==========================================
  // FONT FAMILIES
  // ==========================================
  static final TextStyle _headingBase = GoogleFonts.plusJakartaSans();
  static final TextStyle _bodyBase = GoogleFonts.plusJakartaSans();
  static final TextStyle _monoBase = GoogleFonts.jetBrainsMono();

  // ==========================================
  // DISPLAY / HERO
  // ==========================================
  static TextStyle displayHero({
    Color color = AppColors.white,
    double fontSize = 38,
    FontWeight fontWeight = FontWeight.w800,
    double height = 1.05,
    double letterSpacing = -0.8,
  }) {
    return _headingBase.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // ==========================================
  // HEADINGS
  // ==========================================
  static TextStyle heading({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w700,
    Color color = AppColors.white,
    double? height,
    double? letterSpacing,
  }) {
    return _headingBase.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing ?? -0.3,
    );
  }

  static TextStyle headingLarge({Color color = AppColors.white}) =>
      heading(fontSize: 24, fontWeight: FontWeight.w800, color: color, letterSpacing: -0.5);

  static TextStyle headingMedium({Color color = AppColors.white}) =>
      heading(fontSize: 18, fontWeight: FontWeight.w700, color: color, letterSpacing: -0.3);

  static TextStyle headingSmall({Color color = AppColors.white}) =>
      heading(fontSize: 15, fontWeight: FontWeight.w700, color: color);

  // ==========================================
  // SECTION HEADERS / LABELS
  // ==========================================
  static TextStyle sectionHeader({
    Color color = AppColors.mutedWhite,
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.w800,
    double letterSpacing = 1.4,
  }) {
    return _headingBase.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle badge({
    Color color = AppColors.primaryYellow,
    double fontSize = 10,
    FontWeight fontWeight = FontWeight.w800,
    double letterSpacing = 1.2,
  }) {
    return _headingBase.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // ==========================================
  // BODY
  // ==========================================
  static TextStyle body({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.mutedWhite,
    double? height = 1.5,
    double? letterSpacing = 0.1,
  }) {
    return _bodyBase.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle bodyLarge({Color color = AppColors.white}) =>
      body(fontSize: 15, fontWeight: FontWeight.w500, color: color);

  static TextStyle bodyMedium({Color color = AppColors.mutedWhite}) =>
      body(fontSize: 13, fontWeight: FontWeight.w400, color: color);

  static TextStyle bodySmall({Color color = AppColors.mutedWhite}) =>
      body(fontSize: 11, fontWeight: FontWeight.w400, color: color);

  // ==========================================
  // TELEMETRY / MONOSPACE / CODES
  // ==========================================
  static TextStyle telemetry({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.primaryYellow,
    double? letterSpacing = 0.5,
  }) {
    return _monoBase.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle timestamp({Color color = AppColors.mutedWhite}) =>
      telemetry(fontSize: 11, fontWeight: FontWeight.w500, color: color, letterSpacing: 0.2);

  static TextStyle code({Color color = AppColors.primaryYellow}) =>
      telemetry(fontSize: 12, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.8);
}
