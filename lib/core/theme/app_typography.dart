import 'package:flutter/material.dart';

/// Figma 타이포 컴포넌트 셋 "Component 1"(node 164:10090)의 `lang` 축.
enum AppLang { ko, eng }

/// Figma `weignt` 축 (원문 오타 그대로 5단계).
enum AppFontWeight { light, regular, medium, bold, extrabold }

/// Figma Design system 타이포 스케일.
///
/// - KO: Gothic A1, line-height 1.5em (Figma 스타일 `KO bo 16`에서 확인)
/// - ENG: Poppins, line-height 1.35em (Figma 스타일 `ENG re 14`에서 확인)
/// - weight 매핑 중 Figma로 확인된 것은 KO bold=800, ENG regular=400.
///   나머지는 가정값이며 docs/design-system.md "재확인 필요" 표에 기록되어 있다.
abstract final class AppTypography {
  static const String koFamily = 'GothicA1';
  static const String engFamily = 'Poppins';

  static const double koLineHeight = 1.5;
  static const double engLineHeight = 1.35;

  /// Figma `size` 축.
  static const List<int> sizes = [11, 12, 13, 14, 15, 16, 18, 20, 24, 28, 32];

  static FontWeight weightOf(AppLang lang, AppFontWeight weight) {
    return switch ((lang, weight)) {
      (_, AppFontWeight.light) => FontWeight.w300,
      (_, AppFontWeight.regular) => FontWeight.w400,
      (_, AppFontWeight.medium) => FontWeight.w500,
      (AppLang.ko, AppFontWeight.bold) => FontWeight.w800,
      (AppLang.eng, AppFontWeight.bold) => FontWeight.w700,
      (AppLang.ko, AppFontWeight.extrabold) => FontWeight.w900,
      (AppLang.eng, AppFontWeight.extrabold) => FontWeight.w800,
    };
  }

  static TextStyle style(AppLang lang, AppFontWeight weight, int size) {
    if (!sizes.contains(size)) {
      throw ArgumentError.value(
          size, 'size', 'not in the Figma type scale $sizes',);
    }
    final isKo = lang == AppLang.ko;
    return TextStyle(
      fontFamily: isKo ? koFamily : engFamily,
      fontWeight: weightOf(lang, weight),
      fontSize: size.toDouble(),
      height: isKo ? koLineHeight : engLineHeight,
    );
  }

  static TextStyle ko(AppFontWeight weight, int size) =>
      style(AppLang.ko, weight, size);

  static TextStyle eng(AppFontWeight weight, int size) =>
      style(AppLang.eng, weight, size);
}
