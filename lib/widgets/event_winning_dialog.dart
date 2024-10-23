import 'package:flutter/material.dart';

class EventWinningDialog extends StatelessWidget {
  const EventWinningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 200,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('럭키드로우 당첨되신 걸 축하드려요🥳'),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('선물 받으러 가기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
