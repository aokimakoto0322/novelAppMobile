import 'package:flutter_nobel_app/data/repository/choice_repository.dart';
import 'package:flutter_nobel_app/database/database.dart';

class ChoiceUsecase {
  final ChoiceRepository choiceRepository;

  ChoiceUsecase({
    required this. choiceRepository
  });

  // ストーリーIDを受け取って、ストーリーIDと合致する選択肢リストがあれば返却する
  // 選択肢がある場合はリストで返却、ない場合は[](空のリスト)を返却する
  Future<List<Choice>> fetchCoiceList(MyDatabase db) async {
    var result = await choiceRepository.fetchChoiceList();

    return result;
  }
}