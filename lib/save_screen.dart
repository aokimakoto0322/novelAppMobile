import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/provider/save_provider.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_nobel_app/views/save_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SaveScreen extends ConsumerWidget {
  const SaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseProvider);
    final saveUsecase = ref.read(saveUsecaseProvider);
    final usecase = ref.read(storyUsecaseProvider.notifier);

    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<List<SaveViewModel>>(
          future: saveUsecase.fetchSaveList(database),
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
                  leading: Text(snapshot.data![index].id.toString()),
                  onTap: () {
                    // 画面遷移の前に画面状態をロードしておく
                    usecase.initGameScreen(
                      snapshot.data![index].storyId - 1,
                      snapshot.data![index].id
                    );
                    context.go('/game/${snapshot.data![index].storyId - 1}/${snapshot.data![index].id}');
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