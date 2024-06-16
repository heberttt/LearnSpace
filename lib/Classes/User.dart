import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LearnSpaceUser {
  String id = "";
  String username = "late";
  String email = "";
  String role = "student";
  String profilePictureUrl = "";
  int point = 0;
  int approval = 0;

  List<String> savedQuestionIDs = [];

  LearnSpaceUser();

  Future<void> plusPoint(int addedPoint) async {
    point += addedPoint;
    final db = FirebaseFirestore.instance;
    final storageRef = FirebaseStorage.instance.ref();
    try {
      final userURLRef = db.collection("users").doc(id);
      await userURLRef.update({"point": "$point"}).then(
          (value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    } catch (e) {
      print(e);
    }
  }

  Future<void> minusPoint(int addedPoint) async {
    point -= addedPoint;
    final db = FirebaseFirestore.instance;
    final storageRef = FirebaseStorage.instance.ref();
    try {
      final userURLRef = db.collection("users").doc(id);
      await userURLRef.update({"point": "$point"}).then(
          (value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    } catch (e) {
      print(e);
    }
  }

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

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    Map<String, dynamic> userDataMap = userDoc.data() as Map<String, dynamic>;

    setId(id);
    setUsername(userDataMap['username']);
    setEmail(userDataMap['email']);
    setProfilePictureURL(userDataMap['profile_picture_url']);
    setRole(userDataMap['role']);
    setPoint(int.parse(userDataMap['point']));

    CollectionReference savedQuestionIDsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('savedQuestions');

    QuerySnapshot savedQuestionIDsQuery = await savedQuestionIDsRef.get();

    List<String> gotSavedQuestionIDs = [];
    for (QueryDocumentSnapshot doc in savedQuestionIDsQuery.docs) {
      gotSavedQuestionIDs.add(doc.id);
    }
    savedQuestionIDs = gotSavedQuestionIDs;

  }


  void addSavedQuestionID(String questionID){
    savedQuestionIDs.add(questionID);

    final db = FirebaseFirestore.instance;

    final data = {'1' : 1};

    db.collection('users')
        .doc(id)
        .collection("savedQuestions")
        .doc(questionID)
        .set(data);
    
  }

  void deleteSavedQuestionID(String questionID){
    savedQuestionIDs.remove(questionID);
    try {
    FirebaseFirestore.instance.collection('users').doc(id).collection('savedQuestions').doc(questionID).delete();
      
    } catch (e) {
      print(e);
    }
  }

  void removeSavedQuestionID(String questionID){
    savedQuestionIDs.remove(questionID);
  }


  Future<void> updateUsername(String newName) async {
    final db = FirebaseFirestore.instance;
    final storageRef = FirebaseStorage.instance.ref();
    try {
      final profilePictureURLRef = db.collection("users").doc(id);
      await profilePictureURLRef.update({"username": newName}).then(
          (value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    } catch (e) {
      print(e);
    }
    setUsername(newName);
  }

  void setPoint(int point) {
    this.point = point;
  }

  void setApproval(int approval) {
    this.approval = approval;
  }

  void setProfilePictureURL(String url) {
    profilePictureUrl = url;
  }

  void setRole(String role) {
    this.role = role;
  }

  String getProfile() {
    return profilePictureUrl;
  }

  int getApproval() {
    return approval;
  }

  int getPoint() {
    return point;
  }

  Future<void> updateProfilePicture(File pickedImage) async {
    final db = FirebaseFirestore.instance;
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child("$id.jpg");
    try {
      await mountainsRef.putFile(pickedImage);
      final profilePictureURLRef = db.collection("users").doc(id);
      await profilePictureURLRef.update({
        "profile_picture_url":
            'https://firebasestorage.googleapis.com/v0/b/learnspacefirebase.appspot.com/o/$id.jpg?alt=media'
      }).then((value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    } catch (e) {
      print(e);
    }
  }
}
