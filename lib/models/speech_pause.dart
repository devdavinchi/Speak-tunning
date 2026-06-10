class SpeechPause {
  final DateTime startedAt;
  final Duration duration;
  final String afterWords;

  const SpeechPause({
    required this.startedAt,
    required this.duration,
    required this.afterWords,
  });

  String get formattedStartedAt {
    final hour = startedAt.hour.toString().padLeft(2, '0');
    final minute = startedAt.minute.toString().padLeft(2, '0');
    final second = startedAt.second.toString().padLeft(2, '0');

    return '$hour:$minute:$second';
  }

  String get formattedDuration {
    return '${duration.inSeconds} seconds';
  }
}
