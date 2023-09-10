import 'package:flutter/material.dart';
import 'package:test3/src/main2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<Map<String, dynamic>> fetchDocumentData() async {
  try {
    DocumentReference docRef =
        firestore.collection('user_post').doc('3ztr19CobXNhZ5Epj74P');
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // ドキュメントが存在する場合、データを取得して返します
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return data;
    } else {
      return {}; // ドキュメントが存在しない場合は空のMapを返します
    }
  } catch (e) {
    print('Error fetching document: $e');
    return {}; // エラー時にも空のMapを返します
  }
}

class YourScreen extends StatefulWidget {
  @override
  _YourScreenState createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  Map<String, dynamic> documentData = {}; // 取得したデータを格納する変数

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Document Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> data = await fetchDocumentData();
                setState(() {
                  documentData = data; // 取得したデータを更新
                });
              },
              child: Text('Fetch Document Data'),
            ),
            SizedBox(height: 20),
            Text('Title: ${documentData['author']}'), // ドキュメントのフィールドを表示
            Text('Description: ${documentData['imgURL']}'),
          ],
        ),
      ),
    );
  }
}
