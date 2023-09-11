import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    subscribeToUpdates(); // リアルタイム更新の購読
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

  void subscribeToUpdates() {
    firestore.collection('user_post').snapshots().listen((event) {
      fetchDocumentData(); // データが変更されたときにデータを更新
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            // ドキュメントのリストを表示
            Column(
              children: documentList.map<Widget>((documentData) {
                return Column(
                  children: [
                    Text('タイトル: ${documentData['title']}'),

                    // 画像URLリストを表示
                    if (documentData['imgURL'] is List)
                      Column(
                        children:
                            documentData['imgURL'].map<Widget>((imageUrl) {
                          return Image.network(imageUrl);
                        }).toList(),
                      )
                    else if (documentData['imgURL'] is String)
                      Image.network(documentData['imgURL']), // 単一のURLの場合
                    Text('説明: ${documentData['author']}'),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
