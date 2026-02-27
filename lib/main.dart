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
        textTheme: GoogleFonts.notoSansJpTextTheme(),
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

    await storyUsecase.getAllStory();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usecase = ref.read(storyUsecaseProvider.notifier);
    final backlogUsecase = ref.read(backlogUsecaseProvider);
    
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/home.jpg'),
              fit: BoxFit.cover
            )
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      if (!isLoading) {
                        await Future.delayed(Duration(milliseconds: 200));
                        usecase.resetState();
                        await backlogUsecase.deleteBackLog();
                        await usecase.setCurrentIndex(0);
                        if (!context.mounted) return;
                        
                        context.go('/game'); // 戻る禁止の画面遷移
                      }
                    },
                    child: Text('初めから')
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (!isLoading) {
                        context.push('/save'); // 戻る許可の画面遷移
                      }
                    },
                    child: Text('続きから')
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
