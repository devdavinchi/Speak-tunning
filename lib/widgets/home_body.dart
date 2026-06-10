import 'package:flutter/material.dart';
import 'package:speak_tuning/widgets/score_card.dart';
import 'package:speak_tuning/widgets/underlined_text.dart';

import '../controllers/speech_session_controller.dart';
import '../models/speech_feedback.dart';
import 'feedback_list.dart';
import 'info_card.dart';
import 'mic_button.dart';

class HomeBody extends StatelessWidget {
  final SpeechSessionController session;
  final SpeechFeedback feedback;
  final bool isListening;
  final bool isAnalyzing;
  final VoidCallback onMicTap;

  const HomeBody({
    super.key,
    required this.session,
    required this.feedback,
    required this.isListening,
    required this.isAnalyzing,
    required this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                session.spokenText.isEmpty
                    ? 'Tap the mic and start speaking.'
                    : session.spokenText,
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
              if (feedback.analyzedTranscript.isNotEmpty) ...[
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Exact Transcript (with pauses)',
                  icon: Icons.subtitles,
                  child: UnderlinedText(feedback.analyzedTranscript),
                ),
              ],

              if (feedback.improvedVersion.isNotEmpty) ...[
                const SizedBox(height: 16),
                InfoCard(
                  title: 'Improved Version',
                  icon: Icons.auto_awesome_mosaic,
                  child: Text(
                    feedback.improvedVersion,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 16,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],

            const SizedBox(height: 32),
            // mic button
            Center(
              child: MicButton(onTap: onMicTap, isListening: isListening),
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
    );
  }
}
