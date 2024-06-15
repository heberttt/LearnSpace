

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnspace/Classes/Question.dart';
import 'package:learnspace/pages/LoginUI.dart';
import 'package:learnspace/pages/Profile.dart';
import 'package:learnspace/pages/draftPost.dart';
import 'package:learnspace/states.dart';
import 'package:learnspace/widgets/QuestionCard.dart';
import 'package:learnspace/widgets/SearchBar.dart';
import 'package:provider/provider.dart';
import '../Classes/User.dart';

class Home extends StatefulWidget {
  Home({super.key});

  LearnSpaceUser user = LearnSpaceUser();

  Home.getUser2(String userUID, {super.key}) {
    user.setId(userUID);
  }

  Home.getUser(this.user, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? tabController;

  int _selectedIndex = 0;
  late LearnSpaceUser _user;
  double vdheight = 4;

  Route _createDraft() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const DraftPostWidget(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void showSideBar() {
    HomeScaffoldKey.currentState?.openDrawer();
  }

  final HomeScaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _widgetOptions = [];

  final authenticatedUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    widget.user.getOtherInfoFromUID();
    super.initState();
    LearnSpaceUser _user = widget.user;
    _widgetOptions = [
      MainWidget.getUser(_user, HomeScaffoldKey),
      ProfileWidget.getUser(_user)
    ];
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController!.dispose();
  }

  bool _checkIfInMain() {
    if (_selectedIndex == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<MyStates>(context, listen: true).getTopics();
    Provider.of<MyStates>(context, listen: true).setCurrentUser(widget.user);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: _checkIfInMain(),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(_createDraft());
            },
            backgroundColor: FlutterFlowTheme.of(context).primary,
            elevation: 8,
            child: Icon(
              Icons.add,
              color: FlutterFlowTheme.of(context).info,
              size: 24,
            ),
          ),
        ),
        key: HomeScaffoldKey,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: _widgetOptions,
        ) ,
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              Container(
                  color: FlutterFlowTheme.of(context).primary,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text("LearnSpace",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  )),
              ListTile(
                visualDensity: VisualDensity(vertical: vdheight),
                leading: const Icon(Icons.person),
                title: const Text(' My Profile '),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Welcome, "${widget.user.username}", ${authenticatedUser.uid}, ${widget.user.username}'),
                  ));
                },
              ),
              ListTile(
                visualDensity: VisualDensity(vertical: vdheight),
                leading: const Icon(Icons.book),
                title: const Text(' My Course '),
                onTap: () {},
              ),
              ListTile(
                visualDensity: VisualDensity(vertical: vdheight),
                leading: const Icon(Icons.workspace_premium),
                title: const Text(' Go Premium '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                visualDensity: VisualDensity(vertical: vdheight),
                leading: const Icon(Icons.video_label),
                title: const Text(' Saved Videos '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                visualDensity: VisualDensity(vertical: vdheight),
                leading: const Icon(Icons.edit),
                title: const Text(' Edit Profile '),
                onTap: () {
                  print(FirebaseAuth.instance
                      .authStateChanges()
                      .listen((User? user) {
                    if (user == null) {
                      print('User is currently signed out!');
                    } else {
                      print('User is signed in!');
                    }
                  }));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                visualDensity: VisualDensity(vertical: vdheight),
                leading: const Icon(Icons.logout),
                title: const Text('LogOut'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginUIWidget()),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: FlutterFlowTheme.of(context).primary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "Profile",
            )
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      tabController!.index = _selectedIndex;
    });
  }
}

class MainModel extends FlutterFlowModel<MainWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

class TopicButton extends StatefulWidget {
  TopicButton.getTopic(this.topic, {super.key});

  late String topic;
  @override
  State<TopicButton> createState() => _TopicButtonState();
}

class _TopicButtonState extends State<TopicButton> {
  Color selectedText(context) {
    final myStates = Provider.of<MyStates>(context);
    if (myStates.selectedTopic != widget.topic) {
      return Colors.white;
    }
    return FlutterFlowTheme.of(context).primary;
  }

  Color selectedBackground(context) {
    final myStates = Provider.of<MyStates>(context);
    if (myStates.selectedTopic == widget.topic) {
      return Colors.white;
    }
    return FlutterFlowTheme.of(context).primary;
  }

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: () {
        Provider.of<MyStates>(context, listen: false).selectTopic(widget.topic);
      },
      text: widget.topic,
      options: FFButtonOptions(
        height: 35,
        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        color: selectedBackground(context),
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: 'Manrope',
              color: selectedText(context),
              fontSize: 10,
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
            ),
        elevation: 3,
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({super.key});

  LearnSpaceUser user = LearnSpaceUser();

  late GlobalKey<ScaffoldState> Skey;

