# Flutter 하네스 + 디자인 토큰 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 화면을 만들기 전에, AI 세션이 CLAUDE.md만 읽고 Figma 노드를 찾아 규칙대로 Flutter 코드를 만들 수 있는 하네스(문서 + 프로젝트 골격 + 디자인 토큰)를 완성한다.

**Architecture:** Feature-first Flutter 앱(`lib/core` + `lib/features/<feature>/{data,domain,presentation}`). Riverpod로 상태/DI, go_router `StatefulShellRoute`로 홈/채팅/MY 탭 셸. Figma Design system 페이지의 값을 `lib/core/theme/` 토큰 파일로 옮기고 `ThemeData` + `ThemeExtension`으로 노출한다. 문서는 `CLAUDE.md`(진입점) → `docs/*.md`(상세)로 위임한다.

**Tech Stack:** Flutter 3.27.3 (Dart 3.6), flutter_riverpod + riverpod_annotation/generator, go_router, freezed + json_serializable, build_runner, very_good_analysis, custom_lint + riverpod_lint. 폰트 Gothic A1(KO), Poppins(ENG).

Spec: `docs/superpowers/specs/2026-09-29-flutter-harness-design.md`

## Global Constraints

- Flutter 3.27.3 / Dart SDK `^3.6.0`. 플랫폼은 **android, ios만** 생성한다.
- 프로젝트명 `donguran`, org `com.donguran`.
- 헥스값은 Figma 확인값 그대로. 임의 보정 금지. 토큰에 없는 값은 하드코딩하지 않고 보고한다.
- 폰트는 **Gothic A1(KO), Poppins(ENG)**. Pretendard 사용 금지.
- 다크모드 구현 안 함. 시맨틱 레이어는 `ThemeExtension`으로 두어 추가 가능하게만 한다.
- 생성 코드(`*.g.dart`, `*.freezed.dart`)는 커밋한다.
- Figma API는 2026-10-04 전까지 429 상태. 이 계획은 Figma 호출 없이 완료 가능해야 한다. Figma 호출이 필요한 확인 항목은 문서에 "재확인 필요"로 남긴다.
- 모든 커밋 메시지 끝에 `Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>` 를 붙인다.
- 각 Task 완료 시 `flutter analyze` 경고 0, `flutter test` 통과 상태를 유지한다.
- 작업 디렉터리: `D:\00_repository\donguran.flutterApp\.claude\worktrees\flutter-figma-mcp-setup-808051` (Git Bash 경로 `D:/00_repository/donguran.flutterApp/.claude/worktrees/flutter-figma-mcp-setup-808051`). 아래 모든 명령은 이 디렉터리에서 실행한다.

---

## File Structure

| 경로 | 책임 |
|---|---|
| `pubspec.yaml` | 의존성, 폰트/에셋 등록 |
| `analysis_options.yaml` | very_good_analysis + custom_lint 활성화 |
| `lib/main.dart` | `ProviderScope` + `DonguranApp` 실행 |
| `lib/app.dart` | `DonguranApp`: `MaterialApp.router`, `AppTheme.light()`, 라우터 주입 |
| `lib/core/theme/app_colors.dart` | 원시 팔레트 상수 + 계열별 스케일 리스트 |
| `lib/core/theme/app_semantic_colors.dart` | 역할 토큰 `ThemeExtension` |
| `lib/core/theme/app_typography.dart` | `AppLang`, `AppFontWeight`, 스타일 팩토리 |
| `lib/core/theme/app_spacing.dart` | 스페이싱 상수 |
| `lib/core/theme/app_radius.dart` | 라디우스 상수 |
| `lib/core/theme/app_shadows.dart` | BoxShadow 상수 |
| `lib/core/theme/app_theme.dart` | `AppTheme.light()` 조립 |
| `lib/core/router/routes.dart` | `AppRoute` enum (경로 문자열) |
| `lib/core/router/app_router.dart` | `appRouterProvider` (go_router) |
| `lib/core/router/app_shell.dart` | 탭 셸 (`NavigationBar`) |
| `lib/core/widgets/README.md` | 공용 위젯 폴더 규칙 |
| `lib/features/<f>/presentation/<f>_page.dart` | 플레이스홀더 페이지 |
| `lib/features/<f>/README.md` | 대응 Figma SEG node-id, 레이어 규칙 |
| `test/core/theme/*_test.dart` | 토큰 테스트 |
| `test/app_test.dart` | 스플래시→홈, 탭 전환 위젯 테스트 |
| `.mcp.json` | Figma MCP 서버 |
| `.claude/skills/figma-to-widget/SKILL.md` | Figma→위젯 변환 절차 |
| `CLAUDE.md`, `docs/architecture.md`, `docs/conventions.md`, `docs/design-system.md`, `docs/figma.md` | 하네스 문서 |

---

### Task 1: Flutter 프로젝트 생성 + 의존성 + lint

**Files:**
- Create: `pubspec.yaml`, `analysis_options.yaml`, `android/`, `ios/`, `lib/main.dart` (flutter create 산출물)
- Delete: `test/widget_test.dart` (기본 생성물, 있을 경우)

**Interfaces:**
- Produces: 이후 모든 Task가 의존하는 패키지 목록. import 경로 prefix `package:donguran/...`.

- [ ] **Step 1: 프로젝트 생성**

```bash
flutter create . --project-name donguran --org com.donguran --platforms android,ios --empty
```
Expected: `All done!`. `lib/main.dart`, `android/`, `ios/`, `pubspec.yaml`, `analysis_options.yaml`, `.gitignore`, `.metadata` 생성. 기존 `README.md`, `docs/`는 유지된다.

- [ ] **Step 2: pubspec.yaml 교체**

`pubspec.yaml` 전체를 다음으로 교체:

```yaml
name: donguran
description: 여행 동행 매칭 + AI 플래너 앱
publish_to: "none"
version: 0.1.0+1

environment:
  sdk: ^3.6.0

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  go_router: ^14.6.2
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.13
  riverpod_generator: ^2.6.3
  riverpod_lint: ^2.6.3
  custom_lint: ^0.7.0
  freezed: ^2.5.7
  json_serializable: ^6.9.0
  very_good_analysis: ^7.0.0

flutter:
  uses-material-design: true
```

- [ ] **Step 3: analysis_options.yaml 교체**

```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  plugins:
    - custom_lint
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    public_member_api_docs: false
    lines_longer_than_80_chars: false
```

- [ ] **Step 4: 기본 테스트 삭제 후 의존성 설치**

```bash
rm -f test/widget_test.dart
flutter pub get
```
Expected: `Got dependencies!`. 버전 충돌이 나면 충돌난 패키지의 캐럿 하한을 `flutter pub outdated`가 보여주는 resolvable 버전으로 내린다. 패키지를 제거하지는 않는다.

- [ ] **Step 5: 분석 통과 확인**

```bash
flutter analyze
```
Expected: `No issues found!`. (`--empty`의 main.dart가 lint에 걸리면 Task 7에서 교체되므로 그 파일의 경고만 허용하고 진행.)

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "chore: Flutter 프로젝트 생성 및 의존성/lint 설정

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 2: 폰트 에셋 (Gothic A1, Poppins)

