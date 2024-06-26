import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnspace/states.dart';
import 'pages/LoginUI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/Home.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Ideal time to initialize
//   await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );



runApp(
    ChangeNotifierProvider(
      create: (context) => MyStates(),
      child: MaterialApp(
    home: FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AuthWrapper(); 
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error initializing Firebase: ${snapshot.error}'),
            ),
          ); 
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ); 
      },
    ),
  ),
    ),
  );

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
            return const LoginUIWidget(); 
          } else {
            return Home.getUser2(FirebaseAuth.instance.currentUser!.uid); 
          }
        }

        return Scaffold(
          body: Center(
            child: Center(child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/LearnSpaceLogo.png',
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),),
          ),
        ); 
      },
    ); 
  } 
} 

