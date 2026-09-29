# feature: chat

- Figma: SEG3 Chatting (node-id `870:8926`)
- 화면 범위: 채팅 목록, 동행 메이트 채팅, 찔러보기 채팅, 상대 프로필

## 레이어
- `domain/` — 엔티티(freezed), 추상 Repository. Flutter import 금지.
- `data/` — `Fake<Name>Repository` 등 구현체. domain에만 의존.
- `presentation/` — 페이지, 위젯, Riverpod Provider/Notifier. domain에 의존, data는 Provider 주입으로만 사용.
