import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:carousel_slider/carousel_slider.dart'; // carousel_slider パッケージをインポート
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../user_page/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class recipe extends StatelessWidget {
  final String title;
  final String comment;
  final String user_image;
  final String name;
  final List<String>? imgURL;
  final List<String>? Ingredients;
  final List<String>? procedure;

  recipe({
    required this.title,
    required this.imgURL,
    required this.comment,
    required this.name,
    required this.user_image,
    required this.Ingredients,
    required this.procedure,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Recipe Page',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  '$user_image',
                  width: 80,
                  height: 80,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text("$name"),
            ],
          ),
        ],
      )),
    );
  }
}
