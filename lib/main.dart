import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/game_screen.dart';
import 'package:flutter_nobel_app/provider/backlog_provider.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_nobel_app/save_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(),
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
    
    return Scaffold(
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
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (context, animation, secondaryAnimation) => GameScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation.drive(
                                CurveTween(curve: Curves.easeIn)
                              ),
                              child: child
                            );
                          },
                          transitionDuration: Duration(milliseconds: 500)
                        )
                      );
                    }
                  },
                  child: Text('初めから')
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!isLoading) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaveScreen()
                        )
                      );
                    }
                  },
                  child: Text('続きから')
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
