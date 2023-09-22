import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class YourScreen extends StatefulWidget {
  @override
  _YourScreenState createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  List<Map<String, dynamic>> documentList = [];
  bool isTextVisible = false; // ウィジェットの表示/非表示を管理

  void toggleVisibility() {
    setState(() {
      isTextVisible = !isTextVisible; // ボタンを押すたびに表示/非表示を切り替え
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDocumentData(); // 初期データの取得
  }

  Future<void> fetchDocumentData() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('user_post')
          .orderBy('time', descending: true) // 'time' フィールドで降順ソート（新しい順）
          .get();
      List<Map<String, dynamic>> dataList = [];

      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          dataList.add(data);
        }
      });

      setState(() {
        documentList = dataList;
      });
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }

  Future<void> _refreshData() async {
    await fetchDocumentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ドキュメントのリストを表示
              Column(
                children: documentList.map<Widget>((documentData) {
                  return Container(
                    margin: EdgeInsets.all(5), // 枠の余白を追加
                    padding: EdgeInsets.all(5), // 内容の余白を追加

                    decoration: BoxDecoration(
                      // 枠のスタイルを設定
                      border: Border.all(
                        // 黒い枠線を追加
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(
                        // 角を丸くする
                        Radius.circular(20),
                      ),
                    ),

                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    'lib/src/img/rika.jpg',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: documentData['name'] != null
                                            ? ' ${documentData['name']}'
                                            : '名無しさん',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          //fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Center(
                          child: Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'title\n',
                                      style: GoogleFonts.happyMonkey(
                                        textStyle: const TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          //fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${documentData['title']}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (documentData['imgURL'] is List)
                          Column(
                            children:
                                documentData['imgURL'].map<Widget>((imageUrl) {
                              return Image.network(
                                imageUrl,
                              );
                            }).toList(),
                          )
                        else if (documentData['imgURL'] is String)
                          Image.network(
                            documentData['imgURL'],
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'comment\n',
                                style: GoogleFonts.happyMonkey(
                                  textStyle: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: ' ${documentData['author']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // const Divider(
                        //   height: 10,
                        //   thickness: 0,
                        //   indent: 70,
                        //   endIndent: 70,
                        //   color: Colors.black,
                        // ),

                        // RichText(
                        //   textAlign: TextAlign.center,
                        //   text: TextSpan(
                        //     children: [
                        //       TextSpan(
                        //         text: '食材\n',
                        //         style: GoogleFonts.happyMonkey(
                        //           textStyle: const TextStyle(
                        //             fontSize: 25,
                        //             color: Colors.black,
                        //           ),
                        //         ),
                        //       ),
                        //       TextSpan(
                        //         children: [
                        //           for (var item in documentData['具材'])
                        //             TextSpan(
                        //               text: '$item\n',
                        //               style: const TextStyle(
                        //                 fontSize: 20,
                        //                 color: Colors.black,
                        //                 //fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const Divider(
                        //   height: 10,
                        //   thickness: 0,
                        //   indent: 70,
                        //   endIndent: 70,
                        //   color: Colors.black,
                        // ),

                        // RichText(
                        //   textAlign: TextAlign.center,
                        //   text: TextSpan(
                        //     children: [
                        //       TextSpan(
                        //         text: '作り方手順\n',
                        //         style: GoogleFonts.happyMonkey(
                        //           textStyle: const TextStyle(
                        //             fontSize: 25,
                        //             color: Colors.black,
                        //           ),
                        //         ),
                        //       ),
                        //       TextSpan(
                        //         children: [
                        //           for (var item in documentData['手順'])
                        //             TextSpan(
                        //               text: '$item\n',
                        //               style: const TextStyle(
                        //                 fontSize: 20,
                        //                 color: Colors.black,
                        //                 //fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
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
