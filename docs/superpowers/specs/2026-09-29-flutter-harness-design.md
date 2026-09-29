# Flutter 하네스 + 디자인 토큰 설계

- 날짜: 2026-09-29
- 브랜치: `claude/flutter-figma-mcp-setup-808051`
- 상태: 승인됨 (2026-09-29)

## 1. 배경

"잠자면서 돈벌기 프로젝트"(코드명)는 **여행 동행(동행글) 매칭 소셜 앱 + AI 여행 플래너**다.
Figma 파일(`hcAIg0kmbZu9lqXcv73HtF`)에는 리서치, IA + Userflow, Design system, 세그먼트별 디자인(SEG1~5)이 있다.
저장소는 README만 있는 빈 상태이며, Flutter 3.27.3이 설치되어 있다.

이 스펙의 목표는 **화면을 만들기 전에 하네스를 채우는 것**이다:
AI 세션이 CLAUDE.md만 읽고도 Figma 노드를 찾아 규칙에 맞는 Flutter 코드를 만들 수 있는 상태.

## 2. 범위

### 포함
1. 문서: CLAUDE.md, `docs/architecture.md`, `docs/conventions.md`, `docs/design-system.md`, `docs/figma.md`
2. Figma MCP 프로젝트 설정 `.mcp.json` + 변환 워크플로 스킬 `.claude/skills/figma-to-widget/`
3. Flutter 프로젝트 골격 (feature-first, Riverpod + go_router + freezed), 탭 셸 라우팅까지
4. Design system 페이지의 컬러/타이포/스페이싱/라디우스/그림자를 Dart 토큰과 `ThemeData`로 구현 + 테스트

### 제외
실제 화면 구현, 공용 위젯, 다크모드, CI, 실제 API 연동, 카카오/애플 로그인 SDK 설정.

## 3. 결정 사항

| 항목 | 결정 | 이유 |
|---|---|---|
| 상태관리 | Riverpod (riverpod_annotation) | 화면 단위 Provider 분리가 Figma 화면 구조와 맞고, 생성 패턴이 안정적 |
| 라우팅 | go_router | 탭 ShellRoute, 딥링크 대응 |
| 모델 | freezed + json_serializable | 불변 모델, 생성 코드 커밋 |
| 폴더 구조 | Feature-first | Figma SEG1~5 및 탭과 1:1 대응 |
| 백엔드 | 없음. `domain/` 추상 Repository + `data/` Fake 구현 | 앱 우선, 이후 override로 교체 |
| 다크모드 | 이번엔 라이트만 | Figma에 부분적으로만 존재 |
| 플랫폼 | android, ios | web/desktop 미생성 |
| 프로젝트명 | `donguran`, org `com.donguran` | |

## 4. 문서 구조

```
CLAUDE.md                          # 50줄 이내. 스택, 핵심 규칙, docs 링크
.mcp.json                          # figma-developer-mcp, API 키는 env 참조
docs/
  superpowers/specs/               # 스펙
  superpowers/plans/               # 구현 계획
  architecture.md                  # feature-first, 레이어 의존 방향, Riverpod 규칙
  conventions.md                   # 네이밍, 파일 분할, 테스트, lint
  design-system.md                 # 토큰 목록(node-id 병기), 시맨틱 유도 근거, 컴포넌트↔위젯 매핑표
  figma.md                         # 파일 키, 페이지/세그먼트 node-id 표, IA 트리, 미결 기획 메모
.claude/skills/figma-to-widget/SKILL.md
```

원칙:
- CLAUDE.md는 진입점. 상세는 docs로 위임.
- 모든 Figma 참조는 node-id 병기.
- `figma.md`의 IA 트리와 미결 메모는 오늘 추출한 내용을 그대로 기록한다.

### 4.1 figma.md에 들어갈 핵심 정보

페이지 node-id:

| 페이지 | node-id |
|---|---|
| Index | 0:1 |
| App research | 1:6 |
| IA + Userflow | 39:419 (섹션: IA 94:6488, 로그인/회원가입 68:8010, MY/설정 94:6486, 채팅 136:7814, 홈 136:7812) |
| Design system | 164:7979 (컬러 166:5379, 타이포 164:10095 / 셋 164:10090, 스페이싱 215:283 / 셋 215:257) |
| Design | 166:5396 |
| SEG1 Login + Join | 166:5397 |
| SEG2 MY + Setting | 509:5055 |
| SEG3 Chatting | 870:8926 |
| SEG4 Main | 914:6938 |
| SEG5 AI | 958:38480 |
| ADM 페이지 | 973:21417 |

