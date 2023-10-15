// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:carousel_slider/carousel_slider.dart'; // carousel_slider パッケージをインポート
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import '../user_page/user_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// final FirebaseFirestore firestore = FirebaseFirestore.instance;
// final auth = FirebaseAuth.instance;
// final uid = auth.currentUser?.uid.toString();

// class YourScreen extends StatefulWidget {
//   @override
//   YourScreenState createState() => YourScreenState(user: null);
// }

// class YourScreenState extends State<YourScreen> {
//   List<Map<String, dynamic>> documentList = [];
//   bool isTextVisible = false;
//   final User? user;

//   YourScreenState({required this.user});

//   void toggleVisibility() {
//     setState(() {
//       isTextVisible = !isTextVisible;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchDocumentData();
//   }

//   Future<void> fetchDocumentData() async {
//     try {
//       QuerySnapshot querySnapshot = await firestore
//           .collection('user_post')
//           .orderBy('time', descending: true)
//           .get();
//       List<Map<String, dynamic>> dataList = [];

//       querySnapshot.docs.forEach((doc) {
//         if (doc.exists) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           dataList.add(data);
//         }
//       });

//       setState(() {
//         documentList = dataList;
//       });
//     } catch (e) {
//       print('Error fetching documents: $e');
//     }
//   }

//   Future<void> _refreshData() async {
//     await fetchDocumentData();
//   }

//   Widget buildImage(path, index) => Container(
//         //画像間の隙間
//         margin: EdgeInsets.symmetric(horizontal: 13),
//         color: Colors.blue,
//         child: Image.network(
//           path,
//           fit: BoxFit.cover,
//         ),
//       );

//   Widget abuildImageWidget(dynamic documentData) {
//     if (documentData['imgURL'] != null) {
//       if (documentData['imgURL'] is List) {
//         List<String> imageUrls = List<String>.from(documentData['imgURL']);

//         if (imageUrls.isNotEmpty) {
//           int imagecount = 0;
//           return Column(
//             children: [
//               CarouselSlider.builder(
//                 options: CarouselOptions(
//                   height: 200,
//                   initialPage: 0,
//                   viewportFraction: 1,

//                   enableInfiniteScroll: false, // ループを無効にする
//                   onPageChanged: (index, reason) {
//                     setState(() {
//                       imagecount = index;
//                     });
//                   },
//                 ),

//                 itemCount: imageUrls.length,
//                 itemBuilder: (context, index, realIndex) {
//                   final path = imageUrls[index];
//                   return buildImage(path, index);
//                 },

//                 // items: imageUrls.map<Widget>((imageUrl) {
//                 //   return Image.network(imageUrl);
//                 // }).toList(),
//               ),
//               // AnimatedSmoothIndicator(
//               //   activeIndex: imagecount,
//               //   count: imageUrls.length,
//               //   //エフェクトはドキュメントを見た方がわかりやすい
//               //   effect: JumpingDotEffect(
//               //       dotHeight: 20,
//               //       dotWidth: 20,
//               //       activeDotColor: Colors.green,
//               //       dotColor: Colors.black12),
//               // ),
//             ],
//           );
//         }
//       } else if (documentData['imgURL'] is String) {
//         // 単一の画像を表示
//         return Image.network(documentData['imgURL']);
//       }
//     }

//     // その他の型の場合の処理
//     return Container(
//       child: Text("画像がありません"),
//     ); // デフォルトでは空のコンテナを返すか、適切なエラーウィジェットを返すことができます
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const Padding(
//           padding: EdgeInsets.only(left: 10),
//         ),
//         title: Text(
//           "chefGourmet",
//           style: GoogleFonts.happyMonkey(
//             textStyle: const TextStyle(
//               fontSize: 35,
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshData,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),
//               Column(
//                 children: documentList.map<Widget>((documentData) {
//                   return Container(
//                     margin: EdgeInsets.all(5),
//                     padding: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.black,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => userpage(
//                                           uid: documentData['user_id'],
//                                           user: null,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   child: Row(
//                                     children: [
//                                       if (documentData['user_image'] is List)
//                                         Column(
//                                           children: documentData['user_image']
//                                               .map<Widget>((imageUrl) {
//                                             return ClipOval(
//                                               child: Image.network(
//                                                 imageUrl,
//                                                 width: 50,
//                                                 height: 50,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             );
//                                           }).toList(),
//                                         )
//                                       else if (documentData['user_image']
//                                           is String)
//                                         ClipOval(
//                                           child: Image.network(
//                                             documentData['user_image'],
//                                             width: 50,
//                                             height: 50,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       const SizedBox(
//                                         width: 10,
//                                       ),
//                                       RichText(
//                                         textAlign: TextAlign.center,
//                                         text: TextSpan(
//                                           children: [
//                                             TextSpan(
//                                               text: documentData['name'] != null
//                                                   ? ' ${documentData['name']}'
//                                                   : '名無しさん',
//                                               style: const TextStyle(
//                                                 fontSize: 20,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(
//                                     LineIcons.download,
//                                     size: 30,
//                                   ),
//                                   onPressed: () {
//                                     print('IconButton tapped');
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Center(
//                                 child: Text(
//                                   "  ${documentData['title']}",
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         abuildImageWidget(documentData),

//                         // if (documentData['imgURL'] != null)
//                         //   if (documentData['imgURL'] is List)
//                         //     CarouselSlider(
//                         //       options: CarouselOptions(
//                         //         height: 200, // スライダーの高さを設定
//                         //       ),
//                         //       items: documentData['imgURL']
//                         //           .map<Widget>((imageUrl) {
//                         //         return Image.network(imageUrl);
//                         //       }).toList(),
//                         //     )
//                         //   else if (documentData['imgURL'] is String)
//                         //     Image.network(
//                         //       documentData['imgURL'],
//                         //     ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         RichText(
//                           textAlign: TextAlign.center,
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: 'comment\n',
//                                 style: GoogleFonts.happyMonkey(
//                                   textStyle: const TextStyle(
//                                     fontSize: 25,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: ' ${documentData['author']}',
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => userpage2(),
//                               ),
//                             );
//                           },
//                           child: Text('詳細'),
//                         ),
//                         const SizedBox(
//                           height: 40,
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
