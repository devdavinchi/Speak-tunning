import 'package:flutter/material.dart';
import 'package:speak_tuning/services/gemini_service.dart';
import 'package:speak_tuning/services/speech_service.dart';
import 'package:speak_tuning/widgets/mic_button.dart';

import '../controllers/speech_session_controller.dart';
import '../models/speech_feedback.dart';
import '../widgets/feedback_list.dart';
import '../widgets/info_card.dart';
import '../widgets/score_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechService _speechService = SpeechService();
  final GeminiService _geminiService = GeminiService();
  final SpeechSessionController _session = SpeechSessionController();

  SpeechFeedback feedback = SpeechFeedback.empty();
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

              InfoCard(
                title: 'Your speech',
                icon: Icons.record_voice_over,
                child: Text(
                  _session.spokenText.isEmpty
                      ? 'Tap the mic and start speaking.'
                      : _session.spokenText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),

              if (isAnalyzing) ...[
                const SizedBox(height: 16),
                const InfoCard(
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
                ScoreCard(score: feedback.score, summary: feedback.summary),
                const SizedBox(height: 16),
                ListCard(
                  title: 'Filler words',
                  icon: Icons.hearing,
                  items: feedback.fillerWords,
                  emptyText: 'No clear filler words found.',
                ),
                const SizedBox(height: 16),
                ListCard(
                  title: 'What worked',
                  icon: Icons.check_circle_outline,
                  items: feedback.strengths,
                  emptyText: 'Speak a little longer to find strengths.',
                ),
                const SizedBox(height: 16),
                ListCard(
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
      final textToAnalyze = _session.textWithPauseData.trim();

      setState(() {
        isListening = false;
      });

      if (textToAnalyze.isEmpty) return;

      setState(() {
        isAnalyzing = true;
      });

      final analyzedFeedback = await _geminiService.analyzeSpeech(
        textToAnalyze,
      );
      if (!mounted) return;
      setState(() {
        feedback = analyzedFeedback;
        isAnalyzing = false;
      });

      await _speechService.speak(analyzedFeedback.spokenReply);
      return;
    }

    await _speechService.stopSpeaking();
    setState(() {
      _session.reset();
      feedback = SpeechFeedback.empty();
      isListening = true;
    });

    await _speechService.startListening((result, isFinal) async {
      setState(() {
        _session.updateSpeech(result, isFinal);
      });
    });
  }
}
