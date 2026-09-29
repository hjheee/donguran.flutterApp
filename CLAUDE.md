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
