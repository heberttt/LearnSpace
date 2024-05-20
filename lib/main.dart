import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'pages/LoginUI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/Home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();

// Ideal time to initialize
await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  
  runApp(const MaterialApp(
    home: Home(),
  ));

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
}


