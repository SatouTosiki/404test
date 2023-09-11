import 'package:flutter/material.dart';
import 'package:test3/src/main2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user_post').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return Text('No data available');
          }
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final author = document['author'] ?? ''; // 'author' フィールドの値を取得
              final imgURL = document['imgURL'] ?? '';
              final time = document['time'];
              final title = document['title']; // 'title' フィールドの値を取得
              return ListTile(
                title: Text(author), // 'author' フィールドの値を表示
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(imgURL),
                    Text(time), // 'time' フィールドの値を表示
                    Text(title), // 'title' フィールドの値を表示
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
