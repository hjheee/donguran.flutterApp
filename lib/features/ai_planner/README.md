# feature: ai_planner

- Figma: SEG5 AI (node-id `958:38480`)
- 화면 범위: AI 플래너 1~4단계, 데이터 조회, 계획표, 이탈/오류

## 레이어
- `domain/` — 엔티티(freezed), 추상 Repository. Flutter import 금지.
- `data/` — `Fake<Name>Repository` 등 구현체. domain에만 의존.
- `presentation/` — 페이지, 위젯, Riverpod Provider/Notifier. domain에 의존, data는 Provider 주입으로만 사용.
