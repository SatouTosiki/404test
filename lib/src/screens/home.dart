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
import 'package:animated_text_kit/animated_text_kit.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final uid = auth.currentUser?.uid;
User? user = FirebaseAuth.instance.currentUser;

class YourScreen extends StatefulWidget {
  @override
  YourScreenState createState() => YourScreenState(user: null);
}

class YourScreenState extends State<YourScreen> {
  String? userid_test; // 投稿データからuidを取得し格納している変数
  String? userName;

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

  Future<bool> checkIfUserLiked(String documentId) async {
    try {
      DocumentSnapshot heartDoc = await FirebaseFirestore.instance
          .collection('user_post')
          .doc(documentId)
          .collection('heart')
          .doc(uid)
          .get();

      return heartDoc.exists;
    } catch (e) {
      print('ユーザーのいいね確認時にエラーが発生しました: $e');

      return false;
    }
  }

  Future<void> fetchDocumentData() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('user_post')
          .orderBy('time', descending: true)
          .get();
      List<Map<String, dynamic>> dataList = [];

      await Future.forEach(querySnapshot.docs, (doc) async {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['documentId'] = doc.id;
          // ユーザー名を取得
          await checkUserIdInUsersCollection(data['user_id'], data);
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

  Future<void> checkUserIdInUsersCollection(
      String userId, Map<String, dynamic> data) async {
    try {
      // users コレクションの参照
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // userid に格納されている値で users コレクションからドキュメントを取得
      DocumentSnapshot userDocument = await usersCollection.doc(userId).get();

      // ドキュメントが存在するかチェック
      if (userDocument.exists) {
        // ドキュメントが存在する場合、nameフィールドの値を取得
        setState(() {
          data['userName'] = userDocument['name'];
        });

        print('ありました。ユーザー名: ${data['userName']} ;userIDは:$userId');
      } else {
        print('なし');
      }
    } catch (e) {
      print('エラー: $e');
    }
  }

  void _initialize() async {
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

  Future<void> _refreshData() async {
    await fetchDocumentData();
  }

  Future<int> fetchCommentCount(String documentId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user_post')
          .doc(documentId)
          .collection('comment') // コメントが保存されているコレクションのパスに適宜変更
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('コメント数を取得できませんでした: $e');
      return 0;
    }
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

    return Padding(
      padding: const EdgeInsets.all(60),
      child: Container(
        child: Text("画像がないのですよにぱー★"),
      ),
    );
  }

  Widget buildImage(String path, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Image.network(
          path,
          fit: BoxFit.contain, // 画像を画面内に収めるように縮小
          width: double.infinity,
          height: double.infinity,
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('投稿 ${documentList.length}件',
                            textStyle: TextStyle(fontSize: 20)),
                        TypewriterAnimatedText('投稿 ${documentList.length}件',
                            textStyle: TextStyle(fontSize: 20)),
                        TypewriterAnimatedText('にぱー⭐︎',
                            textStyle: TextStyle(fontSize: 20)),
                        TypewriterAnimatedText('投稿 ${documentList.length}件',
                            textStyle: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ],
              ),
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
                                          name: documentData["userName"] ??
                                              uid, // userName が null の場合は '名無しさん' を表示
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
                                              text: documentData["userName"] !=
                                                      null
                                                  ? ' ${documentData["userName"]}'
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
                                              icon: FutureBuilder<bool>(
                                                future: checkIfUserLiked(
                                                    documentData['documentId']),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Icon(
                                                      LineIcons.heart,
                                                      size: 30,
                                                      color: Colors.black,
                                                    );
                                                  } else {
                                                    bool isLiked =
                                                        snapshot.data ?? false;
                                                    return Icon(
                                                      isLiked
                                                          ? LineIcons.heartAlt
                                                          : LineIcons.heart,
                                                      size: 30,
                                                      color: isLiked
                                                          ? Colors.red
                                                          : Colors.black,
                                                    );
                                                  }
                                                },
                                              ),
                                              onPressed: () async {
                                                final User? user = FirebaseAuth
                                                    .instance.currentUser;
                                                if (user != null) {
                                                  final String userId =
                                                      user.uid;

                                                  // user_postのハートに対するサブコレクションへの参照を作成
                                                  final heartRef =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "user_post")
                                                          .doc(documentData[
                                                              'documentId'])
                                                          .collection("heart")
                                                          .doc(uid);

                                                  // user_postのハートに対するサブコレクションへの参照を作成
                                                  final userPostRef =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "user_post")
                                                          .doc(documentData[
                                                              'documentId']);

                                                  // currentUserのコレクションに新しいコレクション "liked_posts" を作成
                                                  final userLikedPostsRef =
                                                      FirebaseFirestore.instance
                                                          .collection("users")
                                                          .doc(userId)
                                                          .collection(
                                                              "liked_posts");

                                                  // ハートの状態を反転
                                                  bool isLiked = isLikedMap[
                                                          documentData[
                                                              'documentId']] ??
                                                      false;

                                                  try {
                                                    if (isLiked) {
                                                      // いいねを取り消す場合
                                                      await heartRef.delete();
                                                      await userLikedPostsRef
                                                          .doc(documentData[
                                                              'documentId'])
                                                          .delete();
                                                    } else {
                                                      // いいねをつける場合
                                                      await heartRef.set({
                                                        'ID': uid,
                                                      });

                                                      // currentUserのliked_postsコレクションにいいねした投稿IDを追加
                                                      await userLikedPostsRef
                                                          .doc(documentData[
                                                              'documentId'])
                                                          .set({});
                                                    }

                                                    // いいねの状態を更新
                                                    setState(() {
                                                      isLikedMap[documentData[
                                                              'documentId']] =
                                                          !isLiked;
                                                    });

                                                    // ハートの状態を保存
                                                    saveLikedState(
                                                        documentData[
                                                            'documentId'],
                                                        !isLiked);

                                                    // user_postのハート数を取得
                                                    int heartCount =
                                                        await fetchHeartCount(
                                                            documentData[
                                                                'documentId']);

                                                    // ハート数を表示
                                                    print('ハートの数: $heartCount');
                                                  } catch (e) {
                                                    print(
                                                        'いいねの処理でエラーが発生しました: $e');
                                                  }
                                                }
                                              },
                                            ),
                                            Text(
                                              '$heartCount',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
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
                            FutureBuilder<int>(
                              future:
                                  fetchCommentCount(documentData['documentId']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('エラー: ${snapshot.error}');
                                } else {
                                  int commentCount = snapshot.data ?? 0;
                                  return Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          LineIcons.comment,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          // コメントが押された時の処理を追加
                                        },
                                      ),
                                      Text(
                                        '$commentCount件',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
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
                        // user_id = documentData['user_id'], // フィールドに値を設定
                        Text(
                          '投稿 ID: ${documentData['documentId']}',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'user ID: ${documentData['user_id']}',
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
