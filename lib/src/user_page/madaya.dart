import 'package:flutter/material.dart';
import 'UserDelet.dart';
import '../register/register_page.dart';
import '../screens/login_page.dart';

class madaPage extends StatelessWidget {
  const madaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('削除処理'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('まだ完了していません'),
            Text("一度ログインしてから削除してください"),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login(
                                user: null,
                                // user: null,
                              )));
                },
                child: Text('ログアウト')),
          ],
        ),
      ),
    );
  }
}
