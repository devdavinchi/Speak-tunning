import 'package:flutter/material.dart';
import 'package:speak_tuning/widgets/mic_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String spokenText = '';
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // title
              const Text(
                "AI Speech Tuner",
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
                "AI corrects your filler words.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 60),
              Text(spokenText),
              // mic button
              MicButton(onTap: () => debugPrint("mic clicked")),
              const SizedBox(height: 30),

              const Text(
                "Tap to start speaking",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
