import 'dart:io';

import 'push_class.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:line_icons/line_icons.dart';

import 'package:test3/src/push/confirmation.dart';

import 'confirmation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  List<File> images = []; // 選択された複数の画像を格納するリスト

  final picker = ImagePicker();

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
                        "選べる画像は5枚まで",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 25),
                      ),
                    ),

              const SizedBox(height: 25),

              FilledButton.tonal(
                child: const Text(
                  '画像を追加',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  getImageFromGallery();
                },
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),

              const SizedBox(height: 20),

              // 選択された画像を表示

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: images.map((image) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 350,
                        width: 350,
                        child: Image.file(image, fit: BoxFit.cover),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 40),

              if (images.isNotEmpty) // 画像が選択されている場合にのみ表示

                //AddDocumentScreen(),

                //RecipeForm(), //クラスを別ファイルから呼び出してる

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
