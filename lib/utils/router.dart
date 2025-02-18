import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyavun/providers/theme_manager.dart';
import 'package:gyavun/screens/artists/artist_screen.dart';
import 'package:gyavun/screens/download_screen.dart';
import 'package:gyavun/screens/lists/list_screen.dart';
import 'package:gyavun/screens/main_screen.dart';
import 'package:gyavun/screens/main_screen/home_screen.dart';
import 'package:gyavun/screens/playlists/favorites_details.dart';
import 'package:gyavun/screens/playlists/playlists_screen.dart';
import 'package:gyavun/screens/search/main_search.dart';
import 'package:gyavun/screens/settings/app_layout.dart';
import 'package:gyavun/screens/settings/download_screen.dart';
import 'package:gyavun/screens/settings/setting_search_screen.dart';
import 'package:gyavun/screens/settings/playback_screent.dart';
import 'package:gyavun/screens/settings/setting_screen.dart';
import 'package:gyavun/screens/settings/theme_screen.dart';

PageController pageController = PageController();
GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
        builder: (context, state, child) => Directionality(
            textDirection: GetIt.I<ThemeManager>().isRightToLeftDirection
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child),
        routes: [
          StatefulShellRoute.indexedStack(
            branches: branches,
            builder: (context, state, navigationShell) =>
                ScaffoldWithNestedNavigation(navigationShell: navigationShell),
          ),
        ]),
  ],
);

List<StatefulShellBranch> branches = [
  StatefulShellBranch(
    routes: [
      // top route inside branch
      GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeScreen()),
          routes: [
            GoRoute(
              path: 'list',
              pageBuilder: (context, state) =>
                  CupertinoPage(child: ListScreen(list: state.extra as Map)),
            ),
            GoRoute(
              path: 'search',
              pageBuilder: (context, state) =>
                  const MaterialPage(child: MainSearchScreen()),
              routes: [
                GoRoute(
                  path: 'list',
                  pageBuilder: (context, state) => CupertinoPage(
                      child: ListScreen(list: state.extra as Map)),
                ),
                GoRoute(
                  path: 'artist',
                  pageBuilder: (context, state) => CupertinoPage(
                      child:
                          ArtistScreen(artist: Map.from(state.extra as Map))),
                ),
              ],
            ),
          ]),
    ],
  ),
  StatefulShellBranch(
    routes: [
      // top route inside branch
      GoRoute(
          path: '/playlists',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: PlaylistsScreen()),
          routes: [
            GoRoute(
              path: 'favorite',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: FavoriteDetails()),
            ),
          ]),
    ],
  ),
  StatefulShellBranch(
    routes: [
      // top route inside branch
      GoRoute(
        path: '/downloads',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: DownloadsScreen()),
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      // top route inside branch
      GoRoute(
          path: '/settings',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingScreen()),
          routes: [
            GoRoute(
              path: 'applayout',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: AppLayout()),
            ),
            GoRoute(
              path: 'theme',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: ThemeScreen()),
            ),
            GoRoute(
              path: 'playback',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: PlaybackScreen()),
            ),
            GoRoute(
              path: 'search',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: SettingSearchScreen()),
            ),
            GoRoute(
              path: 'download',
              pageBuilder: (context, state) =>
                  const CupertinoPage(child: DownloadScreen()),
            )
          ]),
    ],
  ),
];
