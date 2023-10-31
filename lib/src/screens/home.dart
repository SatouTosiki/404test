import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:carousel_slider/carousel_slider.dart'; // carousel_slider パッケージをインポート
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/model.dart';
import '../recipe/recipe_page.dart';
import '../user_page/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_ detail.dart';

// final CollectionReference users =
//     FirebaseFirestore.instance.collection('user_post');
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final uid = auth.currentUser?.uid.toString();

class YourScreen extends StatefulWidget {
  @override
  YourScreenState createState() => YourScreenState(user: null);
}

class YourScreenState extends State<YourScreen> {
  bool isLiked = false;
  int likeCount = 0;
  int imagecount = 0; // ここで初期化
  List<Map<String, dynamic>> documentList = [];
  bool isTextVisible = false;
  final User? user;

  YourScreenState({required this.user});

  void toggleVisibility() {
    setState(() {
      isTextVisible = !isTextVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDocumentData();
  }

  Future<void> fetchDocumentData() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('user_post')
          .orderBy('time', descending: true)
          .get();
      List<Map<String, dynamic>> dataList = [];

      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['documentId'] = doc.id; // ドキュメントIDをデータに追加
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

  Widget abuildImageWidget(dynamic documentData) {
    if (documentData['imgURL'] != null) {
      if (documentData['imgURL'] is List) {
        List<String> imageUrls = List<String>.from(documentData['imgURL']);
        if (imageUrls.isNotEmpty) {
          return Column(
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 300,
                  initialPage: 0,
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      imagecount = index;
                    });
                  },
                  enableInfiniteScroll: false, // 無限スクロールを無効にする
                ),
                itemBuilder: (context, index, realIndex) {
                  final path = imageUrls[index];
                  return buildImage(path, index);
                },
                itemCount: imageUrls.length,
              ),
              const SizedBox(
                height: 20,
              ),
              AnimatedSmoothIndicator(
                activeIndex: imagecount,
                count: imageUrls.length,
                effect: const JumpingDotEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ],
          );
        }
      } else if (documentData['imgURL'] is String) {
        // 単一の画像を表示
        return Image.network(documentData['imgURL']);
      }
    }

    // 画像がない場合の処理
    return Container(
      child: Text("画像がありません"),
    );
  }

  Widget buildImage(path, index) => Container(
        //画像間の隙間
        margin: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.grey,
        child: Image.network(
          path,
          fit: BoxFit.cover,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
        ),
        title: Text(
          "chefGourmet",
          style: GoogleFonts.happyMonkey(
            textStyle: const TextStyle(
              fontSize: 35,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Column(
                children: documentList.map<Widget>((documentData) {
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
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => userpage(
                                          name: documentData['name'],
                                          user_image:
                                              documentData["user_image"],
                                          time: documentData["time"],
                                          user_id: documentData["user_id"],
                                          //user: null,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      if (documentData['user_image'] is List)
                                        Column(
                                          children: documentData['user_image']
                                              .map<Widget>((imageUrl) {
                                            return ClipOval(
                                              child: Image.network(
                                                imageUrl,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }).toList(),
                                        )
                                      else if (documentData['user_image']
                                          is String)
                                        ClipOval(
                                          child: Image.network(
                                            documentData['user_image'],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      const SizedBox(
                                        width: 10,
                                      ),
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
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    LineIcons.download,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    UserService();
                                    //print('IconButton tapped');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "  ${documentData['title']}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        abuildImageWidget(documentData), //userの投稿画像を表示

                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                  icon: Icon(
                                    isLiked
                                        ? LineIcons.heartAlt
                                        : LineIcons.heart,
                                    size: 30,
                                    color: isLiked ? Colors.pink : Colors.black,
                                  ),
                                  onPressed: () {
                                    // LikeButton();
                                    //isLiked;
                                  }),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(
                                  LineIcons.comment,
                                  size: 30,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        children: [
                                          Expanded(
                                            child: ListView(
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '閉じる',
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Center(
                                                  child: const Text(
                                                    "コメント",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                                Container(
                                                  height: 0.5,
                                                  width: 1000,
                                                  color: Colors.grey,
                                                ),
                                                //CommentWidget(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'comment\n',
                                style: GoogleFonts.happyMonkey(
                                  textStyle: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: ' ${documentData['comment']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipePage(
                                  title: documentData["title"],
                                  name: documentData["name"],
                                  comment: documentData["comment"],
                                  imgURL:
                                      List<String>.from(documentData["imgURL"]),
                                  Ingredients: List<String>.from(
                                      documentData["Ingredients"]),
                                  procedure: List<String>.from(
                                      documentData["procedure"]),
                                  user_image: documentData["user_image"],
                                  documentId: documentData["documentId"],
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'レシピを見る',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Text(
                          '投稿 ID: ${documentData['documentId']}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        )
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