**Files:**
- Create: `assets/fonts/GothicA1-{Light,Regular,Medium,ExtraBold,Black}.ttf`, `assets/fonts/Poppins-{Light,Regular,Medium,Bold,ExtraBold}.ttf`, `assets/fonts/OFL-GothicA1.txt`, `assets/fonts/OFL-Poppins.txt`
- Modify: `pubspec.yaml` (`flutter:` 섹션)

**Interfaces:**
- Produces: 폰트 패밀리 이름 `GothicA1` (weights 300,400,500,800,900), `Poppins` (weights 300,400,500,700,800). Task 4가 이 이름을 사용한다.

- [ ] **Step 1: 폰트 다운로드 (Google Fonts 공식 저장소, OFL)**

```bash
mkdir -p assets/fonts && cd assets/fonts
B=https://raw.githubusercontent.com/google/fonts/main/ofl
for w in Light Regular Medium ExtraBold Black; do curl -fsSL -o GothicA1-$w.ttf $B/gothica1/GothicA1-$w.ttf; done
for w in Light Regular Medium Bold ExtraBold; do curl -fsSL -o Poppins-$w.ttf $B/poppins/Poppins-$w.ttf; done
curl -fsSL -o OFL-GothicA1.txt $B/gothica1/OFL.txt
curl -fsSL -o OFL-Poppins.txt $B/poppins/OFL.txt
cd ../.. && ls -la assets/fonts
```
Expected: ttf 10개(각 수십~수백 KB), OFL 2개. 0바이트 파일이 있으면 실패로 간주하고 재시도.

- [ ] **Step 2: pubspec 폰트 등록**

`pubspec.yaml`의 `flutter:` 섹션을 다음으로 교체:

```yaml
flutter:
  uses-material-design: true
  fonts:
    - family: GothicA1
      fonts:
        - asset: assets/fonts/GothicA1-Light.ttf
          weight: 300
        - asset: assets/fonts/GothicA1-Regular.ttf
          weight: 400
        - asset: assets/fonts/GothicA1-Medium.ttf
          weight: 500
        - asset: assets/fonts/GothicA1-ExtraBold.ttf
          weight: 800
        - asset: assets/fonts/GothicA1-Black.ttf
          weight: 900
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Light.ttf
          weight: 300
        - asset: assets/fonts/Poppins-Regular.ttf
          weight: 400
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
        - asset: assets/fonts/Poppins-ExtraBold.ttf
          weight: 800
```

- [ ] **Step 3: 검증**

```bash
flutter pub get && flutter analyze
```
Expected: 오류 없음 (에셋 경로가 틀리면 `pub get`이 경고).

- [ ] **Step 4: Commit**

```bash
git add assets pubspec.yaml
git commit -m "feat(theme): Gothic A1, Poppins 폰트 에셋 추가

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 3: 원시 컬러 토큰

**Files:**
- Create: `lib/core/theme/app_colors.dart`
- Test: `test/core/theme/app_colors_test.dart`

**Interfaces:**
- Produces: `abstract final class AppColors` — `Color` 상수 `coral100..coral1000`, `green100..1000`, `orange100..1000`, `yellow100..1000`, `blue100..1000`, `purple100..1000`, `gray50, gray100..gray900, gray950, gray1000`, `white`, `black`, `whiteAlpha4/7/10/30/50/70/90`, `blackAlpha4/7/10/30/50/60/70/90`, `toast`; `List<Color>` 상수 `coralScale, greenScale, orangeScale, yellowScale, blueScale, purpleScale, grayScale, whiteAlphaScale, blackAlphaScale`.

- [ ] **Step 1: 실패하는 테스트 작성**

`test/core/theme/app_colors_test.dart`:

```dart
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
      for (final scale in [AppColors.whiteAlphaScale, AppColors.blackAlphaScale]) {
        for (var i = 1; i < scale.length; i++) {
          expect(scale[i].alpha, greaterThan(scale[i - 1].alpha));
        }
      }
    });
  });
}
```

- [ ] **Step 2: 실패 확인**

```bash
flutter test test/core/theme/app_colors_test.dart
```
Expected: 컴파일 에러 `Target of URI doesn't exist: 'package:donguran/core/theme/app_colors.dart'`.

- [ ] **Step 3: 구현**

`lib/core/theme/app_colors.dart`:

```dart
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
  static const List<Color> coralScale = [coral100, coral200, coral300, coral400, coral500, coral600, coral700, coral800, coral900, coral1000];
  static const List<Color> greenScale = [green100, green200, green300, green400, green500, green600, green700, green800, green900, green1000];
  static const List<Color> orangeScale = [orange100, orange200, orange300, orange400, orange500, orange600, orange700, orange800, orange900, orange1000];
  static const List<Color> yellowScale = [yellow100, yellow200, yellow300, yellow400, yellow500, yellow600, yellow700, yellow800, yellow900, yellow1000];
  static const List<Color> blueScale = [blue100, blue200, blue300, blue400, blue500, blue600, blue700, blue800, blue900, blue1000];
  static const List<Color> purpleScale = [purple100, purple200, purple300, purple400, purple500, purple600, purple700, purple800, purple900, purple1000];
  static const List<Color> grayScale = [gray50, gray100, gray200, gray300, gray400, gray500, gray600, gray700, gray800, gray900, gray950, gray1000];
  static const List<Color> whiteAlphaScale = [whiteAlpha4, whiteAlpha7, whiteAlpha10, whiteAlpha30, whiteAlpha50, whiteAlpha70, whiteAlpha90, white];
  static const List<Color> blackAlphaScale = [blackAlpha4, blackAlpha7, blackAlpha10, blackAlpha30, blackAlpha50, blackAlpha60, blackAlpha70, blackAlpha90];
}
```

- [ ] **Step 4: 통과 확인**

```bash
flutter test test/core/theme/app_colors_test.dart && flutter analyze
```
Expected: `All tests passed!`, `No issues found!`. 루미넌스 테스트가 특정 단계에서 실패하면 **헥스를 고치지 말고** reason에 나온 계열/단계를 사용자에게 보고한다(Figma 확인값이 우선이며, 그 경우 테스트에서 해당 계열만 제외하고 사유를 주석으로 남긴다).

- [ ] **Step 5: Commit**

