import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:carousel_slider/carousel_slider.dart'; // carousel_slider パッケージをインポート
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../recipe/recipe_page.dart';
import '../user_page/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final uid = auth.currentUser?.uid;
User? user = FirebaseAuth.instance.currentUser;

class SearchScreen extends StatefulWidget {
  @override
  YourScreenState createState() => YourScreenState(user: null);
}

class YourScreenState extends State<SearchScreen> {
  String? userid_test; // 投稿データからuidを取得し格納している変数
  String? userName;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredDocumentList = [];
  bool isLiked = false;
  int imagecount = 0;
  List<Map<String, dynamic>> documentList = [];
  bool isTextVisible = false;
  final User? user;
  Map<String, bool> isLikedMap = {};

  YourScreenState({required this.user});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

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

      print('ドキュメント数検索: ${documentList.length}');

      // ハートの状態を読み込む
      loadLikedStates();
    } catch (e) {
      print('エラー画面表示できないなのです☆: $e');
    }
  }

  void _initialize() async {
    try {
      _user = _auth.currentUser;
      initSharedPreferences();
      fetchDocumentData();
      loadSearchHistory();
    } catch (e) {
      print('エラーが発生しました: $e');
    }
  }

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // キーボード以外をタップした場合、フォーカスを外す
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          title: Text(
            "Screen",
            style: GoogleFonts.happyMonkey(
              textStyle: const TextStyle(
                fontSize: 35,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(LineIcons.history),
              onPressed: () {
                // 検索履歴を表示するポップアップメニューを表示
                showSearchHistory(context);
                // 検索ワードをFirestoreに保存
              },
            ),
            IconButton(
              icon: Icon(LineIcons.certificate),
              onPressed: () {
                // 検索履歴を表示するポップアップメニューを表示
                _showRankingPopup();
                // 検索ワードをFirestoreに保存
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: '検索',
                      suffixIcon: IconButton(
                        icon: Icon(LineIcons.search),
                        onPressed: () {
                          performSearch();
                        },
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      // 検索ボタンが押された時の処理
                      performSearch();
                    },
                  ),
                ),
                const SizedBox(height: 0),
                Column(
                  children: filteredDocumentList.map<Widget>((documentData) {
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
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => userpage(
                                            name: documentData["userName"] ??
                                                '名無しさんa', // userName が null の場合は '名無しさん' を表示
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
                                                text: documentData[
                                                            "userName"] !=
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
                                                      documentData[
                                                          'documentId']),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
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
                                                          snapshot.data ??
                                                              false;
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
                                                  final User? user =
                                                      FirebaseAuth
                                                          .instance.currentUser;
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
                                                            .collection("heart")
                                                            .doc(uid);

                                                    // user_postのハートに対するサブコレクションへの参照を作成
                                                    // ignore: unused_local_variable
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
      ),
    );
  }

  // 検索履歴を表示するメソッド
  void showSearchHistory(BuildContext context) {
    List<String>? searchHistory =
        prefs.getStringList('searchHistoryKey'); // キーは適切に変更してください

    if (searchHistory != null && searchHistory.isNotEmpty) {
      // 検索履歴がある場合、ポップアップメニューで表示
      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(100, 100, 0, 0),
        items: [
          ...searchHistory.map<PopupMenuEntry<String>>((String term) {
            return PopupMenuItem<String>(
              value: term,
              child: Text(term),
            );
          }).toList(),
          PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'clearHistory',
            child: Text('履歴を消去'),
          ),
        ],
      ).then((selectedTerm) {
        if (selectedTerm != null) {
          if (selectedTerm == 'clearHistory') {
            // '履歴を消去' が選択された場合、検索履歴を削除
            clearSearchHistory();
          } else {
            // 選択された検索履歴を使って新たな検索を実行
            searchController.text = selectedTerm;
            performSearch();
          }
        }
      });
    } else {
      // 検索履歴がない場合のメッセージを表示
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('検索履歴なし'),
            content: Text('検索履歴がありません。'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // 検索履歴を削除するメソッド
  void clearSearchHistory() {
    prefs.remove('searchHistoryKey'); // キーは適切に変更してください
  }

  // 検索履歴を読み込むメソッド
  void loadSearchHistory() {
    List<String>? searchHistory = prefs.getStringList('searchHistoryKey') ?? [];

    if (searchHistory.isNotEmpty) {
      // 読み込んだ検索履歴を使って何かできる場合はここで実装
    }
  }

  // 検索履歴を保存するメソッド
  void saveSearchHistory(String searchTerm) {
    List<String> searchHistory = prefs.getStringList('searchHistoryKey') ?? [];

    if (!searchHistory.contains(searchTerm)) {
      searchHistory.add(searchTerm);
      prefs.setStringList('searchHistoryKey', searchHistory);
    }
  }

  // 検索ロジック
  void performSearch() {
    String searchTerm = searchController.text.trim(); // 空白を除去

    if (searchTerm.isEmpty) {
      // 検索キーワードが空の場合はメッセージを表示
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text('検索キーワードを入力してください。'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // 検索ワードに一致するデータを抽出
      List<Map<String, dynamic>> searchResults = documentList
          .where((documentData) =>
              documentData['comment'].toLowerCase().contains(searchTerm) ||
              documentData['name'].toLowerCase().contains(searchTerm) ||
              documentData['title'].toLowerCase().contains(searchTerm) ||
              documentData['user_id'].toLowerCase().contains(searchTerm))
          .toList();

      setState(() {
        filteredDocumentList = searchResults;
      });

      // 検索結果がない場合のメッセージを表示
      if (searchResults.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('検索結果なし'),
              content: Text('お探しのものが見つかりませんでした。'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // 検索履歴を保存
        saveSearchHistory(searchTerm);
        saveSearchHistory2(searchTerm);
      }
    }
  }

  // 検索履歴をFirestoreに保存するメソッド
  Future<void> saveSearchHistory2(String searchWord) async {
    try {
      // 検索ワードが空でない場合のみ処理を実行
      if (searchWord.isNotEmpty && _user != null) {
        final CollectionReference searchHistoryCollection =
            FirebaseFirestore.instance.collection('searchHistory');

        final DocumentReference searchWordDocument =
            searchHistoryCollection.doc(searchWord);

        final String userId = _user!.uid;

        // ドキュメントが存在するか確認
        final DocumentSnapshot searchWordSnapshot =
            await searchWordDocument.get();

        if (searchWordSnapshot.exists) {
          // ドキュメントが存在する場合、ユーザーごとのフィールドにユーザーIDを保存
          Map<String, dynamic> userCounts =
              searchWordSnapshot.get('userCounts') ?? {};

          if (!userCounts.containsKey(userId)) {
            userCounts[userId] = true;
            await searchWordDocument.update({
              'userCounts': userCounts,
            });
          }
        } else {
          // ドキュメントが存在しない場合、新規に作成
          await searchWordDocument.set({
            'userCounts': {userId: true},
          });

          // Firestoreに保存されたことをターミナルに表示
          print('ユーザー "$userId" が検索ワード "$searchWord" を Firestore に保存しました。');
        }
      }
    } catch (e) {
      print('検索ワード保存エラー: $e');
    }
  }

  Future<void> _showRankingPopup() async {
    // searchHistoryコレクションからuserIdのカウントを取得してランキング表示
    QuerySnapshot<Map<String, dynamic>> rankingSnapshot =
        await FirebaseFirestore.instance.collection('searchHistory').get();

    List<Map<String, dynamic>> rankingList = rankingSnapshot.docs
        .map((doc) => {
              'searchWord': doc.id,
              'userCount': (doc['userCounts'] as Map).length,
            })
        .toList();

    // ユーザー数が多い順に並び替え
    rankingList.sort((a, b) => b['userCount'].compareTo(a['userCount']));

    // ランキングポップアップの表示
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('検索ランキング'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: rankingList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    '${index + 1}. ${rankingList[index]['searchWord']}',
                  ),
                  subtitle: Text(
                    '検索数: ${rankingList[index]['userCount']}',
                  ),
                  onTap: () {
                    // タップされた検索ワードで検索を実行
                    searchController.text = rankingList[index]['searchWord'];
                    performSearch();
                    Navigator.of(context).pop(); // ポップアップを閉じる
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('閉じる'),
            ),
          ],
        );
      },
    );
  }
}
