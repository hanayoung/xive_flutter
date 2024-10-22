import 'package:flutter/material.dart';

void show(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (_) {
      return LayoutBuilder(builder: (context, constraints) {
        double dialogHeight = constraints.maxHeight * 0.7;
        return Container(
          height: dialogHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  '스캔 준비 완료',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: -0.02,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Image.asset(
                  'assets/images/dialog_nfc_anim.gif',
                  height: 160,
                  width: 160,
                ),
                const Text(
                  '기기 뒷면을 XIVE NFC에 태그',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: -0.02,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: const Color(0xFFDFDFDF),
                          ),
                          onPressed: () {},
                          child: const Text(
                            '취소하기',
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: -0.02,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}