```bash
git add lib/core/theme/app_colors.dart test/core/theme/app_colors_test.dart
git commit -m "feat(theme): Figma 원시 컬러 팔레트 토큰

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 4: 타이포그래피 토큰

**Files:**
- Create: `lib/core/theme/app_typography.dart`
- Test: `test/core/theme/app_typography_test.dart`

**Interfaces:**
- Consumes: Task 2 폰트 패밀리 `GothicA1`, `Poppins`.
- Produces: `enum AppLang { ko, eng }`, `enum AppFontWeight { light, regular, medium, bold, extrabold }`, `abstract final class AppTypography` with `static const String koFamily`, `engFamily`, `static const List<int> sizes`, `static FontWeight weightOf(AppLang, AppFontWeight)`, `static TextStyle style(AppLang lang, AppFontWeight weight, int size)`, `static TextStyle ko(AppFontWeight, int)`, `static TextStyle eng(AppFontWeight, int)`.

- [ ] **Step 1: 실패하는 테스트 작성**

`test/core/theme/app_typography_test.dart`:

```dart
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
      expect(() => AppTypography.ko(AppFontWeight.regular, 17), throwsArgumentError);
    });
  });
}
```

- [ ] **Step 2: 실패 확인**

```bash
flutter test test/core/theme/app_typography_test.dart
```
Expected: 컴파일 에러 (파일 없음).

- [ ] **Step 3: 구현**

`lib/core/theme/app_typography.dart`:

```dart
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
      throw ArgumentError.value(size, 'size', 'not in the Figma type scale $sizes');
    }
    final isKo = lang == AppLang.ko;
    return TextStyle(
      fontFamily: isKo ? koFamily : engFamily,
      fontWeight: weightOf(lang, weight),
      fontSize: size.toDouble(),
      height: isKo ? koLineHeight : engLineHeight,
    );
  }

  static TextStyle ko(AppFontWeight weight, int size) => style(AppLang.ko, weight, size);

  static TextStyle eng(AppFontWeight weight, int size) => style(AppLang.eng, weight, size);
}
```

- [ ] **Step 4: 통과 확인**

```bash
flutter test test/core/theme/app_typography_test.dart && flutter analyze
```
Expected: `All tests passed!`, `No issues found!`.

- [ ] **Step 5: Commit**

```bash
git add lib/core/theme/app_typography.dart test/core/theme/app_typography_test.dart
git commit -m "feat(theme): Gothic A1 / Poppins 타이포 스케일 토큰

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 5: 스페이싱 · 라디우스 · 그림자 토큰

**Files:**
- Create: `lib/core/theme/app_spacing.dart`, `lib/core/theme/app_radius.dart`, `lib/core/theme/app_shadows.dart`
- Test: `test/core/theme/app_layout_tokens_test.dart`

**Interfaces:**
- Produces: `AppSpacing.s2 … s156` (double) + `AppSpacing.all` (List<double>); `AppRadius.r4, r16, r20, r24, r32, pill` (double) + `AppRadius.circular(double)` → `BorderRadius`, `AppRadius.topSheet` (BorderRadius 위 32); `AppShadows.card, tooltip, quotation` (List<BoxShadow>).

- [ ] **Step 1: 실패하는 테스트 작성**

`test/core/theme/app_layout_tokens_test.dart`:

```dart
import 'package:donguran/core/theme/app_radius.dart';
import 'package:donguran/core/theme/app_shadows.dart';
import 'package:donguran/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppSpacing matches the Figma padding component set', () {
    expect(AppSpacing.all, [2, 4, 8, 10, 12, 16, 20, 24, 28, 32, 36, 40, 48, 56, 64, 80, 100, 120, 156]);
    expect(AppSpacing.s16, 16);
  });

  test('AppRadius values', () {
    expect(AppRadius.pill, 99);
    expect(AppRadius.circular(AppRadius.r16), BorderRadius.circular(16));
    expect(AppRadius.topSheet, const BorderRadius.vertical(top: Radius.circular(32)));
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
```

- [ ] **Step 2: 실패 확인**

```bash
flutter test test/core/theme/app_layout_tokens_test.dart
```
Expected: 컴파일 에러 (파일 없음).

- [ ] **Step 3: 구현**

`lib/core/theme/app_spacing.dart`:

```dart
/// Figma "padding" 컴포넌트 셋(node 215:257)의 `height` 변형값.
abstract final class AppSpacing {
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s36 = 36;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s56 = 56;
  static const double s64 = 64;
  static const double s80 = 80;
  static const double s100 = 100;
  static const double s120 = 120;
  static const double s156 = 156;

  static const List<double> all = [s2, s4, s8, s10, s12, s16, s20, s24, s28, s32, s36, s40, s48, s56, s64, s80, s100, s120, s156];
}
```

`lib/core/theme/app_radius.dart`:

```dart
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
  static const BorderRadius topSheet = BorderRadius.vertical(top: Radius.circular(r32));
}
```

`lib/core/theme/app_shadows.dart`:

```dart
import 'package:flutter/material.dart';

/// Figma Design system effect 스타일.
abstract final class AppShadows {
  /// 컬러 토큰 카드 등 — Figma effect_7777830f
  static const List<BoxShadow> card = [
    BoxShadow(offset: Offset(0, 4), blurRadius: 8, color: Color.fromRGBO(20, 20, 20, 0.12)),
  ];

  /// tooltip secondary — Figma effect_7fe4a8af
  static const List<BoxShadow> tooltip = [
    BoxShadow(offset: Offset(0, 1), blurRadius: 8, color: Color.fromRGBO(140, 138, 136, 0.16)),
  ];

  /// quotation card (before) — Figma effect_f56d5c8c
  static const List<BoxShadow> quotation = [
    BoxShadow(offset: Offset(0, 2), blurRadius: 12, color: Color.fromRGBO(140, 138, 136, 0.10)),
  ];
}
```

- [ ] **Step 4: 통과 확인**

```bash
flutter test test/core/theme/app_layout_tokens_test.dart && flutter analyze
```
Expected: `All tests passed!`, `No issues found!`.

- [ ] **Step 5: Commit**

