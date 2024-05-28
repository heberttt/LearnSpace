import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:learnspace/Classes/Answer.dart';
import 'package:learnspace/Classes/Comment.dart';
import 'package:learnspace/widgets/CommentPiece.dart';

class AnswerPiece extends StatefulWidget {
  AnswerPiece({super.key});

  late Answer answer;

  AnswerPiece.getAnswer(this.answer, {super.key});

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
      pieces.add(cp);
    }

    commentPieces = pieces;
  }
}
