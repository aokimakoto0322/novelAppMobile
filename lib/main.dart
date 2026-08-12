import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/provider/backlog_provider.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'router/router.dart';
import 'package:flutter_nobel_app/widget/title_slideshow.dart';
import 'package:flutter_nobel_app/widget/button/title_button.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  final database = MyDatabase();

  // 環境変数
  await dotenv.load(fileName: ".env");

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database)
      ],
      child: MyApp()
    )
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.kosugiMaruTextTheme(),
      ),
      routerConfig: router,
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  List<Story> allStory = [];
  bool isLoading = false; // 初期データ取得時のロード状態を管理
  bool isFading = false; // 暗転用フラグを追加

  @override
  void initState() {
    super.initState();
    fetchAllStory();
  }

  Future<void> fetchAllStory() async {
    final storyUsecase = ref.read(storyUsecaseProvider.notifier);

    setState(() {
      isLoading = true;
    });

    try {
      await storyUsecase.getAllStory();
    } catch (e) {
      debugPrint("ストーリー取得エラー: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usecase = ref.read(storyUsecaseProvider.notifier);
    final backlogUsecase = ref.read(backlogUsecaseProvider);
    
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            const TitleSlideshow(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TitleButton(
                      text: '初めから',
                      onPressed: () async {
                        if (!isLoading && !isFading) {
                          setState(() {
                            isFading = true; // 暗転開始
                          });

                          // 暗転アニメーションを待つ
                          await Future.delayed(const Duration(milliseconds: 1200));

                          usecase.resetState();
                          await backlogUsecase.deleteBackLog();
                          await usecase.setCurrentIndex(0);
                          if (!context.mounted) return;
                          
                          context.go('/game'); // 戻る禁止の画面遷移
                        }
                      }
                    ),
                    const SizedBox(height: 20),
                    TitleButton(
                      text: '続きから',
                      onPressed: () {
                        if (!isLoading && !isFading) {
                          // 念のためここでもフラグを立てるか、即座に遷移させる
                          if (!context.mounted) return;
                          context.push('/save'); // 戻る許可の画面遷移
                        }
                      }
                    ),
                  ],
                ),
              ),
            ),
            // 暗転用のオーバーレイ
            IgnorePointer(
              ignoring: !isFading,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000), // 1秒かけて暗転
                opacity: isFading ? 1.0 : 0.0,
                child: Container(color: Colors.black),
              ),
            ),

            // ローディング表示（追加）
            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 20),
                      Text("データを読み込み中...", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
