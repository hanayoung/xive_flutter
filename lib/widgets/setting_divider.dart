import 'package:flutter/material.dart';

class SettingDivider extends StatelessWidget {
  const SettingDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).dividerColor,
      height: 8,
      width: MediaQuery.of(context).size.width,
    );
  }
}
