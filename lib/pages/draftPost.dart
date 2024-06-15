import 'dart:io';
import 'package:dart_openai/dart_openai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnspace/Classes/Question.dart';
import 'package:learnspace/Classes/User.dart';
import 'package:learnspace/states.dart';
import 'package:provider/provider.dart';

class DraftPostWidget extends StatefulWidget {
  const DraftPostWidget({super.key});

  @override
  State<DraftPostWidget> createState() => _DraftPostWidgetState();
}

class _DraftPostWidgetState extends State<DraftPostWidget> {
  late DraftPostModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool attached = false;

  List<String> _topics = [""];

  late File image;

  Widget getImage() {
    if (attached == false) {
      return SizedBox(
        height: 0.01,
      );
    }

    return Image.file(
      image,
      width: 300,
      height: 200,
      fit: BoxFit.cover,
    );

    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(8),
    //   child: Image.network(
    //     image,
    //     width: 300,
    //     height: 200,
    //     fit: BoxFit.cover,
    //   ),
    // );
  }

  Widget getAttachButton() {
    if (attached == false) {
      return FlutterFlowIconButton(
        borderColor: FlutterFlowTheme.of(context).primary,
        borderRadius: 20,
        borderWidth: 1,
        buttonSize: 40,
        icon: Icon(
          Icons.attach_file,
          color: FlutterFlowTheme.of(context).primaryText,
          size: 24,
        ),
        onPressed: () async {
          var pickedImage = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            imageQuality: 100,
            maxWidth: 7000,
          );
          if (pickedImage != null) {
            File pickedImageFile = File(pickedImage.path);
            setState(() {
              attached = true;
              image = pickedImageFile;
            });
          }
        },
      );
    } else {
      return FlutterFlowIconButton(
        borderColor: FlutterFlowTheme.of(context).primary,
        borderRadius: 20,
        borderWidth: 1,
        buttonSize: 40,
        icon: Icon(
          Icons.close,
          color: FlutterFlowTheme.of(context).primaryText,
          size: 24,
        ),
        onPressed: () {
          setState(() {
            attached = false;
          });
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DraftPostModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  String? selectedTopic;
  String _postStatus = "Post";
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    final myStates = Provider.of<MyStates>(context);
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Draft question',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  letterSpacing: 0,
                ),
          ),
          leading: FlutterFlowIconButton(
            borderRadius: 20,
            buttonSize: 40,
            icon: Icon(
              Icons.chevron_left,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
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
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 20, 0, 0),
                      child: Text(
                        'Topic',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Manrope',
                              fontSize: 12,
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                    FlutterFlowDropDown(
                      options: myStates.topics,
                      onChanged: (val) {
                        selectedTopic = val;
                        setState(() => _model.dropDownValue = val);
                      },
                      width: 300,
                      height: 56,
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Manrope',
                                letterSpacing: 0,
                              ),
                      hintText: 'Please select...',
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24,
                      ),
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      elevation: 2,
                      borderColor: FlutterFlowTheme.of(context).alternate,
                      borderWidth: 2,
                      borderRadius: 8,
                      margin: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
                      hidesUnderline: true,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Text(
                              'Question',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Manrope',
                                    fontSize: 12,
                                    letterSpacing: 0,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 10, 8, 0),
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Manrope',
                                    letterSpacing: 0,
                                  ),
                          hintStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Manrope',
                                    letterSpacing: 0,
                                  ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Manrope',
                              letterSpacing: 0,
                            ),
                        maxLines: null,
                        minLines: 25,
                        validator:
                            _model.textControllerValidator.asValidator(context),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                      child: getImage(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage, 
                          style: TextStyle(
                            color: Colors.red[500],
                          )
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (selectedTopic == null) {
                                  setState(() {
                                    _errorMessage = "Please choose a topic!";
                                  });
                                  return;
                                } else if (_model.textController.text == "") {
                                  setState(() {
                                    _errorMessage = "Please enter a content!";
                                  });
                                  return;
                                }

                                if (attached == true && selectedTopic != null) {
                                  setState(() {
                                    _postStatus = "...";
                                  });
                                  Question uploadingQuestion =
                                      Question.getEmpty();
                                  uploadingQuestion
                                      .setContent(_model.textController.text);
                                  uploadingQuestion.setPlusPoint(10);
                                  uploadingQuestion
                                      .setQuestionType(selectedTopic!);

                                  await uploadingQuestion.uploadQuestion(
                                      myStates.currentUser, image);


                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    _postStatus = "...";
                                  });
                                  Question uploadingQuestion =
                                      Question.getEmpty();
                                  uploadingQuestion
                                      .setContent(_model.textController.text);
                                  uploadingQuestion.setPlusPoint(10);
                                  uploadingQuestion
                                      .setQuestionType(selectedTopic!);

                                  await uploadingQuestion
                                      .uploadQuestionWithoutAttachment(
                                          myStates.currentUser);


                                  Navigator.pop(context);
                                }
                              },
                              text: _postStatus,
                              options: FFButtonOptions(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: 40,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24, 0, 24, 0),
                                iconPadding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Manrope',
                                      color: Colors.white,
                                      letterSpacing: 0,
                                    ),
                                elevation: 3,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          getAttachButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DraftPostModel extends FlutterFlowModel<DraftPostWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController? dropDownValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
