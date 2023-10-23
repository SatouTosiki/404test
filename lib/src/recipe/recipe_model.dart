import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class ProcedureList extends StatelessWidget {
  //作り方手順を表示させるクラス
  final List<String>? procedures;

  ProcedureList({required this.procedures});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: procedures != null
          ? List.generate(procedures!.length, (index) {
              String procedureText = procedures![index];
              String inde = "${index + 1}";
              String numberedText = "$procedureText";
              return Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: inde,
                              style: const TextStyle(
                                fontSize: 30, // 数字のフォントサイズ
                                fontWeight: FontWeight.bold, // 数字の太さ
                                color: Colors.green, // 数字の色
                              ),
                            ),
                            TextSpan(
                              text: procedureText,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              );
            })
          : [],
    );
  }
}

class g extends StatelessWidget {
  //作り方手順を表示させるクラス
  final List<String>? Ingredients;

  g({required this.Ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: Ingredients != null
          ? List.generate(Ingredients!.length, (index) {
              String IngredientsTexts = Ingredients![index];
              String inde2 = "${index + 1}";
              String numberedText = "$IngredientsTexts";
              return Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: inde2,
                              style: const TextStyle(
                                fontSize: 30, // 数字のフォントサイズ
                                fontWeight: FontWeight.bold, // 数字の太さ
                                color: Colors.green, // 数字の色
                              ),
                            ),
                            TextSpan(
                              text: IngredientsTexts,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              );
            })
          : [],
    );
  }
}

class CommentInputWidget extends StatefulWidget {
  @override
  _CommentInputWidgetState createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
  // TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: const [
          Text(
            "コメント",
            style: TextStyle(fontSize: 20),
          ),
          TextField(
            //controller: _commentController, // コントローラーを設定
            decoration: InputDecoration(
              suffixIcon: Icon(
                LineIcons.check,
              ),
              hintText: 'コメントを入力してください',
            ),
          ),
        ],
      ),
    );
  }
}
