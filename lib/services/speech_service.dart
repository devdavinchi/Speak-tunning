import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  //underscore means its private and only this class can use it
  bool isListening = false;

  Future<bool> initialize() async {
    return await _speech.initialize(
      onError: (error) => debugPrint('Error: $error'),
      onStatus: (status) => debugPrint('Status: $status'),
    );
  }

  Future<void> startListening(Function(String) onResult) async {
    bool available = await _speech.initialize();
    if (available) {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
      );
      isListening = true;
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
    isListening = false;
  }
}