```bash
git add lib/core/theme/app_spacing.dart lib/core/theme/app_radius.dart lib/core/theme/app_shadows.dart test/core/theme/app_layout_tokens_test.dart
git commit -m "feat(theme): 스페이싱/라디우스/그림자 토큰

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 6: 시맨틱 컬러 + AppTheme

**Files:**
- Create: `lib/core/theme/app_semantic_colors.dart`, `lib/core/theme/app_theme.dart`
- Test: `test/core/theme/app_theme_test.dart`

**Interfaces:**
- Consumes: `AppColors`(Task 3), `AppTypography`, `AppLang`, `AppFontWeight`(Task 4), `AppRadius`(Task 5).
- Produces: `class AppSemanticColors extends ThemeExtension<AppSemanticColors>` with fields `primary, onPrimary, surface, surfaceLow, surfaceInverse, onSurfaceInverse, textPrimary, textSecondary, textDisabled, border, borderStrong, divider, disabled, scrim` and `static const AppSemanticColors light`; `abstract final class AppTheme { static ThemeData light(); }`; 확장 getter `BuildContext.semanticColors`.

- [ ] **Step 1: 실패하는 테스트 작성**

`test/core/theme/app_theme_test.dart`:

```dart
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
```

- [ ] **Step 2: 실패 확인**

```bash
flutter test test/core/theme/app_theme_test.dart
```
Expected: 컴파일 에러 (파일 없음).

- [ ] **Step 3: 시맨틱 컬러 구현**

`lib/core/theme/app_semantic_colors.dart`:

```dart
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
      onSurfaceInverse: Color.lerp(onSurfaceInverse, other.onSurfaceInverse, t)!,
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
  AppSemanticColors get semanticColors => Theme.of(this).extension<AppSemanticColors>()!;
}
```

- [ ] **Step 4: AppTheme 구현**

`lib/core/theme/app_theme.dart`:

```dart
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
      onError: AppColors.white,
      outline: semantic.borderStrong,
      outlineVariant: semantic.border,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: semantic.surface,
      fontFamily: AppTypography.koFamily,
      textTheme: _textTheme(semantic),
      dividerTheme: DividerThemeData(color: semantic.divider, thickness: 1, space: 1),
      chipTheme: ChipThemeData(shape: RoundedRectangleBorder(borderRadius: AppRadius.circular(AppRadius.pill))),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: semantic.surface,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(AppTypography.ko(AppFontWeight.medium, 11)),
      ),
      extensions: const [semantic],
    );
  }

  /// Material 역할 ↔ Figma 스케일 매핑. 정본은 docs/design-system.md.
  static TextTheme _textTheme(AppSemanticColors s) {
    TextStyle ko(AppFontWeight w, int size) => AppTypography.ko(w, size).copyWith(color: s.textPrimary);
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
```

- [ ] **Step 5: 통과 확인**

```bash
flutter test test/core/theme && flutter analyze
```
Expected: 모든 theme 테스트 통과, `No issues found!`.

- [ ] **Step 6: Commit**

```bash
git add lib/core/theme test/core/theme
git commit -m "feat(theme): 시맨틱 컬러 ThemeExtension 및 AppTheme.light

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 7: 기능 폴더 골격 + 라우터 + 앱 진입점

**Files:**
- Create: `lib/core/router/routes.dart`, `lib/core/router/app_router.dart` (+ 생성 `app_router.g.dart`), `lib/core/router/app_shell.dart`, `lib/app.dart`
- Create: `lib/features/auth/presentation/splash_page.dart`, `lib/features/auth/presentation/login_page.dart`, `lib/features/home/presentation/home_page.dart`, `lib/features/chat/presentation/chat_page.dart`, `lib/features/my/presentation/my_page.dart`
- Create: `lib/features/{auth,home,chat,my,ai_planner,notification}/README.md`, `lib/features/{auth,home,chat,my,ai_planner,notification}/{data,domain}/.gitkeep`, `lib/features/{ai_planner,notification}/presentation/.gitkeep`, `lib/core/widgets/README.md`, `lib/core/utils/.gitkeep`
- Modify: `lib/main.dart`
- Test: `test/app_test.dart`

**Interfaces:**
- Consumes: `AppTheme.light()`(Task 6).
- Produces: `enum AppRoute { splash, login, home, chat, my }` with `String path`; `appRouterProvider` (Riverpod, `GoRouter`); `class DonguranApp extends ConsumerWidget`; 페이지 위젯 `SplashPage, LoginPage, HomePage, ChatPage, MyPage`; `AppShell(navigationShell:)`.

- [ ] **Step 1: 실패하는 위젯 테스트 작성**

`test/app_test.dart`:

```dart
import 'package:donguran/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash redirects to home and bottom tabs switch pages', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DonguranApp()));
    await tester.pumpAndSettle();

    expect(find.text('HomePage · Figma SEG4 (914:6938)'), findsOneWidget);

    await tester.tap(find.text('채팅'));
    await tester.pumpAndSettle();
    expect(find.text('ChatPage · Figma SEG3 (870:8926)'), findsOneWidget);

    await tester.tap(find.text('MY'));
    await tester.pumpAndSettle();
    expect(find.text('MyPage · Figma SEG2 (509:5055)'), findsOneWidget);

    await tester.tap(find.text('홈'));
    await tester.pumpAndSettle();
    expect(find.text('HomePage · Figma SEG4 (914:6938)'), findsOneWidget);
  });
}
```

- [ ] **Step 2: 실패 확인**

```bash
flutter test test/app_test.dart
```
Expected: 컴파일 에러 (`package:donguran/app.dart` 없음).

- [ ] **Step 3: 라우트 enum**

`lib/core/router/routes.dart`:

```dart
/// 앱 경로. 문자열을 직접 쓰지 말고 항상 이 enum을 사용한다.
enum AppRoute {
  splash('/splash'),
  login('/login'),
  home('/home'),
  chat('/chat'),
  my('/my');

  const AppRoute(this.path);

  final String path;
}
```

- [ ] **Step 4: 플레이스홀더 페이지 5개**

`lib/features/auth/presentation/splash_page.dart`:

```dart
import 'package:donguran/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 스플래시. 인증 로직이 없으므로 첫 프레임 후 바로 홈으로 이동한다(스펙 5절).
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go(AppRoute.home.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('SplashPage · Figma SEG1 (166:5397)')));
  }
}
```

`lib/features/auth/presentation/login_page.dart`:

```dart
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('LoginPage · Figma SEG1 (166:5397)')));
  }
}
```

`lib/features/home/presentation/home_page.dart`:

```dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('HomePage · Figma SEG4 (914:6938)')));
  }
}
```

`lib/features/chat/presentation/chat_page.dart`:

```dart
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('ChatPage · Figma SEG3 (870:8926)')));
  }
}
```

`lib/features/my/presentation/my_page.dart`:

```dart
import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('MyPage · Figma SEG2 (509:5055)')));
  }
}
```

- [ ] **Step 5: 탭 셸**

`lib/core/router/app_shell.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 홈 / 채팅 / MY 탭 셸. Figma GNB 컴포넌트(node 700:7673) 대응.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '홈'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: '채팅'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'MY'),
        ],
      ),
    );
  }
}
```

- [ ] **Step 6: 라우터 Provider**

`lib/core/router/app_router.dart`:

```dart
import 'package:donguran/core/router/app_shell.dart';
import 'package:donguran/core/router/routes.dart';
import 'package:donguran/features/auth/presentation/login_page.dart';
import 'package:donguran/features/auth/presentation/splash_page.dart';
import 'package:donguran/features/chat/presentation/chat_page.dart';
import 'package:donguran/features/home/presentation/home_page.dart';
import 'package:donguran/features/my/presentation/my_page.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      GoRoute(path: AppRoute.splash.path, builder: (_, __) => const SplashPage()),
      GoRoute(path: AppRoute.login.path, builder: (_, __) => const LoginPage()),
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: AppRoute.home.path, builder: (_, __) => const HomePage())]),
          StatefulShellBranch(routes: [GoRoute(path: AppRoute.chat.path, builder: (_, __) => const ChatPage())]),
          StatefulShellBranch(routes: [GoRoute(path: AppRoute.my.path, builder: (_, __) => const MyPage())]),
        ],
      ),
    ],
  );
}
```

- [ ] **Step 7: 앱 + main**

`lib/app.dart`:

```dart
import 'package:donguran/core/router/app_router.dart';
import 'package:donguran/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DonguranApp extends ConsumerWidget {
  const DonguranApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'donguran',
      theme: AppTheme.light(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

`lib/main.dart` 전체 교체:

```dart
import 'package:donguran/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: DonguranApp()));
}
```

- [ ] **Step 8: 코드 생성**

```bash
dart run build_runner build --delete-conflicting-outputs
```
Expected: `Succeeded after ...` 와 `lib/core/router/app_router.g.dart` 생성. `Ref` 타입 관련 에러가 나면 시그니처를 `GoRouter appRouter(AppRouterRef ref)` 로 바꾼다(riverpod_generator 2.x 구버전 시그니처).

- [ ] **Step 9: 기능 폴더 README와 빈 폴더**

```bash
for f in auth home chat my ai_planner notification; do mkdir -p lib/features/$f/data lib/features/$f/domain lib/features/$f/presentation; touch lib/features/$f/data/.gitkeep lib/features/$f/domain/.gitkeep; done
touch lib/features/ai_planner/presentation/.gitkeep lib/features/notification/presentation/.gitkeep
mkdir -p lib/core/widgets lib/core/utils && touch lib/core/utils/.gitkeep
```

각 `lib/features/<f>/README.md`를 아래 형식으로 작성한다. `<f>`, `<Figma>`, `<id>`, `<화면 범위>`는 표의 값으로 치환:

```markdown
# feature: <f>