IA 요약: 스플래시 → SNS 로그인(카카오/애플) → 회원가입 4단계(약관, 개인정보, 추가정보, 여행타입) → 탭 셸(홈 / 채팅 / MY).
홈: 동행글 목록·상세·작성 5단계·신고, 동행자 평가, 알림, AI 플래너 4단계→조회→계획표.
채팅: 목록, 동행 메이트 채팅, 찔러보기 채팅, 상대 프로필.
MY: 설정(프로필/나이/취향), 팔로우/팔로잉, 작성·저장·최근 본 동행글, 차단, 인증배지(메일 인증), 공지/약관, 알림설정, 문의, 로그아웃/탈퇴.

미결 기획 메모(Figma IA 페이지 원문): 약관 내역 정의 필요, 취향 테스트 기준, 신원정보 등록 방식, 필터 정책(조건 값), AI 정보처리 UI 방식과 상세 수준, 유저별 평가점수 처리 방식, 팔로우 유저 직접 컨택 방식.

## 5. Flutter 골격

```
pubspec.yaml            # flutter_riverpod, riverpod_annotation, go_router, freezed_annotation,
                        # json_annotation; dev: build_runner, riverpod_generator, freezed,
                        # json_serializable, very_good_analysis, custom_lint, riverpod_lint
analysis_options.yaml
lib/
  main.dart             # ProviderScope + App
  app.dart              # MaterialApp.router + AppTheme.light()
  core/
    theme/              # 6절
    router/             # app_router.dart, routes.dart(경로 enum), ShellRoute 탭 3개
    widgets/            # 빈 폴더 + README
    utils/
  features/
    auth/ home/ chat/ my/ ai_planner/ notification/
      data/ domain/ presentation/    # 각 README에 대응 Figma SEG node-id 기재
test/
  core/theme/
```

- 라우트: `/splash`, `/login`, 탭 셸 `/home`, `/chat`, `/my`. 화면은 이름만 보이는 플레이스홀더 `Scaffold`.
- 스플래시는 즉시 `/home`으로 이동(인증 로직 없음).
- Repository: `domain/`에 추상 클래스, `data/`에 `Fake*Repository`. Provider는 fake를 기본 주입. 이번 스펙에서는 규칙만 문서화하고 실제 Repository는 만들지 않는다.
- 생성 코드(`*.g.dart`, `*.freezed.dart`) 커밋.

## 6. 디자인 토큰

```
lib/core/theme/
  app_colors.dart            # 원시 팔레트. Figma 라벨명 그대로
  app_semantic_colors.dart   # 역할 토큰
  app_typography.dart        # Gothic A1(KO) / Poppins(ENG) 11~32 × 5 weight
  app_spacing.dart           # 2,4,8,10,12,16,20,24,28,32,36,40,48,56,64,80,100,120,156
  app_radius.dart            # 4,16,20,24,32, pill 99
  app_shadows.dart           # 3종
  app_theme.dart             # ThemeData.light 조립
```

### 6.1 원시 컬러 (Figma 확인값)
- 코랄(브랜드 primary) 10단계: FFEBE9 FFCFC9 FFA79C FF7F6E **F56751** F25641 E03C26 CC2A14 B21500 941100
- 그린 10: D6FFCC B4F7A3 84ED6B 54DB32 3ACB15 00B206 00A606 189100 137500 105E00
- 오렌지 10: FFEFDE FFE4C7 FFCC96 FFC180 FFB469 FFA340 F0872B D46300 B25300 803700
- 옐로 10: FFF8D2 FFF3AD FFED89 FFE75D FFDC52 F7CD23 E4B700 CBA300 B08D00 896E00
- 블루 10: DFF0FF B3DCFF 72BDFF 4AABFF 2B9BFC 0E85ED 0074D9 0063BA 00549E 004B8C
- 퍼플 10: F1E5FF E1C9FF C79CFF B682FA A56AF2 9559E3 8248CF 6E2FC2 5E20B0 4C1495
- 웜 그레이 12: FBFAFA F2F1F0 E5E4E3 D1D0CF ADACAA 8C8A88 6E6B69 595654 474340 332F2B 262421 1A1817
- White alpha: 4, 7, 10, 30, 50, 70, 90%, FFFFFF
- Black alpha(base 141414): 4, 7, 10, 30, 50, 60, 70, 90%, 141414

