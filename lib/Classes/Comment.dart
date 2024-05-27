import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:learnspace/Classes/User.dart';

class Comment {
  String content = "";
  String commentID = "";
  LearnSpaceUser user = LearnSpaceUser();
  String questionID = "";
  String answerID = "";

  Comment(this.commentID, this.answerID, this.questionID);

  Future<void> getOtherDataFromID() async {
    final ref = FirebaseDatabase.instance.ref();

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

    setContent(answerDataMap['content']);
    user.setId(answerDataMap['userID']);
    await user.getOtherInfoFromUID();
  }

  void setContent(String content) {
    this.content = content;
  }
}
