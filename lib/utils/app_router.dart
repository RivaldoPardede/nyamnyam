import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/pages/favorites_page.dart';
import '../ui/pages/restaurant_detail_page.dart';
import '../ui/pages/restaurant_list_page.dart';
import '../ui/pages/search_page.dart';
import '../ui/pages/settings_page.dart';
import '../ui/widgets/scaffold_with_navbar.dart';

/// App router configuration using go_router with StatefulShellRoute
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellHome',
  );
  static final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellSearch',
  );
  static final _shellNavigatorFavoritesKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellFavorites',
  );
  static final _shellNavigatorSettingsKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellSettings',
  );

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      // Stateful Nested Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const RestaurantListPage(),
              ),
            ],
          ),
          // Search Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearchKey,
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          // Favorites Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorFavoritesKey,
            routes: [
              GoRoute(
                path: '/favorites',
                name: 'favorites',
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),
          // Settings Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettingsKey,
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),

      // Detail Route (Full Screen, hides bottom nav)
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        parentNavigatorKey: _rootNavigatorKey, // Use root navigator
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final name = state.uri.queryParameters['name'] ?? 'Restaurant';
          return RestaurantDetailPage(restaurantId: id, restaurantName: name);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri.path}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
