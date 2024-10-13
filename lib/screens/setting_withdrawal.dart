import 'package:flutter/material.dart';
import 'package:xive/widgets/title_bar.dart';

class SettingWithdrawal extends StatelessWidget {
  const SettingWithdrawal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          TitleBar(
            title: "회원탈퇴",
          ),
        ],
      ),
    );
  }
}
