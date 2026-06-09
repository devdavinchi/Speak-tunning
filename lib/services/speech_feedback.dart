class SpeechFeedback {
  final int score;
  final String summary;
  final List<String> fillerWords;
  final List<String> strengths;
  final List<String> tips;
  final String spokenReply;

  const SpeechFeedback({
    required this.score,
    required this.summary,
    required this.fillerWords,
    required this.strengths,
    required this.tips,
    required this.spokenReply,
  });

  factory SpeechFeedback.empty() {
    return const SpeechFeedback(
      score: 0,
      summary: '',
      fillerWords: [],
      strengths: [],
      tips: [],
      spokenReply: '',
    );
  }

  factory SpeechFeedback.fromJson(Map<String, dynamic> json) {
    return SpeechFeedback(
      score: json['score'] is int ? json['score'] : 0,
      summary: json['summary']?.toString() ?? '',
      fillerWords: _stringList(json['fillerWords']),
      strengths: _stringList(json['strengths']),
      tips: _stringList(json['tips']),
      spokenReply: json['spokenReply']?.toString() ?? '',
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return [];
    return value.map((item) => item.toString()).toList();
  }
}
