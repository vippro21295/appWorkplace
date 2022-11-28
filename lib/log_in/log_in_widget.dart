import 'dart:async';

import '../backend/api_requests/api_calls.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../custom_code/actions/index.dart' as actions;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInWidget extends StatefulWidget {
  const LogInWidget({Key? key}) : super(key: key);

  @override
  _LogInWidgetState createState() => _LogInWidgetState();
}

class _LogInWidgetState extends State<LogInWidget> {
  ApiCallResponse? responseLogin;
  TextEditingController? tfPassWordController;

  late bool tfPassWordVisibility;
  TextEditingController? tfUserNameController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tfPassWordController = TextEditingController();
    tfPassWordVisibility = false;
    tfUserNameController = TextEditingController();
    autoLogin();
  }

  @override
  void dispose() {
    tfPassWordController?.dispose();
    tfUserNameController?.dispose();
    super.dispose();
  }

  Future<void> autoLogin() async {
    if (FFAppState().userName != "" && FFAppState().passWord != "") {
      responseLogin = await PTCLoginCall.call(
        userName: FFAppState().userName,
        password: FFAppState().passWord,
      );
      if (getJsonField(
        (responseLogin?.jsonBody ?? ''),
        r'''$.isSuccess''',
      )) {
        context.pushNamed('ChamCong');
      } else {
        actions.toastMessageCustom(context, "Success", "Thất bại",
            "Tài khoản hoặc mật khẩu không chính xác");
      }
    }
  }

  Future<void> login() async {
    if (validation()) {
      responseLogin = await PTCLoginCall.call(
        userName: tfUserNameController!.text,
        password: tfPassWordController!.text,
      );

      if (getJsonField(
        (responseLogin?.jsonBody ?? ''),
        r'''$.isSuccess''',
      )) {
        setState(() => FFAppState().userName = tfUserNameController!.text);
        setState(() => FFAppState().passWord = tfPassWordController!.text);
        setState(() => FFAppState().imageUser = getJsonField(
              (responseLogin?.jsonBody ?? ''),
              r'''$.imageUser''',
            ));
        setState(() => FFAppState().departmentId = getJsonField(
              (responseLogin?.jsonBody ?? ''),
              r'''$.deparmentId''',
            ));

        context.pushNamed('ChamCong');
      } else {
        actions.toastMessage(context, "Error", "Thất bại",
            "Tài khoản hoặc mật khẩu không chính xác");
      }
      setState(() {});
    }
  }

  bool validation() {
    if (tfUserNameController!.text == "") {
      actions.toastMessage(context, "Warning", "Lỗi", "Vui lòng nhập Username");
      return false;
    }

    if (tfPassWordController!.text == "") {
      actions.toastMessage(context, "Warning", "Lỗi", "Vui lòng nhập Password");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).theme2,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Image.asset(
                    'assets/images/Framemaillogo.png',
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.05, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(35, 0, 35, 10),
                    child: Image.asset(
                      'assets/images/Logo_ngang_@2x_1logo_Wp.png',
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: tfUserNameController,
                            //autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'User name',
                              hintText: 'Nhập tên đăng nhập',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).theme3,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).theme3,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).stateRED2,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).stateRED2,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context).filltext,
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      lineHeight: 2,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: tfPassWordController,
                            //autofocus: true,
                            obscureText: !tfPassWordVisibility,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Nhập mật khẩu',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).theme3,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).theme3,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).stateRED2,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).stateRED2,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context).filltext,
                              suffixIcon: InkWell(
                                onTap: () => setState(
                                  () => tfPassWordVisibility =
                                      !tfPassWordVisibility,
                                ),
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  tfPassWordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Color(0xFF757575),
                                  size: 20,
                                ),
                              ),
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      lineHeight: 2,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF175ACD), Color(0xFF00558F)],
                          stops: [0, 1],
                          begin: AlignmentDirectional(0.87, -1),
                          end: AlignmentDirectional(-0.87, 1),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FFButtonWidget(
                        onPressed: () async {
                          login();
                        },
                        text: 'Đăng nhập',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 55,
                          color: FlutterFlowTheme.of(context).tertiaryColor,
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Inter',
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
                                fontSize: 16,
                              ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                            'ForgotPassword',
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        },
                        text: 'Quên mật khẩu?',
                        options: FFButtonOptions(
                          width: 160,
                          height: 40,
                          elevation: 0,
                          color: Colors.white,
                          textStyle:
                              FlutterFlowTheme.of(context).subtitle2.override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF007AFF),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 160,
                            height: 20,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 0, 0),
                                  child: Text(
                                    '1800 6610',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 190,
                            height: 20,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.globe,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 0, 0),
                                    child: Text(
                                      'https://phattien.com',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