  MainWidget.getUser(this.user, this.Skey, {super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with AutomaticKeepAliveClientMixin{
  late MainModel _model;

  @override
  bool get wantKeepAlive => true;

  List<String> _rulesChildren = [''];

  Future<void> _fetchRules() async {
    final db = FirebaseFirestore.instance;

     DocumentSnapshot ds = await db.collection('rules').doc('1').get();

    

     List<String> rules =  List<String>.from(ds['rules']);

    List<String> orderedRules = [];

    int i = 0;
    for(String rule in rules){
      i++;
      orderedRules.add("$i. $rule");
    }

     setState(() {
       _rulesChildren = orderedRules;
     });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<QuestionCard> questionCards = [];

  Future<List<QuestionCard>> getQuestionCards() async {
    List<String> questionIDs = await getQuestionIDs();
    List<QuestionCard> questionCards = [];

    for (String questionID in questionIDs) {
      Question question = Question(questionID);
      await question.getOtherDataFromID();
      QuestionCard questionCard = QuestionCard.getQuestion(question);
      questionCards.add(questionCard);
    }

    questionCards.sort((b, a) => a.question.date.compareTo(b.question.date));

    return questionCards;
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

  @override
  void initState() {
    _fetchRules();
    _fetchQuestionCards();
    super.initState();
    _model = createModel(context, () => MainModel());
  }

  List<Widget> _listviewChildrens = [];

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

    questionCards = await getQuestionCards();
    List<Widget> _listviewChildrens = [
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child: FlutterFlowDropDown(
          options: _rulesChildren,
          onChanged: (val) => setState(() => _model.dropDownValue = val),
          width: MediaQuery.sizeOf(context).width * 0.95,
          height: 30,
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Manrope',
                letterSpacing: 0,
              ),
          hintText: 'Rules...',
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24,
          ),
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          elevation: 2,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2,
          borderRadius: 8,
          margin: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          hidesUnderline: true,
        ),
      ),
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

    setState(() {
      this._listviewChildrens = _listviewChildrens;
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  List<Widget> _displayedCards(BuildContext context) {
    final myStates = Provider.of<MyStates>(context);

    List<Widget> displayedCards = [];

    if (myStates.selectedTopic != "All" && myStates.searchedQuestion == "") {
      for (Widget i in _listviewChildrens) {
        if (i is QuestionCard &&
            i.question.questionType == myStates.selectedTopic) {
          displayedCards.add(i);
        }
      }

      return displayedCards;
    } else if (myStates.selectedTopic != "All" &&
        myStates.searchedQuestion != "") {
      for (Widget i in _listviewChildrens) {
        if (i is QuestionCard &&
            i.question.questionType == myStates.selectedTopic &&
            i.question.content.contains(myStates.searchedQuestion)) {
          displayedCards.add(i);
        }
      }

      return displayedCards;
    } else if (myStates.selectedTopic == "All" &&
        myStates.searchedQuestion == "") {
      displayedCards = _listviewChildrens;
      return displayedCards;
    } else {
      for (Widget i in _listviewChildrens) {
        if (i is QuestionCard &&
            i.question.content.contains(myStates.searchedQuestion)) {
          displayedCards.add(i);
        }
      }
      return displayedCards;
    }
  }

  List<TopicButton> getTopicButtons(BuildContext context) {
    List<TopicButton> topics = [];

    final myStates = Provider.of<MyStates>(context);

    List<String> availableTopics = myStates.topics;

    TopicButton topicButton = TopicButton.getTopic("All");
    topics.add(topicButton);

    for (String topic in availableTopics) {
      if (topic == 'Others') {
        continue;
      }
      TopicButton topicButton = TopicButton.getTopic(topic);
      topics.add(topicButton);
    }

    TopicButton topicButton2 = TopicButton.getTopic('Others');
    topics.add(topicButton2);

    return topics;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            leading: Visibility(
              visible: false,
              child: FlutterFlowIconButton(
                borderColor: FlutterFlowTheme.of(context).primary,
                borderRadius: 20,
                borderWidth: 1,
                buttonSize: 40,
                fillColor: FlutterFlowTheme.of(context).accent1,
                icon: Icon(
                  Icons.table_rows_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24,
                ),
                onPressed: () {
                  widget.Skey.currentState!.openDrawer();
                },
              ),
            ),
            title: Text(
              'Home',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 0,
                  ),
            ),
            actions: [],
            elevation: 2,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [HomeSearchBar()],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children:
                          getTopicButtons(context).divide(SizedBox(width: 10)),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchQuestionCards,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _displayedCards(context).length,
                      itemBuilder: (BuildContext context, int index) {
                        return _displayedCards(context)[index];
                      },
                      //children: _listviewChildrens.divide(SizedBox(height: 20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
