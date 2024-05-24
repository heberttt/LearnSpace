import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'pages/LoginUI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/Home.dart';

Future<void> main() async {

// Ideal time to initialize
  
  runApp(const MaterialApp(
    home: LoginUIWidget(),
  ));

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
}


