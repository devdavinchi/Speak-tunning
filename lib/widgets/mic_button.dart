import 'package:flutter/material.dart';

class MicButton extends StatefulWidget {
  final VoidCallback onTap;
  const MicButton({super.key, required this.onTap});

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withValues(alpha: 0.4),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: const Icon(Icons.mic, color: Colors.white, size: 70),
      ),
    );
  }
}
