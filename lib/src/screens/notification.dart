// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:test3/src/screens/home.dart';

// class NotificationScreen extends StatefulWidget {
//   final Function(Map<String, dynamic>)? onPostCreated;

//   const NotificationScreen({Key? key, this.onPostCreated}) : super(key: key);

//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   late TextEditingController _titleController;

//   late TextEditingController _contentController;

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController();
//     _contentController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();

//     _contentController.dispose();

//     super.dispose();
//   }

//   void _createPost(BuildContext context) {
//     final postsCollection = FirebaseFirestore.instance.collection('posts');

//     final postData = {
//       'title': _titleController.text,
//       'content': _contentController.text,
//       'timestamp': DateTime.now(),
//     };

//     postsCollection.add(postData).then((value) {
//       print('Post created successfully!');

//       if (widget.onPostCreated != null) {
//         widget.onPostCreated!(postData);
//       }

//       Navigator.pop(context);
//     }).catchError((error) {
//       print('Failed to create post: $error');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 16),
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 labelText: 'タイトル',
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _contentController,
//               decoration: InputDecoration(
//                 labelText: '内容',
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 _createPost(context);
//               },
//               child: Text('投稿する'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
