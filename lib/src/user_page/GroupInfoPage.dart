import 'package:flutter/material.dart';

import '../register/register_page.dart';
import '../screens/login_page.dart';

class GroupInfoPage extends StatelessWidget {
  const GroupInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('退会完了'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('退会手続きを完了いたしました!'),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Registe(
                              // user: null,
                              )));
                },
                child: Text('新規登録へ戻る')),
          ],
        ),
      ),
    );
  }
}
