import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../screens/login_page.dart';
import '../user_page/te.dart';

User? user = FirebaseAuth.instance.currentUser; //ログインしているユーザーを取得suerに

class MyPage extends StatefulWidget {
  final User? user;

  MyPage({required this.user});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Future<void> _refreshData() async {
    // Add your Firebase data refresh logic here
    // For example, you can re-fetch user data or any other data you need from Firebase.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue, // グレーに変更
              ),
              child: Text(
                'Drawer Header',
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
          ],
        ),
      ),
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
                        children: const [
                          Text(
                            "フォロワー",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text("実装予定"),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            "フォロー中",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text("実装予定"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
