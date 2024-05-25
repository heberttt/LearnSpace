import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnspace/pages/LoginUI.dart';
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

late var SKey;

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
    _widgetOptions = [MainWidget.getUser(_user), Text("hi")];
  }

  @override
  Widget build(BuildContext context) {
    SKey = HomeScaffoldKey;
    return SafeArea(
      child: Scaffold(
        key: SKey,
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

  MainWidget.getUser(this.user, {super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  late MainModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainModel());
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
                SKey.currentState!.openDrawer();
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
                      children: [],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: FlutterFlowDropDown(
                    options: [widget.user.email, 'Rule 2:'],
                    onChanged: (val) =>
                        setState(() => _model.dropDownValue = val),
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
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                        child: QuestionCard(),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                        child: QuestionCard(),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                        child: QuestionCard(),
                      ),
                    ].divide(SizedBox(height: 20)),
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

class QuestionCard extends StatefulWidget {
  const QuestionCard({super.key});

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                    child: Text(
                      '2 hours ago',
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Manrope',
                            letterSpacing: 0,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Container(
                    width: 70,
                    height: 70,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/learnspacefirebase.appspot.com/o/user-profile.png?alt=media&token=59e8130d-c794-4125-a83e-22a7482bd81b',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Manrope',
                              fontSize: 20,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        'Student',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Manrope',
                              letterSpacing: 0,
                            ),
                      ),
                    ].divide(SizedBox(height: 5)),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: FlutterFlowTheme.of(context).accent4,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: 100,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How do you create custom widget in flutter?',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Manrope',
                                    letterSpacing: 0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'Answer',
                  options: FFButtonOptions(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    height: 40,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Manrope',
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                    elevation: 3,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(360),
                      bottomRight: Radius.circular(360),
                      topLeft: Radius.circular(360),
                      topRight: Radius.circular(360),
                    ),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '+5',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Manrope',
                                  letterSpacing: 0,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ].divide(SizedBox(width: 10)),
            ),
          ),
        ],
      ),
    );
  }
}
