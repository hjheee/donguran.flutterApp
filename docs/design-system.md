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
