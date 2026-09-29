# feature: my

- Figma: SEG2 MY + Setting (node-id `509:5055`)
- 화면 범위: MY 메인, 설정, 팔로우/팔로잉, 동행글 관리, 차단, 인증배지, 공지/약관, 문의, 탈퇴

## 레이어
- `domain/` — 엔티티(freezed), 추상 Repository. Flutter import 금지.
- `data/` — `Fake<Name>Repository` 등 구현체. domain에만 의존.
- `presentation/` — 페이지, 위젯, Riverpod Provider/Notifier. domain에 의존, data는 Provider 주입으로만 사용.
