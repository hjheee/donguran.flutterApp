import 'package:flutter/material.dart';

/// Figma Design system 컴포넌트에서 관찰된 borderRadius 값.
///
/// 4: 컬러 토큰 카드 / indicator bar · 16: account card, content card · 20: quotation card
/// 24: alert · 32: datepicker 시트 상단 · 99: pill (chip, toggle, badge, toast, tooltip, FAB, segment)
abstract final class AppRadius {
  static const double r4 = 4;
  static const double r16 = 16;
  static const double r20 = 20;
  static const double r24 = 24;
  static const double r32 = 32;
  static const double pill = 99;

  static BorderRadius circular(double radius) => BorderRadius.circular(radius);

  /// 바텀시트/데이트피커 상단만 둥근 형태 (Figma "32px 32px 0px 0px").
  static const BorderRadius topSheet =
      BorderRadius.vertical(top: Radius.circular(r32));
}
