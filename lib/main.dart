import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/mypage/mypage.dart';
import 'src/main2.dart';
import 'src/screens/login_page.dart';
// import 'firebase_options.dart';
// import 'register/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:test3/src/mypage/mypage.dart';
import 'src/main2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter app',
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // スプラッシュ画面などに書き換えても良い
              return const SizedBox();
            }
            if (snapshot.hasData) {
              // User が null でなない、つまりサインイン済みのホーム画面へ
              return MyHomePage();
            }
            // User が null である、つまり未サインインのサインイン画面へ
            return Login();
          },
        ),
      );
}
//あーあー！テスト〜テ〜スト〜
