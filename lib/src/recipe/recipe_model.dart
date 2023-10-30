import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test3/src/push/push_class.dart';
import 'package:test3/src/register/register_model.dart';

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

// FirebaseFirestore firestore = FirebaseFirestore.instance;
// CollectionReference commentsCollection = firestore
//     .collection('user_post')
//     .doc('uA0yUEyvscYL3olSWyvl')
//     .collection('comment');

// class CommentInputWidget extends StatefulWidget {
//   @override
//   CommentInputWidgetState createState() => CommentInputWidgetState();
// }

// class CommentInputWidgetState extends State<CommentInputWidget> {
//   TextEditingController CommentText = TextEditingController();

//   // Future come() async {
//   //   final Cdoc = FirebaseFirestore.instance
//   //       .collection('user_post')
//   //       .doc('uA0yUEyvscYL3olSWyvl')
//   //       .collection("commetn");

//   //   // await Cdoc.set({
//   //   //   'commet':CommentText,
//   //   // });
//   // }

//   // Future<void> getAllComments() async {
//   //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//   //       .collection('user_post')
//   //       .doc('uA0yUEyvscYL3olSWyvl')
//   //       .collection('comment')
//   //       .get();
//   //   List<Map<String, dynamic>> commentList = [];

//   //   for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//   //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//   //     // data を使って何か処理
//   //   }
//   // }

//   // Future<void> commentpush() async {
//   //   final comment = CommentText.text;
//   //   final co = "uA0yUEyvscYL3olSWyvl";
//   //   if (comment.isNotEmpty) {
//   //     final Cdoc = FirebaseFirestore.instance
//   //         .collection('user_post')
//   //         .doc(co)
//   //         .collection('comment');

//   //     // コメントをFirestoreに追加
//   //     await Cdoc.add({
//   //       'comment': comment,
//   //       'timestamp': FieldValue.serverTimestamp(),
//   //     });

//   //     // コメントを追加したらテキストフィールドをクリア
//   //     CommentText.clear();
//   //   } else {
//   //     // コメントが空の場合のエラーハンドリング
//   //     print('コメントが入力されていません');
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       child: Row(children: [
//         Expanded(
//           child: TextField(
//             controller: CommentText, // コントローラーを設定
//             decoration: InputDecoration(
//               hintText: 'コメントを入力してください',
//             ),
//           ),
//         ),
//         Column(
//           children: [
//             TextButton(
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(100)),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 30),
//               ),
//               onPressed: () {
//                 //commentpush();
//                 print("確認");
//                 //commentpush();
//               },
//               child: const Text(
//                 '投稿',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ]),
//     );
//   }
// }

// class CommentListWidget extends StatefulWidget {
//   @override
//   _CommentListWidgetState createState() => _CommentListWidgetState();
// }

// class _CommentListWidgetState extends State<CommentListWidget> {
//   List<Map<String, dynamic>> comments = [];

//   @override
//   void initState() {
//     super.initState();
//     getAllComments();
//   }

//   Future<void> getAllComments() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('user_post')
//         .doc('uA0yUEyvscYL3olSWyvl')
//         .collection('comment')
//         .get();

//     List<Map<String, dynamic>> commentList = [];

//     for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       commentList.add(data);
//     }

//     setState(() {
//       comments = commentList;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: comments.length,
//       itemBuilder: (context, index) {
//         Map<String, dynamic> commentData = comments[index];
//         return ListTile(
//           title: Text(commentData['comment']),

//           // 他のコメントデータを表示するウィジェットを追加できます
//         );
//       },
//     );
//   }
// }
