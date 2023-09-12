import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class YourScreen extends StatefulWidget {
  @override
  _YourScreenState createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  List<Map<String, dynamic>> documentList = [];

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
              SizedBox(height: 20),

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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'title\n',
                                style: GoogleFonts.happyMonkey(
                                  textStyle: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: ' ${documentData['title']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 10,
                          thickness: 1,
                          indent: 10,
                          endIndent: 0,
                          color: Colors.black,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'comment\n',
                                style: GoogleFonts.happyMonkey(
                                  textStyle: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: ' ${documentData['author']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
