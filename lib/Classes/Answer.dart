import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:learnspace/Classes/Comment.dart';
import 'package:learnspace/Classes/User.dart';

class Answer {
  List<Comment> comments = [];
  String content = "";
  String answerID = "";
  LearnSpaceUser user = LearnSpaceUser();
  String questionID = "";
  String date = "";

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

    date = answerDataMap['date'];
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
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('questions')
          .doc(questionID)
          .collection('answers')
          .doc(answerID)
          .collection('comments');

      QuerySnapshot querySnapshot = await collectionRef.get();

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

    DateTime now = DateTime.now();
    
    date = now.toString();

    final data = {'content': content, 'userID': user.id, 'date' : date};

    DocumentReference mainDocRef = db.collection('questions').doc(questionID);

    CollectionReference subCollectionRef = mainDocRef.collection("answers");
    await subCollectionRef.add(data);

    
  }
}
