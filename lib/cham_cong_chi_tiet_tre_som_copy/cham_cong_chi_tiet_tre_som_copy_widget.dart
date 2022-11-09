import 'package:app_workplace/index.dart';
import '../backend/api_requests/api_calls.dart';
import '../custom_code/actions/shimmer.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';

class ChamCongChiTietTreSomCopyWidget extends StatefulWidget {
  const ChamCongChiTietTreSomCopyWidget({
    Key? key,
    this.dateSelected,
  }) : super(key: key);

  final String? dateSelected;

  @override
  _ChamCongChiTietTreSomCopyWidgetState createState() =>
      _ChamCongChiTietTreSomCopyWidgetState();
}

class _ChamCongChiTietTreSomCopyWidgetState
    extends State<ChamCongChiTietTreSomCopyWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: PTCDetailDateCall.call(
        userName: FFAppState().userName,
        selectDate: DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(widget.dateSelected.toString())),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return ShimmerLoading();
        }
        final chamCongChiTietTreSomCopyPTCDetailDateResponse = snapshot.data!;
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              borderWidth: 1,
              buttonSize: 50,
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: FlutterFlowTheme.of(context).backgroundComponents,
                size: 24,
              ),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LichChamCongThangCopyWidget()));
              },
            ),
            title: Text(
              'Chấm công chi tiết',
              style: FlutterFlowTheme.of(context).subtitle2.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).backgroundComponents,
                  ),
            ),
            actions: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                child: Container(
                  width: 90,
                  height: 90,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () {
                      context.pushNamed('ProfilePage');
                    },
                    child: Image.network(
                      FFAppState().imageUser,
                    ),
                  ),
                ),
              ),
            ],
            centerTitle: false,
            elevation: 1,
          ),
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: custom_widgets.ChamCongChiTiet(
                    width: double.infinity,
                    height: double.infinity,
                    listDate: getJsonField(
                        chamCongChiTietTreSomCopyPTCDetailDateResponse.jsonBody,
                        r'''$.listDate'''),
                    listTS: getJsonField(
                            chamCongChiTietTreSomCopyPTCDetailDateResponse
                                .jsonBody,
                            r'''$.listTS''')
                        .toList(),
                    listCT: getJsonField(
                            chamCongChiTietTreSomCopyPTCDetailDateResponse
                                .jsonBody,
                            r'''$.listCT''')
                        .toList(),
                    listTC: getJsonField(
                            chamCongChiTietTreSomCopyPTCDetailDateResponse
                                .jsonBody,
                            r'''$.listTC''')
                        .toList(),
                    listTypeTS: getJsonField(
                            chamCongChiTietTreSomCopyPTCDetailDateResponse
                                .jsonBody,
                            r'''$.listTypeTS''')
                        .toList(),
                    listTypeCT: getJsonField(
                            chamCongChiTietTreSomCopyPTCDetailDateResponse
                                .jsonBody,
                            r'''$.listTypeCT''')
                        .toList(),
                    listReason: getJsonField(
                            chamCongChiTietTreSomCopyPTCDetailDateResponse
                                .jsonBody,
                            r'''$.listReason''')
                        .toList(),
                         listReasonFurlough: getJsonField(
                            chamCongChiTietTreSomCopyPTCDetailDateResponse
                                .jsonBody,
                            r'''$.listReasonFurlough''')
                        .toList(),
                    listTimesheet: getJsonField(
                            chamCongChiTietTreSomCopyPTCDetailDateResponse
                                .jsonBody,
                            r'''$.listTimesheet''')
                        .toList(),
                    listHoliday: getJsonField(
                            chamCongChiTietTreSomCopyPTCDetailDateResponse
                                .jsonBody,
                            r'''$.listHoliday''')
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
