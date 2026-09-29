# feature: home

- Figma: SEG4 Main (node-id `914:6938`)
- 화면 범위: 홈 메인, 동행글 상세/작성 5단계/신고, 동행자 평가

## 레이어
- `domain/` — 엔티티(freezed), 추상 Repository. Flutter import 금지.
- `data/` — `Fake<Name>Repository` 등 구현체. domain에만 의존.
- `presentation/` — 페이지, 위젯, Riverpod Provider/Notifier. domain에 의존, data는 Provider 주입으로만 사용.
