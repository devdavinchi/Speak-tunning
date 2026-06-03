import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  //underscore means its private and only this class can use it
  bool isListening = false;
  Future<void> initialize() async {
    await _speech.initialize();
  }

  Future<void> startListening(Function(String) onResult) async {
    await _speech.listen(onResult: (result) {
      onResult(result.recognizedWords);
    });
  }
}