- Figma: <Figma> (node-id `<id>`)
- 화면 범위: <화면 범위>

## 레이어
- `domain/` — 엔티티(freezed), 추상 Repository. Flutter import 금지.
- `data/` — `Fake<Name>Repository` 등 구현체. domain에만 의존.
- `presentation/` — 페이지, 위젯, Riverpod Provider/Notifier. domain에 의존, data는 Provider 주입으로만 사용.
```

| f | Figma | id | 화면 범위 |
|---|---|---|---|
| auth | SEG1 Login + Join | 166:5397 | 스플래시, SNS 로그인(카카오/애플), 회원가입 1~4단계(약관/개인정보/추가정보/여행타입) |
| home | SEG4 Main | 914:6938 | 홈 메인, 동행글 상세/작성 5단계/신고, 동행자 평가 |
| chat | SEG3 Chatting | 870:8926 | 채팅 목록, 동행 메이트 채팅, 찔러보기 채팅, 상대 프로필 |
| my | SEG2 MY + Setting | 509:5055 | MY 메인, 설정, 팔로우/팔로잉, 동행글 관리, 차단, 인증배지, 공지/약관, 문의, 탈퇴 |
| ai_planner | SEG5 AI | 958:38480 | AI 플래너 1~4단계, 데이터 조회, 계획표, 이탈/오류 |
| notification | SEG4 Main 내 홈/알림 | 914:6938 (IA 섹션 136:7812) | 알림 메인, 알림설정 |

`lib/core/widgets/README.md`:

```markdown
# core/widgets

Figma Design system 컴포넌트(btn, input, chip, toggle, badge, toast, alert, bs, header, GNB 등)의 Flutter 구현이 들어가는 곳.
아직 비어 있다. 추가 시 `.claude/skills/figma-to-widget/SKILL.md` 절차를 따르고 `docs/design-system.md` 매핑표에 등록한다.
파일 이름은 `app_<component>.dart`, 클래스는 `App<Component>` (예: `app_button.dart` / `AppButton`).
```

- [ ] **Step 10: 통과 확인**

```bash
flutter test && flutter analyze && dart run custom_lint
```
Expected: `All tests passed!`, `No issues found!`, custom_lint 출력 `No issues found!`.

- [ ] **Step 11: Commit**

```bash
git add -A
git commit -m "feat: feature-first 골격, go_router 탭 셸, Riverpod 진입점

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 8: `.mcp.json` + `docs/figma.md`

**Files:**
- Create: `.mcp.json`, `docs/figma.md`

**Interfaces:**
- Produces: 이후 세션이 참조하는 Figma node-id 정본.

- [ ] **Step 1: .mcp.json**

```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["-y", "figma-developer-mcp", "--stdio"],
      "env": { "FIGMA_API_KEY": "${FIGMA_API_KEY}" }
    }
  }
}
```

- [ ] **Step 2: docs/figma.md**

````markdown
# Figma 참조

- 파일: 잠자면서 돈벌기 프로젝트 — `https://www.figma.com/design/hcAIg0kmbZu9lqXcv73HtF/`
- fileKey: `hcAIg0kmbZu9lqXcv73HtF`
- MCP: `.mcp.json`의 `figma` 서버 (`figma-developer-mcp`). 환경변수 `FIGMA_API_KEY` 필요.
- 화면 기준 크기: 390×844

## 호출 규칙 (API 쿼터 보호)
1. **항상 `nodeId`를 지정**한다. 캔버스(페이지) 전체 조회 금지.
2. 구조 파악이 필요하면 `depth: 1~2`로 먼저 훑고, 필요한 노드만 다시 조회한다.
3. 429가 나오면 즉시 중단하고 이 문서와 `docs/design-system.md`의 값으로 작업한다. (Viewer 좌석은 쿼터가 작다.)

## 페이지 node-id

| 페이지 | node-id | 내용 |
|---|---|---|
| Index | `0:1` | 목차 |
| App research | `1:6` | 타 앱 리서치 보드 (구현 참조 아님) |
| IA + Userflow | `39:419` | 섹션: IA `94:6488`(트리 `43:33`), 로그인/회원가입 `68:8010`, MY/설정 `94:6486`, 채팅 `136:7814`, 홈 `136:7812`, 체크리스트 `94:6489` |
| Design system | `164:7979` | 컬러 섹션 `166:5379`, 타이포 섹션 `164:10095`(셋 `164:10090`), 스페이싱 섹션 `215:283`(셋 `215:257`) |
| ㄴ Update note | `215:300` | 디자인 변경 이력 |
| Design | `166:5396` | 세그먼트 부모 |
| ㄴ SEG1 Login + Join | `166:5397` | → `lib/features/auth` |
| ㄴ SEG2 MY + Setting | `509:5055` | → `lib/features/my` |
| ㄴ SEG3 Chatting | `870:8926` | → `lib/features/chat` |
| ㄴ SEG4 Main | `914:6938` | → `lib/features/home`, `lib/features/notification` |
| ㄴ SEG5 AI | `958:38480` | → `lib/features/ai_planner` |
| ADM 페이지 | `973:21417` | 어드민 (앱 범위 외) |
| Draft / TEST | `1014:3576`, `210:1703` | 무시 |

## Design system 주요 컴포넌트 node-id

| 컴포넌트 | node-id | 변형 축 |
|---|---|---|
| btn / solid | `214:1155` | define(kakao login/apple login/cta/btn), state(default/pressed/disabled/activated), grade(default/primary/secondary/cta), count(1/2) |
| btn | `394:13599` | type(solid/line), size(large/small), state, step(primary/secondary) |
| btn (text) | `215:1620` | txt type(only/underline), weight(medium/small) |
| input | `318:59001` | state(default/submitted/focused/error) |
| input + btn | `856:12349` | state |
| input + validation | `318:59392` | state(pass/default/error/error both) |
| textbox | `360:12034` | default/focused/submitted/error |
| selectbox | `372:51186` | count(single/double), state |
| dropdown | `858:16005` | state |
| chip | `372:60275` | activated(on/off) |
| toggle | `858:14941` | state(on/off) |
| segment control / btn | `360:37695` / `372:41949` | num(2/3/4), activated |
| badge | `528:16525` | size(small/large), mode(light/dark), type(txt/txt+ico) |
| tooltip | `215:1696` | grade(primary/secondary), arrowside(up/down) |
| toast | `236:3080` | — |
| alert | `858:12077` | btn(1/2) |
| bs (bottom sheet header) | `236:2307` | use(cont/li/li main), type |
| header | `284:12234` | button right(txt/ico/GNB), show 옵션 |
| GNB / gnb ico | `700:7673` / `650:7439` | ico(chat/home/my), state |
| li (list item) | `318:16216` | type(checkbox/check list/menuslit/notice/btn/toggle/chattingslit), state |
| li / radio, li / survey | `394:3657`, `858:17130` | activated, type |
| indicator (mark/bar) | `284:12465`, `284:12487`, `298:12590` | activated, num |
| content card | `854:10889` | case(other/my/chat) |
| quotation card | `856:10067` | type(pass/email/card), state(before/after) |
| account card | `780:16338` | — |
| img (avatar) | `780:15959` | type(1~5, 그라디언트) |
| chattingbox | `872:30047` | type(txt/photo), case(self/other) |
| chat input / set | `890:31308` / `890:31557` | state |
| chatting profile | `870:17989` | count(1/2/3/3+a) |
| datepicker | `924:7109` | state |
| picture select | `960:11193` | state |
| null (empty state) | `780:18451` | show 옵션 |
| FAB | `923:21498` | — |
| divider | `851:9691` | level(1/2) |
| ico (24px) | `213:1897` | type(solid/line), mode, define(31종) |
| logo | `277:9613` | type(logo/wordmark KO/ENG), mode |
| status_bar / home_indicator / keyboard | `164:8893` / `164:8886` / `164:8788` | mode |

