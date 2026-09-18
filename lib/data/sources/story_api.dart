import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:http/http.dart' as http;

class CommonStoryApi {
  Future<List<Story>> fetchAllStory() async {
    String baseUrl = dotenv.env['FETCH_STORY_API'] ?? 'https://google.com';
    String token = dotenv.env['TOKEN'] ?? '';
    String url = "$baseUrl/story?token=$token";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept-Encoding': 'gzip, deflate, br',
      },
    );

    if (response.statusCode == 200) {
      String decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = jsonDecode(decodedBody);
      final stories = jsonData.map((data) => Story.fromJson(data)).toList();
      stories.sort((a, b) {
        final numA = num.tryParse(a.sortId);
        final numB = num.tryParse(b.sortId);
        if (numA != null && numB != null) {
          return numA.compareTo(numB);
        }
        return a.sortId.compareTo(b.sortId);
      });
      return stories;
    } else {
      throw Exception('failed request');
    }
  }
}
