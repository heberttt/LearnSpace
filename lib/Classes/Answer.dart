import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:learnspace/Classes/Comment.dart';
import 'package:learnspace/Classes/User.dart';

class Answer {
  List<Comment> comments = [];
  String content = "";
  String answerID = "";
  LearnSpaceUser user = LearnSpaceUser();
  String questionID = "";

  Answer(this.answerID, this.questionID);
  Answer.getEmpty();

  void setQuestionID(String newQuestionID) {
    questionID = newQuestionID;
  }

  Future<void> getOtherDataFromID() async {
    final ref = FirebaseDatabase.instance.ref();

    DocumentSnapshot answerDoc = await FirebaseFirestore.instance
        .collection('questions')
        .doc(questionID)
        .collection("answers")
        .doc(answerID)
        .get();

    Map<String, dynamic> answerDataMap =
        answerDoc.data() as Map<String, dynamic>;

    setContent(answerDataMap['content']);
    user.setId(answerDataMap['userID']);
    await user.getOtherInfoFromUID();

    List<Comment> comments = [];

    List<String> commentIDs = await getCommentIDs();

    for (String commentID in commentIDs) {
      Comment comment = Comment(commentID, answerID, questionID);
      await comment.getOtherDataFromID();
      comments.add(comment);
    }

    this.comments = comments;
  }

  Future<List<String>> getCommentIDs() async {
    List<String> commentIDs = [];
    try {
      // Reference to your Firestore collection
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('questions')
          .doc(questionID)
          .collection('answers')
          .doc(answerID)
          .collection('comments');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Iterate through each document and add the document ID to the list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        commentIDs.add(doc.id);
      }
    } catch (e) {
      print(e);
    }
    return commentIDs;
  }

  void setContent(String data) {
    content = data;
  }

  void setUser(LearnSpaceUser newUser) {
    user = newUser;
  }

  Future<void> uploadAnswer() async {
    final db = FirebaseFirestore.instance;

    final data = {'content': content, 'userID': user.id};

    DocumentReference mainDocRef = db.collection('questions').doc(questionID);

    // Reference to the sub-collection
    CollectionReference subCollectionRef = mainDocRef.collection("answers");
    // Adding data to the sub-collection
    await subCollectionRef.add(data);
  }
}
