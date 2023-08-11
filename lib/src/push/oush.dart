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

  //カメラで撮影した画像を取得する命令
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        images.add(File(pickedFile.path)); // images リストに画像を追加
      }
    });
  }

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
              images.isNotEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "",
                        //画像が入っているときはtextなし
                        style: TextStyle(
                            //fontStyle: FontStyle.italic,
                            fontSize: 20),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "画像は5枚まで^_^",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 25),
                      ),
                    ),
              FilledButton.tonal(
                child: Text(
                  '写真を撮る',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  getImageFromCamera();
                },
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),

              const SizedBox(height: 25),

              FilledButton.tonal(
                child: const Text(
                  'ライブラリから選ぶ',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  getImageFromGallery();
                },
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
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
              const SizedBox(height: 40),

              if (images.isNotEmpty) // 画像が選択されている場合にのみ表示

                OutlinedButton(
                  child: Text(
                    '次へ',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(200, 50), // 幅200、高さ50の大きさに設定

                    primary: Colors.black,
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Colors.orange),
                  ),
                  onPressed: () {},
                ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
