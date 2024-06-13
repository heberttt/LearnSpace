import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnspace/Classes/User.dart';
import 'package:learnspace/pages/draftPost.dart';
import 'pages/LoginUI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/Home.dart';
import 'package:provider/provider.dart';

class MyStates with ChangeNotifier {
  List<String> topics = [];

  LearnSpaceUser currentUser = LearnSpaceUser();

  void setCurrentUser(LearnSpaceUser user) {
    currentUser = user;
  }

  Future<void> getTopics() async {
    List<String> topics = [];
    try {
      // Reference to your Firestore collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('questionType');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Iterate through each document and add the document ID to the list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        topics.add(doc.id);
      }
    } catch (e) {
      print("Error fetching document IDs: $e");
    }
    this.topics = topics;
  }
}
