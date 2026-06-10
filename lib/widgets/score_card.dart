import 'package:flutter/material.dart';

import 'info_card.dart';

class ScoreCard extends StatelessWidget {
  final int score;
  final String summary;

  const ScoreCard({super.key, required this.score, required this.summary});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
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