## IA 요약 (IA + Userflow 페이지에서 추출)

- 스플래시 → SNS 로그인/회원가입(카카오·애플) → SNS 인증 → 완료처리
  - 회원가입 1단계 약관동의 → 2단계 개인정보 설정 → 3단계 추가정보 설정 → 4단계 여행타입 설정
- 탭 셸: 홈 / 채팅 / MY
- 홈: 메인, 전체보기(콘텐츠 없음), 동행글 상세(이미지 확대, 동행자 정보, 신고 BS, 신고완료), 동행글 작성 1~5단계(동행자 추가)·작성완료, 동행자 평가(확인단계, 평가, 완료), 알림 메인·알림설정, AI 플래너 1~4단계 → 데이터 조회중/완료 → 계획표(이탈, 중도 이탈 안내, 오류)
- 채팅: 메인(null, 삭제), 동행 메이트 채팅 상세, 찔러보기 채팅 상세, 키패드, 추가기능(나가기), 사진추가, 상대방 프로필(더보기)
- MY: 메인, 설정(프로필 변경, 나이, 취향설정·최대개수, 저장 안내), 팔로우/팔로잉 목록(해제), 작성한/저장한/최근 본 동행글 관리, 차단한 사용자, 인증배지(메일 인증·발송완료·오류), 공지사항+약관, 알림설정, 문의하기, 로그아웃, 탈퇴(설문, 완료)

## 미결 기획 메모 (IA 페이지 원문)
1. 사용자 위치정보 / 개인정보 수집 / 푸시 알림 사용 등 필요한 약관 내역 정의 필요. 취향 테스트는 어떤 내용을 기준으로 정할지?
2. 신원정보 등록은 어떤 방식으로 처리할 것인지 정의 필요
3. 필터 정책 수립 필요 (조건 값)
4. AI 정보처리 UI 어떤 방식으로 제작 가능한지? (채팅타입 / QnA 타입 등) 얼마나 디테일한 정보값을 제공할 것인지 개발검토 필요
5. 유저별 평가점수 처리 방식 검토 필요 (점수 환산 기준 / 명칭 등의 개념)
6. 노션연동 화면 참고
7. 팔로우한 유저에게 직접 컨택할 수 있는 방식을 검토
````

- [ ] **Step 3: Commit**

```bash
git add .mcp.json docs/figma.md
git commit -m "docs: Figma MCP 설정 및 node-id 참조 문서

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 9: `docs/design-system.md`, `docs/architecture.md`, `docs/conventions.md`

**Files:**
- Create: `docs/design-system.md`, `docs/architecture.md`, `docs/conventions.md`

- [ ] **Step 1: docs/design-system.md**

````markdown
# Design System → Flutter 매핑

정본 코드: `lib/core/theme/`. Figma 출처: Design system 페이지 `164:7979`.
값을 바꿀 때는 Figma 확인값만 반영하고, 이 문서와 코드를 같은 커밋에서 갱신한다.

## 원시 컬러 (`app_colors.dart`)

Figma 라벨 형식 `<계열 약어> <단계>` (예: `yel 800`). 단계는 밝은 순 100~1000. Dart는 계열 전체 이름 사용.

| 계열 | Dart 접두 | Figma 약어 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | 1000 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Coral (primary) | `coral` | 재확인 필요 | FFEBE9 | FFCFC9 | FFA79C | FF7F6E | **F56751** | F25641 | E03C26 | CC2A14 | B21500 | 941100 |
| Green | `green` | 재확인 필요 | D6FFCC | B4F7A3 | 84ED6B | 54DB32 | 3ACB15 | 00B206 | 00A606 | 189100 | 137500 | 105E00 |
| Orange | `orange` | 재확인 필요 | FFEFDE | FFE4C7 | FFCC96 | FFC180 | FFB469 | FFA340 | F0872B | D46300 | B25300 | 803700 |
| Yellow | `yellow` | `yel` | FFF8D2 | FFF3AD | FFED89 | FFE75D | FFDC52 | F7CD23 | E4B700 | CBA300 | B08D00 | 896E00 |
| Blue | `blue` | 재확인 필요 | DFF0FF | B3DCFF | 72BDFF | 4AABFF | 2B9BFC | 0E85ED | 0074D9 | 0063BA | 00549E | 004B8C |
| Purple | `purple` | 재확인 필요 | F1E5FF | E1C9FF | C79CFF | B682FA | A56AF2 | 9559E3 | 8248CF | 6E2FC2 | 5E20B0 | 4C1495 |

Gray(웜) 12단계: `gray50` FBFAFA, `gray100` F2F1F0, `gray200` E5E4E3, `gray300` D1D0CF, `gray400` ADACAA, `gray500` 8C8A88, `gray600` 6E6B69, `gray700` 595654, `gray800` 474340, `gray900` 332F2B, `gray950` 262421, `gray1000` 1A1817. (Figma 단계 번호 재확인 필요)

White alpha: 4/7/10/30/50/70/90% + `white` FFFFFF. Black alpha(base 141414): 4/7/10/30/50/60/70/90% + `black` 141414. `toast` = gray900 80%.

## 시맨틱 토큰 (`app_semantic_colors.dart`)

Figma에 시맨틱 정의가 없어 컴포넌트 사용례로 유도. `context.semanticColors.<name>`으로 사용.

| 시맨틱 | 값 | 근거 (Figma 컴포넌트) |
|---|---|---|
| primary | coral500 | toggle on, indicator bar on, mark on, tooltip primary 배경 |
| onPrimary | white | tooltip primary 텍스트 |
| surface | white | 화면 배경, GNB, header |
| surfaceLow | gray50 | content card 배경, quotation card(after) |
| surfaceInverse | gray900 | chip on 배경 |
| onSurfaceInverse | white | chip on 텍스트 |
| textPrimary | black(141414) | 타이포 컴포넌트 셋 텍스트 색 |
| textSecondary | gray600 | 추정. 재확인 필요 |
| textDisabled | gray400 | 추정. 재확인 필요 |
| border | gray100 | content card stroke |
| borderStrong | gray200 | chip off stroke |
| divider | blackAlpha7 | 섹션 구분선 stroke |
| disabled | gray500 | toggle off |
| scrim | toast(gray900 80%) | toast 배경 |

## 타이포 (`app_typography.dart`)

- KO: **Gothic A1**, line-height 1.5 — Figma 스타일 `KO bo 16` (node `164:10058`)에서 확인
- ENG: **Poppins**, line-height 1.35 — Figma 스타일 `ENG re 14` (node `164:10035`)에서 확인
- size: 11 12 13 14 15 16 18 20 24 28 32
- 사용: `AppTypography.ko(AppFontWeight.bold, 16)` / `AppTypography.eng(AppFontWeight.regular, 14)`
- IA 페이지 프레임의 "Pretendard K Edition"은 토큰 폰트가 아니다. 사용 금지.

weight 매핑:

| Figma `weignt` | KO Gothic A1 | ENG Poppins | 상태 |
|---|---|---|---|
| light | 300 | 300 | 재확인 필요 |
| regular | 400 | 400 | ENG 확인, KO 재확인 필요 |
| medium | 500 | 500 | 재확인 필요 |
| bold | 800 | 700 | KO 확인, ENG 재확인 필요 |
| extrabold | 900 | 800 | 재확인 필요 |

Material TextTheme 매핑 (`app_theme.dart`): display 32 / headlineL 28 / headlineM 24 / titleL 20 / titleM 18 / titleS 16 = KO bold; bodyL 16 / bodyM 15 / bodyS 14 = KO regular; labelL 14 / labelM 13 / labelS 12 = KO medium.

## 스페이싱 / 라디우스 / 그림자

- `AppSpacing.s2 … s156` = Figma padding 셋 `215:257`
- `AppRadius`: r4(토큰 카드, indicator), r16(account/content card), r20(quotation), r24(alert), r32(datepicker 상단 `topSheet`), pill 99(chip/toggle/badge/toast/tooltip/FAB/segment)
- `AppShadows.card` 0 4 8 #141414 12% · `tooltip` 0 1 8 #8C8A88 16% · `quotation` 0 2 12 #8C8A88 10%
- 기타 관찰값(토큰화 안 함): FAB stroke 그라디언트 coral400→yellow300 149deg, 아바타 그라디언트 5종, 키보드 blur 54.37

## 컴포넌트 ↔ 위젯 매핑표

위젯을 만들 때마다 한 줄 추가한다. node-id는 `docs/figma.md` 참조.

| Figma 컴포넌트 | node-id | Flutter 위젯 | 상태 |
|---|---|---|---|
| GNB | 700:7673 | `lib/core/router/app_shell.dart` `AppShell` (임시 NavigationBar) | 플레이스홀더 |

## 재확인 필요 목록 (Figma API 429 해제 후, 2026-10-04 이후)
1. 각 계열 Figma 약어와 그레이 단계 번호 — 컬러 토큰 프레임 1개씩(`166:5120`, `166:5203`, `164:10755`, `214:1574`, `214:1636`, `164:10570`) 조회
2. weight 매핑 미확인 8칸 — `164:10090` 하위 변형 중 KO light/regular/medium/extrabold, ENG light/medium/bold/extrabold 각 1개 조회
3. textSecondary / textDisabled 근거
````

- [ ] **Step 2: docs/architecture.md**

````markdown
# 아키텍처

## 구조 (feature-first)

```
lib/
  main.dart                  ProviderScope + DonguranApp
  app.dart                   MaterialApp.router + AppTheme
  core/
    theme/                   디자인 토큰, AppTheme (docs/design-system.md)
    router/                  AppRoute enum, appRouterProvider, AppShell(탭)
    widgets/                 Design system 공용 위젯 (App* 접두)
    utils/
  features/<feature>/
    domain/                  엔티티(freezed), 추상 Repository. Flutter import 금지
    data/                    Repository 구현 (Fake*, 추후 Api*). domain에만 의존
    presentation/            Page, 위젯, Provider/Notifier
