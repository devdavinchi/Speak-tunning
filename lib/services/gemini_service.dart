import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _url = 'https://openrouter.ai/api/v1/chat/completions';

  Future<String> analyzeText(String spokenText) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                    'You are a speech coach. Analyze this text for filler words like um, uh, like, you know. Give short helpful feedback: $spokenText',
              },
            ],
          },
        ],
      }),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return 'Error: could not get feedback';
    }
  }
}
