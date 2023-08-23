import 'oush.dart';
import 'package:flutter/material.dart';

//pushで使うclass記述用ファイル

class RecipeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("レシピを追加"),
        TextField(
          decoration: InputDecoration(hintText: "タイトル"),
        ),
        TextField(
          decoration: InputDecoration(hintText: "説明"),
        ),
      ],
    );
  }
}
