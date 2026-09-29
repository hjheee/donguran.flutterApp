import 'package:donguran/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTypography', () {
    test('type scale has the 11 Figma sizes', () {
      expect(AppTypography.sizes, [11, 12, 13, 14, 15, 16, 18, 20, 24, 28, 32]);
    });

    test('generates all 110 styles (2 lang x 5 weight x 11 size)', () {
      var count = 0;
      for (final lang in AppLang.values) {
        for (final weight in AppFontWeight.values) {
          for (final size in AppTypography.sizes) {
            final s = AppTypography.style(lang, weight, size);
            expect(s.fontSize, size.toDouble());
            count++;
          }
        }
      }
      expect(count, 110);
    });

    test('KO uses Gothic A1 with 1.5 line height (Figma "KO bo 16")', () {
      final s = AppTypography.ko(AppFontWeight.bold, 16);
      expect(s.fontFamily, 'GothicA1');
      expect(s.fontWeight, FontWeight.w800);
      expect(s.height, 1.5);
      expect(s.fontSize, 16);
    });

    test('ENG uses Poppins with 1.35 line height (Figma "ENG re 14")', () {
      final s = AppTypography.eng(AppFontWeight.regular, 14);
      expect(s.fontFamily, 'Poppins');
      expect(s.fontWeight, FontWeight.w400);
      expect(s.height, 1.35);
    });

    test('rejects sizes outside the Figma scale', () {
      expect(
        () => AppTypography.ko(AppFontWeight.regular, 17),
        throwsArgumentError,
      );
    });
  });
}
