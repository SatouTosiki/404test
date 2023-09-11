import 'dart:io';
import '../main2.dart';
import '../screens/home.dart';
import 'push_class.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'push.dart';
import 'package:line_icons/line_icons.dart';
import 'package:test3/src/push/confirmation.dart';
import 'confirmation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'push_class.dart';

class AddBookPage extends StatelessWidget {
  //List<File> images = [];
  final picker = ImagePicker();

  AddBookModel model = AddBookModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
        create: (_) => AddBookModel(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Consumer<AddBookModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: SizedBox(
                            width: 300,
                            height: 420,
                            child: SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal, // 画像が水平方向にスクロールできるようにします
                              child: Row(
                                children: model.imageFiles.isNotEmpty
                                    ? model.imageFiles.map((imageFile) {
                                        return Image.file(imageFile);
                                      }).toList()
                                    : [
                                        Image.asset(
                                          "lib/src/img/aaa.png",
                                        ),
                                      ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            print("反応！");

                            await model.pickImage();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          " ${model.imageFiles.length} 枚選択中。",
                          style: const TextStyle(fontSize: 16),
                        ), // length の値を表示する Text ウィジェット

                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'タイトル',
                          ),
                          onChanged: (text) {
                            model.title = text;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: '説明文',
                          ),
                          onChanged: (text) {
                            model.author = text;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // 追加の処理
                            try {
                              // timestampを現在の日時に設定
                              final DateTime now = DateTime.now();
                              model.timestamp =
                                  now.toString(); // タイムスタンプを文字列として設定
                              model.startLoading();
                              await model.addBook();

                              //投稿が成功したら、ホーム画面に遷移
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => MyHomePage(),
                                ),
                              );
                            } catch (e) {
                              print(e);
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            } finally {
                              model.endLoading();
                            }
                          },
                          child: Text('投稿'),
                        ),
                      ],
                    ),
                  ),
                  if (model.isLoading)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            }),
          ),
        ));
  }
}
