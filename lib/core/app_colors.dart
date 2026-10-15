import 'package:flutter/material.dart';

/// لوحة ألوان Neon/Glass
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════
  // Neon Colors
  // ═══════════════════════════════════════════
  static const Color neonCyan = Color(0xFF16D9F2);
  static const Color neonPurple = Color(0xFF8B5CF6);
  static const Color neonPink = Color(0xFFFF6B9D);
  static const Color neonGreen = Color(0xFF10E5A0);
  static const Color neonBlue = Color(0xFF3B82F6);
  static const Color neonOrange = Color(0xFFFF9500);
  static const Color neonYellow = Color(0xFFFFD700);
  static const Color neonRed = Color(0xFFFF3D5A);
  static const Color neonMagenta = Color(0xFFE91E63);
  static const Color neonLime = Color(0xFFCDDC39);
  static const Color neonTeal = Color(0xFF00BCD4);
  static const Color neonIndigo = Color(0xFF5C6BC0);

  // Primary / Secondary
  static const Color primary = neonCyan;
  static const Color primaryDark = Color(0xFF0A8DA0);
  static const Color primaryLight = Color(0xFF6EE8F5);
  static const Color secondary = neonPurple;
  static const Color secondaryDark = Color(0xFF6D3FE0);
  static const Color secondaryLight = Color(0xFFA989F9);
  static const Color accent = neonPink;

  // Dark Backgrounds
  static const Color darkBg = Color(0xFF05070D);
  static const Color darkBgElevated = Color(0xFF0A0F1A);
  static const Color darkSurface = Color(0xFF0F1621);
  static const Color darkContainer = Color(0xFF141C2B);
  static const Color darkContainerHigh = Color(0xFF1A2536);
  static const Color darkDivider = Color(0xFF223046);

  // Glass
  static Color glassLight = Colors.white.withOpacity(0.05);
  static Color glassMedium = Colors.white.withOpacity(0.08);
  static Color glassHeavy = Colors.white.withOpacity(0.14);
  static Color glassBorder = Colors.white.withOpacity(0.10);
  static Color glassBorderBright = Colors.white.withOpacity(0.22);

  // Light Backgrounds
  static const Color lightBg = Color(0xFFF5F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightContainer = Color(0xFFEBF1F8);
  static const Color lightContainerHigh = Color(0xFFDDE7F2);
  static const Color lightDivider = Color(0xFFC5D4E2);

  // Text
  static const Color textDarkPrimary = Color(0xFFF4FAFF);
  static const Color textDarkSecondary = Color(0xFFB8D4E2);
  static const Color textDarkHint = Color(0xFF6E8499);
  static const Color textLightPrimary = Color(0xFF071426);
  static const Color textLightSecondary = Color(0xFF3D5A70);
  static const Color textLightHint = Color(0xFF8FA8B8);

  // Status
  static const Color success = Color(0xFF10E5A0);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFFF3D5A);
  static const Color info = Color(0xFF3B82F6);

  // Borders
  static const Color borderDark = Color(0xFF327D9D);
  static const Color borderLight = Color(0xFFB8D4E2);
  static const Color outline = Color(0xFF327D9D);
  static const Color outlineVariant = Color(0xFF1F4A68);

  // ═══════════════════════════════════════════
  // Gradients
  // ═══════════════════════════════════════════
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [neonCyan, neonPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient auroraGradient = LinearGradient(
    colors: [neonCyan, neonPurple, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [neonOrange, neonPink, neonPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [neonCyan, neonBlue, neonPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fireGradient = LinearGradient(
    colors: [neonYellow, neonOrange, neonRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient forestGradient = LinearGradient(
    colors: [neonGreen, neonCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient rainbowGradient = LinearGradient(
    colors: [neonRed, neonOrange, neonYellow, neonGreen, neonCyan, neonBlue, neonPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBg, darkBgElevated],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x08FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient meshGradient = LinearGradient(
    colors: [
      Color(0xFF16D9F2),
      Color(0xFF8B5CF6),
      Color(0xFFFF6B9D),
      Color(0xFF16D9F2),
    ],
    stops: [0.0, 0.33, 0.66, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ═══════════════════════════════════════════
  // Glow Shadows
  // ═══════════════════════════════════════════
  static List<BoxShadow> glow(Color color, {double intensity = 1.0}) {
    return [
      BoxShadow(
        color: color.withOpacity(0.4 * intensity),
        blurRadius: 16 * intensity,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: color.withOpacity(0.2 * intensity),
        blurRadius: 32 * intensity,
        spreadRadius: 4,
      ),
    ];
  }

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  // Presets — 40 لون
  static const List<Color> colorPresets = [
    neonCyan, neonPurple, neonPink, neonGreen,
    neonBlue, neonOrange, neonYellow, neonRed,
    neonMagenta, neonLime, neonTeal, neonIndigo,
    Color(0xFF00E5FF), Color(0xFFFF6E40), Color(0xFF651FFF), Color(0xFF00E676),
    Color(0xFF6EE8F5), Color(0xFFA989F9), Color(0xFFFFB4CE), Color(0xFF7EE8B5),
    Color(0xFF85BAFF), Color(0xFFFFC685), Color(0xFFFFF085), Color(0xFFFF8888),
    Color(0xFF071426), Color(0xFF102C43), Color(0xFF183D58), Color(0xFF0A1A28),
    Color(0xFF0F1621), Color(0xFF141C2B), Color(0xFF1A2536), Color(0xFF223046),
    Color(0xFFFFFFFF), Color(0xFFF5F8FC), Color(0xFF808080), Color(0xFF000000),
    Color(0xFF8B5A2B), Color(0xFF654321), Color(0xFFD2691E), Color(0xFFCD853F),
  ];
}
