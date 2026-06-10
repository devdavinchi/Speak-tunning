class SpeechFeedback {
  final int score;
  final String summary;
  final List<String> fillerWords;
  final String analyzedTranscript;
  final String improvedVersion;
  final String spokenReply;

  const SpeechFeedback({
    required this.score,
    required this.summary,
    required this.fillerWords,
    required this.analyzedTranscript,
    required this.improvedVersion,
    required this.spokenReply,
  });

  factory SpeechFeedback.empty() {
    return const SpeechFeedback(
      score: 0,
      summary: '',
      fillerWords: [],
      analyzedTranscript: '',
      improvedVersion: '',
      spokenReply: '',
    );
  }

  factory SpeechFeedback.fromJson(Map<String, dynamic> json) {
    return SpeechFeedback(
      score: json['score'] is int ? json['score'] : 0,
      summary: json['summary']?.toString() ?? '',
      fillerWords: _stringList(json['fillerWords']),
      analyzedTranscript: json['analyzedTranscript']?.toString() ?? '',
      improvedVersion: json['improvedVersion']?.toString() ?? '',
      spokenReply: json['spokenReply']?.toString() ?? '',
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return [];
    return value.map((item) => item.toString()).toList();
  }
}
