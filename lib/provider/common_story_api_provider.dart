import 'package:flutter_nobel_app/data/sources/story_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonStoryApiProvider = Provider<CommonStoryApi>((ref) {
  return CommonStoryApi();
});