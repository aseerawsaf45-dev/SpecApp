import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primaryBlack = Color(0xFF0A0A0A);
  static const Color deepBlack = Color(0xFF050505);
  static const Color charcoal = Color(0xFF141414);
  static const Color elevatedSurface = Color(0xFF1C1C1C);
  
  static const Color primaryYellow = Color(0xFFFFD21F);
  static const Color brightYellow = Color(0xFFFFE66B);
  
  // Text
  static const Color white = Color(0xFFFFFFFF);
  static const Color mutedWhite = Color(0xFFB8B8B8);
  
  // Borders
  static const Color darkBorder = Color(0xFF292929);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFD21F), Color(0xFFFFB800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF050505), Color(0xFF161616), Color(0xFF2A2205)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Glows
  static RadialGradient yellowGlow(double opacity) {
    return RadialGradient(
      colors: [
        primaryYellow.withValues(alpha: opacity),
        Colors.transparent,
      ],
      center: Alignment.center,
      radius: 1.0,
    );
  }
}
