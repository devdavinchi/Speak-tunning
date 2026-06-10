import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:speak_tuning/models/speech_feedback.dart';

class GeminiService {
  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _model = 'gemini-2.5-flash';

  String get _url =>
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  Future<String> analyzeText(String spokenText) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'x-goog-api-key': _apiKey},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                    '''
You are a speech coach. Analyze this spoken text:
"$spokenText"

Return only valid JSON. Do not use markdown.
Use this exact shape:
{
  "score": 0,
  "summary": "short overall feedback",
  "fillerWords": ["word or phrase"],
  "strengths": ["what went well"],
  "tips": ["specific improvement tip"],
  "spokenReply": "one short sentence the app can speak aloud"
}

Score should be from 0 to 100.
Keep every list between 1 and 4 items.
''',
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
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      return 'Error: could not get feedback';
    }
  }

  Future<SpeechFeedback> analyzeSpeech(String spokenText) async {
    final responseText = await analyzeText(spokenText);

    try {
      final cleanJson = responseText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final decoded = jsonDecode(cleanJson);
      return SpeechFeedback.fromJson(decoded);
    } catch (_) {
      return SpeechFeedback(
        score: 0,
        summary: responseText,
        fillerWords: const [],
        strengths: const [],
        tips: const [
          'Try speaking again so I can analyze your speech clearly.',
        ],
        spokenReply: responseText,
      );
    }
  }
}
