import 'package:flutter/material.dart';

/// Figma Design system effect 스타일.
abstract final class AppShadows {
  /// 컬러 토큰 카드 등 — Figma effect_7777830f
  static const List<BoxShadow> card = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 8,
      color: Color.fromRGBO(20, 20, 20, 0.12),
    ),
  ];

  /// tooltip secondary — Figma effect_7fe4a8af
  static const List<BoxShadow> tooltip = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 8,
      color: Color.fromRGBO(140, 138, 136, 0.16),
    ),
  ];

  /// quotation card (before) — Figma effect_f56d5c8c
  static const List<BoxShadow> quotation = [
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 12,
      color: Color.fromRGBO(140, 138, 136, 0.10),
    ),
  ];
}