```

feature ↔ Figma 세그먼트 대응은 각 `lib/features/<f>/README.md`와 `docs/figma.md`에 있다.

## 의존 방향
`presentation → domain ← data`. `core`는 어느 feature에도 의존하지 않는다. feature 간 직접 import 금지. 공유가 필요하면 `core`로 올린다.

## 상태관리 / DI (Riverpod)
- 코드 생성 사용: `@riverpod` + `riverpod_generator`. 수동 `Provider(...)` 금지.
- Repository는 `domain/`의 추상 타입으로 Provider를 선언하고 기본값으로 `Fake*Repository`를 반환한다. 실제 API가 생기면 `ProviderScope(overrides:)` 또는 Provider 본문 교체로 바꾼다.
- 화면 상태는 `presentation/`의 `@riverpod class XxxNotifier extends _$XxxNotifier`. 위젯은 `ConsumerWidget` / `ConsumerStatefulWidget`.
- 생성 파일(`*.g.dart`, `*.freezed.dart`)은 커밋한다. 변경 후 `dart run build_runner build --delete-conflicting-outputs`.

## 라우팅 (go_router)
- 경로 문자열은 `lib/core/router/routes.dart`의 `AppRoute` enum에만 존재한다.
- 탭(홈/채팅/MY)은 `StatefulShellRoute.indexedStack`. 탭 밖 전체화면(스플래시, 로그인, 상세)은 셸 밖 `GoRoute`.
- 새 화면 = `AppRoute` 항목 추가 + `app_router.dart`에 `GoRoute` 추가 + `test/app_test.dart` 또는 feature 테스트에 도달 테스트.

## 모델
`freezed` + `json_serializable`. 엔티티는 `domain/`에, DTO가 따로 필요해질 때만 `data/`에 둔다.

## 백엔드
없음. 모든 데이터는 `Fake*Repository`가 메모리에서 제공한다. 네트워크 코드 추가 금지(스펙 범위 외).
````

- [ ] **Step 3: docs/conventions.md**

````markdown
# 컨벤션

## 작업 흐름
1. 화면/컴포넌트 작업 전 `docs/figma.md`에서 node-id 확인, `.claude/skills/figma-to-widget/SKILL.md` 절차 준수.
2. TDD: 테스트 → 실패 확인 → 구현 → 통과 → 커밋. 위젯은 `testWidgets`, 토큰/로직은 `test`.
3. 커밋은 작게, 메시지는 `type(scope): 한국어 요약` (`feat`, `fix`, `docs`, `chore`, `refactor`, `test`).
4. 완료 선언 전 `flutter analyze` 경고 0, `dart run custom_lint` 경고 0, `flutter test` 통과를 실제로 실행해 확인한다.

## 네이밍
- 파일: `snake_case.dart`. 페이지 `<name>_page.dart`, 위젯 `app_<name>.dart`(core) / `<feature>_<name>.dart`(feature), Provider `<name>_provider.dart`, Notifier `<name>_notifier.dart`.
- 클래스: 페이지 `XxxPage`, 공용 위젯 `AppXxx`, Repository `XxxRepository`(추상) / `FakeXxxRepository`.
- Figma 변형 축(state/grade/size)은 Dart `enum`으로 1:1. 이름은 Figma 원문 오타(`defualt`, `weignt`)를 고쳐 쓴다.

## 스타일 규칙
- 색/크기/폰트를 리터럴로 쓰지 않는다. `AppColors`, `context.semanticColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppShadows`만 사용. 토큰에 없는 값은 하드코딩 대신 사용자에게 보고.
- 텍스트는 한국어 UI 기준(KO 타이포). 영문 전용 텍스트만 `AppTypography.eng`.
- `print` 금지, `debugPrint`도 커밋 금지.
- 파일 300줄 넘으면 분리 검토.
- lint: `very_good_analysis` 기준. 예외는 `analysis_options.yaml`에만 기록.

## 테스트
- 토큰: 값·개수 스냅샷 (`test/core/theme/`).
- 라우팅: 앱을 띄워 실제 탭/이동으로 검증 (`test/app_test.dart`).
- 위젯: 변형별 렌더링 + 상호작용. 골든 테스트는 아직 사용하지 않음.
````

- [ ] **Step 4: Commit**

```bash
git add docs/design-system.md docs/architecture.md docs/conventions.md
git commit -m "docs: 디자인 시스템 매핑, 아키텍처, 컨벤션 문서

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 10: `figma-to-widget` 스킬 + `CLAUDE.md`

