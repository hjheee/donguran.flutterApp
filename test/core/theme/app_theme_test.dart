import 'package:donguran/core/theme/app_colors.dart';
import 'package:donguran/core/theme/app_semantic_colors.dart';
import 'package:donguran/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme.light', () {
    final theme = AppTheme.light();

    test('primary is coral500 and surfaces are white', () {
      expect(theme.colorScheme.primary, AppColors.coral500);
      expect(theme.scaffoldBackgroundColor, AppColors.white);
      expect(theme.useMaterial3, isTrue);
    });

    test('exposes AppSemanticColors extension', () {
      final semantic = theme.extension<AppSemanticColors>();
      expect(semantic, isNotNull);
      expect(semantic!.primary, AppColors.coral500);
      expect(semantic.surfaceInverse, AppColors.gray900);
      expect(semantic.divider, AppColors.blackAlpha7);
      expect(semantic.disabled, AppColors.gray500);
    });

    test('text theme uses Gothic A1', () {
      expect(theme.textTheme.bodyLarge!.fontFamily, 'GothicA1');
      expect(theme.textTheme.bodyLarge!.fontSize, 16);
      expect(theme.textTheme.titleLarge!.fontWeight, FontWeight.w800);
    });

    test('copyWith and lerp keep values', () {
      const s = AppSemanticColors.light;
      expect(s.lerp(s, 0.5).primary, s.primary);
      expect(s.copyWith(primary: AppColors.blue500).primary, AppColors.blue500);
    });
  });

  testWidgets('context.semanticColors reads the extension', (tester) async {
    late AppSemanticColors seen;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) {
            seen = context.semanticColors;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(seen.primary, AppColors.coral500);
  });
}
