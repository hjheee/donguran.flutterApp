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
