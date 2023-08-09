import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

//カラーコード指定のためのclass
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

//colorクラス
class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  List<File> images = []; // 選択された複数の画像を格納するリスト
  final picker = ImagePicker();

  // カメラで撮影した画像を取得する命令
  // Future getImageFromCamera() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     if (pickedFile != null) {
  //       images.add(File(pickedFile.path)); // images リストに画像を追加
  //     }
  //   });
  // }

  // 端末のアルバムに保存されている画像を取得する命令
  Future getImageFromGallery() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage(); // 複数の画像を選択
    setState(() {
      if (pickedFiles != null) {
        for (var pickedFile in pickedFiles) {
          if (images.length < 5) {
            // リストにまだ5枚未満の画像がある場合に追加
            images.add(File(pickedFile.path)); // images リストに画像を追加
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F0FFFF'), // HexColorで指定,

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  // getImageFromCamera();
                },
                child: const Text('写真を撮る'),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  getImageFromGallery();
                },
                child: const Text('アルバムから選ぶ'),
              ),
              const SizedBox(height: 20),
              // 選択された画像を表示
              Column(
                children: images.map((image) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 400,
                      width: 400,
                      child: Image.file(image, fit: BoxFit.cover),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
