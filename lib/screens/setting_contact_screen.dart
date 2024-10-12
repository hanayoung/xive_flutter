import 'package:flutter/material.dart';
import 'package:xive/widgets/title_bar.dart';

class SettingContactScreen extends StatelessWidget {
  const SettingContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
            child: Column(children: [
      TitleBar(
        title: "1:1문의",
      )
    ])));
  }
}
