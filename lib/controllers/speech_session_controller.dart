import 'package:speak_tuning/models/speech_pause.dart';

class SpeechSessionController {
  String spokenText = '';
  String fullSpeechText = '';
  String currentSpeechChunk = '';
  String lastSavedChunk = '';

  DateTime? _lastSpeechChangeAt;

  final List<SpeechPause> longPauses = [];

  static const Duration longPauseThreshold = Duration(seconds: 5);

  void reset() {
    spokenText = '';
    fullSpeechText = '';
    currentSpeechChunk = '';
    lastSavedChunk = '';
    longPauses.clear();
    _lastSpeechChangeAt = DateTime.now();
  }

  void updateSpeech(String result, bool isFinal) {
    final cleanResult = result.trim();
    if (cleanResult.isEmpty) return;

    final now = DateTime.now();

    if (cleanResult != currentSpeechChunk) {
      _detectPause(now);
    }

    currentSpeechChunk = cleanResult;

    spokenText = '$fullSpeechText $currentSpeechChunk'.trim();

    if (isFinal && cleanResult != lastSavedChunk) {
      fullSpeechText = '$fullSpeechText $cleanResult'.trim();
      lastSavedChunk = cleanResult;
      currentSpeechChunk = '';
      _lastSpeechChangeAt = now;
    }
  }

  String get textToAnalyze {
    return spokenText.trim();
  }

  String get pauseReport {
    if (longPauses.isEmpty) {
      return 'No long pauses detected.';
    }

    return longPauses
        .map((pause) {
          return '- Long pause at ${pause.formattedStartedAt}, '
              'duration: ${pause.formattedDuration}, '
              'after this speech: "${pause.afterWords}"';
        })
        .join('\n');
  }

  String get textWithPauseData {
    return '''
Spoken text:
$textToAnalyze

Pause data:
$pauseReport
''';
  }

  void _detectPause(DateTime now) {
    if (_lastSpeechChangeAt == null) {
      _lastSpeechChangeAt = now;
      return;
    }

    if (spokenText.trim().isEmpty) {
      _lastSpeechChangeAt = now;
      return;
    }

    final pauseDuration = now.difference(_lastSpeechChangeAt!);

    if (pauseDuration >= longPauseThreshold) {
      longPauses.add(
        SpeechPause(
          startedAt: _lastSpeechChangeAt!,
          duration: pauseDuration,
          afterWords: spokenText,
        ),
      );
    }

    _lastSpeechChangeAt = now;
  }
}
