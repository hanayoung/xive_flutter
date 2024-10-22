import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:xive/screens/setting_withdrawal.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.controller,
    required this.isMain,
    required this.idx,
  });

  final SettingController controller;
  final bool isMain;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Checkbox(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        value: isMain
            ? controller.isChecked.value
            : controller.selectedIdx.value == idx,
        onChanged: (bool? value) {
          controller.toggleCheckbox();
        },
        activeColor: Colors.black,
        checkColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: const BorderSide(
              color: Color(0xFF999999),
              width: 2,
            )),
      ),
    );
  }
}
