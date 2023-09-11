import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<List<String>> fetchImageURLs() async {
  try {
    DocumentReference docRef =
        firestore.collection('user_post').doc('5IWsRoa6F7kLajjIraHw');
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // ドキュメントが存在する場合、リスト形式のimgURLsフィールドを取得して返します
      List<String> imageURLs = List<String>.from(docSnapshot.get('imgURLs'));
      return imageURLs;
    } else {
      return []; // ドキュメントが存在しない場合は空のリストを返します
    }
  } catch (e) {
    print('Error fetching image URLs: $e');
    return []; // エラー時にも空のリストを返します
  }
}

class YourScreen extends StatefulWidget {
  @override
  _YourScreenState createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  List<String> imageUrls = []; // 画像のURLを格納するリスト

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                List<String> urls = await fetchImageURLs();
                setState(() {
                  imageUrls = urls; // 画像のURLリストを更新
                });
              },
              child: Text('Fetch Image URLs'),
            ),
            SizedBox(height: 20),
            Text('Title: ${documentData['author']}'), // ドキュメントのフィールドを表示
            Text('Title: ${documentData['author']}'), // ドキュメントのフィールドを表示
            if (documentData['imgURL'] != null)
              Image.network(documentData['imgURL']), // imgURLがnullでない場合にのみ画像を表示
          ],
        ),
      ),
    );
  }
}