Figma 라벨 형식은 `<계열 약어> <단계>` (확인 예: `yel 800 = #CBA300`), 단계는 밝은 순 100~1000. Dart 토큰은 계열 전체 이름 + 단계(`yellow800`)로 쓰고, 그레이 12단계는 50, 100~900, 950, 1000으로 번호를 매긴다. 헥스는 Figma 값 그대로, 임의 보정 금지. 계열 약어(red/cor 등)는 Figma API 제한 해제 후 `design-system.md`에 보충한다.

### 6.2 타이포
Design system 페이지 확인값: **KO = Gothic A1, ENG = Poppins** (IA 페이지의 Pretendard는 토큰 폰트가 아님). 둘 다 Google Fonts OFL, `assets/fonts/`에 번들.
size 11,12,13,14,15,16,18,20,24,28,32 × light/regular/medium/bold/extrabold × KO/ENG = 110 스타일. Figma 스타일명 예: `KO bo 16`, `ENG re 14`.
line-height: KO 1.5em, ENG 1.35em (각 1개 샘플로 확인, 전 단계 동일 가정). letter-spacing 없음.
weight 매핑 확인값: KO bold = 800(ExtraBold), ENG regular = 400. 나머지 가정: light 300, medium 500, KO extrabold 900, ENG bold 700, ENG extrabold 800. 가정 항목은 `design-system.md`에 "재확인 필요"로 표기.

### 6.3 시맨틱 유도
Figma에 시맨틱 정의가 없어 컴포넌트 사용례에서 유도하고 근거를 `design-system.md`에 표로 남긴다.

| 시맨틱 | 값 | 근거 |
|---|---|---|
| primary | coral F56751 | toggle on, indicator on, mark on, tooltip primary |
| surfaceInverse | gray 332F2B | chip on 배경 |
| surface | FFFFFF | 대부분 화면 배경 |
| surfaceLow | gray FBFAFA | content card, quotation card after |
| border | gray F2F1F0 / E5E4E3 | content card stroke / chip off stroke |
| divider | blackAlpha 7% | 섹션 구분선 |
| disabled | gray 8C8A88 | toggle off |
| scrim/toast | 332F2B 80% | toast 배경 |

### 6.4 그림자
- card: 0 4 8 rgba(20,20,20,.12)
- tooltip: 0 1 8 rgba(140,138,136,.16)
- quotation: 0 2 12 rgba(140,138,136,.10)

### 6.5 테스트
- 각 팔레트 단계 수와 대표 헥스 검증
- 타이포 110개(11사이즈×5웨이트×2언어) 모두 생성됨
- `AppTheme.light()` 생성 성공, primary == F56751

## 7. Figma 연동 워크플로

`.mcp.json`:
```json
{ "mcpServers": { "figma": { "command": "npx", "args": ["-y", "figma-developer-mcp", "--stdio"],
  "env": { "FIGMA_API_KEY": "${FIGMA_API_KEY}" } } } }
```

스킬 `figma-to-widget` 절차:
1. `docs/figma.md`에서 node-id 확인 → 해당 노드만 `get_figma_data` (페이지 전체 조회 금지)
2. hex/size/padding을 토큰으로 매핑. 토큰에 없는 값은 하드코딩하지 않고 사용자에게 보고
3. Figma 변형(state/grade/size)은 위젯 enum 파라미터로 1:1
4. `design-system.md` 매핑표에 위젯↔node-id 추가
5. 위젯 테스트 먼저, 구현 후 (TDD)

## 8. 완료 정의
- `flutter analyze` 경고 0, `flutter test` 통과
- 안드로이드 에뮬레이터에서 스플래시 → 탭 3개 전환 확인
- 새 세션이 CLAUDE.md만 읽고 "SEG2 MY 메인 화면 만들어" 요청을 처리할 경로를 찾을 수 있음
