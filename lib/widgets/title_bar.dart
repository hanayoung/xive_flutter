import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TitleBar extends StatelessWidget {
  final String title;
  const TitleBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/left_arrow_icon.svg',
            height: 24,
            width: 24,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        ],
      ),
    );
  }
}
