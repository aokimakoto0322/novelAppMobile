import 'package:flutter_nobel_app/data/repository/save_repository.dart';
import 'package:flutter_nobel_app/provider/backlog_provider.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/usecase/save_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final saveRepositoryProvider = Provider<SaveRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SaveRepository(db);
});

final saveUsecaseProvider = Provider<SaveUsecase>((ref) {
  final saveRepository = ref.watch(saveRepositoryProvider);
  final backlogRepository = ref.watch(backlogRepositoryProvider);

  return SaveUsecase(
    saveRepository: saveRepository,
    backlogRepository: backlogRepository
  );
});