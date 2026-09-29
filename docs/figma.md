# Figma 참조

- 파일: 잠자면서 돈벌기 프로젝트 — `https://www.figma.com/design/hcAIg0kmbZu9lqXcv73HtF/`
- fileKey: `hcAIg0kmbZu9lqXcv73HtF`
- MCP: `.mcp.json`의 `figma` 서버 (`figma-developer-mcp`). 환경변수 `FIGMA_API_KEY` 필요.
- 화면 기준 크기: 390×844

## 호출 규칙 (API 쿼터 보호)
1. **항상 `nodeId`를 지정**한다. 캔버스(페이지) 전체 조회 금지.
2. 구조 파악이 필요하면 `depth: 1~2`로 먼저 훑고, 필요한 노드만 다시 조회한다.
3. 429가 나오면 즉시 중단하고 이 문서와 `docs/design-system.md`의 값으로 작업한다. (Viewer 좌석은 쿼터가 작다.)

## 페이지 node-id

| 페이지 | node-id | 내용 |
|---|---|---|
| Index | `0:1` | 목차 |
| App research | `1:6` | 타 앱 리서치 보드 (구현 참조 아님) |
| IA + Userflow | `39:419` | 섹션: IA `94:6488`(트리 `43:33`), 로그인/회원가입 `68:8010`, MY/설정 `94:6486`, 채팅 `136:7814`, 홈 `136:7812`, 체크리스트 `94:6489` |
| Design system | `164:7979` | 컬러 섹션 `166:5379`, 타이포 섹션 `164:10095`(셋 `164:10090`), 스페이싱 섹션 `215:283`(셋 `215:257`) |
| ㄴ Update note | `215:300` | 디자인 변경 이력 |
| Design | `166:5396` | 세그먼트 부모 |
| ㄴ SEG1 Login + Join | `166:5397` | → `lib/features/auth` |
| ㄴ SEG2 MY + Setting | `509:5055` | → `lib/features/my` |
| ㄴ SEG3 Chatting | `870:8926` | → `lib/features/chat` |
| ㄴ SEG4 Main | `914:6938` | → `lib/features/home`, `lib/features/notification` |
| ㄴ SEG5 AI | `958:38480` | → `lib/features/ai_planner` |
| ADM 페이지 | `973:21417` | 어드민 (앱 범위 외) |
| Draft / TEST | `1014:3576`, `210:1703` | 무시 |

## Design system 주요 컴포넌트 node-id

| 컴포넌트 | node-id | 변형 축 |
|---|---|---|
| btn / solid | `214:1155` | define(kakao login/apple login/cta/btn), state(default/pressed/disabled/activated), grade(default/primary/secondary/cta), count(1/2) |
| btn | `394:13599` | type(solid/line), size(large/small), state, step(primary/secondary) |
| btn (text) | `215:1620` | txt type(only/underline), weight(medium/small) |
| input | `318:59001` | state(default/submitted/focused/error) |
| input + btn | `856:12349` | state |
| input + validation | `318:59392` | state(pass/default/error/error both) |
| textbox | `360:12034` | default/focused/submitted/error |
| selectbox | `372:51186` | count(single/double), state |
| dropdown | `858:16005` | state |
| chip | `372:60275` | activated(on/off) |
| toggle | `858:14941` | state(on/off) |
| segment control / btn | `360:37695` / `372:41949` | num(2/3/4), activated |
| badge | `528:16525` | size(small/large), mode(light/dark), type(txt/txt+ico) |
| tooltip | `215:1696` | grade(primary/secondary), arrowside(up/down) |
| toast | `236:3080` | — |
| alert | `858:12077` | btn(1/2) |
| bs (bottom sheet header) | `236:2307` | use(cont/li/li main), type |
| header | `284:12234` | button right(txt/ico/GNB), show 옵션 |
| GNB / gnb ico | `700:7673` / `650:7439` | ico(chat/home/my), state |
| li (list item) | `318:16216` | type(checkbox/check list/menuslit/notice/btn/toggle/chattingslit), state |
| li / radio, li / survey | `394:3657`, `858:17130` | activated, type |
| indicator (mark/bar) | `284:12465`, `284:12487`, `298:12590` | activated, num |
| content card | `854:10889` | case(other/my/chat) |
| quotation card | `856:10067` | type(pass/email/card), state(before/after) |
| account card | `780:16338` | — |
| img (avatar) | `780:15959` | type(1~5, 그라디언트) |
| chattingbox | `872:30047` | type(txt/photo), case(self/other) |
| chat input / set | `890:31308` / `890:31557` | state |
| chatting profile | `870:17989` | count(1/2/3/3+a) |
| datepicker | `924:7109` | state |
| picture select | `960:11193` | state |
| null (empty state) | `780:18451` | show 옵션 |
| FAB | `923:21498` | — |
| divider | `851:9691` | level(1/2) |
| ico (24px) | `213:1897` | type(solid/line), mode, define(31종) |
| logo | `277:9613` | type(logo/wordmark KO/ENG), mode |
| status_bar / home_indicator / keyboard | `164:8893` / `164:8886` / `164:8788` | mode |

## IA 요약 (IA + Userflow 페이지에서 추출)

- 스플래시 → SNS 로그인/회원가입(카카오·애플) → SNS 인증 → 완료처리
  - 회원가입 1단계 약관동의 → 2단계 개인정보 설정 → 3단계 추가정보 설정 → 4단계 여행타입 설정
- 탭 셸: 홈 / 채팅 / MY
- 홈: 메인, 전체보기(콘텐츠 없음), 동행글 상세(이미지 확대, 동행자 정보, 신고 BS, 신고완료), 동행글 작성 1~5단계(동행자 추가)·작성완료, 동행자 평가(확인단계, 평가, 완료), 알림 메인·알림설정, AI 플래너 1~4단계 → 데이터 조회중/완료 → 계획표(이탈, 중도 이탈 안내, 오류)
- 채팅: 메인(null, 삭제), 동행 메이트 채팅 상세, 찔러보기 채팅 상세, 키패드, 추가기능(나가기), 사진추가, 상대방 프로필(더보기)
- MY: 메인, 설정(프로필 변경, 나이, 취향설정·최대개수, 저장 안내), 팔로우/팔로잉 목록(해제), 작성한/저장한/최근 본 동행글 관리, 차단한 사용자, 인증배지(메일 인증·발송완료·오류), 공지사항+약관, 알림설정, 문의하기, 로그아웃, 탈퇴(설문, 완료)

## 미결 기획 메모 (IA 페이지 원문)
1. 사용자 위치정보 / 개인정보 수집 / 푸시 알림 사용 등 필요한 약관 내역 정의 필요. 취향 테스트는 어떤 내용을 기준으로 정할지?
2. 신원정보 등록은 어떤 방식으로 처리할 것인지 정의 필요
3. 필터 정책 수립 필요 (조건 값)
4. AI 정보처리 UI 어떤 방식으로 제작 가능한지? (채팅타입 / QnA 타입 등) 얼마나 디테일한 정보값을 제공할 것인지 개발검토 필요
5. 유저별 평가점수 처리 방식 검토 필요 (점수 환산 기준 / 명칭 등의 개념)
6. 노션연동 화면 참고
7. 팔로우한 유저에게 직접 컨택할 수 있는 방식을 검토
