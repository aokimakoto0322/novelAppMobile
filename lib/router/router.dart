import 'package:flutter/widgets.dart';
import 'package:flutter_nobel_app/backlog_screen.dart';
import 'package:flutter_nobel_app/game_screen.dart';
import 'package:flutter_nobel_app/main.dart';
import 'package:flutter_nobel_app/save_screen.dart';
import 'package:flutter_nobel_app/splash_screen.dart';
import 'package:flutter_nobel_app/unity_splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: UnitySplashScreen(),
        ),
      ),
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/title',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const MyHomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 3000),
          );
        },
      ),
      // セーブデータがなく、新規作成する場合
      GoRoute(
        path: '/game',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: GameScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // ここでフェードインの挙動を調整
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInCirc, // ゆっくり現れるカーブ
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 1500), // 1.5秒かけて明るくなる
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

  return router;
});