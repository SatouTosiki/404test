import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../user_page/user_page.dart';
import 'home_ detail.dart';

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
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 10), // パディングの値を調整
        ),
        title: Text(
          "chefGourmet",
          style: GoogleFonts.happyMonkey(
            textStyle: const TextStyle(
              fontSize: 35,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween, // 要素を左右に均等に配置
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            // （2） 実際に表示するページ(ウィジェット)を指定する
                                            builder: (context) => userpage()));
                                    // クリック時の処理をここに追加
                                  },
                                  child: Row(
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
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    LineIcons.download,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    // アイコンボタンがタップされたときに実行するアクションをここに追加
                                    print('IconButton tapped');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // テキストを中央に配置するために余白を均等に配置
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "  ${documentData['title']}",
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
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
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    // （2） 実際に表示するページ(ウィジェット)を指定する
                                    builder: (context) => userpage2()));
                            // ボタンが押されたときに発動される処理
                          },
                          child: Text('詳細'),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
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
