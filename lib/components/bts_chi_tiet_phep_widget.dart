import 'package:app_workplace/custom_code/model/furlough.dart';
import '../backend/api_requests/api_calls.dart';
import '../custom_code/model/furlough_ticket.dart';
import '../flutter_flow/flutter_flow_drop_down.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import '../../custom_code/actions/index.dart' as actions;



class BtsChiTietPhepWidget extends StatefulWidget {
  const BtsChiTietPhepWidget(
      {Key? key, this.listFurlough, this.furloughNP, this.updateList})
      : super(key: key);

  final List<FurloughTicket>? listFurlough;
  final Furlough? furloughNP;
  final updateList;
  @override
  _BtsChiTietPhepWidgetState createState() =>
      _BtsChiTietPhepWidgetState(listFurlough!, furloughNP!);
}

class _BtsChiTietPhepWidgetState extends State<BtsChiTietPhepWidget> {
  String? dropDownFurlough;
  List<double> noSalary = [];
  ApiCallResponse? responseLeaveYear;
  List<FurloughTicket>? listFurlough;
  Furlough? furloughNP;
  _BtsChiTietPhepWidgetState(this.listFurlough, this.furloughNP);

  void removeFurlough(String date, int index) async {
    furloughNP!.numberFurlough =
        furloughNP!.numberFurlough! - listFurlough![index].numberFurlough!;
    setState(() {
      listFurlough!.removeWhere((element) => element.fromDate == date);
    });

    responseLeaveYear = await PTCGetLeaveYear.call(
        userName: FFAppState().userName, fromDate: date);

    if (responseLeaveYear != null) {
      if (getJsonField(
          (responseLeaveYear?.jsonBody ?? ''), r'''$.isSuccess''')) {
        setState(
          () {
            dynamic leaveYear = getJsonField(
                (responseLeaveYear?.jsonBody ?? ''), r'''$.lstObj''');
            if (leaveYear != null) {
              furloughNP!.leaveRemainPrevYear =
                  double.parse(leaveYear["LeaveRemainPrevYear"].toString());
              furloughNP!.avaiableLeaveRemain =
                  double.parse(leaveYear["AvaiableLeaveRemain"].toString());
              furloughNP!.loanLeave =
                  double.parse(leaveYear["LoanLeave"].toString());
              furloughNP!.maxLoanLeave =
                  double.parse(leaveYear["MaxLoanLeave"].toString());
            }
            var pT = furloughNP!.leaveRemainPrevYear! +
                furloughNP!.avaiableLeaveRemain!;
            var tUMax = furloughNP!.maxLoanLeave!;
            var sNN = furloughNP!.numberFurlough!;
            if (pT > sNN) {
              furloughNP!.annualLeave = sNN;
              furloughNP!.annualLeaveTemp = sNN;
              furloughNP!.tempLeave = 0;
              //furloughNPTemp.tempLeaveTemp = 0;
              noSalary = [];
              for (double i = 0; i <= sNN; i = i + 0.5) {
                noSalary.add(i);
              }
              furloughNP!.noSalary = 0;
              //furloughNPTemp.noSalaryTemp = 0;
              furloughNP!.leaveRemain = pT - furloughNP!.annualLeave!;
            } else {
              if (tUMax >= (sNN - pT)) {
                furloughNP!.annualLeave = pT;
                furloughNP!.annualLeaveTemp = pT;
                furloughNP!.tempLeave = sNN - pT;
                //furloughNPTemp.tempLeaveTemp = sNN - pT;
                noSalary = [];
                for (double i = 0; i <= sNN; i = i + 0.5) {
                  noSalary.add(i);
                }
                furloughNP!.noSalary = 0;
                //furloughNPTemp.noSalaryTemp = 0;
                furloughNP!.leaveRemain = pT - furloughNP!.annualLeave!;
              } else {
                furloughNP!.annualLeave = pT;
                furloughNP!.annualLeaveTemp = pT;
                furloughNP!.tempLeave = tUMax;
                //furloughNPTemp.annualLeaveTemp = tUMax;
                noSalary = [];
                for (double i = (sNN - pT - tUMax); i <= sNN; i = i + 0.5) {
                  noSalary.add(i);
                }
                furloughNP!.noSalary = sNN - pT - tUMax;
                // furloughNPTemp.noSalaryTemp = sNN - pT - tUMax;
                furloughNP!.leaveRemain = pT - furloughNP!.annualLeave!;
              }
            }
          },
        );
      }
    } else
      actions.toastMessage(
          context, "Warning", "Thông báo", "Không lấy được số phép tồn");
    
    widget.updateList(furloughNP, noSalary, listFurlough);
    
  }

