import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user_page.dart';

User? user = FirebaseAuth.instance.currentUser;
final auth = FirebaseAuth.instance;
