import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learnspace/pages/CreateAccount.dart';
import 'Home.dart';
import '../Classes/User.dart';

class LoginUIModel extends FlutterFlowModel<LoginUIWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}

class LoginUIWidget extends StatefulWidget {
  const LoginUIWidget({super.key});

  @override
  State<LoginUIWidget> createState() => _LoginUIWidgetState();
}

class _LoginUIWidgetState extends State<LoginUIWidget> {
  late LoginUIModel _model;


  void _signOut() {
    FirebaseAuth.instance.signOut();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSigningIn = false;

  

  Future<void> _signInWithEmail(String email, String password) async {
    setState(() {
      _isSigningIn = true;
    });
    try {
      final userCredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print(userCredentials);
      
      

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home.getUser2(FirebaseAuth.instance.currentUser!.uid)),
      );
    } catch (e) {
      print("Something went wrong");
    }
    setState(() {
      _isSigningIn = false;
    });
  }

  String _signInStatus() {
    if (_isSigningIn) {
      return "Loading...";
    }
    return "Sign In";
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginUIModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/LearnSpaceLogo.png',
                          width: 170,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 100,
                    height: 15,
                    decoration: const BoxDecoration(),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back!',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: 'Outfit',
                              fontSize: 40,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 30,
                        decoration: const BoxDecoration(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              25, 0, 25, 0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _model.textController1,
                              focusNode: _model.textFieldFocusNode1,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Enter your email ',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Manrope',
                                      letterSpacing: 0,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Manrope',
                                      letterSpacing: 0,
                                    ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        15, 0, 15, 0),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Manrope',
                                    letterSpacing: 0,
                                  ),
                              validator: _model.textController1Validator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 30,
                        decoration: const BoxDecoration(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              25, 0, 25, 0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              obscureText: true,
                              controller: _model.textController2,
                              focusNode: _model.textFieldFocusNode2,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: 'Enter your password',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Manrope',
                                      letterSpacing: 0,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Manrope',
                                      letterSpacing: 0,
                                    ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        15, 0, 15, 0),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Manrope',
                                    letterSpacing: 0,
                                  ),
                              validator: _model.textController2Validator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 50,
                        decoration: const BoxDecoration(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          child: Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: FFButtonWidget(
                              onPressed: () {
                                String enteredEmail =
                                    _model.textController1.text;
                                String enteredPassword =
                                    _model.textController2.text;

                                _signInWithEmail(enteredEmail, enteredPassword);
                              },
                              text: _signInStatus(),
                              options: FFButtonOptions(
                                width: 300,
                                height: 40,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Manrope',
                                      color: Colors.white,
                                      letterSpacing: 0,
                                    ),
                                elevation: 3,
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: InkWell(
                          onTap: () {
                            print("Go to create new user");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateAccountWidget()),
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Text(
                              'New user? Create account here',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Manrope',
                                    color: const Color(0xFF6CA0EF),
                                    letterSpacing: 0,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Opacity(
                    opacity: 0.3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
                      child: Divider(
                        height: 0,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).secondary,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                      child: Text(
                        'or Sign in with:',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Manrope',
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "assets/images/Google_Logo.png",
                          height: 30,
                        ),
                        onPressed: () {
                          //signInWithGoogle();
                        },
                      ),
                      const SizedBox(width: 45),
                      IconButton(
                        icon: Image.asset(
                          "assets/images/Microsoft_icon.png",
                          height: 30,
                        ),
                        onPressed: () {
                          print(FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User? user) {
                            if (user == null) {
                              print('User is currently signed out!');
                            } else {
                              print('User is signed in!');
                            }
                          }));
                        },
                      ),
                      IconButton(
                          onPressed: _signOut, icon: const Icon(Icons.favorite))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// signInWithGoogle() async {
//   GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//   GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

//   AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

//   UserCredential userCredential =
//       await FirebaseAuth.instance.signInWithCredential(credential);

//   print(userCredential.user?.displayName);
// }
