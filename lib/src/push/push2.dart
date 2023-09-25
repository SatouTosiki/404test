import 'dart:ffi';
import '../main2.dart';
import 'push_class.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class AddBookPage extends StatelessWidget {
  final picker = ImagePicker();
  //List<Widget> textFields = []; // テキストフィールドのリスト

  AddBookModel model = AddBookModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
        create: (_) => AddBookModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "push",
              style: GoogleFonts.happyMonkey(
                  textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              )),
            ),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Consumer<AddBookModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        FilledButton.tonal(
                          onPressed: () {
                            model.pickImage();
                          },
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                          ),
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                image: AssetImage(
                                  'lib/src/img/aaa.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

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

                        Text(
                          " ${model.imageFiles.length} 枚選択中",
                          style: const TextStyle(fontSize: 16),
                        ), // length の値を表示する Text ウィジェット

                        GestureDetector(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: model.imageFiles.isNotEmpty
                                  ? model.imageFiles.map((imageFile) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.file(
                                          imageFile,
                                          width: 150, // 画像の幅を調整してください
                                          height: 150, // 画像の高さを調整してください
                                          fit: BoxFit.cover, // 画像の表示方法を調整してください
                                        ),
                                      );
                                    }).toList()
                                  : [],
                            ),
                          ),
                          onTap: () async {
                            await model.pickImage();
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'タイトル',
                          ),
                          onChanged: (text) {
                            model.title = text;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'コメント',
                          ),
                          onChanged: (text) {
                            model.author = text;
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        textbotton(),

                        const SizedBox(height: 30),

                        reee(),

                        const SizedBox(
                          height: 20,
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
