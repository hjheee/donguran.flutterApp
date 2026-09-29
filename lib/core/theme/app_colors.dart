import 'package:flutter/material.dart';

/// Figma "Design system" 페이지(node 164:7979)의 원시 컬러 팔레트.
///
/// 단계 번호는 Figma 라벨 규칙(밝은 순 100~1000)을 따른다. 예: Figma `yel 800` → [yellow800].
/// 헥스값은 Figma 확인값 그대로이며 임의 보정하지 않는다. 출처: docs/design-system.md
abstract final class AppColors {
  // ---- Coral (브랜드 primary) — Figma node 166:5100~5145
  static const Color coral100 = Color(0xFFFFEBE9);
  static const Color coral200 = Color(0xFFFFCFC9);
  static const Color coral300 = Color(0xFFFFA79C);
  static const Color coral400 = Color(0xFFFF7F6E);
  static const Color coral500 = Color(0xFFF56751);
  static const Color coral600 = Color(0xFFF25641);
  static const Color coral700 = Color(0xFFE03C26);
  static const Color coral800 = Color(0xFFCC2A14);
  static const Color coral900 = Color(0xFFB21500);
  static const Color coral1000 = Color(0xFF941100);

  // ---- Green — Figma node 166:5203~5248
  static const Color green100 = Color(0xFFD6FFCC);
  static const Color green200 = Color(0xFFB4F7A3);
  static const Color green300 = Color(0xFF84ED6B);
  static const Color green400 = Color(0xFF54DB32);
  static const Color green500 = Color(0xFF3ACB15);
  static const Color green600 = Color(0xFF00B206);
  static const Color green700 = Color(0xFF00A606);
  static const Color green800 = Color(0xFF189100);
  static const Color green900 = Color(0xFF137500);
  static const Color green1000 = Color(0xFF105E00);

  // ---- Orange — Figma node 164:10755~10790, 166:5086
  static const Color orange100 = Color(0xFFFFEFDE);
  static const Color orange200 = Color(0xFFFFE4C7);
  static const Color orange300 = Color(0xFFFFCC96);
  static const Color orange400 = Color(0xFFFFC180);
  static const Color orange500 = Color(0xFFFFB469);
  static const Color orange600 = Color(0xFFFFA340);
  static const Color orange700 = Color(0xFFF0872B);
  static const Color orange800 = Color(0xFFD46300);
  static const Color orange900 = Color(0xFFB25300);
  static const Color orange1000 = Color(0xFF803700);

  // ---- Yellow — Figma node 166:5041~5095 (yel 800 = 166:5076 확인)
  static const Color yellow100 = Color(0xFFFFF8D2);
  static const Color yellow200 = Color(0xFFFFF3AD);
  static const Color yellow300 = Color(0xFFFFED89);
  static const Color yellow400 = Color(0xFFFFE75D);
  static const Color yellow500 = Color(0xFFFFDC52);
  static const Color yellow600 = Color(0xFFF7CD23);
  static const Color yellow700 = Color(0xFFE4B700);
  static const Color yellow800 = Color(0xFFCBA300);
  static const Color yellow900 = Color(0xFFB08D00);
  static const Color yellow1000 = Color(0xFF896E00);

  // ---- Blue — Figma node 214:1574~1619
  static const Color blue100 = Color(0xFFDFF0FF);
  static const Color blue200 = Color(0xFFB3DCFF);
  static const Color blue300 = Color(0xFF72BDFF);
  static const Color blue400 = Color(0xFF4AABFF);
  static const Color blue500 = Color(0xFF2B9BFC);
  static const Color blue600 = Color(0xFF0E85ED);
  static const Color blue700 = Color(0xFF0074D9);
  static const Color blue800 = Color(0xFF0063BA);
  static const Color blue900 = Color(0xFF00549E);
  static const Color blue1000 = Color(0xFF004B8C);

  // ---- Purple — Figma node 214:1636~1681
  static const Color purple100 = Color(0xFFF1E5FF);
  static const Color purple200 = Color(0xFFE1C9FF);
  static const Color purple300 = Color(0xFFC79CFF);
  static const Color purple400 = Color(0xFFB682FA);
  static const Color purple500 = Color(0xFFA56AF2);
  static const Color purple600 = Color(0xFF9559E3);
  static const Color purple700 = Color(0xFF8248CF);
  static const Color purple800 = Color(0xFF6E2FC2);
  static const Color purple900 = Color(0xFF5E20B0);
  static const Color purple1000 = Color(0xFF4C1495);

