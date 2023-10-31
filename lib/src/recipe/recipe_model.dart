import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test3/src/push/push_class.dart';
import 'package:test3/src/register/register_model.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

class Commentstyle extends StatelessWidget {
  //コメントボタン内のtext表示部分
  final String commentText;
  Commentstyle(this.commentText);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            commentText,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
