
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:learnspace/Classes/Question.dart';
import 'package:learnspace/pages/QnA.dart';
import 'package:learnspace/states.dart';
import 'package:provider/provider.dart';

class QuestionCard extends StatefulWidget {
  QuestionCard({super.key});

  Question question = Question("");

  bool _toggleValue = false;

  QuestionCard.getQuestion(this.question, {super.key});
  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  void initState() {
    super.initState();
  }


  void _getToggleValue(BuildContext context) {
    final myStates = Provider.of<MyStates>(context);

    if (myStates.currentUser.savedQuestionIDs
        .contains(widget.question.questionID)) {
      setState(() {
        widget._toggleValue = true;
      });
    }
  }

  void _pressToggleIcon(BuildContext context) {
    final myStates = Provider.of<MyStates>(context);


    if (widget._toggleValue) {
      setState(() {
        widget._toggleValue = false;
      });
    } else {
      setState(() {
        widget._toggleValue = true;
      });

      setState(() {
        widget._toggleValue = true;
      });
      //myStates.currentUser.addSavedQuestionID(widget.question.questionID);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getToggleValue(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                      child: Text(
                        widget.question.date,
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        widget.question.user.profilePictureUrl,
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
                          widget.question.user.username,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Manrope',
                                    fontSize: 20,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w800,
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
                      ].divide(SizedBox(height: 5)),
                    ),
                  ),
                ],
              ),
            ),
            const Opacity(
              opacity: 0.5,
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
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
                            widget.question.content,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
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
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FFButtonWidget(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QuestionPageWidget.getQuestion(
                                    widget.question)),
                      );
                    },
                    text: 'Answer',
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      height: 40,
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Manrope',
                                color: Colors.white,
                                letterSpacing: 0,
                              ),
                      elevation: 3,
                      borderSide: const BorderSide(
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
                      borderRadius: const BorderRadius.only(
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
                              '+${widget.question.plusPoint}',
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
                  ToggleIcon(
                    onPressed: () {
                      final myStates = Provider.of<MyStates>(context, listen: false);
                      if(!widget._toggleValue){
                        myStates.currentUser.addSavedQuestionID(widget.question.questionID);
                      }else{
                        myStates.currentUser.deleteSavedQuestionID(widget.question.questionID);
                      }
                      setState(() {
                        widget._toggleValue = !widget._toggleValue;
                      });
                      
                      
                      
                      
                      
                    },
                    value: widget._toggleValue,
                    onIcon: Icon(
                      Icons.bookmark,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 25,
                    ),
                    offIcon: Icon(
                      Icons.bookmark_border,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 25,
                    ),
                  ),
                ].divide(SizedBox(width: 10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
