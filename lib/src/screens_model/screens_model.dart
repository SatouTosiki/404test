import 'package:flutter/material.dart';
import 'package:test3/src/main2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('user_post').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // データが読み込まれるまでローディング表示
        }

        var posts = snapshot.data.docs;

        if (posts.isEmpty) {
          return Center(child: Text('投稿がありません'));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            var post = posts[index].data() as Map<String, dynamic>;

            // データを表示するUIをここで構築
            return Card(
              child: ListTile(
                title: Text(post['title']),
                subtitle: Text(post['description']),
                // 画像を表示するには、post['imageUrl']を使って画像をロードするコードを追加します
                // 例: Image.network(post['imageUrl']),
              ),
            );
          },
        );
      },
    );
  }
}
