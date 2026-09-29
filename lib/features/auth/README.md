# feature: auth

- Figma: SEG1 Login + Join (node-id `166:5397`)
- 화면 범위: 스플래시, SNS 로그인(카카오/애플), 회원가입 1~4단계(약관/개인정보/추가정보/여행타입)

## 레이어
- `domain/` — 엔티티(freezed), 추상 Repository. Flutter import 금지.
- `data/` — `Fake<Name>Repository` 등 구현체. domain에만 의존.
- `presentation/` — 페이지, 위젯, Riverpod Provider/Notifier. domain에 의존, data는 Provider 주입으로만 사용.
