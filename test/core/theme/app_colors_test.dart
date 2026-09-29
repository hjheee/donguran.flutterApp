import 'package:donguran/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors', () {
    test('chromatic scales have 10 steps each', () {
      for (final scale in [
        AppColors.coralScale,
        AppColors.greenScale,
        AppColors.orangeScale,
        AppColors.yellowScale,
        AppColors.blueScale,
        AppColors.purpleScale,
      ]) {
        expect(scale, hasLength(10));
      }
    });

    test('gray scale has 12 steps, alpha scales 8 steps', () {
      expect(AppColors.grayScale, hasLength(12));
      expect(AppColors.whiteAlphaScale, hasLength(8));
      expect(AppColors.blackAlphaScale, hasLength(8));
    });

    test('brand primary and Figma-confirmed values match', () {
      expect(AppColors.coral500, const Color(0xFFF56751));
      expect(AppColors.yellow800, const Color(0xFFCBA300));
      expect(AppColors.gray900, const Color(0xFF332F2B));
      expect(AppColors.gray50, const Color(0xFFFBFAFA));
      expect(AppColors.black, const Color(0xFF141414));
      expect(AppColors.white, const Color(0xFFFFFFFF));
    });

    test('scales get darker as step increases', () {
      for (final scale in [
        AppColors.coralScale,
        AppColors.greenScale,
        AppColors.orangeScale,
        AppColors.yellowScale,
        AppColors.blueScale,
        AppColors.purpleScale,
        AppColors.grayScale,
      ]) {
        for (var i = 1; i < scale.length; i++) {
          expect(
            scale[i].computeLuminance(),
            lessThan(scale[i - 1].computeLuminance()),
            reason: 'step $i of $scale is not darker than step ${i - 1}',
          );
        }
      }
    });

    test('alpha scales are ordered by increasing opacity', () {
      for (final scale in [
        AppColors.whiteAlphaScale,
        AppColors.blackAlphaScale,
      ]) {
        for (var i = 1; i < scale.length; i++) {
          expect(scale[i].a, greaterThan(scale[i - 1].a));
        }
      }
    });
  });
}
