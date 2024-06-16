import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:learnspace/Classes/User.dart';

class Comment {
  String content = "";
  String commentID = "";
  LearnSpaceUser user = LearnSpaceUser();
  String questionID = "";
  String answerID = "";
  String date = "";

  Comment(this.commentID, this.answerID, this.questionID);
  Comment.getEmpty();

  void setUser(LearnSpaceUser newUser) {
    user = newUser;
  }

  void setQuestionID(String newQuestionID) {
    questionID = newQuestionID;
  }

  void setAnswerID(String newAnswerID) {
    answerID = newAnswerID;
  }

  Future<void> getOtherDataFromID() async {

    DocumentSnapshot commentDoc = await FirebaseFirestore.instance
        .collection('questions')
        .doc(questionID)
        .collection('answers')
        .doc(answerID)
        .collection('comments')
        .doc(commentID)
        .get();

    Map<String, dynamic> answerDataMap =
        commentDoc.data() as Map<String, dynamic>;

    date = answerDataMap['date'];
    setContent(answerDataMap['content']);
    user.setId(answerDataMap['userID']);
    await user.getOtherInfoFromUID();
  }

  void setContent(String content) {
    this.content = content;
  }

  Future<void> uploadComment() async {
    final db = FirebaseFirestore.instance;
    DateTime now = DateTime.now();

    date = now.toString();
    final data = {'content': content, 'userID': user.id, 'date': date};

    DocumentReference mainDocRef = db
        .collection('questions')
        .doc(questionID)
        .collection("answers")
        .doc(answerID);

    // Reference to the sub-collection
    CollectionReference subCollectionRef = mainDocRef.collection("comments");
    // Adding data to the sub-collection
    await subCollectionRef.add(data);
  }
}
