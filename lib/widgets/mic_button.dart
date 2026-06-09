import 'package:flutter/material.dart';

class MicButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isListening;

  const MicButton({
    super.key,
    required this.onTap,
    this.isListening = false,
  });

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.isListening ? Colors.greenAccent : Colors.redAccent;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: buttonColor,
          boxShadow: [
            BoxShadow(
              color: buttonColor.withValues(alpha: 0.4),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Icon(
          widget.isListening ? Icons.stop : Icons.mic,
          color: Colors.white,
          size: 70,
        ),
      ),
    );
  }
}
