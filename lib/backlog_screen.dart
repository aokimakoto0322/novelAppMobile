
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/provider/backlog_provider.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BacklogScreen extends ConsumerStatefulWidget {

  const BacklogScreen({
    super.key
  });


  @override
  ConsumerState<BacklogScreen> createState() => _BacklogScreenState();
}

class _BacklogScreenState extends ConsumerState<BacklogScreen> {
  @override
  Widget build(BuildContext context) {
    final usecase = ref.watch(backlogUsecaseProvider);
    final state = ref.watch(storyUsecaseProvider);
    
    return Scaffold(
      body: FutureBuilder<List<BackLog>>(
        future: usecase.getBacklog(state.saveId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("バックログがありません"));
          }
      
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].word),
                subtitle: Text(snapshot.data![index].speaker),
                leading: Text(snapshot.data![index].choiceWord),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
          );
        }
      ),
    );
  }
}