import 'dart:io';

import 'push_class.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

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

  // Future getImageFromGallery() async {
  //   final List<XFile>? pickedFiles = await picker.pickMultiImage(); // 複数の画像を選択

  //   setState(() {
  //     if (pickedFiles != null) {
  //       for (var pickedFile in pickedFiles) {
  //         if (images.length < 5) {
  //           // リストにまだ5枚未満の画像がある場合に追加

  //           images.add(File(pickedFile.path)); // images リストに画像を追加
  //         }
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F0FFFF'), // HexColorで指定,

      // body: Center(
      //   child: AddTextFieldButton(), // クラスを使ってボタンとテキストフィールドを表示
      // ),
    );
  }
}
