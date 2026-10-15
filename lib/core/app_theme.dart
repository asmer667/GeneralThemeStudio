import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.neonCyan,
      onPrimary: AppColors.darkBg,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.darkBg,
      secondary: AppColors.neonPurple,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: Colors.white,
      tertiary: AppColors.neonPink,
      onTertiary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: const Color(0xFF2A1613),
      onErrorContainer: AppColors.error,
      surface: AppColors.darkSurface,
      onSurface: AppColors.textDarkPrimary,
      surfaceContainerHighest: AppColors.darkContainerHigh,
      onSurfaceVariant: AppColors.textDarkSecondary,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBg,
      canvasColor: AppColors.darkBg,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDarkPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: const TextStyle(
          color: AppColors.textDarkPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        iconTheme: const IconThemeData(color: AppColors.textDarkPrimary),
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonCyan,
          foregroundColor: AppColors.darkBg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neonCyan,
          side: const BorderSide(color: AppColors.neonCyan, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkContainer.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.neonCyan, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.textDarkSecondary),
        hintStyle: const TextStyle(color: AppColors.textDarkHint),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkContainer,
        selectedColor: AppColors.neonCyan.withOpacity(0.2),
        disabledColor: AppColors.darkSurface,
        labelStyle: const TextStyle(
          color: AppColors.textDarkPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        showCheckmark: false,
      ),

      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.08),
        thickness: 1,
        space: 1,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.textDarkPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.textDarkSecondary,
          fontSize: 14,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkContainerHigh,
        contentTextStyle: const TextStyle(color: AppColors.textDarkPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 8,
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.neonCyan,
        inactiveTrackColor: AppColors.darkDivider,
        thumbColor: AppColors.neonCyan,
        overlayColor: AppColors.neonCyan.withOpacity(0.2),
        valueIndicatorColor: AppColors.neonCyan,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.neonCyan;
          }
          return AppColors.textDarkHint;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.neonCyan.withOpacity(0.3);
          }
          return AppColors.darkDivider;
        }),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.neonCyan,
        linearTrackColor: AppColors.darkDivider,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textDarkPrimary, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(color: AppColors.textDarkPrimary, fontWeight: FontWeight.w700),
        displaySmall: TextStyle(color: AppColors.textDarkPrimary, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(color: AppColors.textDarkPrimary, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: AppColors.textDarkPrimary, fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(color: AppColors.textDarkPrimary, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: AppColors.textDarkPrimary, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: AppColors.textDarkPrimary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: AppColors.textDarkSecondary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.textDarkPrimary),
        bodyMedium: TextStyle(color: AppColors.textDarkSecondary),
        bodySmall: TextStyle(color: AppColors.textDarkHint),
        labelLarge: TextStyle(color: AppColors.textDarkPrimary, fontWeight: FontWeight.w700),
        labelMedium: TextStyle(color: AppColors.textDarkSecondary),
        labelSmall: TextStyle(color: AppColors.textDarkHint),
      ),
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primaryDark,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.textLightPrimary,
      secondary: AppColors.secondaryDark,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.textLightPrimary,
      tertiary: AppColors.accent,
      onTertiary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.textLightPrimary,
      surfaceContainerHighest: AppColors.lightContainerHigh,
      onSurfaceVariant: AppColors.textLightSecondary,
      outline: AppColors.outline,
      outlineVariant: AppColors.borderLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBg,
      canvasColor: AppColors.lightBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.textLightPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: AppColors.textLightPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: AppColors.textLightPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightDivider, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightDivider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textLightPrimary, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(color: AppColors.textLightPrimary, fontWeight: FontWeight.w700),
        displaySmall: TextStyle(color: AppColors.textLightPrimary, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(color: AppColors.textLightPrimary, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: AppColors.textLightPrimary, fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(color: AppColors.textLightPrimary, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: AppColors.textLightPrimary, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: AppColors.textLightPrimary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: AppColors.textLightSecondary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.textLightPrimary),
        bodyMedium: TextStyle(color: AppColors.textLightSecondary),
        bodySmall: TextStyle(color: AppColors.textLightHint),
        labelLarge: TextStyle(color: AppColors.textLightPrimary, fontWeight: FontWeight.w700),
        labelMedium: TextStyle(color: AppColors.textLightSecondary),
        labelSmall: TextStyle(color: AppColors.textLightHint),
      ),
    );
  }
}
