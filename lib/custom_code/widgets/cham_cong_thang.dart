// Automatic FlutterFlow imports
import 'package:app_workplace/backend/api_requests/api_calls.dart';
import '../../cham_cong_chi_tiet_tre_som_copy/cham_cong_chi_tiet_tre_som_copy_widget.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// Automatic FlutterFlow imports
import 'package:table_calendar/table_calendar.dart';
import '../../custom_code/actions/index.dart' as actions;

class ChamCongThang extends StatefulWidget {
  const ChamCongThang({
    Key? key,
    this.width,
    this.height,
    required this.timeKeep,
  }) : super(key: key);

  final double? width;
  final double? height;
  final List<dynamic> timeKeep;

  @override
  _ChamCongThangState createState() => _ChamCongThangState(timeKeep);
}

class _ChamCongThangState extends State<ChamCongThang> {
  ApiCallResponse? responseTimekeep;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  dynamic dateSelected;

  List? selectedEvent;

  List<dynamic> timeKeep;
  _ChamCongThangState(this.timeKeep);

  @override
  void initState() {
    getTimekeep();
    //returnDateSelect(DateTime.now());
    super.initState();
  }

  // void _handleData(date) {
  //   setState(() {
  //     selectedDay = date;
  //   });
  //   print(selectedDay);
  // }

  void getTimekeep() async {
    if (timeKeep.isEmpty) {
      responseTimekeep =
          await PTCTimekeepCall.call(userName: FFAppState().userName);
      if (responseTimekeep != null) {
        setState(() {
          timeKeep = getJsonField(
            (responseTimekeep?.jsonBody ?? ''),
            r'''$.listObj''',
          ).toList();
        });
      }
    }
  }

  String returnColor(DateTime _datetime) {
    String result = "0xFFFFFFFF";
    if (timeKeep.isNotEmpty) {
      timeKeep.forEach((element) {
        DateTime start = DateTime.parse(element["start"].toString());
        if (_datetime.day == start.day && _datetime.month == start.month) {
          if (element["shiftName"].toString() == "TUA")
            result = "0xFF999999";
          else
            result = element["color"].toString();
        }
      });
    }
    return result;
  }

  String returnShiftName(DateTime _datetime) {
    String result = "";
    if (timeKeep.isNotEmpty) {
      timeKeep.forEach((element) {
        DateTime start = DateTime.parse(element["start"].toString());
        if (_datetime.day == start.day && _datetime.month == start.month) {
          result = element["shiftName"].toString();
        }
      });
    }
    return result;
  }

  String returnBorderToday(DateTime _datetime, String shiftName) {
    if (_datetime.day == DateTime.now().day &&
        _datetime.month == DateTime.now().month &&
        _datetime.year == DateTime.now().year)
      //return '0xFFE65100';
      return '0xFF13dbfa';
    else if (shiftName == "")
      return '0xFF808080';
    else
      return '0xFFFFFFFF';
  }

  bool returnToday(DateTime _datetime) {
    if (_datetime.day == DateTime.now().day &&
        _datetime.month == DateTime.now().month &&
        _datetime.year == DateTime.now().year)
      return true;
    else
      return false;
  }

  returnDateSelect(DateTime _datetime) {
    if (timeKeep.isNotEmpty) {
      timeKeep.forEach((element) {
        DateTime start = DateTime.parse(element["start"].toString());
        if (_datetime.day == start.day && _datetime.month == start.month) {
          setState(() {
            dateSelected = element;
          });
        }
      });
    } else {
      setState(() {});
    }
  }

  String dateConvert(String _datetime) {
    DateTime start = DateTime.parse(_datetime);
    return 'Ngày ' +
        returnTwoDateAndMonth(start.day.toString()) +
        '/' +
        returnTwoDateAndMonth(start.month.toString()) +
        '/' +
        start.year.toString();
  }

  String returnTitleMonthHeader(DateTime _datetime) {
    return "Tháng " +
        _datetime.month.toString() +
        " " +
        _datetime.year.toString();
  }

  String returnTwoDateAndMonth(String dateOrMonth) {
    if (dateOrMonth.length == 1)
      return "0" + dateOrMonth;
    else
      return dateOrMonth;
  }

  String returnStatus(String status) {
    late String _statusR;
    switch (status) {
      case 'ACC':
        {
          _statusR = 'Chờ duyệt';
        }
        break;
      case 'AC1':
        {
          _statusR = 'Chờ duyệt';
        }
        break;
      case 'AC2':
        {
          _statusR = 'Chờ duyệt';
        }
        break;
      case 'APP':
        {
          _statusR = 'Đã duyệt';
        }
        break;
      case 'NAP':
        {
          _statusR = 'Không duyệt';
        }
        break;
      default:
        {
          _statusR = "";
        }
        break;
    }
    return _statusR;
  }

