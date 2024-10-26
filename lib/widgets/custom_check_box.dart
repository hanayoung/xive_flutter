import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/screens/setting_withdrawal_screen.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.isMain,
    required this.idx,
  });

  final bool isMain;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithDrawalController>(
      builder: (controller) {
        return Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
          value: isMain ? controller.isChecked : controller.selectedIdx == idx,
          onChanged: (bool? value) {
            if (isMain) {
              controller.toggleCheckbox();
            } else {
              controller.setSelectedIdx(idx);
            }
          },
          activeColor: Colors.black,
          checkColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: const BorderSide(
              color: Color(0xFF999999),
              width: 2,
            ),
          ),
        );
      },
    );
  }
}
