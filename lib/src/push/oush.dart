import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  File? image;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: image == null ? const Text('画像が選ばれていません！') : Image.file(image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        child: Icon(LineIcons.camera),
      ),
    );
  }
}
