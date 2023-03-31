
import '../backend/api_requests/api_calls.dart';
import '../custom_code/actions/shimmer.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';


class LichChamCongThangCopyWidget extends StatefulWidget {
  const LichChamCongThangCopyWidget({Key? key}) : super(key: key);

  @override
  _LichChamCongThangCopyWidgetState createState() =>
      _LichChamCongThangCopyWidgetState();
}

class _LichChamCongThangCopyWidgetState
    extends State<LichChamCongThangCopyWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: PTCTimekeepCall.call(
        userName: FFAppState().userName,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return ShimmerLoading();
        }
        final lichChamCongThangCopyPTCTimekeepResponse = snapshot.data;
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
                context.pushNamed('NavigationBar');
              },
            ),
            title: Text(
              'Lịch chấm công',
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
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: custom_widgets.ChamCongThang(
                  width: double.infinity,
                  height: double.infinity,
                  timeKeep: getJsonField(
                    lichChamCongThangCopyPTCTimekeepResponse!.jsonBody,
                    r'''$.listObj''',
                  ).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
