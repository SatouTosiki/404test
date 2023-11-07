import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test3/src/user_page/user_page.dart';

final CollectionReference users =
    FirebaseFirestore.instance.collection('user_post');
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final uid = auth.currentUser?.uid.toString();

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int imagecount = 0;
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> searchResults = [];
  bool isLiked = false;
  int likeCount = 0;
  List<Map<String, dynamic>> documentList = [];
  bool isTextVisible = false;
  late final User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "search",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: '検索キーワードを入力してください',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                performSearch();
              },
              child: Text('検索'),
            ),
            Expanded(
              child: searchResults.isEmpty
                  ? Center(
                      child: Text('お探しのものはありません'),
                    )
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final documentData = searchResults[index];
                        return buildPostUI(documentData);
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> performSearch() async {
    final keyword = searchController.text.toLowerCase();

    if (keyword.isEmpty) {
      // Display a message when the search input is empty
      setState(() {
        searchResults = [];
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text('検索キーワードを入力してください。'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('user_post').get();

      List<Map<String, dynamic>> results = [];

      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // 検索キーワードと一致するものを検索

          if (data['author'].toString().toLowerCase().contains(keyword) ||
              data['name'].toString().toLowerCase().contains(keyword) ||
              data['time'].toString().toLowerCase().contains(keyword) ||
              data['title'].toString().toLowerCase().contains(keyword) ||
              data['具材'].toString().toLowerCase().contains(keyword) ||
              data['user_id'].toString().toLowerCase().contains(keyword) ||
              data['手順'].toString().toLowerCase().contains(keyword)) {
            results.add(data);
          }
        }
      });

      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print('Error searching documents: $e');
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
                itemCount: imageUrls.length,
                itemBuilder: (context, index, realIndex) {
                  final path = imageUrls[index];
                  return buildImage(path, index);
                },
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

  Widget buildImage(path, index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.grey,
        child: Image.network(
          path,
          fit: BoxFit.cover,
        ),
      );

  Widget buildPostUI(Map<String, dynamic> documentData) {
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
                        user_image: documentData["user_image"],
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
                        children:
                            documentData['user_image'].map<Widget>((imageUrl) {
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
                    else if (documentData['user_image'] is String)
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
                  print('IconButton ダウンロード');
                },
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
          abuildImageWidget(documentData),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    LineIcons.heart,
                    size: 30,
                  ),
                  onPressed: () {
                    print('IconButton ハート');
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    LineIcons.comment,
                    size: 30,
                  ),
                  onPressed: () {
                    showBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          child: Text('Bottom コメント'),
                          height: 500,
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                    print('IconButton コメント');
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
                  text: ' ${documentData['author']}',
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
        ],
      ),
    );
  }
}