  // ---- Warm gray (12단계) — Figma node 164:10570~10640, 851:13928
  static const Color gray50 = Color(0xFFFBFAFA);
  static const Color gray100 = Color(0xFFF2F1F0);
  static const Color gray200 = Color(0xFFE5E4E3);
  static const Color gray300 = Color(0xFFD1D0CF);
  static const Color gray400 = Color(0xFFADACAA);
  static const Color gray500 = Color(0xFF8C8A88);
  static const Color gray600 = Color(0xFF6E6B69);
  static const Color gray700 = Color(0xFF595654);
  static const Color gray800 = Color(0xFF474340);
  static const Color gray900 = Color(0xFF332F2B);
  static const Color gray950 = Color(0xFF262421);
  static const Color gray1000 = Color(0xFF1A1817);

  // ---- Base
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF141414);

  // ---- White alpha — Figma node 164:10650~10690
  static const Color whiteAlpha4 = Color.fromRGBO(255, 255, 255, 0.04);
  static const Color whiteAlpha7 = Color.fromRGBO(255, 255, 255, 0.07);
  static const Color whiteAlpha10 = Color.fromRGBO(255, 255, 255, 0.10);
  static const Color whiteAlpha30 = Color.fromRGBO(255, 255, 255, 0.30);
  static const Color whiteAlpha50 = Color.fromRGBO(255, 255, 255, 0.50);
  static const Color whiteAlpha70 = Color.fromRGBO(255, 255, 255, 0.70);
  static const Color whiteAlpha90 = Color.fromRGBO(255, 255, 255, 0.90);

  // ---- Black alpha (base #141414) — Figma node 164:10605~10700
  static const Color blackAlpha4 = Color.fromRGBO(20, 20, 20, 0.04);
  static const Color blackAlpha7 = Color.fromRGBO(20, 20, 20, 0.07);
  static const Color blackAlpha10 = Color.fromRGBO(20, 20, 20, 0.10);
  static const Color blackAlpha30 = Color.fromRGBO(20, 20, 20, 0.30);
  static const Color blackAlpha50 = Color.fromRGBO(20, 20, 20, 0.50);
  static const Color blackAlpha60 = Color.fromRGBO(20, 20, 20, 0.60);
  static const Color blackAlpha70 = Color.fromRGBO(20, 20, 20, 0.70);
  static const Color blackAlpha90 = Color.fromRGBO(20, 20, 20, 0.90);

  /// toast 배경 — Figma `fill_7d12610f` = gray900 80%
  static const Color toast = Color.fromRGBO(51, 47, 43, 0.80);

  // ---- Scales (테스트/반복용)
  static const List<Color> coralScale = [
    coral100,
    coral200,
    coral300,
    coral400,
    coral500,
    coral600,
    coral700,
    coral800,
    coral900,
    coral1000,
  ];
  static const List<Color> greenScale = [
    green100,
    green200,
    green300,
    green400,
    green500,
    green600,
    green700,
    green800,
    green900,
    green1000,
  ];
  static const List<Color> orangeScale = [
    orange100,
    orange200,
    orange300,
    orange400,
    orange500,
    orange600,
    orange700,
    orange800,
    orange900,
    orange1000,
  ];
  static const List<Color> yellowScale = [
    yellow100,
    yellow200,
    yellow300,
    yellow400,
    yellow500,
    yellow600,
    yellow700,
    yellow800,
    yellow900,
    yellow1000,
  ];
  static const List<Color> blueScale = [
    blue100,
    blue200,
    blue300,
    blue400,
    blue500,
    blue600,
    blue700,
    blue800,
    blue900,
    blue1000,
  ];
  static const List<Color> purpleScale = [
    purple100,
    purple200,
    purple300,
    purple400,
    purple500,
    purple600,
    purple700,
    purple800,
    purple900,
    purple1000,
  ];
  static const List<Color> grayScale = [
    gray50,
    gray100,
    gray200,
    gray300,
    gray400,
    gray500,
    gray600,
    gray700,
    gray800,
    gray900,
    gray950,
    gray1000,
  ];
  static const List<Color> whiteAlphaScale = [
    whiteAlpha4,
    whiteAlpha7,
    whiteAlpha10,
    whiteAlpha30,
    whiteAlpha50,
    whiteAlpha70,
    whiteAlpha90,
    white,
  ];
  static const List<Color> blackAlphaScale = [
    blackAlpha4,
    blackAlpha7,
    blackAlpha10,
    blackAlpha30,
    blackAlpha50,
    blackAlpha60,
    blackAlpha70,
    blackAlpha90,
  ];
}
