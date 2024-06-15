import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnspace/Classes/Answer.dart';
import 'package:learnspace/Classes/Question.dart';
import 'package:learnspace/pages/draftAnswer.dart';
import 'package:learnspace/pages/draftPost.dart';
import 'package:learnspace/states.dart';
import 'package:learnspace/widgets/AnswerPiece.dart';
import 'package:provider/provider.dart';

class QuestionPageWidget extends StatefulWidget {
  QuestionPageWidget({super.key});

  Question question = Question("");

  QuestionPageWidget.getQuestion(this.question, {super.key});

  @override
  State<QuestionPageWidget> createState() => _QuestionPageWidgetState();
}

class _QuestionPageWidgetState extends State<QuestionPageWidget> {
  late QuestionPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<AnswerPiece> answerPieces = [];

  List<Widget> _actionChildren = [];



  @override
  void initState() {
    _updateQuestion();
    super.initState();
    _model = createModel(context, () => QuestionPageModel());
  }

  Future<void> _updateQuestion() async {
    Question newQuestion = widget.question;
    await newQuestion.getOtherDataFromID();

    setState(() {
      widget.question = newQuestion;
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Widget _getAnswerButton(BuildContext context) {
    final myStates = Provider.of<MyStates>(context);
    if(widget.question.user.id == myStates.currentUser.id){
      setState(() {
        _actionChildren = [
          IconButton(onPressed: (){
            widget.question.deleteQuestion();
          }, icon: const Icon(Icons.delete, color: Colors.white,))
        ];
      });
      return FFButtonWidget(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DraftAnswerWidget.getQuestionSelf(widget.question)),
          ).then((_) {
            _updateQuestion();
          });
        },
        text: "Comment",
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 0.95,
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
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }
    if (widget.question.checkIfAnsweredBefore(myStates.currentUser)) {
      return FFButtonWidget(
        onPressed: () {
          
        },
        text: "Answered, +${widget.question.plusPoint}!",
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 0.95,
          height: 40,
          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          color: Color.fromARGB(0, 59, 59, 59),
          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: 'Manrope',
                color: Colors.white,
                letterSpacing: 0,
              ),
          elevation: 1,
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    } else {
      return FFButtonWidget(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DraftAnswerWidget.getQuestion(widget.question)),
          ).then((_) {
            _updateQuestion();
          });
        },
        text: "Answer",
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 0.95,
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
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }
  }

  Widget _getAttachmentIfExists() {
    if (widget.question.attachementURL != "") {
      return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(widget.question.attachementURL,
              width: 300, height: 200, fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return child;
          }, loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }));
    }
    return const SizedBox(height: 0);
  }

  List<Widget> _getListViewChildren() {
    List<Widget> defaultChildren = [
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Container(
                        width: 120,
                        height: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          widget.question.user.profilePictureUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.question.user.username,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Manrope',
                                    fontSize: 25,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          widget.question.user.role,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Manrope',
                                    letterSpacing: 0,
                                  ),
                        ),
                      ],
                    ),
                  ].divide(SizedBox(width: 20)),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.question.questionType,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Manrope',
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 30, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.95,
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.question.content,
                          textAlign: TextAlign.start,
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
            padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 20),
            child: _getAttachmentIfExists(),
          ),
          _getAnswerButton(context),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                child: Text(
                  'Answers',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Manrope',
                        letterSpacing: 0,
                      ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: FlutterFlowTheme.of(context).accent4,
          ),
        ].divide(SizedBox(
          height: 10,
        )),
      ),
    ];

    _getAnswerPieces();

    defaultChildren.addAll(answerPieces);

    return defaultChildren;
  }

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
            borderColor: FlutterFlowTheme.of(context).primary,
            borderRadius: 20,
            borderWidth: 1,
            buttonSize: 40,
            fillColor: FlutterFlowTheme.of(context).accent1,
            icon: Icon(
              Icons.chevron_left,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: _actionChildren,
          centerTitle: false,
          elevation: 2,
          
        ),
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            onRefresh: _updateQuestion,
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children:
                  _getListViewChildren().divide(const SizedBox(height: 15)),
            ),
          ),
        ),
      ),
    );
  }

  void _getAnswerPieces() {
    List<AnswerPiece> pieces = [];

    for (Answer a in widget.question.answers) {
      AnswerPiece ap = AnswerPiece.getAnswer(widget.question, a);
      pieces.add(ap);
    }

    pieces.sort((b, a) => a.answer.date.compareTo(b.answer.date));

    answerPieces = pieces;
  }
}

class QuestionPageModel extends FlutterFlowModel<QuestionPageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
