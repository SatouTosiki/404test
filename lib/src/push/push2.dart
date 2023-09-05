import 'dart:io';
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
  List<File> images = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel(),
      child: Scaffold(
        body: Center(
          child: Consumer<AddBookModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: SizedBox(
                          width: 200,
                          height: 320,
                          child: Column(
                            children: model.imageFiles.isNotEmpty
                                ? model.imageFiles.map((imageFile) {
                                    return Image.file(imageFile);
                                  }).toList()
                                : [
                                    Image.asset(
                                      "/Users/satoutoshiki/Desktop/pr/test3/lib/src/img/aaa.png",
                                    ),
                                  ],
                          ),
                        ),
                        onTap: () async {
                          print("反応！");

                          await model.pickImage();

                          // final List<XFile>? pickedFiles = await picker.pickMultiImage();
                          //await model.pickImage();
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
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
                        decoration: InputDecoration(
                          hintText: '説明文',
                        ),
                        onChanged: (text) {
                          model.author = text;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // 追加の処理
                          try {
                            model.startLoading();
                            await model.addBook();
                            Navigator.of(context).pop(true);
                          } catch (e) {
                            print(e);
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
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
      ),
    );
  }
}
