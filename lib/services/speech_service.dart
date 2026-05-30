import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  //underscore means its private and only this class can use it
  bool isListening = false;
  Future<void> initialize() async {
    await _speech.initialize();
  }
}
