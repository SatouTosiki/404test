import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../push/push_class.dart';
import 'mypage.dart';

User? user = FirebaseAuth.instance.currentUser;
final auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final myuid = auth.currentUser?.uid;
late SharedPreferences prefs;

String? userid_test; // 投稿データからuidを取得し格納している変数
String? userName;

bool isLiked = false;
int imagecount = 0;
List<Map<String, dynamic>> mydocumentList = [];
bool isTextVisible = false;

Map<String, bool> isLikedMap = {};

//フォロ中の取得どうかの確認
Future<int> myfollowing(String myuid) async {
  try {
    QuerySnapshot flollo = await FirebaseFirestore.instance
        .collection('users')
        .doc(myuid)
        .collection('following')
        .get();

    return flollo.docs.length;
  } catch (e) {
    print('フォロワー取得: $e');
    return 0;
  }
}

//フォロワーの取得
Future<int> myfollowers(String myuid) async {
  try {
    QuerySnapshot flollo = await FirebaseFirestore.instance
        .collection('users')
        .doc(myuid)
        .collection('followers')
        .get();

    return flollo.docs.length;
  } catch (e) {
    print('フォロワー取得: $e');
    return 0;
  }
}

Future<void> MyPushet() async {
  try {
    QuerySnapshot querySnapshot = await firestore
        .collection('user_post')
        .doc(myuid)
        .collection('pushs')
        // .orderBy('time', descending: true)
        .get();
    List<Map<String, dynamic>> mydataList = [];

    await Future.forEach(querySnapshot.docs, (doc) async {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        mydataList.add(data);
      }
    });
    // データが取得できたら、Stateを更新して画面を再構築する
    setState(() {});
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
        Map<String, dynamic> data = postDocument.data() as Map<String, dynamic>;
        data['documentId'] = documentId;

        // 投稿のユーザー名を取得
        await checkUserIdInUsersCollection(data['user_id'], data);

        dataList.add(data);
      }
    });

    setState(() {
      mydocumentList = dataList;
    });

    print('いいねした投稿数: ${mydocumentList.length}');

    // 各投稿のいいねの状態を読み込む
    loadLikedStates();
  } catch (e) {
    print('エラー画面表示できないなのです☆: $e');
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
  mydocumentList.forEach((documentData) {
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

Future<void> refreshData() async {
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
      color: Colors.grey,
      child: Image.network(
        path,
        fit: BoxFit.cover,
      ),
    );
