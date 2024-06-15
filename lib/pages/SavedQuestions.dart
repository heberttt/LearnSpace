import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnspace/Classes/Question.dart';
import 'package:learnspace/Classes/User.dart';
import 'package:learnspace/states.dart';
import 'package:learnspace/widgets/QuestionCard.dart';
import 'package:provider/provider.dart';

class SavedQuestionsModel extends FlutterFlowModel<SavedQuestionsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

class SavedQuestionsWidget extends StatefulWidget {
  SavedQuestionsWidget({super.key});

  late LearnSpaceUser user;

  SavedQuestionsWidget.getUser(this.user, {super.key});

  @override
  State<SavedQuestionsWidget> createState() => _SavedQuestionsWidgetState();
}

class _SavedQuestionsWidgetState extends State<SavedQuestionsWidget> {
  late SavedQuestionsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<QuestionCard> questionCards = [];

  @override
  void initState() {
    _fetchQuestionCards();
    super.initState();
    _model = createModel(context, () => SavedQuestionsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<List<QuestionCard>> getQuestionCards(BuildContext context) async {
    List<String> questionIDs = await getQuestionIDs();
    List<QuestionCard> questionCards = [];
    final myStates = Provider.of<MyStates>(context, listen: false);
    for (String questionID in questionIDs) {
      if (myStates.currentUser.savedQuestionIDs.contains(questionID)) {
        Question question = Question(questionID);
        await question.getOtherDataFromID();
        QuestionCard questionCard = QuestionCard.getQuestion(question);
        questionCards.add(questionCard);
      }
    }

    questionCards.sort((b, a) => a.question.date.compareTo(b.question.date));

    return questionCards;
  }

  Future<void> _fetchQuestionCards() async {
    setState(() {
      this._listviewChildrens = [
        Container(
          height: 40,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ];
    });

    questionCards = await getQuestionCards(context);

    List<Widget> _listviewChildrens = [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(),
          ),
        ],
      ),
    ];

    _listviewChildrens.addAll(questionCards);

    if (questionCards.isEmpty){
      _listviewChildrens.add(
        Center(child: const Text("You haven't saved any questions yet."))
      );
    }

    setState(() {
      this._listviewChildrens = _listviewChildrens;
    });
  }

  Future<List<String>> getQuestionIDs() async {
    List<String> questionIDs = [];
    try {
      // Reference to your Firestore collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('questions');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Iterate through each document and add the document ID to the list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        questionIDs.add(doc.id);
      }
    } catch (e) {
      print("Error fetching document IDs: $e");
    }
    return questionIDs;
  }

  List<Widget> _listviewChildrens = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 20,
            borderWidth: 1,
            buttonSize: 40,
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Saved Questions',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: _listviewChildrens,
            ),
          ),
        ),
      ),
    );
  }
}
