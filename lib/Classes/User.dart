import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LearnSpaceUser {
  String id = "";
  String username = "";
  String email = "";
  String role = "student";
  String profilePictureUrl = "";

  LearnSpaceUser();

  void setUsername(String username) {
    this.username = username;
  }

  void setId(String id) {
    this.id = id;
  }

  void setEmail(String email) {
    this.email = email;
  }

  Future<void> getOtherInfoFromUID() async {
    final ref = FirebaseDatabase.instance.ref();

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    Map<String, dynamic> userDataMap = userDoc.data() as Map<String, dynamic>;

    setId(id);
    setUsername(userDataMap['username']);
    setEmail(userDataMap['email']);
    setProfilePictureURL(userDataMap['profile_picture_url']);
    setRole(userDataMap['role']);
  }

  void setProfilePictureURL(String url) {
    profilePictureUrl = url;
  }

  void setRole(String role) {
    this.role = role;
  }

  String getProfile(){
    return profilePictureUrl;
  }

  Future<void> updateProfilePicture(File pickedImage) async {
    final db = FirebaseFirestore.instance;
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child("$id.jpg");
    try {
      await mountainsRef.putFile(pickedImage);
      final profilePictureURLRef = db.collection("users").doc(id);
      await profilePictureURLRef.update({"profile_picture_url": 'https://firebasestorage.googleapis.com/v0/b/learnspacefirebase.appspot.com/o/$id.jpg?alt=media'}).then(
          (value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    } catch (e) {
      print(e);
    }
  }


  
}