**Files:**
- Create: `.claude/skills/figma-to-widget/SKILL.md`, `CLAUDE.md`
- Modify: `README.md`

- [ ] **Step 1: 스킬**

`.claude/skills/figma-to-widget/SKILL.md`:

````markdown
---
name: figma-to-widget
description: Use when implementing any screen or component from the Figma file — turns a Figma node into a Flutter widget using the project's design tokens
---

# Figma → Flutter 위젯

## 절차
1. **node-id 확인**: `docs/figma.md`에서 대상 화면/컴포넌트의 node-id를 찾는다. 없으면 상위 세그먼트를 `depth: 1`로 조회해 찾고 `docs/figma.md`에 추가한다.
2. **해당 노드만 조회**: `get_figma_data(fileKey: hcAIg0kmbZu9lqXcv73HtF, nodeId: <id>)`. 페이지 전체 조회 금지. 429가 나오면 중단하고 사용자에게 보고.
3. **토큰 매핑**: 응답의 hex → `AppColors`/`context.semanticColors`, fontSize/weight → `AppTypography`, padding/gap → `AppSpacing`, borderRadius → `AppRadius`, boxShadow → `AppShadows`. `docs/design-system.md` 표를 기준으로 한다.
   - 토큰에 없는 값이 나오면 **하드코딩하지 않고** 값·노드·용도를 사용자에게 보고한다. 사용자가 승인하면 토큰 파일 + `design-system.md`에 먼저 추가한 뒤 사용한다.
4. **변형 → enum**: Figma 변형 축(state/grade/size/type)을 Dart enum 파라미터로 1:1 대응. Boolean 속성(Show ico 등)은 `bool` 또는 nullable 위젯 파라미터.
5. **위치 결정**: Design system 컴포넌트 → `lib/core/widgets/app_<name>.dart`. 특정 화면 전용 → `lib/features/<f>/presentation/widgets/`.
6. **TDD**: 변형별 렌더 테스트를 먼저 쓰고 실패를 확인한 뒤 구현한다.
7. **기록**: `docs/design-system.md` "컴포넌트 ↔ 위젯 매핑표"에 한 줄 추가.
8. **검증**: `flutter analyze`, `dart run custom_lint`, `flutter test` 통과 후 커밋.

## 하지 말 것
- 색/크기 리터럴, Pretendard, 페이지 전체 Figma 조회, 매핑표 누락.
````

- [ ] **Step 2: CLAUDE.md**

````markdown
# donguran — 여행 동행 매칭 + AI 플래너 Flutter 앱

## 스택
Flutter 3.27.3 · Riverpod(codegen) · go_router · freezed/json_serializable · very_good_analysis + riverpod_lint
폰트: Gothic A1(KO), Poppins(ENG). 백엔드 없음(Fake Repository).

## 먼저 읽을 문서
- 구조/의존 규칙: `docs/architecture.md`
- 네이밍/테스트/커밋 규칙: `docs/conventions.md`
- 디자인 토큰과 Figma 매핑: `docs/design-system.md`
- Figma 파일·node-id·IA: `docs/figma.md`
- 화면/컴포넌트 구현 절차: `.claude/skills/figma-to-widget/SKILL.md` (Figma 작업 시 필수)
- 스펙/계획: `docs/superpowers/specs/`, `docs/superpowers/plans/`

## 핵심 규칙
1. 색·크기·폰트 리터럴 금지. `lib/core/theme/` 토큰만 사용. 토큰에 없는 값은 보고.
2. Figma 조회는 항상 `nodeId` 지정. 페이지 전체 조회 금지. 429 시 중단.
3. feature-first. feature 간 import 금지. `domain/`에서 Flutter import 금지.
4. Provider는 `@riverpod` 코드 생성만. 경로는 `AppRoute` enum만.
5. TDD. 완료 전 `flutter analyze` · `dart run custom_lint` · `flutter test` 실제 실행.

## 명령
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze && dart run custom_lint && flutter test
flutter run -d <device>        # flutter emulators --launch Medium_Phone_API_36.1
```

## 현재 상태 (2026-09-29)
하네스 완료. 화면은 모두 플레이스홀더. 공용 위젯 없음. 다크모드 없음.
````

- [ ] **Step 3: README.md 교체**

```markdown
# donguran

여행 동행 매칭 + AI 여행 플래너 Flutter 앱. 개발 안내는 `CLAUDE.md`와 `docs/`를 참조.
```

- [ ] **Step 4: Commit**

```bash
git add .claude/skills CLAUDE.md README.md
git commit -m "docs: CLAUDE.md 진입점 및 figma-to-widget 스킬

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

### Task 11: 최종 검증 (완료 정의)

**Files:** 없음 (수정이 필요하면 해당 Task로 돌아가 고치고 별도 커밋)

- [ ] **Step 1: 정적 검사 + 테스트**

```bash
flutter analyze && dart run custom_lint && flutter test
```
Expected: `No issues found!` ×2, `All tests passed!`.

- [ ] **Step 2: 에뮬레이터 실행 확인**

```bash
flutter emulators --launch Medium_Phone_API_36.1
flutter devices
```
Expected: `emulator-5554` 같은 android 디바이스가 목록에 나타난다(부팅에 30~60초). 그 후:

```bash
flutter run -d emulator-5554 --release
```
Expected: 앱 실행, 스플래시 문구가 잠깐 보인 뒤 홈 플레이스홀더와 하단 탭 3개. 탭을 눌러 채팅/MY 전환 확인. 확인 후 터미널에서 `q`로 종료. 에뮬레이터를 띄울 수 없으면 `flutter run -d windows`로 대체하고 그 사실을 보고한다(스펙 완료 정의는 안드로이드).

- [ ] **Step 3: 새 세션 시뮬레이션 체크**

CLAUDE.md만 읽고 다음이 가능한지 점검한다 (문서를 열어 확인):
- "SEG2 MY 메인 화면 만들어" → `docs/figma.md`에서 `509:5055` 발견 → `figma-to-widget` 스킬 → `lib/features/my/presentation/` 위치 → 토큰 사용 규칙. 경로가 끊기는 곳이 있으면 해당 문서에 링크를 추가한다.

- [ ] **Step 4: git 상태 정리**

```bash
git status --short
git log --oneline
```
Expected: 작업 트리 clean, Task 1~10 커밋이 순서대로 존재.
