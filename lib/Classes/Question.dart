import 'dart:io';
import 'package:dart_openai/dart_openai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> getAnswerFromChatGPT() async {
    
    String prompt = "The topic is about: $questionType, $content";

    if(questionType == 'Others'){
      prompt = content;
    }

    OpenAI.apiKey = "sk-learnspacegpt-3XTQPaBpz3hCpdFvwbEaT3BlbkFJAZFDfncWMI5vC23PT0QF";

    final completion = await OpenAI.instance.completion.create(
    model: "gpt-3.5-turbo-instruct",
    prompt: prompt,
    maxTokens: 250
  );

    Answer chatGPTAnswer = Answer.getEmpty();

    LearnSpaceUser chatgptUser = LearnSpaceUser();
    chatgptUser.id = 'chatgpt';
    
    chatgptUser.getOtherInfoFromUID();

    chatGPTAnswer.user = chatgptUser;
    chatGPTAnswer.questionID = questionID;

    
    chatGPTAnswer.content = completion.choices[0].text;


    chatGPTAnswer.uploadAnswer();
    
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

    getAnswerFromChatGPT();
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

    getAnswerFromChatGPT();

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
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('questions')
          .doc(questionID)
          .collection('answers');

      QuerySnapshot querySnapshot = await collectionRef.get();

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
