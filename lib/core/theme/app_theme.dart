import 'package:donguran/core/theme/app_colors.dart';
import 'package:donguran/core/theme/app_radius.dart';
import 'package:donguran/core/theme/app_semantic_colors.dart';
import 'package:donguran/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// 앱 ThemeData 조립. 라이트만 제공한다(스펙 6절).
abstract final class AppTheme {
  static ThemeData light() {
    const semantic = AppSemanticColors.light;
    final colorScheme = ColorScheme.light(
      primary: semantic.primary,
      onPrimary: semantic.onPrimary,
      secondary: AppColors.gray900,
      onSecondary: AppColors.white,
      surface: semantic.surface,
      onSurface: semantic.textPrimary,
      error: AppColors.coral700,
      outline: semantic.borderStrong,
      outlineVariant: semantic.border,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: semantic.surface,
      fontFamily: AppTypography.koFamily,
      textTheme: _textTheme(semantic),
      dividerTheme:
          DividerThemeData(color: semantic.divider, thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circular(AppRadius.pill),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: semantic.surface,
        indicatorColor: Colors.transparent,
        labelTextStyle:
            WidgetStatePropertyAll(AppTypography.ko(AppFontWeight.medium, 11)),
      ),
      extensions: const [semantic],
    );
  }

  /// Material 역할 ↔ Figma 스케일 매핑. 정본은 docs/design-system.md.
  static TextTheme _textTheme(AppSemanticColors s) {
    TextStyle ko(AppFontWeight w, int size) =>
        AppTypography.ko(w, size).copyWith(color: s.textPrimary);
    return TextTheme(
      displayLarge: ko(AppFontWeight.bold, 32),
      headlineLarge: ko(AppFontWeight.bold, 28),
      headlineMedium: ko(AppFontWeight.bold, 24),
      titleLarge: ko(AppFontWeight.bold, 20),
      titleMedium: ko(AppFontWeight.bold, 18),
      titleSmall: ko(AppFontWeight.bold, 16),
      bodyLarge: ko(AppFontWeight.regular, 16),
      bodyMedium: ko(AppFontWeight.regular, 15),
      bodySmall: ko(AppFontWeight.regular, 14),
      labelLarge: ko(AppFontWeight.medium, 14),
      labelMedium: ko(AppFontWeight.medium, 13),
      labelSmall: ko(AppFontWeight.medium, 12),
    );
  }
}
