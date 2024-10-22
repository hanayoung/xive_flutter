import 'package:flutter/material.dart';
import 'package:xive/main.dart';

class SettingDialog extends StatelessWidget {
  final Function func;
  const SettingDialog({super.key, required this.func});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 28,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
        ),
        width: MediaQuery.of(context).size.width * 0.7,
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '로그아웃 하시겠어요?',
              style: TextStyle(
                color: Color(0xff191919),
                fontSize: 18,
                letterSpacing: -0.02,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text('언제나 여기서 기다리고 있을게요 😢',
                style: lightModeTheme.textTheme.bodySmall),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0xFFE9E9E9),
                      ),
                      onPressed: () => func(context),
                      child: Text(
                        '떠나기',
                        style: lightModeTheme.textTheme.bodyMedium,
                      )),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: lightModeTheme.primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '머무르기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: -0.02,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
