import 'package:donguran/core/router/app_shell.dart';
import 'package:donguran/core/router/routes.dart';
import 'package:donguran/features/auth/presentation/login_page.dart';
import 'package:donguran/features/auth/presentation/splash_page.dart';
import 'package:donguran/features/chat/presentation/chat_page.dart';
import 'package:donguran/features/home/presentation/home_page.dart';
import 'package:donguran/features/my/presentation/my_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(path: AppRoute.login.path, builder: (_, __) => const LoginPage()),
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                builder: (_, __) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.chat.path,
                builder: (_, __) => const ChatPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.my.path,
                builder: (_, __) => const MyPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
