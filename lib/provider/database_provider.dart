import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider<MyDatabase>((ref) {
  return MyDatabase();
});