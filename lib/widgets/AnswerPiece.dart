import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:learnspace/Classes/Answer.dart';
import 'package:learnspace/Classes/Comment.dart';
import 'package:learnspace/Classes/Question.dart';
import 'package:learnspace/pages/draftComment.dart';
import 'package:learnspace/widgets/CommentPiece.dart';

class AnswerPiece extends StatefulWidget {
  AnswerPiece({super.key});

  late Question question;

  late Answer answer;

  AnswerPiece.getAnswer(this.question, this.answer, {super.key});

  @override
  State<AnswerPiece> createState() => _AnswerPieceState();
}

class _AnswerPieceState extends State<AnswerPiece> {
  List<CommentPiece> commentPieces = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Widget> _getCommentChildren() {
    List<Widget> defaultWidgets = [
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
              child: Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  widget.answer.user.profilePictureUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Text(
                      widget.answer.user.username,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Manrope',
                            letterSpacing: 0,
                          ),
                    ),
                  ),
                  Text(
                    widget.answer.user.role,
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Manrope',
                          fontSize: 11,
                          letterSpacing: 0,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 10),
                child: Text(
                  widget.answer.content,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Manrope',
                        letterSpacing: 0,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: FFButtonWidget(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DraftCommentWidget.getAnswer(
                          widget.question, widget.answer)),
                );
              },
              text: 'Add Comment',
              options: FFButtonOptions(
                width: MediaQuery.sizeOf(context).width * 0.95,
                height: 30,
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Manrope',
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 10,
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
        ],
      ),
    ];
    _getCommentPieces();

    defaultWidgets.addAll(commentPieces);

    return defaultWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: _getCommentChildren(),
      ),
    );
  }

  void _getCommentPieces() {
    List<CommentPiece> pieces = [];

    for (Comment c in widget.answer.comments) {
      CommentPiece cp = CommentPiece.getComment(c);
      print(c.date);
      pieces.add(cp);
    }
    

    pieces.sort((a, b) => a.comment.date.compareTo(b.comment.date));

    setState(() {
      commentPieces = pieces;
    });
  }
}
