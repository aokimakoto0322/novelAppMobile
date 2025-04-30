import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/game_screen.dart';
import 'package:flutter_nobel_app/usecase/save_usecase.dart';
import 'package:flutter_nobel_app/views/save_view_model.dart';

class SaveScreen extends StatefulWidget {
  final MyDatabase database;
  final List<Story> allStory;
  const SaveScreen({super.key, required this.database, required this.allStory});

  @override
  State<StatefulWidget> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  SaveUsecase saveUsecase = SaveUsecase();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<List<SaveViewModel>>(
          future: saveUsecase.fetchSaveList(widget.database),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("セーブデータがありません"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].word),
                  subtitle: Text(snapshot.data![index].saveDate),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameScreen(
                        database: widget.database,
                        allStory: widget.allStory,
                        savedIndex: snapshot.data![index].storyId - 1
                      ))
                    );
                  },
                );
              }
            );
          }
        ),
      ),
    );
  }
  
}