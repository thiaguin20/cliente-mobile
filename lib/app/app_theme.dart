import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlue,
      brightness: Brightness.light,
    );

    return _base(colorScheme).copyWith(
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.textPrimary,
      ),
      cardColor: Colors.white,
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.supportBlue,
      brightness: Brightness.dark,
    );

    return _base(colorScheme).copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
      ),
      cardColor: AppColors.darkSurface,
    );
  }

  static ThemeData _base(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Roboto',
      visualDensity: VisualDensity.standard,
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
