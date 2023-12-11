import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test3/src/user_page/user_page_model.dart';
import '../push/push_class.dart';
import '../recipe/recipe_page.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
User? currentUser = auth.currentUser;
late SharedPreferences prefs;

//late SharedPreferences prefs;

class userpage extends StatefulWidget {
  final String name;
  final String user_image;
  final String time;
  final String user_id;
  userpage({
    required this.name,
    required this.user_image,
    required this.time,
    required this.user_id,
  });

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<userpage> {
  List<Map<String, dynamic>> documentList = [];
  List<Map<String, dynamic>> dataList = [];
  bool isTextVisible = false;
  int imagecount = 0;
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, bool> isLikedMap = {};

  @override
  void initState() {
    userDocumentData();
    super.initState();
    _initialize();

    void userss = user?.displayName;
  }

  Future<List<Map<String, dynamic>>> userDocumentData() async {
    try {
      QuerySnapshot userPostsQuery = await firestore
          .collection('users')
          .doc(widget.user_id)
          .collection('pushs')
          .get();

      List<String> userPostIds =
          userPostsQuery.docs.map((doc) => doc.id).toList();

      List<Map<String, dynamic>> dataList = [];

      for (String documentId in userPostIds) {
        DocumentSnapshot postDocument =
            await firestore.collection('user_post').doc(documentId).get();

        if (postDocument.exists) {
          Map<String, dynamic> data =
              postDocument.data() as Map<String, dynamic>;
          data['documentId'] = documentId;

          // 他の処理...

          dataList.add(data);
        }
      }

      setState(() {
        documentList = dataList;
      });

      // 他の処理...

      return dataList;
    } catch (e) {
      print('エラー: $e');
      return []; // エラー時は空のリストなどを返す
    }
  }

  void _initialize() async {
    try {
      initSharedPreferences();
      userDocumentData();
    } catch (e) {
      print('エラーが発生しました: $e');
      // エラーの対処を行うか、適切なエラーメッセージを表示します。
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

        print('ありました。ユーザー名: ${data['name']} ;userIDは:$userId');
      } else {
        print('なし');
      }
    } catch (e) {
      print('エラー: $e');
    }
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

  // SharedPreferences を初期化するメソッド
  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
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
    await userDocumentData();
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
        color: Colors.grey,
        child: Image.network(
          path,
          fit: BoxFit.cover,
        ),
      );

  @override
  Widget build(BuildContext context) {
    bool isNotCurrentUser = currentUser?.uid != widget.user_id;
    bool isFollowing = false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LineIcons.arrowLeft),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              widget.name,
              style: GoogleFonts.happyMonkey(
                textStyle: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(widget.user_image),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FutureBuilder<int>(
                            future: followers(widget.user_id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('エラー: ${snapshot.error}');
                              } else {
                                return RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'フォロワー\n',
                                        style: GoogleFonts.happyMonkey(
                                          textStyle: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ${snapshot.data}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FutureBuilder<int>(
                            future: following(widget.user_id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('エラー: ${snapshot.error}');
                              } else {
                                return RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'フォロー中\n',
                                        style: GoogleFonts.happyMonkey(
                                          textStyle: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ${snapshot.data}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isNotCurrentUser)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      child: ElevatedButton(
                        child: FutureBuilder<bool>(
                          future: checkIfFollowing(widget.user_id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('読み込み中...');
                            } else if (snapshot.hasError) {
                              return Text('エラー: ${snapshot.error}');
                            } else {
                              isFollowing = snapshot.data ?? false;
                              return Text(
                                isFollowing ? 'フォローを解除' : 'フォロー',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
                        ),
                        onPressed: () async {
                          if (isFollowing) {
                            await unfollowUser(widget.user_id);
                          } else {
                            await followUser(widget.user_id);
                          }

                          // ボタンが押された後に画面全体をリロード
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => userpage(
                                    name: widget.name,
                                    user_image: widget.user_image,
                                    time: widget.time,
                                    user_id: widget.user_id)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: userDocumentData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('エラー: ${snapshot.error}');
                  } else {
                    List<Map<String, dynamic>> documentList =
                        snapshot.data ?? [];

                    // 以下に他のウィジェットのレンダリングを記述

                    return Column(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        child: Row(
                                          children: [
                                            if (documentData['user_image']
                                                is List)
                                              Column(
                                                children:
                                                    documentData['user_image']
                                                        .map<Widget>(
                                                            (imageUrl) {
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
                                                    text: documentData[
                                                                "name"] !=
                                                            null
                                                        ? ' ${documentData["name"]}'
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              return Text(
                                                  'エラー: ${snapshot.error}');
                                            } else {
                                              int heartCount =
                                                  snapshot.data ?? 0;
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
                                                      color: isLikedMap[
                                                                  documentData[
                                                                      'documentId']] ??
                                                              false
                                                          ? Colors.red
                                                          : Colors.black,
                                                    ),
                                                    onPressed: () async {
                                                      final User? user =
                                                          FirebaseAuth.instance
                                                              .currentUser;
                                                      if (user != null) {
                                                        final String userId =
                                                            user.uid;

                                                        // user_postのハートに対するサブコレクションへの参照を作成
                                                        final heartRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "user_post")
                                                                .doc(documentData[
                                                                    'documentId'])
                                                                .collection(
                                                                    "heart")
                                                                .doc(myuid);

                                                        // user_postのハートに対するサブコレクションへの参照を作成
                                                        final userPostRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "user_post")
                                                                .doc(documentData[
                                                                    'documentId']);

                                                        // currentUserのコレクションに新しいコレクション "liked_posts" を作成
                                                        final userLikedPostsRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "users")
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
                                                            await heartRef
                                                                .delete();
                                                            await userLikedPostsRef
                                                                .doc(documentData[
                                                                    'documentId'])
                                                                .delete();
                                                          } else {
                                                            // いいねをつける場合
                                                            await heartRef.set({
                                                              'ID': myuid,
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
                                                          print(
                                                              'ハートの数: $heartCount');
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
                                    future: fetchCommentCount(
                                        documentData['documentId']),
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
                                        imgURL: List<String>.from(
                                            documentData["imgURL"]),
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
                                  color: Color.fromARGB(255, 67, 16, 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
