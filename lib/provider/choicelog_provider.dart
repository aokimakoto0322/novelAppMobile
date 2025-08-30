import 'package:flutter_nobel_app/data/repository/choicelog_repository.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final choiceLogRepositoryProvider = Provider<ChoicelogRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ChoicelogRepository(db);
});