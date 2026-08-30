import 'package:flutter_nobel_app/data/repository/choice_repository.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/usecase/choice_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final choiceRepositoryProvider = Provider<ChoiceRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ChoiceRepository(db);
});

final choiceUsecaseProvider = Provider<ChoiceUsecase>((ref) {
  final choiceRepository = ref.watch(choiceRepositoryProvider);
  return ChoiceUsecase(choiceRepository: choiceRepository);
});