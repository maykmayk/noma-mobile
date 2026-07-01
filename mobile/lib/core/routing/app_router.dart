import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/ride/presentation/ride_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import 'app_shell.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final notifier = _RouterRefreshNotifier();

  final sub = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
    notifier.notify();
  });

  ref.onDispose(() {
    sub.cancel();
    notifier.dispose();
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: notifier,
    redirect: (context, state) {
      final loggedIn = Supabase.instance.client.auth.currentSession != null;
      final onAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!loggedIn && !onAuthRoute) return '/login';
      if (loggedIn && onAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ride',
                name: 'ride',
                builder: (context, state) => const RideScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    name: 'settings',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}
