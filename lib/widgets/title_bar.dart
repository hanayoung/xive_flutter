import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class TitleBar extends StatelessWidget {
  final String title;
  // final Function func;
  const TitleBar({super.key, required this.title});

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
          InkWell(
            onTap: () => Get.back(),
            child: SvgPicture.asset(
              'assets/images/left_arrow_icon.svg',
              height: 24,
              width: 24,
            ),
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
