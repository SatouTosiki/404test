import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: '検索キーワードを入力してください',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                performSearch();
              },
              child: Text('検索'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final documentData = searchResults[index];

                  return buildPostUI(documentData);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> performSearch() async {
    final keyword = searchController.text.toLowerCase();

    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('user_post').get();

      List<Map<String, dynamic>> results = [];

      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // 検索キーワードと一致するものを検索

          if (data['author'].toString().toLowerCase().contains(keyword) ||
              data['imgURL'].toString().toLowerCase().contains(keyword) ||
              data['name'].toString().toLowerCase().contains(keyword) ||
              data['time'].toString().toLowerCase().contains(keyword) ||
              data['title'].toString().toLowerCase().contains(keyword) ||
              data['具材'].toString().toLowerCase().contains(keyword) ||
              data['手順'].toString().toLowerCase().contains(keyword)) {
            results.add(data);
          }
        }
      });

      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print('Error searching documents: $e');
    }
  }

  Widget buildPostUI(Map<String, dynamic> documentData) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 作者名を表示

          Text(
            '作者: ${documentData['author']}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // 画像を表示

          if (documentData['imgURL'] is List)
            Column(
              children: documentData['imgURL'].map<Widget>((imageUrl) {
                return Image.network(
                  imageUrl,
                );
              }).toList(),
            )
          else if (documentData['imgURL'] is String)
            Image.network(
              documentData['imgURL'],
            ),

          // タイトルを表示

          Text(
            'タイトル: ${documentData['title']}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // 具材を表示

          Text(
            '具材: ${documentData['具材']}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // 手順を表示

          Text(
            '手順: ${documentData['手順']}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
