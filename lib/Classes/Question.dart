import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:learnspace/Classes/Answer.dart';
import 'package:learnspace/Classes/User.dart';

class Question {
  String questionID = "test";
  LearnSpaceUser user = LearnSpaceUser();
  String attachementURL = "";
  int plusPoint = 0;
  String content = "";
  String date = "";
  String questionType = "";
  List<Answer> answers = [];

  Question.getEmpty();
  Question(this.questionID);

  Future<void> getOtherDataFromID() async {
    final ref = FirebaseDatabase.instance.ref();

    DocumentSnapshot questionDoc = await FirebaseFirestore.instance
        .collection('questions')
        .doc(questionID)
        .get();

    Map<String, dynamic> questionDataMap =
        questionDoc.data() as Map<String, dynamic>;

    setPlusPoint(questionDataMap['plusPoint']);
    setAttachmentURL(questionDataMap['attachmentURL']);
    setQuestionType(questionDataMap['questionType']);
    setDate(questionDataMap['date']);
    setContent(questionDataMap['content']);
    String userID = questionDataMap['userID'];
    user.setId(userID);
    await user.getOtherInfoFromUID();

    List<Answer> answers = [];

    List<String> answerIDs = await getAnswerIDs();

    for (String answerID in answerIDs) {
      Answer answer = Answer(answerID, questionID);
      await answer.getOtherDataFromID();
      answers.add(answer);
    }

    this.answers = answers;
  }


  void deleteQuestion(){
    final db = FirebaseFirestore.instance;

    db.collection('questions').doc(questionID).delete();
  }

  Future<void> uploadQuestionWithoutAttachment(
      LearnSpaceUser uploadingUser) async {
    final db = FirebaseFirestore.instance;

    DateTime now = DateTime.now();

    String date = now.toString().split('.')[0];

    //date = "${now.year}/${now.month}/${now.day} ${now.hour}:${now.minute}:${now.second}";

    final data = {
      "attachmentURL": "",
      "content": content,
      "date": date,
      "plusPoint": plusPoint,
      "questionType": questionType,
      "userID": uploadingUser.id
    };

    await db.collection("questions").add(data).then((documentSnapshot) {
      questionID = documentSnapshot.id;
    });
  }

  bool checkIfAnsweredBefore(LearnSpaceUser checkingUser) {
    bool exist = false;
    for (Answer ans in answers) {
      if (ans.user.id == checkingUser.id) {
        exist = true;
        break;
      }
    }

    return exist;
  }

  Future<void> uploadQuestion(
      LearnSpaceUser uploadingUser, File pickedImage) async {
    final db = FirebaseFirestore.instance;

    DateTime now = DateTime.now();

    String date = now.toString().split('.')[0];

    //date = "${now.year}/${now.month}/${now.day} ${now.hour}:${now.minute}:${now.second}";

    final data = {
      "attachmentURL": "",
      "content": content,
      "date": date,
      "plusPoint": plusPoint,
      "questionType": questionType,
      "userID": uploadingUser.id
    };

    await db.collection("questions").add(data).then((documentSnapshot) {
      questionID = documentSnapshot.id;
    });

    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child("$questionID.jpg");
    try {
      await mountainsRef.putFile(pickedImage);
      final attachmentPictureURLRef =
          db.collection("questions").doc(questionID);
      await attachmentPictureURLRef.update({
        "attachmentURL":
            'https://firebasestorage.googleapis.com/v0/b/learnspacefirebase.appspot.com/o/$questionID.jpg?alt=media'
      }).then((value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> getAnswerIDs() async {
    List<String> answerIDs = [];
    try {
      // Reference to your Firestore collection
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('questions')
          .doc(questionID)
          .collection('answers');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Iterate through each document and add the document ID to the list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        answerIDs.add(doc.id);
      }
    } catch (e) {
      print("Error fetching document IDs: $e");
    }
    return answerIDs;
  }

  void setDate(String date) {
    this.date = date;
  }

  void setQuestionType(String questionType) {
    this.questionType = questionType;
  }

  void setQuestionID(String questionID) {
    this.questionID = questionID;
  }

  void setAttachmentURL(String url) {
    attachementURL = url;
  }

  void setPlusPoint(int point) {
    plusPoint = point;
  }

  void setContent(String content) {
    this.content = content;
  }
}
