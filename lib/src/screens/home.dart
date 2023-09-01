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
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('images').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            var imageDocuments = snapshot.data!.docs;
            var imageUrl =
                "https://firebasestorage.googleapis.com/v0/b/pr-9faf1.appspot.com/o/97f78c53ef6a6cb29420edb4edb77538.jpg?alt=media&token=ab270d99-9d2e-4079-9596-663f820d80f1";

            if (imageDocuments.isNotEmpty) {
              imageUrl = imageDocuments[0]['imageUrl'];
            }

            return imageUrl.isNotEmpty
                ? Image.network(imageUrl)
                : Text('画像のURLがありません');
          },
        ),
      ),
    );
  }
}
