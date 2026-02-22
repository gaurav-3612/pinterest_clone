import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import your screens and models
import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/main_scaffold.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/photo_detail_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/profile/presentation/saved_screen.dart';
import '../../features/home/data/models/photo_model.dart';

// Create a GlobalKey for the root navigator so auth/modals work smoothly
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home', // We start here, bypassing the missing '/'
  routes: [
    // --- Auth Route ---
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // --- Stateful Bottom Navigation Routing ---
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        // 1. Home Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                // Sub-route: /home/details
                GoRoute(
                  path: 'details', // Note: NO leading slash here
                  builder: (context, state) {
                    final photo = state.extra as PhotoModel;
                    return PhotoDetailScreen(photo: photo);
                  },
                ),
              ],
            ),
          ],
        ),

        // 2. Search Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
              routes: [
                // Sub-route: /search/details
                GoRoute(
                  path: 'details', // Note: NO leading slash here
                  builder: (context, state) {
                    final photo = state.extra as PhotoModel;
                    return PhotoDetailScreen(photo: photo);
                  },
                ),
              ],
            ),
          ],
        ),

        // 3. Create Branch (Placeholder so it doesn't crash)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/create',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Create Pin Feature Coming Soon')),
              ),
            ),
          ],
        ),

        // 4. Inbox Branch (Placeholder so it doesn't crash)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inbox',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Inbox Feature Coming Soon')),
              ),
            ),
          ],
        ),

        // 5. Saved (Profile) Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/saved',
              builder: (context, state) => const SavedScreen(), // Use the SavedScreen we made
            ),
          ],
        ),
      ],
    ),
  ],
);