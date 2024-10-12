import 'package:flutter/material.dart';

class PageViewLongButton extends StatelessWidget {
  final Color backgroundColor;
  final String text;

  const PageViewLongButton({
    super.key,
    required this.controller,
    required this.currentPage,
    required this.backgroundColor,
    required this.text,
  });

  final PageController controller;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                )),
            onPressed: currentPage < 2
                ? () {
                    controller.animateToPage(
                      currentPage + 1,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn,
                    );
                  }
                : () {
                    Navigator.popAndPushNamed(context, '/home');
                  },
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
