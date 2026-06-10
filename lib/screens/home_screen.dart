import 'package:flutter/material.dart';
import 'package:speak_tuning/services/gemini_service.dart';
import 'package:speak_tuning/services/speech_service.dart';

import '../controllers/speech_session_controller.dart';
import '../models/speech_feedback.dart';
import '../widgets/home_body.dart';

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
      body: HomeBody(
        session: _session,
        feedback: feedback,
        isListening: isListening,
        isAnalyzing: isAnalyzing,
        onMicTap: _handleMicTap,
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
