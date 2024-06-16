import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnspace/Classes/User.dart';


class MyStates with ChangeNotifier {
  List<String> topics = [];

  LearnSpaceUser currentUser = LearnSpaceUser();
  List<String> savedQuestionIDsByCurrentUser = [];

 

  String searchedQuestion = "";

  void plusPointCurrentUser(int point) {
    currentUser.plusPoint(point);
    notifyListeners();
  }

  Future<void> updateUsername(String username) async {
    await currentUser.updateUsername(username);
    notifyListeners();
  }

  void setCurrentUser(LearnSpaceUser user) {
    currentUser = user;
  }

  String selectedTopic = "All";

  void selectTopic(String topic) {
    selectedTopic = topic;
    notifyListeners();
  }

  void resetSearch() {
    searchedQuestion = "";
  }

  void searchQuestion(String substring) {
    searchedQuestion = substring;
    notifyListeners();
  }

  void minusPointCurrentUser(int point) {
    currentUser.point -= point;
    currentUser.minusPoint(point); 
    notifyListeners();
  }

  Future<void> getTopics() async {
    List<String> topics = [];
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('questionType');

      QuerySnapshot querySnapshot = await collectionRef.get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if (doc.id == 'Others') {
          continue;
        }
        topics.add(doc.id);
      }
      topics.add('Others');
    } catch (e) {
      print("Error fetching document IDs: $e");
    }
    this.topics = topics;
  }
}
