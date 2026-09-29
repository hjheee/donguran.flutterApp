import 'package:donguran/core/theme/app_radius.dart';
import 'package:donguran/core/theme/app_shadows.dart';
import 'package:donguran/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppSpacing matches the Figma padding component set', () {
    expect(AppSpacing.all, [
      2,
      4,
      8,
      10,
      12,
      16,
      20,
      24,
      28,
      32,
      36,
      40,
      48,
      56,
      64,
      80,
      100,
      120,
      156,
    ]);
    expect(AppSpacing.s16, 16);
  });

  test('AppRadius values', () {
    expect(AppRadius.pill, 99);
    expect(AppRadius.circular(AppRadius.r16), BorderRadius.circular(16));
    expect(
      AppRadius.topSheet,
      const BorderRadius.vertical(top: Radius.circular(32)),
    );
  });

  test('AppShadows card = 0 4 8 rgba(20,20,20,.12)', () {
    final s = AppShadows.card.single;
    expect(s.offset, const Offset(0, 4));
    expect(s.blurRadius, 8);
    expect(s.color, const Color.fromRGBO(20, 20, 20, 0.12));
    expect(AppShadows.tooltip, hasLength(1));
    expect(AppShadows.quotation, hasLength(1));
  });
}
