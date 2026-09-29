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
