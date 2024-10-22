import 'package:flutter/material.dart';
import 'package:xive/main.dart';

class SettingDivider extends StatelessWidget {
  const SettingDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightModeTheme.dividerColor,
      height: 8,
      width: MediaQuery.of(context).size.width,
    );
  }
}
