import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  List<File> images = [];

  // 画像をギャラリーから複数選ぶ関数
  Future pickImages() async {
    try {
      final pickedImages = await ImagePicker().pickMultiImage(
          // ソースをギャラリーに指定

          );

      if (pickedImages == null) return;

      // 選択された画像の数をチェック
      if (images.length + pickedImages.length > 5) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('注意'),
            content: Text('選択できる画像は5枚までです。'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        return;
      }

      // 選択された画像のパスをFileオブジェクトに変換し、リストに追加
      List<File> selectedImages = [];
      for (final pickedImage in pickedImages) {
        final image = File(pickedImage.path);
        selectedImages.add(image);
      }

      setState(() => images.addAll(selectedImages));
    } on PlatformException catch (e) {
      print('Failed to pick images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              MaterialButton(
                color: Colors.blue,
                child: const Text(
                  "画像を選択",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  pickImages();
                },
              ),
              const SizedBox(height: 20),
              Column(
                children: images.map((image) => Image.file(image)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
