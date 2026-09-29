# 아키텍처

## 구조 (feature-first)

```
lib/
  main.dart                  ProviderScope + DonguranApp
  app.dart                   MaterialApp.router + AppTheme
  core/
    theme/                   디자인 토큰, AppTheme (docs/design-system.md)
    router/                  AppRoute enum, appRouterProvider, AppShell(탭)
    widgets/                 Design system 공용 위젯 (App* 접두)
    utils/
  features/<feature>/
    domain/                  엔티티(freezed), 추상 Repository. Flutter import 금지
    data/                    Repository 구현 (Fake*, 추후 Api*). domain에만 의존
    presentation/            Page, 위젯, Provider/Notifier
```

feature ↔ Figma 세그먼트 대응은 각 `lib/features/<f>/README.md`와 `docs/figma.md`에 있다.

## 의존 방향
`presentation → domain ← data`. `core`는 어느 feature에도 의존하지 않는다. feature 간 직접 import 금지. 공유가 필요하면 `core`로 올린다.
예외: `core/router/app_router.dart`만 각 feature의 `presentation/*_page.dart`를 import해 라우트를 조립한다. 그 외 `core` 파일에서 feature import 금지.

## 상태관리 / DI (Riverpod)
- 코드 생성 사용: `@riverpod` + `riverpod_generator`. 수동 `Provider(...)` 금지.
- Repository는 `domain/`의 추상 타입으로 Provider를 선언하고 기본값으로 `Fake*Repository`를 반환한다. 실제 API가 생기면 `ProviderScope(overrides:)` 또는 Provider 본문 교체로 바꾼다.
- 화면 상태는 `presentation/`의 `@riverpod class XxxNotifier extends _$XxxNotifier`. 위젯은 `ConsumerWidget` / `ConsumerStatefulWidget`.
- 생성 파일(`*.g.dart`, `*.freezed.dart`)은 커밋한다. 변경 후 `dart run build_runner build --delete-conflicting-outputs`.

## 라우팅 (go_router)
- 경로 문자열은 `lib/core/router/routes.dart`의 `AppRoute` enum에만 존재한다.
- 탭(홈/채팅/MY)은 `StatefulShellRoute.indexedStack`. 탭 밖 전체화면(스플래시, 로그인, 상세)은 셸 밖 `GoRoute`.
- 새 화면 = `AppRoute` 항목 추가 + `app_router.dart`에 `GoRoute` 추가 + `test/app_test.dart` 또는 feature 테스트에 도달 테스트.

## 모델
`freezed` + `json_serializable`. 엔티티는 `domain/`에, DTO가 따로 필요해질 때만 `data/`에 둔다.

## 백엔드
없음. 모든 데이터는 `Fake*Repository`가 메모리에서 제공한다. 네트워크 코드 추가 금지(스펙 범위 외).
