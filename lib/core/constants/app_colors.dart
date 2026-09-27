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
  
  // Status Accents
  static const Color statusGreen = Color(0xFF22C55E);
  static const Color statusAmber = Color(0xFFF59E0B);
  static const Color statusRed = Color(0xFFEF4444);
  static const Color statusCyan = Color(0xFF06B6D4);
  static const Color surfaceHover = Color(0xFF242424);
  static const Color pillBackground = Color(0xFF1A1A1A);

  // Borders
  static const Color darkBorder = Color(0xFF292929);
  static const Color subtleBorder = Color(0xFF1F1F1F);
  static const Color activeBorder = Color(0x66FFD21F);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFD21F), Color(0xFFFFB800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient metallicBorderGradient = LinearGradient(
    colors: [Color(0xFF383838), Color(0xFF1F1F1F), Color(0xFF2A2A2A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldBorderGradient = LinearGradient(
    colors: [Color(0xFFFFD21F), Color(0x33FFD21F), Color(0xFF292929)],
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

  static List<BoxShadow> yellowBoxShadow({double opacity = 0.25, double blur = 18}) {
    return [
      BoxShadow(
        color: primaryYellow.withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: 1,
      ),
    ];
  }
}