  void gotoDate(DateTime selectedDay) {
    String shiftName = returnShiftName(selectedDay);
    if (shiftName != "") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChamCongChiTietTreSomCopyWidget(
            dateSelected: selectedDay.toString(),
          ),
        ),
      );
    } else {
      actions.toastMessage(
          context, "Warning", "Thông báo", "Ngày được chọn chưa được xếp ca");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Material(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.transparent,
                    child: Container(
                      height: 700,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).theme2,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(2, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          TableCalendar(
                            locale: 'vi_VN',
                            rowHeight: 80,
                            focusedDay: focusedDay,
                            firstDay: DateTime(2022),
                            lastDay: DateTime(2025),
                            calendarFormat: format,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            daysOfWeekVisible: true,
                            availableCalendarFormats: const {
                              CalendarFormat.month: 'Tháng'
                            },
                            daysOfWeekStyle: DaysOfWeekStyle(
                                weekendStyle: TextStyle(color: Colors.red)),
                            onFormatChanged: (CalendarFormat _format) {
                              setState(() {
                                format = _format;
                              });
                            },
                            onDaySelected:
                                (DateTime selectDay, DateTime focusDay) {
                              setState(() {
                                selectedDay = selectDay;
                                focusedDay = focusedDay;

                                gotoDate(selectDay);
                              });
                            },
                            calendarBuilders: CalendarBuilders(
                              headerTitleBuilder: (context, datetime) {
                                return Container(
                                  child: Text(
                                    returnTitleMonthHeader(datetime),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                );
                              },
                              markerBuilder: (context, datetime, events) {
                                return Container(
                                  width: 48,
                                  height: 74,
                                  decoration: BoxDecoration(
                                      color: Color(
                                          int.parse(returnColor(datetime))),
                                      border: Border.all(
                                          color: Color(int.parse(
                                              returnBorderToday(datetime,
                                                  returnShiftName(datetime)))),width: 0),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        datetime.day.toString(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            color:
                                                returnShiftName(datetime) == ""
                                                    ? Colors.grey
                                                    : returnToday(datetime)
                                                        ?  Color(0xFF13dbfa)
                                                        : Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        returnShiftName(datetime),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: returnToday(datetime)
                                                ? Color(0xFF13dbfa)
                                                : Colors.white),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            calendarStyle: const CalendarStyle(),
                            selectedDayPredicate: (DateTime date) {
                              return isSameDay(selectedDay, date);
                            },
                            headerStyle: const HeaderStyle(
                              //formatButtonVisible: true,
                              //formatButtonShowsNext: true,
                              //titleCentered: false,
                              leftChevronVisible: false,
                              rightChevronVisible: false,
                              headerMargin: EdgeInsets.fromLTRB(10, 10, 20, 5),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 3, 0),
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xFF2B79C2)),
                                    ),
                                  ),
                                  Text(
                                    "Bình thường",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 3, 0),
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xFFB90000)),
                                    ),
                                  ),
                                  Text(
                                    "Lỗi công",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 3, 0),
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xFF00A542)),
                                    ),
                                  ),
                                  Text(
                                    "Nghỉ phép",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 3, 0),
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xFFF49200)),
                                    ),
                                  ),
                                  Text(
                                    "Chờ duyệt",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 3, 0),
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xFF3B4652)),
                                    ),
                                  ),
                                  Text(
                                    "Chưa xếp ca",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 3, 0),
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xFF8C4D04)),
                                    ),
                                  ),
                                  Text(
                                    "Không duyệt",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Padding(
              //   padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(5),
              //     child: Material(
              //       elevation: 2,
              //       child: Container(
              //         width: double.infinity,
              //         height: 300,
              //         decoration: BoxDecoration(
              //           color: FlutterFlowTheme.of(context).secondaryBackground,
              //           boxShadow: [
              //             BoxShadow(
              //               blurRadius: 4,
              //               color: Color(0x33000000),
              //               offset: Offset(2, 4),
              //             )
              //           ],
              //           borderRadius: BorderRadius.circular(5),
              //         ),
              //         child: Column(
              //           mainAxisSize: MainAxisSize.max,
              //           children: [
              //             Material(
              //               color: Colors.transparent,
              //               elevation: 5,
              //               child: Container(
              //                 width: double.infinity,
              //                 height: 38,
              //                 decoration: BoxDecoration(
              //                   color: FlutterFlowTheme.of(context).stadeBlue2,
              //                 ),
              //                 child: Padding(
              //                   padding:
              //                       EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
              //                   child: Row(
              //                     mainAxisSize: MainAxisSize.max,
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceBetween,
              //                     children: [
              //                       Padding(
              //                         padding: EdgeInsetsDirectional.fromSTEB(
              //                             10, 0, 0, 0),
              //                         child: Text(
              //                           dateConvert(
              //                               dateSelected["start"].toString()),
              //                           style: FlutterFlowTheme.of(context)
              //                               .bodyText1
              //                               .override(
              //                                 fontFamily: 'Inter',
              //                                 color: FlutterFlowTheme.of(context)
              //                                     .primaryBtnText,
              //                               ),
              //                         ),
              //                       ),
              //                       FFButtonWidget(
              //                         onPressed: () {
              //                           Navigator.push(
              //                             context,
              //                             MaterialPageRoute(
              //                               builder: (context) =>
              //                                   ChamCongChiTietTreSomCopyWidget(
              //                                 dateSelected: dateSelected["start"]
              //                                     .toString(),
              //                               ),
              //                             ),
              //                           );
              //                         },
              //                         text: 'Chấm công',
              //                         options: FFButtonOptions(
              //                           height: 24,
              //                           padding: EdgeInsetsDirectional.fromSTEB(
              //                               5, 0, 5, 0),
              //                           color: FlutterFlowTheme.of(context)
              //                               .stadeBlue2,
              //                           textStyle: FlutterFlowTheme.of(context)
              //                               .bodyText1
              //                               .override(
              //                                 fontFamily: 'Inter',
              //                                 color: FlutterFlowTheme.of(context)
              //                                     .primaryBtnText,
              //                                 fontSize: 12,
              //                               ),
              //                           elevation: 2,
              //                           borderSide: BorderSide(
              //                             color:
              //                                 FlutterFlowTheme.of(context).theme2,
              //                             width: 1,
              //                           ),
              //                           borderRadius: BorderRadius.circular(10),
              //                         ),
              //                       )
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             Align(
              //               alignment: AlignmentDirectional(0, 0),
              //               child: Padding(
              //                 padding:
              //                     EdgeInsetsDirectional.fromSTEB(20, 5, 20, 0),
              //                 child: Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     Column(
              //                       mainAxisSize: MainAxisSize.max,
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceEvenly,
              //                       children: [
              //                         Padding(
              //                           padding: EdgeInsetsDirectional.fromSTEB(
              //                               0, 0, 0, 2),
              //                           child: Text(
              //                             dateSelected["shiftName"].toString(),
              //                             style: FlutterFlowTheme.of(context)
              //                                 .bodyText1
              //                                 .override(
              //                                   fontFamily: 'Inter',
              //                                   color:
              //                                       FlutterFlowTheme.of(context)
              //                                           .stadeBlue2,
              //                                   fontWeight: FontWeight.w600,
              //                                 ),
              //                           ),
              //                         ),
              //                         Padding(
              //                           padding: EdgeInsetsDirectional.fromSTEB(
              //                               0, 0, 0, 2),
              //                           child: Text(
              //                             'Thực tế',
              //                             style: FlutterFlowTheme.of(context)
              //                                 .bodyText1,
              //                           ),
              //                         ),
              //                         Text(
              //                           'Chốt công',
              //                           style: FlutterFlowTheme.of(context)
              //                               .bodyText1,
              //                         ),
              //                       ],
              //                     ),
              //                     Column(
              //                       mainAxisSize: MainAxisSize.max,
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceEvenly,
              //                       children: [
              //                         Padding(
              //                           padding: EdgeInsetsDirectional.fromSTEB(
              //                               0, 0, 0, 2),
              //                           child: Text(
              //                             'Giờ vào',
              //                             style: FlutterFlowTheme.of(context)
              //                                 .bodyText1,
              //                           ),
              //                         ),
              //                         Padding(
              //                           padding: EdgeInsetsDirectional.fromSTEB(
              //                               0, 0, 0, 2),
              //                           child: Text(
              //                             dateSelected["fingerTimeIn"].toString(),
              //                             style: FlutterFlowTheme.of(context)
              //                                 .bodyText1,
              //                           ),
              //                         ),
              //                         Text(
              //                           dateSelected["timeIn"].toString(),
              //                           style: FlutterFlowTheme.of(context)
              //                               .bodyText1,
              //                         ),
              //                       ],
              //                     ),
              //                     Column(
              //                       mainAxisSize: MainAxisSize.max,
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceEvenly,
              //                       children: [
              //                         Padding(
              //                           padding: EdgeInsetsDirectional.fromSTEB(
              //                               0, 0, 0, 2),
              //                           child: Text(
              //                             'Giờ ra',
              //                             style: FlutterFlowTheme.of(context)
              //                                 .bodyText1,
              //                           ),
              //                         ),
              //                         Padding(
              //                           padding: EdgeInsetsDirectional.fromSTEB(
              //                               0, 0, 0, 2),
              //                           child: Text(
              //                             dateSelected["fingerTimeOut"]
              //                                 .toString(),
              //                             style: FlutterFlowTheme.of(context)
              //                                 .bodyText1,
              //                           ),
              //                         ),
              //                         Text(
              //                           dateSelected["timeOut"].toString(),
              //                           style: FlutterFlowTheme.of(context)
              //                               .bodyText1,
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             Padding(
              //               padding:
              //                   EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
              //               child: Container(
              //                 width: double.infinity,
              //                 height: 32,
              //                 decoration: BoxDecoration(
              //                   color: Color(0xFF175ACD),
              //                   borderRadius: BorderRadius.circular(8),
              //                 ),
              //                 child: Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Padding(
              //                       padding: EdgeInsetsDirectional.fromSTEB(
              //                           10, 0, 0, 0),
              //                       child: Text(
              //                         'Phiếu đã gửi',
              //                         style: FlutterFlowTheme.of(context)
              //                             .bodyText1
              //                             .override(
              //                               fontFamily: 'Inter',
              //                               color: FlutterFlowTheme.of(context)
              //                                   .primaryBtnText,
              //                               fontSize: 13,
              //                             ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             // đi trễ, quên vào
              //             SingleChildScrollView(
              //               child: Column(
              //                 children: [
              //                   if (dateSelected["diTre"] != null)
              //                     _buildTimekeep("diTre", dateSelected["diTre"])
              //                   else if (dateSelected["quenVao"] != null)
              //                     _buildTimekeep(
              //                         "quenVao", dateSelected["quenVao"]),
              //                   // về sớm, quên ra
              //                   if (dateSelected['veSom'] != null)
              //                     _buildTimekeep("veSom", dateSelected["veSom"])
              //                   else if (dateSelected['quenRa'] != null)
              //                     _buildTimekeep(
              //                         "quenRa", dateSelected["quenRa"]),
              //                   // đổi ca, đổi Tua
              //                   if (dateSelected['dC'] != null)
              //                     _buildTimekeep("dC", dateSelected["dC"])
              //                   else if (dateSelected['dT'] != null)
              //                     _buildTimekeep("dT", dateSelected["dT"]),
              //                   // nghỉ phép
              //                   if (dateSelected['nP'] != null)
              //                     _buildTimekeep("nP", dateSelected["nP"]),
              //                 ],
              //               ),
              //             ),
              //             Padding(
              //               padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              //               child: Divider(
              //                 height: 1,
              //                 thickness: 1,
              //                 indent: 10,
              //                 endIndent: 10,
              //                 color: FlutterFlowTheme.of(context).lineColor,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconStatus(String status) {
    if (status == 'NAP')
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: Color.fromARGB(255, 255, 20, 3),
          ),
        ),
        child: Icon(
          Icons.clear,
          color: Color.fromARGB(255, 255, 20, 3),
          size: 24,
        ),
      );
    else if (status == 'ACC' || status == 'AC1' || status == 'AC2')
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: Color.fromARGB(255, 252, 227, 3),
          ),
        ),
        child: Icon(
          Icons.timelapse,
          color: Color.fromARGB(255, 252, 227, 3),
          size: 24,
        ),
      );
    else if (status == 'APP')
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: Color.fromARGB(255, 1, 247, 9),
          ),
        ),
        child: Icon(
          Icons.check_circle,
          color: Color.fromARGB(255, 1, 247, 9),
          size: 24,
        ),
      );
    else
      return Container(
        child: null,
      );
  }

  Widget _buildTypeTicket(String typeticket) {
    return Text(
      typeticket,
      style: FlutterFlowTheme.of(context).bodyText1.override(
          fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStatusTicket(String status) {
    return Text(
      returnStatus(status),
      style: FlutterFlowTheme.of(context).bodyText1.override(
            fontFamily: 'Inter',
            fontSize: 13,
          ),
    );
  }

  Widget _buildTimekeep(dynamic type, String status) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).tertiaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_buildIconStatus(status)],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (type == "diTre")
                                  _buildTypeTicket("Phiếu xin đi trễ")
                                else if (type == "quenVao")
                                  _buildTypeTicket("Phiếu quên chấm vào")
                                else if (type == 'veSom')
                                  _buildTypeTicket("Phiếu xin về sớm")
                                else if (type == 'quenRa')
                                  _buildTypeTicket("Phiếu quên chấm ra")
                                else if (type == 'dC')
                                  _buildTypeTicket("Phiếu xin đổi ca")
                                else if (type == 'dT')
                                  _buildTypeTicket("Phiếu xin đổi TUA")
                                else if (type == 'nP')
                                  _buildTypeTicket("Phiếu xin nghỉ phép")
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 3, 0),
                                        child: Text(
                                          'Tình trạng:',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                  fontFamily: 'Inter',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      _buildStatusTicket(status)
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
