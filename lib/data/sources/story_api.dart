import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_nobel_app/models/common_story.dart';
import 'package:http/http.dart' as http;

class CommonStoryApi {
  Future<List<CommonStory>> fetchAllStory() async {
    String baseUrl = dotenv.env['FETCH_STORY_API'] ?? 'https://google.com';
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      String decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = jsonDecode(decodedBody);
      return jsonData.map((data) => CommonStory.fromJson(data)).toList();
    } else {
      throw Exception('failed request');
    }
  }
}
