import 'package:flutter/material.dart';

import 'info_card.dart';

class ListCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final String emptyText;

  const ListCard({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
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
