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
        // THIS IS THE HIDDEN SWITCH TO FORCE JSON MODE
        'generationConfig': {'responseMimeType': 'application/json'},
        'contents': [
          {
            'parts': [
              {
                'text':
                    '''
You are a speech coach. Analyze the following spoken text and its pause data:
"$spokenText"

Reconstruct the exact spoken text. For every filler word you detect, wrap it in asterisks like **um**. 

CRITICAL RULE: You MUST add proper punctuation (periods, commas, question marks) to the reconstructed text so it reads naturally! Do NOT leave it as a raw stream of words.

CRITICAL RULE: For EVERY pause indicated in the pause data, you MUST insert a visual marker exactly where it happened in the text, exactly like this: ".....".

CRITICAL RULE: If the spoken text is just random gibberish or a collection of unrelated words, you must abort and return exactly this JSON:
{
  "score": 0,
  "summary": "Random words detected. No feedback generated.",
  "fillerWords": [],
  "analyzedTranscript": "",
  "improvedVersion": "",
  "spokenReply": "I didn't catch a clear sentence."
}

If it is NOT gibberish, you MUST return this exact JSON shape:
{
  "score": 85,
  "summary": "short overall feedback",
  "fillerWords": ["list of filler words used"],
  "analyzedTranscript": "the exact text with **filler words** and ..... [4.2 second pause] inserted",
  "improvedVersion": "a much better, professional version of the exact same sentence",
  "spokenReply": "one short, encouraging sentence the app can speak aloud"
}
''',
              },
            ],
          },
        ],
      }),
    );

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
        analyzedTranscript: responseText,
        improvedVersion: 'Could not generate an improved version.',
        spokenReply: responseText,
      );
    }
  }
}

// words commenting commit
