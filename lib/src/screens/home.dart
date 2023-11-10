import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:carousel_slider/carousel_slider.dart'; // carousel_slider パッケージをインポート
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/model.dart';
import '../recipe/recipe_model.dart';
import '../recipe/recipe_page.dart';
import '../user_page/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_ detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final uid = auth.currentUser?.uid;
User? user = FirebaseAuth.instance.currentUser;

class YourScreen extends StatefulWidget {
  @override
  YourScreenState createState() => YourScreenState(user: null);
}

class YourScreenState extends State<YourScreen> {
  bool isLiked = false;
  int imagecount = 0;
  List<Map<String, dynamic>> documentList = [];
  bool isTextVisible = false;
  final User? user;
  Map<String, bool> isLikedMap = {};

  YourScreenState({required this.user});

  // SharedPreferences インスタンスを作成
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    try {
      initSharedPreferences();
      fetchDocumentData();
    } catch (e) {
      print('エラーが発生しました: $e');
      // エラーの対処を行うか、適切なエラーメッセージを表示します。
    }
  }

  // SharedPreferences を初期化するメソッド
  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void toggleVisibility() {
    setState(() {
      isTextVisible = !isTextVisible;
    });
  }

  Future<int> fetchHeartCount(String documentId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user_post')
          .doc(documentId)
          .collection('heart')
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('ハートの数を取得できませんでした: $e');
      return 0;
    }
  }

  // SharedPreferences を使ってハートの状態を読み込むメソッド
  void loadLikedStates() {
    documentList.forEach((documentData) {
      bool isLiked =
          prefs.getBool(documentData['documentId'].toString()) ?? false;
      setState(() {
        isLikedMap[documentData['documentId']] = isLiked;
      });
    });
  }

  // SharedPreferences を使ってハートの状態を保存するメソッド
  void saveLikedState(String documentId, bool isLiked) {
    prefs.setBool(documentId, isLiked);
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
          data['documentId'] = doc.id;
          dataList.add(data);
        }
      });

      setState(() {
        documentList = dataList;
      });

      print('ドキュメント数: ${documentList.length}');

      // ハートの状態を読み込む
      loadLikedStates();
    } catch (e) {
      print('エラー画面表示できないなのです☆: $e');
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
                  enableInfiniteScroll: false,
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
        return Image.network(documentData['imgURL']);
      }
    }

    return Container(
      child: Text("画像がありません"),
    );
  }

  Widget buildImage(String path, int index) => Container(
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
              const SizedBox(height: 0),
              Column(
                children: documentList.map<Widget>((documentData) {
                  isLikedMap.putIfAbsent(
                      documentData['documentId'], () => false);
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
                                                fontSize: 17,
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
                                    // Add your download logic here
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
                                    fontSize: 17,
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
                        abuildImageWidget(documentData),
                        Row(
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: FutureBuilder<int>(
                                    future: fetchHeartCount(
                                        documentData['documentId']),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('エラー: ${snapshot.error}');
                                      } else {
                                        int heartCount = snapshot.data ?? 0;
                                        return Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                isLikedMap[documentData[
                                                            'documentId']] ??
                                                        false
                                                    ? LineIcons.heartAlt
                                                    : LineIcons.heart,
                                                size: 30,
                                                color: isLikedMap[documentData[
                                                            'documentId']] ??
                                                        false
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                              onPressed: () async {
                                                final User? user = FirebaseAuth
                                                    .instance.currentUser;
                                                if (user != null) {
                                                  final String userId =
                                                      user.uid;
                                                  final udo = FirebaseFirestore
                                                      .instance
                                                      .collection("user_post")
                                                      .doc(documentData[
                                                          'documentId'])
                                                      .collection("heart")
                                                      .doc(uid);

                                                  await udo.set({
                                                    'ID': userId,
                                                  });
                                                }

                                                if (isLikedMap[documentData[
                                                        'documentId']] ??
                                                    false) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('user_post')
                                                      .doc(documentData[
                                                          'documentId'])
                                                      .collection('heart')
                                                      .doc(uid)
                                                      .delete();
                                                } else {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('user_post')
                                                      .doc(documentData[
                                                          'documentId'])
                                                      .collection('heart')
                                                      .doc(uid)
                                                      .set({
                                                    'ID': uid,
                                                  });
                                                }

                                                QuerySnapshot querySnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('user_post')
                                                        .doc(documentData[
                                                            'documentId'])
                                                        .collection('heart')
                                                        .get();

                                                List<String> heartDocumentIDs =
                                                    [];

                                                querySnapshot.docs
                                                    .forEach((doc) {
                                                  heartDocumentIDs.add(doc.id);
                                                });

                                                int numHeartDocuments =
                                                    heartDocumentIDs.length;

                                                print(
                                                    'ハートの数: $numHeartDocuments');

                                                // 特定の投稿のisLikedの状態だけを変更
                                                setState(() {
                                                  isLikedMap[documentData[
                                                          'documentId']] =
                                                      !(isLikedMap[documentData[
                                                              'documentId']] ??
                                                          false);
                                                });

                                                // ハートの状態を保存
                                                saveLikedState(
                                                    documentData['documentId'],
                                                    isLikedMap[documentData[
                                                            'documentId']] ??
                                                        false);
                                              },
                                            ),
                                            Text(
                                              '$heartCount',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
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
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: ' ${documentData['comment']}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '投稿 ID: ${documentData['documentId']}',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
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
