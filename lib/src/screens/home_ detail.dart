import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:carousel_slider/carousel_slider.dart'; // carousel_slider パッケージをインポート
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../user_page/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final uid = auth.currentUser?.uid.toString();

class CommentWidget extends StatelessWidget {
  //コメントボタン内のtext表示部分

  final String commentText;

  CommentWidget(this.commentText);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            commentText,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class icon extends StatelessWidget {
  //ユーザごとのプロフィール画像wiget

  const icon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ClipOval(
              //child: Image.network(src),
              ),
        ],
      ),
    );
  }
}
