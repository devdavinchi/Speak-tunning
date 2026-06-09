import 'package:flutter/material.dart';
import 'package:speak_tuning/services/gemini_service.dart';
import 'package:speak_tuning/services/speech_service.dart';
import 'package:speak_tuning/widgets/mic_button.dart';

import '../services/speech_feedback.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechService _speechService = SpeechService();
  final GeminiService _geminiService = GeminiService();

  SpeechFeedback feedback = SpeechFeedback.empty();
  String spokenText = '';
  bool isListening = false;
  bool isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _speechService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text(
          "Speak Tuning",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // title
              const Text(
                "AI Speech Tuner",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // subtitle
              const Text(
                "Speak naturally. "
                "AI detects your filler words.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 28),

              _InfoCard(
                title: 'Your speech',
                icon: Icons.record_voice_over,
                child: Text(
                  spokenText.isEmpty
                      ? 'Tap the mic and start speaking.'
                      : spokenText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),

              if (isAnalyzing) ...[
                const SizedBox(height: 16),
                const _InfoCard(
                  title: 'AI feedback',
                  icon: Icons.auto_awesome,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Analyzing your speech...',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ] else if (feedback.summary.isNotEmpty) ...[
                const SizedBox(height: 16),
                _ScoreCard(score: feedback.score, summary: feedback.summary),
                const SizedBox(height: 16),
                _ListCard(
                  title: 'Filler words',
                  icon: Icons.hearing,
                  items: feedback.fillerWords,
                  emptyText: 'No clear filler words found.',
                ),
                const SizedBox(height: 16),
                _ListCard(
                  title: 'What worked',
                  icon: Icons.check_circle_outline,
                  items: feedback.strengths,
                  emptyText: 'Speak a little longer to find strengths.',
                ),
                const SizedBox(height: 16),
                _ListCard(
                  title: 'Try this next',
                  icon: Icons.tips_and_updates,
                  items: feedback.tips,
                  emptyText: 'No tips yet.',
                ),
              ],

              const SizedBox(height: 32),
              // mic button
              Center(
                child: MicButton(
                  onTap: _handleMicTap,
                  isListening: isListening,
                ),
              ),
              const SizedBox(height: 30),

              Text(
                isListening ? "Listening..." : "Tap to start speaking",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleMicTap() async {
    if (isListening) {
      await _speechService.stopListening();
      setState(() => isListening = false);
      return;
    }

    await _speechService.stopSpeaking();
    setState(() {
      spokenText = '';
      feedback = SpeechFeedback.empty();
      isListening = true;
    });

    await _speechService.startListening((result, isFinal) async {
      if (result.trim().isEmpty) return;

      setState(() {
        spokenText = result;
      });

      if (!isFinal || isAnalyzing) return;

      setState(() {
        isListening = false;
        isAnalyzing = true;
      });

      final analyzedFeedback = await _geminiService.analyzeSpeech(result);

      if (!mounted) return;
      setState(() {
        feedback = analyzedFeedback;
        isAnalyzing = false;
      });

      await _speechService.speak(analyzedFeedback.spokenReply);
    });
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.redAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int score;
  final String summary;

  const _ScoreCard({required this.score, required this.summary});

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: 'AI feedback',
      icon: Icons.auto_awesome,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.redAccent),
            ),
            child: Text(
              '$score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              summary,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final String emptyText;

  const _ListCard({
    required this.title,
    required this.icon,
    required this.items,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: title,
      icon: icon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (items.isEmpty ? [emptyText] : items).map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '- ',
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
