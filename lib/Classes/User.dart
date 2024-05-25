import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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

    

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get();

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
  
  void setRole(String role){
    this.role = role;
  }
}
