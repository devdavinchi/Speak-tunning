import 'package:flutter/material.dart';

class UnderlinedText extends StatelessWidget {
  final String text;
  const UnderlinedText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final parts = text.split('**');

    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        // Normal text
        spans.add(
          TextSpan(
            text: parts[i],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
            ),
          ),
        );
      } else {
        // Highlighted filler words
        spans.add(
          TextSpan(
            text: parts[i],
            style: const TextStyle(
              color: Colors.yellowAccent,
              fontSize: 16,
              height: 1.4,
              decoration: TextDecoration.underline,
              decorationColor: Colors.yellowAccent,
            ),
          ),
        );
      }
    }
    return RichText(text: TextSpan(children: spans));
  }
}
