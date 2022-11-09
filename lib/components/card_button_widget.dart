import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class CardButtonWidget extends StatefulWidget {
  const CardButtonWidget({Key? key}) : super(key: key);

  @override
  _CardButtonWidgetState createState() => _CardButtonWidgetState();
}

class _CardButtonWidgetState extends State<CardButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(2, 4),
          )
        ],
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
            child: Image.network(
              '',
              width: 50,
              height: 50,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
            child: Text(
              'Phone Number',
              style: FlutterFlowTheme.of(context).bodyText2.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional(0.9, 0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
