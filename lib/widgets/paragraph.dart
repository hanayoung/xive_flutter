import 'package:flutter/material.dart';
import 'package:xive/main.dart';

class Paragraph extends StatelessWidget {
  final String title, content;
  const Paragraph({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: lightModeTheme.textTheme.titleSmall,
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              content,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                letterSpacing: -0.02,
              ),
            ),
          )
        ],
      ),
    );
  }
}
