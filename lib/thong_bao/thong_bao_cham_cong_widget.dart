import '../backend/api_requests/api_calls.dart';
import '../custom_code/actions/shimmer.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class ThongBaoChamCongWidget extends StatefulWidget {
  const ThongBaoChamCongWidget({super.key});

  @override
  State<ThongBaoChamCongWidget> createState() => _ThongBaoChamCongWidgetState();
}

class _ThongBaoChamCongWidgetState extends State<ThongBaoChamCongWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> listAlert = [];

  String calculateTimeLeft(String inputDate) {
    String timeLeft = '';
    DateTime futureDate = DateTime.parse(inputDate);
    DateTime currentDate = DateTime.now();
    int seconds = futureDate.difference(currentDate).inSeconds;
    int minutes = (seconds / 60).floor();
    int hours = (minutes / 60).floor();
    int days = (hours / 24).floor();

    if (seconds <= 59) {
      seconds = seconds.abs();
      timeLeft = '$seconds giây';
    }
    if (seconds >= 60 && minutes <= 59) {
      minutes = minutes.abs();
      timeLeft = '$minutes phút';
    }
    if (minutes >= 60 && hours <= 23) {
      hours = hours.abs();
      timeLeft = '$hours giờ';
    }
    if (hours >= 24) {
      days = days.abs();
      timeLeft = '$days ngày';
    }
    return timeLeft;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PTCGetAlertTimekeep.call(userName: FFAppState().userName),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return ShimmerLoading();
        }
        if (getJsonField(snapshot.data!.jsonBody, r'''$.isSuccess''')) {
          listAlert =
              getJsonField(snapshot.data!.jsonBody, r'''$.listObj''').toList();
        }

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
              'Thông báo chấm công',
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
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: listAlert.length,
                itemBuilder: ((context, index) {
                  var item = listAlert[index];
                  return Container(   
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),  
                    color: item["MessageStatus"].toString() == "N" ? Colors.black12 : Colors.transparent,               
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Image.network(
                            FFAppState().imageUser,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [          
                                Text(
                                  item["Message"],
                                  maxLines: 3,
                                  style:                                    
                                   TextStyle(                                    
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 3, 0, 0),
                                  child: Text(
                                    calculateTimeLeft(
                                      item["CreatedDate"].toString(),
                                    ),
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      }),
    );

    // return FutureBuilder<ApiCallResponse>(
    //   future: PTCTimekeepCall.call(
    //     userName: FFAppState().userName,
    //   ),
    //   builder: (context, snapshot) {
    //     // Customize what your widget looks like when it's loading.
    //     if (!snapshot.hasData) {
    //       return ShimmerLoading();
    //     }

    //     return Scaffold(
    //       key: scaffoldKey,
    //       appBar: AppBar(
    //         backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
    //         automaticallyImplyLeading: false,
    //         leading: FlutterFlowIconButton(
    //           borderColor: Colors.transparent,
    //           borderRadius: 30,
    //           borderWidth: 1,
    //           buttonSize: 50,
    //           icon: Icon(
    //             Icons.arrow_back_ios_outlined,
    //             color: FlutterFlowTheme.of(context).backgroundComponents,
    //             size: 24,
    //           ),
    //           onPressed: () async {
    //             context.pushNamed('NavigationBar');
    //           },
    //         ),
    //         title: Text(
    //           'Lịch chấm công',
    //           style: FlutterFlowTheme.of(context).subtitle2.override(
    //                 fontFamily: 'Inter',
    //                 color: FlutterFlowTheme.of(context).backgroundComponents,
    //               ),
    //         ),
    //         actions: [
    //           Padding(
    //             padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
    //             child: Container(
    //               width: 90,
    //               height: 90,
    //               clipBehavior: Clip.antiAlias,
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //               ),
    //               child: InkWell(
    //                 onTap: () {
    //                   context.pushNamed('ProfilePage');
    //                 },
    //                 child: Image.network(
    //                   FFAppState().imageUser,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //         centerTitle: false,
    //         elevation: 1,
    //       ),
    //       backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
    //       body: SafeArea(
    //           child: Container(
    //         color: Colors.amber,
    //       )),
    //     );
    //   },
    // );
  }
}
