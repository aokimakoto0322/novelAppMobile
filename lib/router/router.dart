import 'package:flutter/widgets.dart';
import 'package:flutter_nobel_app/backlog_screen.dart';
import 'package:flutter_nobel_app/game_screen.dart';
import 'package:flutter_nobel_app/main.dart';
import 'package:flutter_nobel_app/save_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MyHomePage()),
    // セーブデータがなく、新規作成する場合
    GoRoute(
      path: '/game',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: GameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        );
      },
    ),

    // セーブデータがあり、セーブ画面から遷移する場合
    GoRoute(
      path: '/game/:index/:saveId',
      pageBuilder: (context, state) {
        final index = int.parse(state.pathParameters['index']!);
        final saveId = int.parse(state.pathParameters['saveId']!);

        return CustomTransitionPage(
          child: GameScreen(savedIndex: index, saveId: saveId),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        );
      },
    ),
    GoRoute(path: '/backlog', builder: (context, state) => const BacklogScreen()),
    GoRoute(path: '/save', builder: (context, state) => const SaveScreen()),
  ],
);

final routerProvider = Provider<GoRouter>((ref) => _router);