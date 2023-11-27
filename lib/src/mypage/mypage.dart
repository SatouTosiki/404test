import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:carousel_slider/carousel_slider.dart'; // carousel_slider パッケージをインポート
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../recipe/recipe_page.dart';
import '../screens/login_page.dart';
import '../user_page/UserDelet.dart';
import '../user_page/te.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mypage_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

User? user = FirebaseAuth.instance.currentUser;
final auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final myuid = auth.currentUser?.uid;

late SharedPreferences prefs;

class MyPage extends StatefulWidget {
  @override
  BookmarkScreenState createState() => BookmarkScreenState();
}

class BookmarkScreenState extends State<MyPage> {
  bool isLiked = false;
  int imagecount = 0;
  List<Map<String, dynamic>> documentList = [];
  bool isTextVisible = false;
  // final User? user;
  Map<String, bool> isLikedMap = {};

  //BookmarkScreenState({required this.user});

  // SharedPreferences インスタンスを作成
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initialize();
    void userss = user?.displayName;
  }

// Firebase Authenticationのキャッシュをクリアする関数
  Future<void> clearFirebaseAuthCache() async {
    try {
      await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance
          .signInAnonymously(); // ダミーで再ログインすることでキャッシュをクリア
    } catch (e) {
      print('Firebase Auth Cache Clear Error: $e');
      // エラーハンドリングが必要な場合は追加してください
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

  Future<void> fetchDocumentData() async {
    try {
      // 現在のユーザーの 'liked_posts' コレクションからいいねした投稿を取得
      QuerySnapshot likedPostsQuery = await firestore
          .collection('users')
          .doc(myuid)
          .collection('pushs')
          .get();

      List<String> likedPostIds =
          likedPostsQuery.docs.map((doc) => doc.id).toList();

      // 各いいねした投稿に対応する 'user_post' コレクションからデータを取得
      List<Map<String, dynamic>> dataList = [];

      await Future.forEach(likedPostIds, (documentId) async {
        DocumentSnapshot postDocument =
            await firestore.collection('user_post').doc(documentId).get();

        if (postDocument.exists) {
          Map<String, dynamic> data =
              postDocument.data() as Map<String, dynamic>;
          data['documentId'] = documentId;

          // 投稿のユーザー名を取得
          await checkUserIdInUsersCollection(data['user_id'], data);

          dataList.add(data);
        }
      });

      setState(() {
        documentList = dataList;
      });

      print('ドキュメント数: ${documentList.length}');

      // 各投稿のいいねの状態を読み込む
      loadLikedStates();
    } catch (e) {
      print('いいねした投稿を取得中にエラーが発生しました: $e');
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

  Future<void> deletePost(String documentId) async {
    try {
      // user_post コレクションからドキュメントを削除
      await FirebaseFirestore.instance
          .collection('user_post')
          .doc(documentId)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myuid)
          .collection('pushs')
          .doc(documentId)
          .delete();

      // Firebase Storage から対応するサブディレクトリを削除
      Reference subDirectory =
          FirebaseStorage.instance.ref().child('$myuid/$documentId');

      Reference deepestReference =
          subDirectory.child('path_to_deepest_directory');

      // サブディレクトリ内のファイルを削除
      ListResult listResult = await subDirectory.listAll();
      for (Reference fileRef in listResult.items) {
        await fileRef.delete();
      }

      // サブディレクトリを削除
      await deepestReference.delete();

      // 投稿ごとのストレージのパスを表示
      print('ドキュメントが正常に削除されました: $documentId');
      print('投稿ごとのストレージのパス: ${subDirectory.fullPath}');
    } catch (e) {
      print('ドキュメントの削除中にエラーが発生しました: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${user?.displayName ?? ''}   is room',
              style: GoogleFonts.happyMonkey(
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 79, 104, 214),
        //backgroundColor: Colors.white,
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
                        backgroundImage: NetworkImage(user?.photoURL ?? ''),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FutureBuilder<int>(
                            future: myfollowers(myuid!),
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
                            future: myfollowing(myuid!),
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
              Text(
                '過去の投稿 ${documentList.length}件',
                style: TextStyle(
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                ),
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
                                IconButton(
                                  icon: const Icon(
                                    LineIcons.trash,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                          title: Text('投稿を削除します。'),
                                          children: [
                                            SimpleDialogOption(
                                              child: Text('削除する'),
                                              onPressed: () async {
                                                // 投稿削除処理
                                                await deletePost(
                                                    documentData['documentId']);

                                                // ダイアログを閉じる
                                                Navigator.of(context).pop();

                                                // 画面を更新
                                                setState(() {
                                                  // Fetch and update the data after deleting the post
                                                  fetchDocumentData();
                                                });
                                              },
                                            ),
                                            SimpleDialogOption(
                                              child: Text(
                                                '取り消し',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                // ダイアログを閉じる
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
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

                                                  // user_postのハートに対するサブコレクションへの参照を作成
                                                  final heartRef =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "user_post")
                                                          .doc(documentData[
                                                              'documentId'])
                                                          .collection("heart")
                                                          .doc(myuid);

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue, // グレーに変更
              ),
              child: Text(
                'オプション',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(LineIcons.cog, size: 45),
              title: Text('ユーザー設定'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileEditPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(LineIcons.running, size: 45),
              title: Text('ログアウト'),
              onTap: () {
                clearFirebaseAuthCache();
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Login(
                      user: null,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(LineIcons.trash, size: 45),
              title: Text('アカウント削除'),
              onTap: () {
                //FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => DeleteUserPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
