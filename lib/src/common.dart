import 'package:flutter/material.dart';

Future<void> loading({
  required BuildContext context,
}) async {
  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 250),
      barrierColor: Colors.black.withOpacity(0.5), // 画面マスクの透明度
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      });
}

Future<void> showLoadingDialog({required BuildContext context}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add the image widget for the loading animation
            Image.asset(
              'lib/src/img/卵なしチャーハン.gif',
              width: 100, // adjust the width as needed
              height: 100, // adjust the height as needed
            ),
            SizedBox(height: 16),
            Text('読み込み中...'),
          ],
        ),
      );
    },
  );
}
