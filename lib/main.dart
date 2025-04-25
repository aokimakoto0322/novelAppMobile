import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_nobel_app/database/migration.dart';
import 'package:flutter_nobel_app/game_screen.dart';
import 'package:flutter_nobel_app/models/common_story.dart';
import 'package:flutter_nobel_app/save_screen.dart';
import 'package:flutter_nobel_app/usecase/common_story_usecase.dart';
import 'package:flutter_nobel_app/usecase/save_usecase.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Database database = await initializeDatabase();

  // 環境変数
  await dotenv.load(fileName: ".env");

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Database database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'サンプル', database: database),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Database database;

  const MyHomePage({super.key, required this.title, required this.database});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CommonStoryUsecase commonStoryUsecase = CommonStoryUsecase();
  SaveUsecase saveUsecase = SaveUsecase();
  List<CommonStory> allStory = [];

  @override
  void initState() {
    fetchAllStory();
    super.initState();
  }

  Future<void> fetchAllStory() async {
    allStory = await commonStoryUsecase.getAllStory(widget.database);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
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
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => GameScreen(database: widget.database, allStory: allStory),
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
                  },
                  child: Text('初めから')
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SaveScreen(database: widget.database, allStory: allStory))
                    );
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
