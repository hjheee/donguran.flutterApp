import 'package:donguran/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// 역할(시맨틱) 컬러. Figma에는 시맨틱 정의가 없어 컴포넌트 사용례에서 유도했다.
/// 유도 근거 표: docs/design-system.md "시맨틱 토큰".
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.primary,
    required this.onPrimary,
    required this.surface,
    required this.surfaceLow,
    required this.surfaceInverse,
    required this.onSurfaceInverse,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.border,
    required this.borderStrong,
    required this.divider,
    required this.disabled,
    required this.scrim,
  });

  /// toggle on / indicator on / mark on / tooltip primary
  final Color primary;
  final Color onPrimary;

  /// 기본 화면 배경
  final Color surface;

  /// content card, quotation card(after) 배경
  final Color surfaceLow;

  /// chip on 배경
  final Color surfaceInverse;
  final Color onSurfaceInverse;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;

  /// content card stroke
  final Color border;

  /// chip off stroke
  final Color borderStrong;

  /// 섹션 구분선
  final Color divider;

  /// toggle off
  final Color disabled;

  /// toast 배경
  final Color scrim;

  static const AppSemanticColors light = AppSemanticColors(
    primary: AppColors.coral500,
    onPrimary: AppColors.white,
    surface: AppColors.white,
    surfaceLow: AppColors.gray50,
    surfaceInverse: AppColors.gray900,
    onSurfaceInverse: AppColors.white,
    textPrimary: AppColors.black,
    textSecondary: AppColors.gray600,
    textDisabled: AppColors.gray400,
    border: AppColors.gray100,
    borderStrong: AppColors.gray200,
    divider: AppColors.blackAlpha7,
    disabled: AppColors.gray500,
    scrim: AppColors.toast,
  );

  @override
  AppSemanticColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? surface,
    Color? surfaceLow,
    Color? surfaceInverse,
    Color? onSurfaceInverse,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? border,
    Color? borderStrong,
    Color? divider,
    Color? disabled,
    Color? scrim,
  }) {
    return AppSemanticColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      surface: surface ?? this.surface,
      surfaceLow: surfaceLow ?? this.surfaceLow,
      surfaceInverse: surfaceInverse ?? this.surfaceInverse,
      onSurfaceInverse: onSurfaceInverse ?? this.onSurfaceInverse,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      divider: divider ?? this.divider,
      disabled: disabled ?? this.disabled,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLow: Color.lerp(surfaceLow, other.surfaceLow, t)!,
      surfaceInverse: Color.lerp(surfaceInverse, other.surfaceInverse, t)!,
      onSurfaceInverse:
          Color.lerp(onSurfaceInverse, other.onSurfaceInverse, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}

extension AppSemanticColorsX on BuildContext {
  /// `Theme.of(context).extension<AppSemanticColors>()!` 단축.
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
}
