import 'package:flutter_nobel_app/data/repository/backlog_repository.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/usecase/backlog_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backlogRepositoryProvider = Provider<BacklogRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BacklogRepository(db);
});

final backlogUsecaseProvider = Provider<BacklogUsecase>((ref) {
  final backlogRepository = ref.watch(backlogRepositoryProvider);
  return BacklogUsecase(backlogRepository: backlogRepository);
});