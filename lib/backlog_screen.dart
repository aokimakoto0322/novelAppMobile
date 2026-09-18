
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/provider/backlog_provider.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_nobel_app/constants/const.dart'; // 追加

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
      backgroundColor: Colors.white,
      key: ValueKey('${DateTime.now().millisecond}'), // keyを設定してGoRouterが画面情報を再利用するのを防ぐ
      appBar: AppBar(
        title: const Text("バックログ"),
        leading: BackButton(
          onPressed: () => context.pop(), // ← GoRouter の戻る
        ),
      ),
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
              final String? characterImage = Const.CHARACTER_IMAGE_MAP[snapshot.data![index].speaker];

              return ListTile(
                leading: characterImage != null
                    ? CircleAvatar(
                        backgroundImage: AssetImage(characterImage),
                        radius: 24, // 丸のサイズを調整
                      )
                    : null, // 画像がない場合は何も表示しない
                title: Text(snapshot.data![index].word),
                subtitle: Text(snapshot.data![index].speaker),
                trailing: Text(snapshot.data![index].choiceWord), // choiceWordを右側に移動
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