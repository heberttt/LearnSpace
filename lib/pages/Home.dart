import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnspace/Classes/Question.dart';
import 'package:learnspace/pages/LoginUI.dart';
import 'package:learnspace/pages/Profile.dart';
import 'package:learnspace/widgets/QuestionCard.dart';
import 'package:learnspace/widgets/SearchBar.dart';
import 'package:provider/provider.dart';
import '../Classes/User.dart';

class Home extends StatefulWidget {
  Home({super.key});

  LearnSpaceUser user = LearnSpaceUser();

  Home.getUser2(String userUID, {super.key}) {
    user.setId(userUID);
    user.getOtherInfoFromUID();
  }

  Home.getUser(this.user, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late LearnSpaceUser _user;
  double vdheight = 4;

  void showSideBar() {
    HomeScaffoldKey.currentState?.openDrawer();
  }

  final HomeScaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _widgetOptions = [];

  final authenticatedUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    LearnSpaceUser _user = widget.user;
    _widgetOptions = [
      MainWidget.getUser(_user, HomeScaffoldKey),
      ProfileWidget.getUser(_user)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('FloatingActionButton pressed ...');
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8,
          child: Icon(
            Icons.add,
            color: FlutterFlowTheme.of(context).info,
            size: 24,
          ),
        ),
        key: HomeScaffoldKey,
        body: _widgetOptions[_selectedIndex],
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

class MainWidget extends StatefulWidget {
  MainWidget({super.key});

  LearnSpaceUser user = LearnSpaceUser();

  late GlobalKey<ScaffoldState> Skey;

  MainWidget.getUser(this.user, this.Skey, {super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  late MainModel _model;

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
    _fetchQuestionCards();
    super.initState();
    _model = createModel(context, () => MainModel());
  }

  List<Widget> _listviewChildrens = [];

  Future<void> _fetchQuestionCards() async {
    questionCards = await getQuestionCards();
    List<Widget> _listviewChildrens = [
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child: FlutterFlowDropDown(
          options: [widget.user.email, 'Rule 2:'],
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
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
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
                print("Open drawer!");
              },
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
            centerTitle: false,
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
                  padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FFButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          text: 'Recommended',
                          options: FFButtonOptions(
                            height: 35,
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Manrope',
                                  color: Colors.white,
                                  fontSize: 10,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          text: 'Java',
                          options: FFButtonOptions(
                            height: 35,
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Manrope',
                                  color: Colors.white,
                                  fontSize: 10,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          text: 'Mobile App',
                          options: FFButtonOptions(
                            height: 35,
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Manrope',
                                  color: Colors.white,
                                  fontSize: 10,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          text: 'System Development Methodology',
                          options: FFButtonOptions(
                            height: 35,
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Manrope',
                                  color: Colors.white,
                                  fontSize: 10,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ].divide(SizedBox(width: 10)),
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
                      itemCount: _listviewChildrens.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _listviewChildrens[index];
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
