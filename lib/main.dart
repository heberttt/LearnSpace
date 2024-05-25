import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'pages/LoginUI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/Home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Ideal time to initialize
//   await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );
  runApp(MaterialApp(
    home: FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AuthWrapper(); // Ends the if block for connectionState done
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error initializing Firebase: ${snapshot.error}'),
            ),
          ); // Ends the if block for hasError
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ); // Ends the default case
      },
    ),
  ));
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const LoginUIWidget(); // Ends the if block for user null
          } else {
            return Home.getUser2(FirebaseAuth.instance.currentUser!.uid); // Ends the if block for user not null
          }
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ); // Ends the default case
      },
    ); // Ends StreamBuilder
  } // Ends the build method
} // Ends AuthWrapper class