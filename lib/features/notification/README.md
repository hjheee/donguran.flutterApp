# feature: notification

- Figma: SEG4 Main 내 홈/알림 (node-id `914:6938 (IA 섹션 136:7812)`)
- 화면 범위: 알림 메인, 알림설정

## 레이어
- `domain/` — 엔티티(freezed), 추상 Repository. Flutter import 금지.
- `data/` — `Fake<Name>Repository` 등 구현체. domain에만 의존.
- `presentation/` — 페이지, 위젯, Riverpod Provider/Notifier. domain에 의존, data는 Provider 주입으로만 사용.