  void changeHaftFurlough(
      int index, String haftFurlough, String dateFurlough) async {
    double number = 0;
    if (haftFurlough == '') {
      haftFurlough = 'P';
      listFurlough![index].numberFurlough = 1;
    }
    listFurlough![index].haftFurlough = haftFurlough;

    if (haftFurlough == "P1" || haftFurlough == "P2")
      listFurlough![index].numberFurlough = 0.5;

    if (listFurlough!.isNotEmpty) {
      listFurlough!.forEach((element) {
        number = number + double.parse(element.numberFurlough.toString());
      });
    }

    furloughNP!.numberFurlough = number;

    responseLeaveYear = await PTCGetLeaveYear.call(
        userName: FFAppState().userName, fromDate: dateFurlough);

    if (responseLeaveYear != null) {
      if (getJsonField(
          (responseLeaveYear?.jsonBody ?? ''), r'''$.isSuccess''')) {
        setState(
          () {
            dynamic leaveYear = getJsonField(
                (responseLeaveYear?.jsonBody ?? ''), r'''$.lstObj''');
            if (leaveYear != null) {
              furloughNP!.leaveRemainPrevYear =
                  double.parse(leaveYear["LeaveRemainPrevYear"].toString());
              furloughNP!.avaiableLeaveRemain =
                  double.parse(leaveYear["AvaiableLeaveRemain"].toString());
              furloughNP!.loanLeave =
                  double.parse(leaveYear["LoanLeave"].toString());
              furloughNP!.maxLoanLeave =
                  double.parse(leaveYear["MaxLoanLeave"].toString());
            }
            var pT = furloughNP!.leaveRemainPrevYear! +
                furloughNP!.avaiableLeaveRemain!;
            var tUMax = furloughNP!.maxLoanLeave!;
            var sNN = furloughNP!.numberFurlough!;
            if (pT > sNN) {
              furloughNP!.annualLeave = sNN;
              furloughNP!.annualLeaveTemp = sNN;
              furloughNP!.tempLeave = 0;
              noSalary = [];
              for (double i = 0; i <= sNN; i = i + 0.5) {
                noSalary.add(i);
              }
              furloughNP!.noSalary = 0;
              furloughNP!.leaveRemain = pT - furloughNP!.annualLeave!;
            } else {
              if (tUMax >= (sNN - pT)) {
                furloughNP!.annualLeave = pT;
                furloughNP!.annualLeaveTemp = pT;
                furloughNP!.tempLeave = sNN - pT;
                noSalary = [];
                for (double i = 0; i <= sNN; i = i + 0.5) {
                  noSalary.add(i);
                }
                furloughNP!.noSalary = 0;
                furloughNP!.leaveRemain = pT - furloughNP!.annualLeave!;
              } else {
                furloughNP!.annualLeave = pT;
                furloughNP!.annualLeaveTemp = pT;
                furloughNP!.tempLeave = tUMax;
                noSalary = [];
                for (double i = (sNN - pT - tUMax); i <= sNN; i = i + 0.5) {
                  noSalary.add(i);
                }
                furloughNP!.noSalary = sNN - pT - tUMax;
                furloughNP!.leaveRemain = pT - furloughNP!.annualLeave!;
              }
            }
          },
        );
      }
    } else
      actions.toastMessage(
          context, "Warning", "Thông báo", "Không lấy được số phép tồn");
    widget.updateList(furloughNP, noSalary, listFurlough);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).theme2,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5, 10, 5, 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  height: 20,
                  thickness: 4,
                  indent: 135,
                  endIndent: 135,
                  color: Color(0xFF7E8B9A),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFAFD5FF),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ngày',
                                style: FlutterFlowTheme.of(context).bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFAFD5FF),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Phép',
                                style: FlutterFlowTheme.of(context).bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFAFD5FF),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ca',
                                style: FlutterFlowTheme.of(context).bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFAFD5FF),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Xóa',
                                style: FlutterFlowTheme.of(context).bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                for (int i = 0; i < listFurlough!.length; i++) ...[
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                              color: i % 2 == 0
                                  ? Color(0x201D2428)
                                  : Color(0xFFFFFFFF),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  listFurlough![i].fromDate.toString(),
                                  style: FlutterFlowTheme.of(context).bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                              color: i % 2 == 0
                                  ? Color(0x201D2428)
                                  : Color(0xFFFFFFFF),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 5, 8, 5),
                              child: FlutterFlowDropDown(
                                options: ['P', 'P1', 'P2'],
                                onChanged: (val) => setState(() => {
                                      dropDownFurlough = val,
                                      changeHaftFurlough(i, dropDownFurlough!,
                                          listFurlough![i].fromDate.toString())
                                    }),
                                width: 80,
                                height: 38,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.black,
                                    ),
                                hintText: 'P',
                                fillColor:
                                    FlutterFlowTheme.of(context).stateGreen1,
                                elevation: 2,
                                borderColor:
                                    FlutterFlowTheme.of(context).tertiaryColor,
                                borderWidth: 0,
                                borderRadius: 10,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    10, 4, 10, 4),
                                hidesUnderline: true,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                              color: i % 2 == 0
                                  ? Color(0x201D2428)
                                  : Color(0xFFFFFFFF),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  listFurlough![i].shiftName.toString(),
                                  style: FlutterFlowTheme.of(context).bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                              color: i % 2 == 0
                                  ? Color(0x201D2428)
                                  : Color(0xFFFFFFFF),
                            ),
                            child: InkWell(
                              onTap: () {
                                removeFurlough(
                                    listFurlough![i].fromDate.toString(), i);
                              },
                              child: Icon(
                                FFIcons.kcancelFilled2,
                                color: FlutterFlowTheme.of(context).stateRED3,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 30),
                  child: FFButtonWidget(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    text: 'Đóng',
                    options: FFButtonOptions(
                      width: 200,
                      height: 38,
                      color: FlutterFlowTheme.of(context).primaryColor,
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                              ),
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
          ),
        ),
      ),
    );
  }
}
