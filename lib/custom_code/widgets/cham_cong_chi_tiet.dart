// Automatic FlutterFlow imports
import 'package:app_workplace/backend/api_requests/api_calls.dart';
import 'package:app_workplace/index.dart';
import '../../components/bts_chi_tiet_phep_p_chedo_widget.dart';
import '../../components/bts_chi_tiet_phep_widget.dart';
import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../custom_code/actions/index.dart' as actions;
import 'package:flutter_slidable/flutter_slidable.dart';

import '../actions/shimmer.dart';
import '../model/furlough.dart';
import '../model/furlough_ticket.dart';

class ChamCongChiTiet extends StatefulWidget {
  const ChamCongChiTiet(
      {Key? key,
      this.width,
      this.height,
      this.listDate,
      this.listTS,
      this.listCT,
      this.listTC,
      this.listNP,
      this.listTypeTS,
      this.listTypeCT,
      this.listReason,
      this.listReasonFurlough,
      this.listTimesheet,
      this.listHoliday})
      : super(key: key);

  final double? width;
  final double? height;
  final dynamic listDate;
  final List<dynamic>? listTS;
  final List<dynamic>? listCT;
  final List<dynamic>? listTC;
  final List<dynamic>? listNP;
  final List<dynamic>? listTypeTS;
  final List<dynamic>? listTypeCT;
  final List<dynamic>? listReason;
  final List<dynamic>? listReasonFurlough;
  final List<dynamic>? listTimesheet;
  final List<dynamic>? listHoliday;

  @override
  _ChamCongChiTietState createState() => _ChamCongChiTietState(
      listDate!,
      listTS!,
      listCT!,
      listTC!,
      listNP!,
      listTypeTS!,
      listTypeCT!,
      listReason!,
      listReasonFurlough!,
      listTimesheet!,
      listHoliday!);
}

class _ChamCongChiTietState extends State<ChamCongChiTiet> {
  bool? isLoading = false;
  ApiCallResponse? responseTicket;
  ApiCallResponse? responseDelete;
  ApiCallResponse? responseLeaveYear;
  bool? isCongTac = false;
  bool? isTangCa = false;
  bool? isTreSom = false;
  bool? isNghiPhep = false;
  bool? isDoiCa = false;
  bool? isDoiTUA = false;

  bool? showCongTac = false;
  bool? showTangCa = false;
  bool? showTreSom = false;
  bool? showNghiPhep = false;
  bool? showDoiCa = false;
  bool? showDoiTUA = false;

  bool? showNPTT = true;
  bool? showNPCD = false;
  bool? showNPBHXH = false;

  bool? isTypeTS = false;

  int numberFurloughMaxUse = 0;
  int numberFurloughCD = 0;

  late dynamic timeInApp;
  late dynamic timeOutApp;
  late dynamic timeInRestApp;
  late dynamic timeOutRestApp;
  late Furlough furloughNP;
  List<FurloughTicket> listDateArray = [];
  List<double> noSalary = [];

  String? dropDowntypeTS;
  String? dropDownlateReasonTS;
  String? dropDowntypeCT;
  String? dropDowntypeTC;
  String? dropDownTypeNP;
  String? dropDownTypeNPCD;
  String? dropDownTypeNPBHXH;

  TextEditingController txtGhiChuTS = TextEditingController();
  TextEditingController txtGhiChuCT = TextEditingController();
  TextEditingController txtGhiChuTC = TextEditingController();
  TextEditingController txtGhiChuNP = TextEditingController();
  TextEditingController fromDateNP = TextEditingController();
  TextEditingController toDateNP = TextEditingController();

  dynamic listDate;
  List<dynamic>? listTS;
  List<dynamic>? listCT;
  List<dynamic>? listTC;
  List<dynamic>? listNP;
  List<dynamic>? listTypeTS;
  List<dynamic>? listTypeCT;
  List<dynamic>? listReason;
  List<dynamic>? listReasonFurlough;
  List<dynamic>? listTimesheet;
  List<dynamic>? listHoliday;
  _ChamCongChiTietState(
      this.listDate,
      this.listTS,
      this.listCT,
      this.listTC,
      this.listNP,
      this.listTypeTS,
      this.listTypeCT,
      this.listReason,
      this.listReasonFurlough,
      this.listTimesheet,
      this.listHoliday);

  @override
  void initState() {
    initCreateTicket();
    setState(() {
      timeInApp = listDate["TimeIn"];
      timeOutApp = listDate["TimeOut"];
      timeInRestApp = null;
      timeOutRestApp = null;
      furloughNP = new Furlough();
      dropDownTypeNP = "Nghỉ phép năm";
      fromDateNP.text = DateFormat("dd/MM/yyyy")
          .format(DateTime.parse(listDate["start"].toString()));
    });

    super.initState();
  }

  String dateConvert(String _datetime) {
    DateTime start = DateTime.parse(_datetime);
    return 'Ngày ' + DateFormat('dd/MM/yyyy').format(start);
  }

  void initCreateTicket() {
    DateTime start = DateTime.parse(listDate["start"].toString());
    DateTime today = DateTime.now();
    // ngày quá khứ, ngày hiện tại
    if (daysBetween(start, today) >= 0 &&
        listDate["ShiftName"].toString() != 'TUA') {
      setState(() {
        isCongTac = true;
        isTangCa = true;
        isTreSom = true;
        isNghiPhep = true;
        isDoiCa = false;
        isDoiTUA = false;
      });
    } else if (daysBetween(start, today) >= 0 &&
        listDate["ShiftName"].toString() == 'TUA') {
      setState(() {
        isTangCa = true;
        isCongTac = false;
        isTreSom = false;
        isNghiPhep = false;
        isDoiCa = false;
        isDoiTUA = false;
      });
    } else if (daysBetween(start, today) < 0 &&
        listDate["ShiftName"].toString() != 'TUA') {
      setState(() {
        isNghiPhep = true;
        isDoiCa = true;
        isTangCa = false;
        isCongTac = false;
        isTreSom = false;
        isDoiTUA = false;
      });
    } else if (daysBetween(start, today) < 0 &&
        listDate["ShiftName"].toString() == 'TUA') {
      setState(() {
        isDoiTUA = true;
        isNghiPhep = false;
        isDoiCa = false;
        isTangCa = false;
        isCongTac = false;
        isTreSom = false;
      });
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  // trả về mã loại trễ/sớm
  String returnIdTypeTS(String nameType) {
    String idType = "";
    if (listTypeTS!.isNotEmpty) {
      listTypeTS?.forEach((element) {
        if (nameType == element["Name"].toString()) {
          idType = element["Code"].toString();
        }
      });
    }
    return idType;
  }

  // trả về mã loại công tác
  String returnIdTypeCT(String nameType) {
    String idType = "";
    if (listTypeCT!.isNotEmpty) {
      listTypeCT?.forEach((element) {
        if (nameType == element["Name"].toString()) {
          idType = element["Code"].toString();
        }
      });
    }
    return idType;
  }

  String returnIdReason(String nameReason) {
    String idReason = "";
    if (listReason!.isNotEmpty) {
      listReason?.forEach((element) {
        if (nameReason == element["Name"].toString()) {
          idReason = element["Code"].toString();
        }
      });
    }
    return idReason;
  }

  void changeTypeTS(String typeTS) {
    var startTime = listDate["StartTime"].toString();
    var endTime = listDate["EndTime"].toString();
    var timeInTS, timeOutTS;

    if (listDate["TimeIn"] == null || listDate["TimeOut"] == null) {
      if (listDate["TimeIn"] != null) {
        timeOutTS = null;
        timeInTS = timeInApp;
      } else {
        timeOutTS = null;
        timeInTS = null;
      }
    } else {
      timeOutTS = timeInApp;
      timeInTS = timeOutApp;
    }

    if (typeTS == "DITRE" || typeTS == "QUENVAO") {
      isTypeTS = typeTS == "DITRE" ? true : false;
      if (timeInTS == null) {
        timeInApp = startTime;
        timeOutApp = null;
      } else {
        if (timeOutTS == null) {
          var arrayDate = sort2Argument(timeInTS, startTime);
          timeInApp = arrayDate[0];
          timeOutApp = arrayDate[1];
        } else {
          var arrayDate = sort3Argument(timeInTS, timeOutTS, startTime);
          timeInApp = arrayDate[0];
          timeOutApp = arrayDate[1];
        }
      }
    }

    if (typeTS == "VESOM" || typeTS == "QUENRA") {
      isTypeTS = typeTS == "VESOM" ? true : false;
      if (timeInTS == null) {
        timeInApp = null;
        timeOutApp = endTime;
      } else {
        if (timeOutTS == null) {
          var arrayDate = sort2Argument(timeInTS, endTime);
          timeInApp = arrayDate[0];
          timeOutApp = arrayDate[1];
        } else {
          var arrayDate = sort3Argument(timeInTS, timeOutTS, endTime);
          timeInApp = arrayDate[0];
          timeOutApp = arrayDate[1];
        }
      }
    }
  }

  void changeTypeCT(String typeCT) {
    var timeInCT, timeOutCT;
    var startTime = listDate["StartTime"].toString();
    var endTime = listDate["EndTime"].toString();
    var startRestTime = listDate["StartRestTime"].toString();
    var endRestTime = listDate["EndRestTime"].toString();

    if (listDate["TimeIn"] == null || listDate["TimeOut"] == null) {
      if (listDate["TimeIn"] != null) {
        timeOutCT = null;
        timeInCT = timeInApp;
      } else {
        timeOutCT = null;
        timeInCT = null;
      }
    } else {
      timeOutCT = timeInApp;
      timeInCT = timeOutApp;
    }

    if (typeCT == 'CTDN') {
      timeInRestApp = startTime;
      timeOutRestApp = startRestTime;
      // công tác đầu ngày
      if (timeInCT == null) {
        timeInApp = startTime;
        timeOutApp = null;
      } else {
        if (timeInCT == null) {
          var arrayDate = sort2Argument(timeInCT, startTime);
          timeInApp = arrayDate[0];
          timeOutApp = arrayDate[1];
        } else {
          var arrayDate = sort3Argument(timeInCT, timeOutCT, startTime);
          timeInApp = arrayDate[0];
          timeOutApp = arrayDate[1];
        }
      }
    }

    if (typeCT == 'CTCN') {
      timeInRestApp = endRestTime;
      timeOutRestApp = endTime;
      // công tác cuối ngày
      if (timeInCT == null) {
        timeInApp = null;
        timeOutApp = endTime;
      } else {
        if (timeOutCT == null) {
          var arrayDate = sort2Argument(timeInCT, endTime);
          timeInApp = arrayDate[0];
          timeOutApp = arrayDate[1];
        } else {
          var arrayDate = sort3Argument(timeInCT, timeOutCT, endTime);
          timeInApp = arrayDate[0];
          timeOutApp = arrayDate[1];
        }
      }
    }

    if (typeCT == 'CTNN') {
      timeInRestApp = startTime;
      timeOutRestApp = endTime;
      // công tác nguyên ngày
      if (timeInCT == null) {
        timeInApp = startTime;
        timeOutApp = endTime;
      } else {
        if (timeOutCT == null) {
          var arrayDate = sort3Argument(timeInCT, startTime, endTime);
          timeInApp = arrayDate[0];
          timeOutApp = arrayDate[1];
        } else {
          var arrayDate =
              sort4Argument(timeInCT, timeOutCT, startTime, endTime);
          timeInApp = arrayDate[0];
          timeOutApp = arrayDate[1];
        }
      }
    }
  }

  void changeTypeNP() {
    furloughNP = new Furlough();
    if (dropDownTypeNP == "Nghỉ phép năm") {
      setState(() {
        showNPTT = true;
        showNPCD = false;
        showNPBHXH = false;
        listDateArray = [];
        toDateNP.text = "";
      });
    } else if (dropDownTypeNP == "Nghỉ BHXH") {
      setState(() {
        showNPTT = false;
        showNPCD = false;
        showNPBHXH = true;
        numberFurloughMaxUse = 0;
        listDateArray = [];
        toDateNP.text = "";
      });
    } else if (dropDownTypeNP == "Nghỉ chế độ") {
      setState(() {
        showNPTT = false;
        showNPCD = true;
        showNPBHXH = false;
        numberFurloughMaxUse = 0;
        listDateArray = [];
        toDateNP.text = "";
      });
    }
  }

  void changeNumberFurloughMax(String typeNP) {
    if (listReasonFurlough!.isNotEmpty) {
      listReasonFurlough!.forEach((element) {
        if (element["ReasonName"].toString() == typeNP) {
          setState(() {
            String maxInterval = element["MaxInterval"].toString();
            numberFurloughMaxUse = int.parse(maxInterval);
          });
        }
      });
    }
  }

  String returnNameTypeTS(String nameType) {
    String name = "";
    switch (nameType) {
      case 'DITRE':
        {
          name = "Xin đi trễ";
        }
        break;
      case 'VESOM':
        {
          name = "Xin về sớm";
        }
        break;
      case 'QUENVAO':
        {
          name = "Quên chấm vào";
        }
        break;
      case 'QUENRA':
        {
          name = "Quên chấm ra";
        }
        break;
    }
    return name;
  }

  String returnNameTypeCT(String nameType) {
    String name = "";
    switch (nameType) {
      case 'CTDN':
        {
          name = "Công tác đầu ngày";
        }
        break;
      case 'CTCN':
        {
          name = "Công tác cuối ngày";
        }
        break;
      case 'CTNN':
        {
          name = "Công tác nguyên ngày";
        }
        break;
    }
    return name;
  }

  String returnIdTypeNP(String nameType) {
    String idType = '';
    if (listReasonFurlough!.isNotEmpty) {
      listReasonFurlough!.forEach((element) {
        if (element["ReasonName"].toString() == nameType) {
          idType = element["ReasonType"].toString();
        }
      });
    }
    return idType;
  }

  List<String> sort2Argument(arg1, arg2) {
    var arrArg1 =
        (int.parse(arg1.split(':')[0]) * 60 + int.parse(arg1.split(':')[1]));
    var arrArg2 =
        (int.parse(arg2.split(':')[0]) * 60 + int.parse(arg2.split(':')[1]));

    var arrtemp = [arrArg1, arrArg2];
    arrtemp.sort();
    var arrresult = [
      convertNumberToTime(arrtemp[0]),
      convertNumberToTime(arrtemp[1])
    ];
    return arrresult;
  }

  List<String> sort3Argument(arg1, arg2, arg3) {
    var arrarg1 =
        (int.parse(arg1.split(':')[0]) * 60 + int.parse(arg1.split(':')[1]));
    var arrarg2 =
        (int.parse(arg2.split(':')[0]) * 60 + int.parse(arg2.split(':')[1]));
    var arrarg3 =
        (int.parse(arg3.split(':')[0]) * 60 + int.parse(arg3.split(':')[1]));

    var arrtemp = [arrarg1, arrarg2, arrarg3];
    arrtemp.sort();
    var arrresult = [
      convertNumberToTime(arrtemp[0]),
      convertNumberToTime(arrtemp[2])
    ];
    return arrresult;
  }

  List<String> sort4Argument(arg1, arg2, arg3, arg4) {
    var arrarg1 =
        (int.parse(arg1.split(':')[0]) * 60 + int.parse(arg1.split(':')[1]));
    var arrarg2 =
        (int.parse(arg2.split(':')[0]) * 60 + int.parse(arg2.split(':')[1]));
    var arrarg3 =
        (int.parse(arg3.split(':')[0]) * 60 + int.parse(arg3.split(':')[1]));
    var arrarg4 =
        (int.parse(arg4.split(':')[0]) * 60 + int.parse(arg4.split(':')[1]));

    var arrtemp = [arrarg1, arrarg2, arrarg3, arrarg4];
    arrtemp.sort();
    var arrresult = [
      convertNumberToTime(arrtemp[0]),
      convertNumberToTime(arrtemp[3])
    ];
    return arrresult;
  }

  String convertNumberToTime(int number) {
    var did = (number / 60).round();
    var mod = number - (did * 60);
    if (mod < 0) {
      did = did - 1;
      mod = number - (did * 60);
    }

    if (did < 10 && mod < 10) {
      return '0' + did.toString() + ':0' + mod.toString();
    }
    if (did < 10 && mod > 9) {
      return '0' + did.toString() + ':' + mod.toString();
    }
    if (did > 9 && mod < 10) {
      return did.toString() + ':0' + mod.toString();
    }
    return did.toString() + ':' + mod.toString();
  }

  void submitTicketTS() async {
    if (validationSubmitTS()) {
      actions.popupConfirm(context, 'Xác nhận gửi phiếu trễ/sớm', () async {
        setState(() {
          isLoading = true;
        });
        responseTicket = await PTCCreateTicketTSCall.call(
            userName: FFAppState().userName,
            requestingDate: DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(listDate["start"].toString())),
            reasonType: dropDowntypeTS,
            lateReason: dropDownlateReasonTS,
            note: txtGhiChuTS.text,
            timeIn: listDate["TimeIn"].toString(),
            timeOut: listDate["TimeOut"].toString(),
            afterApprovedTimeIn: timeInApp,
            afterApprovedTimeOut: timeOutApp);
        if (responseTicket != null) {
          setState(() {
            isLoading = false;
          });

          if (getJsonField(
            (responseTicket?.jsonBody ?? ''),
            r'''$.isSuccess''',
          )) {
            actions.toastMessage(
                context,
                "Success",
                "Thành công",
                getJsonField(
                  (responseTicket?.jsonBody ?? ''),
                  r'''$.message''',
                ));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LichChamCongThangCopyWidget()));
          } else {
            actions.toastMessage(
              context,
              "Error",
              "Thất bại",
              getJsonField(
                (responseTicket?.jsonBody ?? ''),
                r'''$.message''',
              ),
            );
          }
        }
      });
    }
  }

  void submitTicketCT() async {
    if (validationSubmitCT()) {
      actions.popupConfirm(
        context,
        "Xác nhận gửi phiếu công tác",
        () async {
          setState(() {
            isLoading = true;
          });

          responseTicket = await PTCCreateTicketCTCall.call(
              userName: FFAppState().userName,
              requestingDate: DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(listDate["start"].toString())),
              reasonType: dropDowntypeCT,
              note: txtGhiChuCT.text,
              timeIn: listDate["TimeIn"].toString(),
              timeOut: listDate["TimeOut"].toString(),
              afterApprovedTimeIn: timeInApp,
              afterApprovedTimeOut: timeOutApp);

          if (responseTicket != null) {
            setState(() {
              isLoading = false;
            });

            if (getJsonField(
              (responseTicket?.jsonBody ?? ''),
              r'''$.isSuccess''',
            )) {
              actions.toastMessage(
                  context,
                  "Success",
                  "Thành công",
                  getJsonField(
                    (responseTicket?.jsonBody ?? ''),
                    r'''$.message''',
                  ));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LichChamCongThangCopyWidget()));
            } else {
              actions.toastMessage(
                context,
                "Error",
                "Thất bại",
                getJsonField(
                  (responseTicket?.jsonBody ?? ''),
                  r'''$.message''',
                ),
              );
            }
          }
        },
      );
    }
  }

  void submitTicketTC() async {
    if (validationSubmitTC()) {
      actions.popupConfirm(
        context,
        "Xác nhận gửi phiếu tăng ca",
        () async {
          setState(() {
            isLoading = true;
          });

          responseTicket = await PTCCreateTicketTCCall.call(
              userName: FFAppState().userName,
              requestingDate: DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(listDate["start"].toString())),
              reasonType: "TCN",
              otHours: dropDowntypeTC,
              note: txtGhiChuTC.text);

          if (responseTicket != null) {
            setState(() {
              isLoading = false;
            });

            if (getJsonField(
              (responseTicket?.jsonBody ?? ''),
              r'''$.isSuccess''',
            )) {
              actions.toastMessage(
                  context,
                  "Success",
                  "Thành công",
                  getJsonField(
                    (responseTicket?.jsonBody ?? ''),
                    r'''$.message''',
                  ));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LichChamCongThangCopyWidget()));
            } else {
              actions.toastMessage(
                context,
                "Error",
                "Thất bại",
                getJsonField(
                  (responseTicket?.jsonBody ?? ''),
                  r'''$.message''',
                ),
              );
            }
          }
        },
      );
    }
  }

  void submitTicketNPTT() async {
    if (validationSubmitNPTT()) {
      actions.popupConfirm(
        context,
        "Xác nhận gửi phiếu nghỉ phép",
        () async {
          setState(() {
            isLoading = true;
          });

          responseTicket = await PTCCreateTicketNPTT.call(
              userName: FFAppState().userName,
              annualLeave: furloughNP.annualLeave,
              avaiableLeaveRemain: furloughNP.avaiableLeaveRemain,
              leaveRemain: furloughNP.leaveRemain,
              leaveRemainPrevYear: furloughNP.leaveRemainPrevYear,
              loanLeave: furloughNP.loanLeave,
              maxLoanLeave: furloughNP.maxLoanLeave,
              noSalary: furloughNP.noSalary,
              note: txtGhiChuNP.text,
              numberFurloughDetail: furloughNP.numberFurlough,
              tempLeave: furloughNP.tempLeave,
              listFurloughDetail: listDateArray);
          if (responseTicket != null) {
            setState(() {
              isLoading = false;
            });

            if (getJsonField(
              (responseTicket?.jsonBody ?? ''),
              r'''$.isSuccess''',
            )) {
              actions.toastMessage(
                  context,
                  "Success",
                  "Thành công",
                  getJsonField(
                    (responseTicket?.jsonBody ?? ''),
                    r'''$.message''',
                  ));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LichChamCongThangCopyWidget()));
            } else {
              actions.toastMessage(
                context,
                "Error",
                "Thất bại",
                getJsonField(
                  (responseTicket?.jsonBody ?? ''),
                  r'''$.message''',
                ),
              );
            }
          }
        },
      );
    }
  }

  void submitTicketNPCD() async {
    if (validationSubmitNPCD()) {
      actions.popupConfirm(context, "Xác nhận gửi phiếu nghỉ phép", () async {
        setState(() {
          isLoading = true;
        });
        responseTicket = await PTCCreateTicketNPCD.call(
            reasonType: returnIdTypeNP(dropDownTypeNPCD!),
            userName: FFAppState().userName,
            note: txtGhiChuNP.text,
            numberFurloughDetail: furloughNP.numberFurlough,
            listFurloughDetail: listDateArray);
        if (responseTicket != null) {
          setState(() {
            isLoading = false;
          });

          if (getJsonField(
            (responseTicket?.jsonBody ?? ''),
            r'''$.isSuccess''',
          )) {
            actions.toastMessage(
                context,
                "Success",
                "Thành công",
                getJsonField(
                  (responseTicket?.jsonBody ?? ''),
                  r'''$.message''',
                ));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LichChamCongThangCopyWidget()));
          } else {
            actions.toastMessage(
              context,
              "Error",
              "Thất bại",
              getJsonField(
                (responseTicket?.jsonBody ?? ''),
                r'''$.message''',
              ),
            );
          }
        }
      });
    }
  }

  void submitTicketNPBHXH() async {
    if (validationSubmitNPBHXH()) {
      actions.popupConfirm(context, "Xác nhận gửi phiếu nghỉ phép", () async {
        List<FurloughTicket> listTicketBHXH = [];
        FurloughTicket furloughTicket = new FurloughTicket();
        furloughTicket.shiftName = "...";
        furloughTicket.shiftId = 2055;
        furloughTicket.fromDate = fromDateNP.text;
        furloughTicket.toDate = toDateNP.text;
        furloughTicket.haftFurlough = "P";
        furloughTicket.numberFurlough = 1;
        listTicketBHXH.add(furloughTicket);
        setState(() {
          isLoading = true;
        });

        responseTicket = await PTCCreateTicketNPBHXH.call(
            reasonType: returnIdTypeNP(dropDownTypeNPBHXH!),
            userName: FFAppState().userName,
            note: txtGhiChuNP.text,
            numberFurloughDetail: furloughNP.numberFurlough,
            listFurloughDetail: listTicketBHXH);
        if (responseTicket != null) {
          setState(() {
            isLoading = false;
          });

          if (getJsonField(
            (responseTicket?.jsonBody ?? ''),
            r'''$.isSuccess''',
          )) {
            actions.toastMessage(
                context,
                "Success",
                "Thành công",
                getJsonField(
                  (responseTicket?.jsonBody ?? ''),
                  r'''$.message''',
                ));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LichChamCongThangCopyWidget()));
          } else {
            actions.toastMessage(
              context,
              "Error",
              "Thất bại",
              getJsonField(
                (responseTicket?.jsonBody ?? ''),
                r'''$.message''',
              ),
            );
          }
        }
      });
    }
  }

  void cancelTicket(String typeTicket) {
    String content = "";
    switch (typeTicket) {
      case "TS":
        {
          content = "Xác nhận hủy phiếu trễ/sớm";
        }
        break;
      case "CT":
        {
          content = "Xác nhận hủy phiếu công tác";
        }
        break;
      case "TC":
        {
          content = "Xác nhận hủy phiếu tăng ca";
        }
        break;
      case "NP":
        {
          content = "Xác nhận hủy phiếu nghỉ phép";
        }
        break;
    }

    actions.popupConfirm(context, content, () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LichChamCongThangCopyWidget()));
    });
  }

  void deletedTicket(
      String ticketId, String updateDate, int index, String typeTicket) async {
    String content = "";
    switch (typeTicket) {
      case "TS":
        {
          content = "Xác nhận xóa phiếu trễ/sớm";
        }
        break;
      case "CT":
        {
          content = "Xác nhận xóa phiếu công tác";
        }
        break;
      case "TC":
        {
          content = "Xác nhận xóa phiếu tăng ca";
        }
        break;
      case "NP":
        {
          content = "Xác nhận xóa phiếu nghỉ phép";
        }
        break;
    }

    actions.popupConfirm(context, content, () async {
      setState(() {
        isLoading = true;
      });

      if (typeTicket == "NP")
        responseDelete = await PTCDeleteTicketFurlough.call(
            ticketID: ticketId,
            updateDate: updateDate,
            userName: FFAppState().userName);
      else
        responseDelete = await PTCDeleteTicketUpdate.call(
            ticketID: ticketId,
            updateDate: updateDate,
            userName: FFAppState().userName);

      if (responseDelete != null) {
        setState(() {
          isLoading = false;
        });

        if (getJsonField(
            (responseDelete?.jsonBody ?? ''), r'''$.isSuccess''')) {
          actions.toastMessage(context, "Success", "Thành công",
              getJsonField((responseDelete?.jsonBody ?? ''), r'''$.message'''));
          // cap nhat danh sach gui phieu
          setState(() {
            if (typeTicket == "TS") {
              if (listTS!.length == 1)
                listTS = <dynamic>[];
              else
                listTS = listTS!.removeAt(index);
            } else if (typeTicket == "CT")
              listCT = <dynamic>[];
            else if (typeTicket == "TC")
              listTC = <dynamic>[];
            else if (typeTicket == "NP") listNP = <dynamic>[];
          });
        } else {
          actions.toastMessage(context, "Error", "Thất bại",
              getJsonField((responseDelete?.jsonBody ?? ''), r'''$.message'''));
        }
      }
    });
  }

  void addDateNP(DateTime pickeddate) async {
    setState(() {
      furloughNP.numberFurlough = 0;
      listDateArray = [];
      noSalary = [];
    });
    var splitFromDate = fromDateNP.text.split('/');
    DateTime fromDate = DateTime(int.parse(splitFromDate[2]),
        int.parse(splitFromDate[1]), int.parse(splitFromDate[0]));
    DateTime toDate =
        DateTime(pickeddate.year, pickeddate.month, pickeddate.day);

    int diff = (toDate.difference(fromDate).inHours / 24).round();

    if (diff < 0)
      actions.toastMessage(context, "Warning", "Thông báo",
          "Ngày kết thúc nghỉ phép phải nhỏ hơn hoặc bằng ngày bắt đầu nghỉ phép");
    else {
      // cùng tháng cùng năm
      if (splitFromDate[2] == pickeddate.year.toString() &&
          splitFromDate[1] == pickeddate.month.toString()) {
        for (int i = fromDate.day; i <= toDate.day; i++) {
          DateTime newDate = DateTime(fromDate.year, fromDate.month, i);
          List response = checkHolidayAndShiftTUA(newDate);
          if (!response[0]) {
            FurloughTicket furloughTicket = new FurloughTicket();
            furloughTicket.shiftName = response[2].toString();
            furloughTicket.shiftId = response[1].toString() == ""
                ? 0
                : int.parse(response[1].toString());
            furloughTicket.fromDate = DateFormat("dd/MM/yyyy").format(newDate);
            furloughTicket.toDate = DateFormat("dd/MM/yyyy").format(newDate);
            if (response[2].toString() == "CH1" ||
                response[2].toString() == "CH2" ||
                response[2].toString() == "CH2") {
              furloughTicket.haftFurlough = "P1";
              furloughTicket.numberFurlough = 0.5;
              setState(() {
                furloughNP.numberFurlough = furloughNP.numberFurlough! + 0.5;
              });
            } else {
              furloughTicket.haftFurlough = "P";
              furloughTicket.numberFurlough = 1;
              setState(() {
                furloughNP.numberFurlough = furloughNP.numberFurlough! + 1;
                listDateArray.add(furloughTicket);
              });
            }
          }
          if (furloughNP.numberFurlough! > 60) {
            actions.toastMessage(context, "Warning", "Thông báo",
                "Số ngày nghỉ phép không được vượt quá 60 ngày");
          }
        }
      } // tháng trước tháng sau
      else {
        var numbermonth = 0;
        var year = fromDate.year;
        switch (fromDate.month) {
          case 1:
          case 3:
          case 5:
          case 7:
          case 8:
          case 10:
          case 12:
            numbermonth = 31;
            break;
          case 4:
          case 6:
          case 9:
          case 11:
            numbermonth = 30;
            break;
          case 2:
            {
              if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0))
                numbermonth = 29;
              else
                numbermonth = 28;
              break;
            }
        }
        for (int i = fromDate.day; i <= numbermonth; i++) {
          DateTime newDate = DateTime(fromDate.year, fromDate.month, i);
          List response = checkHolidayAndShiftTUA(newDate);
          if (!response[0]) {
            FurloughTicket furloughTicket = new FurloughTicket();
            furloughTicket.shiftName = response[2].toString();
            furloughTicket.shiftId = response[1].toString() == ""
                ? 0
                : int.parse(response[1].toString());
            furloughTicket.fromDate = DateFormat("dd/MM/yyyy").format(newDate);
            furloughTicket.toDate = DateFormat("dd/MM/yyyy").format(newDate);
            furloughTicket.haftFurlough = "P";
            furloughTicket.numberFurlough = 1;

            setState(() {
              furloughNP.numberFurlough = furloughNP.numberFurlough! + 1;
              listDateArray.add(furloughTicket);
            });
          }
        }

        for (int i = 1; i <= toDate.day; i++) {
          DateTime newDate = DateTime(toDate.year, toDate.month, i);
          List response = checkHolidayAndShiftTUA(newDate);
          if (!response[0]) {
            FurloughTicket furloughTicket = new FurloughTicket();
            furloughTicket.shiftName = response[2].toString();
            furloughTicket.shiftId = response[1].toString() == ""
                ? 0
                : int.parse(response[1].toString());
            furloughTicket.fromDate = DateFormat("dd/MM/yyyy").format(newDate);
            furloughTicket.toDate = DateFormat("dd/MM/yyyy").format(newDate);
            furloughTicket.haftFurlough = "P";
            furloughTicket.numberFurlough = 1;

            setState(() {
              furloughNP.numberFurlough = furloughNP.numberFurlough! + 1;
              listDateArray.add(furloughTicket);
            });
          }
        }

        if (furloughNP.numberFurlough! > 60) {
          actions.toastMessage(context, "Warning", "Thông báo",
              "Số ngày nghỉ phép không được vượt quá 60 ngày");
        }
      }

      responseLeaveYear = await PTCGetLeaveYear.call(
          userName: FFAppState().userName, fromDate: fromDateNP.text);

      if (responseLeaveYear != null) {
        if (getJsonField(
            (responseLeaveYear?.jsonBody ?? ''), r'''$.isSuccess''')) {
          setState(() {
            dynamic leaveYear = getJsonField(
                (responseLeaveYear?.jsonBody ?? ''), r'''$.lstObj''');
            if (leaveYear != null) {
              furloughNP.leaveRemainPrevYear =
                  double.parse(leaveYear["LeaveRemainPrevYear"].toString());
              furloughNP.avaiableLeaveRemain =
                  double.parse(leaveYear["AvaiableLeaveRemain"].toString());
              furloughNP.loanLeave =
                  double.parse(leaveYear["LoanLeave"].toString());
              furloughNP.maxLoanLeave =
                  double.parse(leaveYear["MaxLoanLeave"].toString());
            }

            var pT = furloughNP.leaveRemainPrevYear! +
                furloughNP.avaiableLeaveRemain!;
            var tUMax = furloughNP.maxLoanLeave!;
            var sNN = furloughNP.numberFurlough!;

            if (pT > sNN) {
              furloughNP.annualLeave = sNN;
              furloughNP.annualLeaveTemp = sNN;
              furloughNP.tempLeave = 0;
              //furloughNPTemp.tempLeaveTemp = 0;
              noSalary = [];
              for (double i = 0; i <= sNN; i = i + 0.5) {
                noSalary.add(i);
              }
              furloughNP.noSalary = 0;
              //furloughNPTemp.noSalaryTemp = 0;
              furloughNP.leaveRemain = pT - furloughNP.annualLeave!;
            } else {
              if (tUMax >= (sNN - pT)) {
                furloughNP.annualLeave = pT;
                furloughNP.annualLeaveTemp = pT;
                furloughNP.tempLeave = sNN - pT;
                //furloughNPTemp.tempLeaveTemp = sNN - pT;
                noSalary = [];
                for (double i = 0; i <= sNN; i = i + 0.5) {
                  noSalary.add(i);
                }
                furloughNP.noSalary = 0;
                //furloughNPTemp.noSalaryTemp = 0;
                furloughNP.leaveRemain = pT - furloughNP.annualLeave!;
              } else {
                furloughNP.annualLeave = pT;
                furloughNP.annualLeaveTemp = pT;
                furloughNP.tempLeave = tUMax;
                //furloughNPTemp.annualLeaveTemp = tUMax;
                noSalary = [];
                for (double i = (sNN - pT - tUMax); i <= sNN; i = i + 0.5) {
                  noSalary.add(i);
                }
                furloughNP.noSalary = sNN - pT - tUMax;
                // furloughNPTemp.noSalaryTemp = sNN - pT - tUMax;
                furloughNP.leaveRemain = pT - furloughNP.annualLeave!;
              }
            }
          });
        }
      } else
        actions.toastMessage(
            context, "Warning", "Thông báo", "Không lấy được số phép tồn");
      toDateNP.text = DateFormat('dd/MM/yyyy').format(pickeddate);
    }
  }

  void changeNoSalary() {
    var pTNo =
        furloughNP.leaveRemainPrevYear! + furloughNP.avaiableLeaveRemain!;
    var pNNo = furloughNP.annualLeaveTemp;
    var kLNo = furloughNP.noSalary;
    var sNNNo = furloughNP.numberFurlough;
    var step = sNNNo! - kLNo!;
    if (step >= pNNo!) {
      setState(() {
        furloughNP.tempLeave = step - pNNo;
        furloughNP.annualLeave = pNNo;
        furloughNP.leaveRemain = pTNo - furloughNP.annualLeave!;
      });
    } else {
      setState(() {
        furloughNP.tempLeave = 0;
        furloughNP.annualLeave = step;
        furloughNP.leaveRemain = pTNo - furloughNP.annualLeave!;
      });
    }
  }

  List checkHolidayAndShiftTUA(DateTime date) {
    bool check = false;
    String furloughShiftID = "";
    String furloughShiftName = "";
    if (listHoliday!.isNotEmpty) {
      listHoliday!.forEach((ele) {
        DateTime holiday = DateTime.parse(ele["HolidayDate"].toString());
        if (holiday.year == date.year &&
            holiday.month == date.month &&
            holiday.day == date.day) {
          actions.toastMessage(context, "Warning", "Thông báo",
              "Ngày ${DateFormat('dd/MM/yyyy').format(date)} là ngày nghỉ lễ");
          check = true;
        }
      });
    }

    if (listTimesheet!.isNotEmpty) {
      listTimesheet!.forEach((element) {
        DateTime start = DateTime.parse(element["start"].toString());
        if (start.year == date.year &&
            start.month == date.month &&
            start.day == date.day) {
          furloughShiftID = element["shiftID"].toString();
          furloughShiftName = element["shiftName"].toString();
        }
      });
      if (furloughShiftName == "TUA") {
        actions.toastMessage(context, "Warning", "Thông báo",
            "Ngày ${DateFormat('dd/MM/yyyy').format(date)} là ngày có ca TUA");
        check = true;
      }
    }
    return [check, furloughShiftID, furloughShiftName];
  }

  void updateListFurlough(furloughNPDetail, noSalaryDetail, listArrayFurlough) {
    setState(() {
      furloughNP = furloughNPDetail;
      noSalary = noSalaryDetail;
      listDateArray = listArrayFurlough;
    });
  }

  bool validationSubmitTS() {
    bool check = true;
    if (dropDowntypeTS == null || dropDowntypeTS == "") {
      check = false;
      actions.toastMessage(
          context, "Warning", "Lỗi", "Vui lòng chọn loại trễ/sớm");
    } else {
      if (dropDowntypeTS == "QUENVAO" || dropDowntypeTS == "QUENRA") {
        if (txtGhiChuTS.text == "") {
          check = false;
          actions.toastMessage(
              context, "Warning", "Lỗi", "Vui lòng nhập lý do làm phiếu");
        }
      }
    }
    if (isTypeTS!) if (dropDownlateReasonTS == null ||
        dropDownlateReasonTS == "") {
      actions.toastMessage(
          context, "Warning", "Lỗi", "Vui lòng chọn lý do trễ/sớm");
      check = false;
    }
    return check;
  }

  bool validationSubmitCT() {
    if (dropDowntypeCT == null || dropDowntypeCT == "") {
      actions.toastMessage(
          context, "Warning", "Lỗi", "Vui lòng chọn loại công tác");
      return false;
    }
    if (txtGhiChuCT.text == "") {
      actions.toastMessage(
          context, "Warning", "Lỗi", "Vui lòng nhập lý do làm phiếu");
      return false;
    }
    return true;
  }

  bool validationSubmitTC() {
    if (dropDowntypeTC == null || dropDowntypeTC == "") {
      actions.toastMessage(
          context, "Warning", "Lỗi", "Vui lòng chọn loại số giờ tăng ca");
      return false;
    }
    if (txtGhiChuTC.text == "") {
      actions.toastMessage(
          context, "Warning", "Lỗi", "Vui lòng nhập lý do làm phiếu");
      return false;
    }
    return true;
  }

  bool validationSubmitNPTT() {
    if (listDateArray.isEmpty) {
      actions.toastMessage(context, "Warning", "Lỗi",
          "Danh sách ngày nghỉ rỗng không thể tạo phiếu");
      return false;
    }

    if (txtGhiChuNP.text == "") {
      actions.toastMessage(
          context, "Warning", "Lỗi", "Vui lòng nhập lý do làm phiếu");
      return false;
    }
    return true;
  }

  bool validationSubmitNPCD() {
    if (dropDownTypeNPCD == null || dropDownTypeNPCD == "") {
      actions.toastMessage(
          context, "Warning", "Lỗi", "Vui lòng chọn loại phép chế độ");
      return false;
    }

    if (listDateArray.isEmpty) {
      actions.toastMessage(context, "Warning", "Lỗi",
          "Danh sách ngày nghỉ rỗng không thể tạo phiếu");
      return false;
    } else {
      if (listDateArray.length > numberFurloughMaxUse) {
        actions.toastMessage(context, "Warning", "Lỗi",
            "Số ngày nghỉ phép không được vượt quá tối đa số ngày nghỉ cho phép");
        return false;
      }
    }

    if (txtGhiChuNP.text == "") {
      actions.toastMessage(
          context, "Warning", "Lỗi", "Vui lòng nhập lý do làm phiếu");
      return false;
    }
    return true;
  }

  bool validationSubmitNPBHXH() {
    if (dropDownTypeNPBHXH == null || dropDownTypeNPBHXH == "") {
      actions.toastMessage(
          context, "Warning", "Lỗi", "Vui lòng chọn loại phép BHXH");
      return false;
    }

    if (listDateArray.isEmpty) {
      actions.toastMessage(context, "Warning", "Lỗi",
          "Danh sách ngày nghỉ rỗng không thể tạo phiếu");
      return false;
    } else {
      if (listDateArray.length > numberFurloughMaxUse) {
        actions.toastMessage(context, "Warning", "Lỗi",
            "Số ngày nghỉ phép không được vượt quá tối đa số ngày nghỉ cho phép");
        return false;
      }
    }
    if (txtGhiChuNP.text == "") {
      actions.toastMessage(
          context, "Warning", "Lỗi", "Vui lòng nhập lý do làm phiếu");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading!)
      return ShimmerLoading();
    else
      return Container(
        height: widget.height,
        width: widget.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Material(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 38,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).stadeBlue2,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 0, 0),
                                    child: Text(
                                      dateConvert(listDate["start"].toString()),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBtnText,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 10, 20, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 3),
                                          child: Text(
                                            listDate["ShiftName"].toString(),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .stadeBlue2,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 3),
                                          child: Text(
                                            'Thực tế',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                          ),
                                        ),
                                        Text(
                                          'Sau duyệt',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 3),
                                          child: Text(
                                            'Giờ vào',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 3),
                                          child: Text(
                                            listDate["FingerTimeIn"] == null
                                                ? "--:--"
                                                : listDate["FingerTimeIn"]
                                                    .toString(),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                          ),
                                        ),
                                        Text(
                                          timeInApp == null
                                              ? "--:--"
                                              : timeInApp,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 3),
                                          child: Text(
                                            'Giờ ra',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 3),
                                          child: Text(
                                            listDate["FingerTimeOut"] == null
                                                ? "--:--"
                                                : listDate["FingerTimeOut"]
                                                    .toString(),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                          ),
                                        ),
                                        Text(
                                          timeOutApp == null
                                              ? "--:--"
                                              : timeOutApp,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (showCongTac!)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    15, 5, 15, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 5, 0),
                                            child: Text(
                                              'Bắt đầu CT:',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1,
                                            ),
                                          ),
                                          Text(
                                            timeInRestApp == null
                                                ? '--:--'
                                                : timeInRestApp,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .customColor3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 5, 0),
                                            child: Text(
                                              'Kết thúc CT:',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1,
                                            ),
                                          ),
                                          Text(
                                            timeOutRestApp == null
                                                ? '--:--'
                                                : timeOutRestApp,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .customColor3,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).stadeBlue1,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).lineColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isCongTac!)
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FFButtonWidget(
                                    onPressed: () {
                                      setState(() {
                                        showTangCa = false;
                                        showCongTac = true;
                                        showTreSom = false;
                                        showNghiPhep = false;
                                        showDoiCa = false;
                                        showDoiTUA = false;
                                      });
                                    },
                                    text: 'Công tác',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 32,
                                      color: !showCongTac!
                                          ? FlutterFlowTheme.of(context)
                                              .tertiaryColor
                                          : Colors.blue,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .subtitle2
                                          .override(
                                            fontFamily: 'Roboto Condensed',
                                            color: !showCongTac!
                                                ? FlutterFlowTheme.of(context)
                                                    .primaryText
                                                : Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                      elevation: 0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (isTangCa!)
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FFButtonWidget(
                                  onPressed: () {
                                    setState(() {
                                      showTangCa = true;
                                      showCongTac = false;
                                      showTreSom = false;
                                      showNghiPhep = false;
                                      showDoiCa = false;
                                      showDoiTUA = false;
                                    });
                                  },
                                  text: 'Tăng ca',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 32,
                                    color: !showTangCa!
                                        ? FlutterFlowTheme.of(context)
                                            .tertiaryColor
                                        : Colors.blue,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .subtitle2
                                        .override(
                                          fontFamily: 'Roboto Condensed',
                                          color: !showTangCa!
                                              ? FlutterFlowTheme.of(context)
                                                  .primaryText
                                              : Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                    elevation: 0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isTreSom!)
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FFButtonWidget(
                                  onPressed: () {
                                    setState(() {
                                      showTangCa = false;
                                      showCongTac = false;
                                      showTreSom = true;
                                      showNghiPhep = false;
                                      showDoiCa = false;
                                      showDoiTUA = false;
                                    });
                                  },
                                  text: 'Trễ/ Sớm',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 32,
                                    color: !showTreSom!
                                        ? FlutterFlowTheme.of(context)
                                            .tertiaryColor
                                        : Colors.blue,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .subtitle2
                                        .override(
                                          fontFamily: 'Roboto Condensed',
                                          color: !showTreSom!
                                              ? FlutterFlowTheme.of(context)
                                                  .primaryText
                                              : Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                    elevation: 0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isNghiPhep!)
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 2, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FFButtonWidget(
                                    onPressed: () {
                                      setState(() {
                                        showTangCa = false;
                                        showCongTac = false;
                                        showTreSom = false;
                                        showNghiPhep = true;
                                        showDoiCa = false;
                                        showDoiTUA = false;
                                      });
                                    },
                                    text: 'Nghỉ phép',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 32,
                                      color: !showNghiPhep!
                                          ? FlutterFlowTheme.of(context)
                                              .tertiaryColor
                                          : Colors.blue,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .subtitle2
                                          .override(
                                            fontFamily: 'Roboto Condensed',
                                            color: !showNghiPhep!
                                                ? FlutterFlowTheme.of(context)
                                                    .primaryText
                                                : Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                      elevation: 0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (isDoiCa!)
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 2, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FFButtonWidget(
                                    onPressed: () {
                                      setState(() {
                                        showTangCa = false;
                                        showCongTac = false;
                                        showTreSom = false;
                                        showNghiPhep = false;
                                        showDoiCa = true;
                                        showDoiTUA = false;
                                      });
                                    },
                                    text: 'Đổi ca',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 32,
                                      color: !showDoiCa!
                                          ? FlutterFlowTheme.of(context)
                                              .tertiaryColor
                                          : Colors.blue,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .subtitle2
                                          .override(
                                            fontFamily: 'Roboto Condensed',
                                            color: !showDoiCa!
                                                ? FlutterFlowTheme.of(context)
                                                    .primaryText
                                                : Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                      elevation: 0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (isDoiTUA!)
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 2, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FFButtonWidget(
                                    onPressed: () {
                                      setState(() {
                                        showTangCa = false;
                                        showCongTac = false;
                                        showTreSom = false;
                                        showNghiPhep = false;
                                        showDoiCa = false;
                                        showDoiTUA = true;
                                      });
                                    },
                                    text: 'Đổi TUA',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 32,
                                      color: !showDoiTUA!
                                          ? FlutterFlowTheme.of(context)
                                              .tertiaryColor
                                          : Colors.blue,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .subtitle2
                                          .override(
                                            fontFamily: 'Roboto Condensed',
                                            color: !showDoiTUA!
                                                ? FlutterFlowTheme.of(context)
                                                    .primaryText
                                                : Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                      elevation: 0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (showTreSom!) ...[
                          if (listTS!.isNotEmpty)
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 38,
                                  decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .stadeBlue3,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          topLeft: Radius.circular(8))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                        child: Text(
                                          listTS!.length > 0
                                              ? 'Phiếu đã gửi (' +
                                                  listTS!.length.toString() +
                                                  ')'
                                              : 'Phiếu đã gửi',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBtnText,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                for (var i = 0; i < listTS!.length; i++) ...[
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 0, 0),
                                    child: _buildListTS(
                                        listTS![i]["ReasonType"],
                                        listTS![i]["TicketID"],
                                        listTS![i]["CreatedDate"],
                                        listTS![i]["UpdatedDate"],
                                        listTS![i]["RequestingDate"],
                                        listTS![i]["Note"],
                                        listTS![i]["Status"],
                                        i),
                                  ),
                                ],
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          FlutterFlowDropDown(
                            options: listTypeTS!
                                .map((e) => e["Name"].toString())
                                .toList(),
                            onChanged: (val) => setState(() => {
                                  dropDowntypeTS = returnIdTypeTS(val!),
                                  changeTypeTS(dropDowntypeTS!)
                                }),
                            width: double.infinity,
                            height: 52,
                            textStyle:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      color: Color(0xFF979DA3),
                                    ),
                            hintText: 'Loại trễ sớm',
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FlutterFlowTheme.of(context).theme3,
                              size: 26,
                            ),
                            fillColor: Colors.white,
                            elevation: 0,
                            borderColor: FlutterFlowTheme.of(context).lineColor,
                            borderWidth: 0,
                            borderRadius: 8,
                            margin:
                                EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                            hidesUnderline: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (isTypeTS!) ...[
                            FlutterFlowDropDown(
                              options: listReason!
                                  .map((e) => e["Name"].toString())
                                  .toList(),
                              onChanged: (val) => setState(() => {
                                    dropDownlateReasonTS = returnIdReason(val!)
                                  }),
                              width: double.infinity,
                              height: 50,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF979DA3),
                                  ),
                              hintText: 'Lý do',
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: FlutterFlowTheme.of(context).theme3,
                                size: 26,
                              ),
                              fillColor: Colors.white,
                              elevation: 0,
                              borderColor:
                                  FlutterFlowTheme.of(context).lineColor,
                              borderWidth: 0,
                              borderRadius: 8,
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                              hidesUnderline: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                          _buildNote(txtGhiChuTS),
                          SizedBox(
                            height: 10,
                          ),
                          _buildFileUpload(),
                          SizedBox(
                            height: 10,
                          ),
                          _buildCancelSend(() {
                            cancelTicket("TS");
                          }, () async {
                            submitTicketTS();
                          })
                        ],
                        if (showCongTac!) ...[
                          if (listCT!.isNotEmpty)
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 38,
                                  decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .stadeBlue3,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          topLeft: Radius.circular(8))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                        child: Text(
                                          listCT!.length > 0
                                              ? 'Phiếu đã gửi (' +
                                                  listCT!.length.toString() +
                                                  ')'
                                              : 'Phiếu đã gửi',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBtnText,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                for (var i = 0; i < listCT!.length; i++) ...[
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 0, 0),
                                    child: _buildListCT(
                                        listCT![i]["ReasonType"],
                                        listCT![i]["TicketID"],
                                        listCT![i]["CreatedDate"],
                                        listCT![i]["UpdatedDate"],
                                        listCT![i]["RequestingDate"],
                                        listCT![i]["Note"],
                                        listCT![i]["Status"],
                                        i),
                                  ),
                                ],
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          FlutterFlowDropDown(
                            options: listTypeCT!
                                .map((e) => e["Name"].toString())
                                .toList(),
                            onChanged: (val) => setState(() => {
                                  dropDowntypeCT = returnIdTypeCT(val!),
                                  changeTypeCT(dropDowntypeCT!)
                                }),
                            width: double.infinity,
                            height: 52,
                            textStyle:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      color: Color(0xFF979DA3),
                                    ),
                            hintText: 'Loại công tác',
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FlutterFlowTheme.of(context).theme3,
                              size: 26,
                            ),
                            fillColor: Colors.white,
                            elevation: 0,
                            borderColor: FlutterFlowTheme.of(context).lineColor,
                            borderWidth: 0,
                            borderRadius: 8,
                            margin:
                                EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                            hidesUnderline: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _buildNote(txtGhiChuCT),
                          SizedBox(
                            height: 10,
                          ),
                          _buildFileUpload(),
                          SizedBox(
                            height: 10,
                          ),
                          _buildCancelSend(() {
                            cancelTicket("TS");
                          }, () async {
                            submitTicketCT();
                          })
                        ],
                        if (showTangCa!) ...[
                          if (listTC!.isNotEmpty) ...[
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 38,
                                  decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .stadeBlue3,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          topLeft: Radius.circular(8))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                        child: Text(
                                          listTS!.length > 0
                                              ? 'Phiếu đã gửi (' +
                                                  listTS!.length.toString() +
                                                  ')'
                                              : 'Phiếu đã gửi',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBtnText,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                for (var i = 0; i < listTC!.length; i++) ...[
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 0, 0),
                                    child: _buildListTC(
                                        listTC![i]["TicketID"],
                                        listTC![i]["CreatedDate"],
                                        listTC![i]["UpdatedDate"],
                                        listTC![i]["RequestingDate"],
                                        listTC![i]["Note"],
                                        listTC![i]["Status"],
                                        listTC![i]["OTHours"],
                                        listTC![i]["ApprovedOTHours"],
                                        i),
                                  ),
                                ],
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/pencil.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Bạn đã tạo Phiếu tăng ca',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Để thay đổi, vui lòng huỷ phiếu đã tạo',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context)
                                                .stateOrange3,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ] else ...[
                            FlutterFlowDropDown(
                              options: [
                                '0.5',
                                '1',
                                '1.5',
                                '2',
                                '2.5',
                                '3',
                                '3.5',
                                '4',
                                '4.5',
                                '5',
                                '5.5',
                                '6',
                                '6.5',
                                '7',
                                '7.5',
                                '8',
                                '8.5',
                                '9',
                                '9.5',
                                '10'
                              ],
                              onChanged: (val) =>
                                  setState(() => dropDowntypeTC = val),
                              width: double.infinity,
                              height: 52,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF979DA3),
                                  ),
                              hintText: 'Số giờ tăng ca',
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: FlutterFlowTheme.of(context).theme3,
                                size: 26,
                              ),
                              fillColor: Colors.white,
                              elevation: 0,
                              borderColor:
                                  FlutterFlowTheme.of(context).lineColor,
                              borderWidth: 0,
                              borderRadius: 8,
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                              hidesUnderline: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _buildNote(txtGhiChuTC),
                            SizedBox(
                              height: 10,
                            ),
                            _buildFileUpload(),
                            SizedBox(
                              height: 10,
                            ),
                            _buildCancelSend(() {
                              cancelTicket("TC");
                            }, () async {
                              submitTicketTC();
                            })
                          ]
                        ],
                        if (showNghiPhep!) ...[
                          if (listNP!.isNotEmpty) ...[
                            for (var i = 0; i < listNP!.length; i++) ...[
                              _buildListNP(
                                listNP![i]["TicketID"].toString(),
                                listNP![i]["CreatedDate"].toString(),
                                listNP![i]["UpdatedDate"].toString(),
                                listNP![i]["Name"].toString(),
                                listNP![i]["FromDate"].toString(),
                                listNP![i]["ToDate"].toString(),
                                listNP![i]["Type"].toString(),
                                listNP![i]["NumberFurloughDetail"].toString(),
                                listNP![i]["NoSalary"] == null
                                    ? "0"
                                    : listNP![i]["NoSalary"].toString(),
                                listNP![i]["TempLeave"] == null
                                    ? "0"
                                    : listNP![i]["TempLeave"].toString(),
                                listNP![i]["Note"].toString(),
                                listNP![i]["Status"].toString(),
                                i,
                              )
                            ],
                            SizedBox(
                              height: 10,
                            ),
                          ],
                          FlutterFlowDropDown(
                            initialOption: dropDownTypeNP,
                            options: [
                              'Nghỉ phép năm',
                              'Nghỉ BHXH',
                              'Nghỉ chế độ'
                            ],
                            onChanged: (val) => setState(
                                () => {dropDownTypeNP = val, changeTypeNP()}),
                            width: double.infinity,
                            height: 52,
                            textStyle:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      color: Color(0xFF979DA3),
                                    ),
                            hintText: 'Loại nghỉ phép',
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FlutterFlowTheme.of(context).theme3,
                              size: 26,
                            ),
                            fillColor: Colors.white,
                            elevation: 0,
                            borderColor: FlutterFlowTheme.of(context).lineColor,
                            borderWidth: 0,
                            borderRadius: 8,
                            margin:
                                EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                            hidesUnderline: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (showNPTT!) ...[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 5, 0),
                                    child: TextField(
                                      readOnly: true,
                                      controller: fromDateNP,
                                      
                                      // onTap: () async {
                                      //   DateTime? pickeddate =
                                      //       await showDatePicker(
                                      //           context: context,
                                      //           initialDate: DateTime.now(),
                                      //           firstDate: DateTime(2000),
                                      //           lastDate: DateTime(2101));
                                      //   if (pickeddate != null) {
                                      //     setState(() {
                                      //       fromDateNP.text =
                                      //           DateFormat('dd/MM/yyyy')
                                      //               .format(pickeddate);
                                      //     });
                                      //   }
                                      // },
                                      decoration: InputDecoration(
                                        labelText: 'Nghỉ từ ngày',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor:
                                            FlutterFlowTheme.of(context).theme2,
                                        suffixIcon: Icon(
                                          FFIcons.kcalendarAddOn,
                                          color: Color(0xFF979DA3),
                                          size: 24,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF979DA3),
                                            fontSize: 12,
                                            lineHeight: 1,
                                          ),
                                      keyboardType: TextInputType.none,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 0, 0),
                                    child: TextFormField(
                                      controller: toDateNP,
                                      onTap: () async {
                                        DateTime? pickeddate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101));
                                        if (pickeddate != null) {
                                          setState(() {
                                            addDateNP(pickeddate);
                                          });
                                        }
                                      },
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Nghỉ đến ngày',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor:
                                            FlutterFlowTheme.of(context).theme2,
                                        suffixIcon: Icon(
                                          FFIcons.kcalendarAddOn,
                                          color: Color(0xFF979DA3),
                                          size: 24,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF979DA3),
                                            fontSize: 12,
                                            lineHeight: 1,
                                          ),
                                      keyboardType: TextInputType.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(0),
                                              bottomRight: Radius.circular(0),
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(0),
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              height: 35,
                                              constraints: BoxConstraints(
                                                maxWidth: 132,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFAFD5FF),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(0),
                                                  bottomRight:
                                                      Radius.circular(0),
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(0),
                                                ),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .lineColor,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Số ngày nghỉ',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily:
                                                              'Roboto Condensed',
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFF5),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  furloughNP.numberFurlough
                                                      .toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .stateRED3,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFAFD5FF),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Đã ứng phép',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily:
                                                            'Roboto Condensed',
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .backgroundComponents,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFF5),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  furloughNP.loanLeave
                                                      .toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor3,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFAFD5FF),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Phép được hưởng',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily:
                                                            'Roboto Condensed',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFF5),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  furloughNP.leaveRemainPrevYear
                                                          .toString() +
                                                      " + " +
                                                      furloughNP
                                                          .avaiableLeaveRemain
                                                          .toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor3,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFAFD5FF),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Phép có thể ứng',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily:
                                                            'Roboto Condensed',
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .backgroundComponents,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFF5),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  furloughNP.maxLoanLeave
                                                      .toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor3,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFAFD5FF),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(0),
                                                bottomRight: Radius.circular(0),
                                                topLeft: Radius.circular(0),
                                                topRight: Radius.circular(8),
                                              ),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Phép năm',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily:
                                                            'Roboto Condensed',
                                                        fontSize: 13,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFF5),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  furloughNP.annualLeave
                                                      .toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor3,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFAFD5FF),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Tạm ứng phép',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily:
                                                            'Roboto Condensed',
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .backgroundComponents,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFF5),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  furloughNP.tempLeave
                                                      .toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor3,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFAFD5FF),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Phép còn lại',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily:
                                                            'Roboto Condensed',
                                                        fontSize: 13,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFF5),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(0),
                                                topLeft: Radius.circular(0),
                                                topRight: Radius.circular(0),
                                              ),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  furloughNP.leaveRemain
                                                      .toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor3,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFAFD5FF),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Chi tiết nghỉ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily:
                                                            'Roboto Condensed',
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFF5),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiaryColor,
                                                      barrierColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiaryColor,
                                                      context: context,
                                                      builder: (context) {
                                                        return Padding(
                                                          padding:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .viewInsets,
                                                          child: BtsChiTietPhepWidget(
                                                              listFurlough:
                                                                  listDateArray,
                                                              furloughNP:
                                                                  furloughNP,
                                                              updateList:
                                                                  updateListFurlough),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        setState(() {}));
                                                  },
                                                  text: 'Xem',
                                                  options: FFButtonOptions(
                                                    width: 80,
                                                    height: 30,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .stateRED1,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .subtitle2
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .backgroundComponents,
                                                          fontSize: 14,
                                                        ),
                                                    elevation: 2,
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .stateRED3,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFAFD5FF),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Nghỉ không lương',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily:
                                                            'Roboto Condensed',
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFF5),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(0),
                                                bottomRight: Radius.circular(8),
                                                topLeft: Radius.circular(0),
                                                topRight: Radius.circular(0),
                                              ),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .lineColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FlutterFlowDropDown(
                                                  initialOption: furloughNP
                                                      .noSalary
                                                      .toString(),
                                                  options: noSalary
                                                      .map((e) => e.toString())
                                                      .toList(),
                                                  onChanged: (val) => {
                                                    setState(() =>
                                                        furloughNP.noSalary =
                                                            double.parse(val!)),
                                                    changeNoSalary()
                                                  },
                                                  width: 90,
                                                  height: 35,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyText1
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            color: Colors.black,
                                                          ),
                                                  hintText: 'Chọn',
                                                  fillColor: Colors.white,
                                                  elevation: 2,
                                                  borderColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .lineColor,
                                                  borderWidth: 0,
                                                  borderRadius: 10,
                                                  margin: EdgeInsetsDirectional
                                                      .fromSTEB(12, 4, 12, 4),
                                                  hidesUnderline: true,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _buildNote(txtGhiChuNP),
                            SizedBox(
                              height: 10,
                            ),
                            _buildFileUpload(),
                            SizedBox(height: 10),
                            _buildCancelSend(() {
                              cancelTicket("NP");
                            }, () {
                              submitTicketNPTT();
                            })
                          ] else if (showNPCD!) ...[
                            FlutterFlowDropDown(
                              options: listReasonFurlough!
                                  .where((i) =>
                                      i["FurloughType"].toString() == "CD")
                                  .toList()
                                  .map((e) => e["ReasonName"].toString())
                                  .toList(),
                              // listReasonFurlough!.map((e) => e["ReasonName"].toString()).toList(),
                              onChanged: (val) => setState(() => {
                                    dropDownTypeNPCD = val,
                                    changeNumberFurloughMax(dropDownTypeNPCD!)
                                  }),
                              width: double.infinity,
                              height: 52,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF979DA3),
                                  ),
                              hintText: 'Loại phép',
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: FlutterFlowTheme.of(context).theme3,
                                size: 26,
                              ),
                              fillColor: Colors.white,
                              elevation: 0,
                              borderColor:
                                  FlutterFlowTheme.of(context).lineColor,
                              borderWidth: 0,
                              borderRadius: 8,
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                              hidesUnderline: true,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 5, 0),
                                    child: TextField(
                                      readOnly: true,
                                      controller: fromDateNP,
                                      // onTap: () async {
                                      //   DateTime? pickeddate =
                                      //       await showDatePicker(
                                      //           context: context,
                                      //           initialDate: DateTime.now(),
                                      //           firstDate: DateTime(2000),
                                      //           lastDate: DateTime(2101));
                                      //   if (pickeddate != null) {
                                      //     setState(() {
                                      //       fromDateNP.text =
                                      //           DateFormat('dd/MM/yyyy')
                                      //               .format(pickeddate);
                                      //     });
                                      //   }
                                      // },
                                      decoration: InputDecoration(
                                        labelText: 'Nghỉ từ ngày',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor:
                                            FlutterFlowTheme.of(context).theme2,
                                        suffixIcon: Icon(
                                          FFIcons.kcalendarAddOn,
                                          color: Color(0xFF979DA3),
                                          size: 24,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF979DA3),
                                            fontSize: 12,
                                            lineHeight: 1,
                                          ),
                                      keyboardType: TextInputType.none,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 0, 0),
                                    child: TextFormField(
                                      controller: toDateNP,
                                      onTap: () async {
                                        DateTime? pickeddate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101));
                                        if (pickeddate != null) {
                                          setState(() {
                                            addDateNP(pickeddate);
                                          });
                                        }
                                      },
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Nghỉ đến ngày',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor:
                                            FlutterFlowTheme.of(context).theme2,
                                        suffixIcon: Icon(
                                          FFIcons.kcalendarAddOn,
                                          color: Color(0xFF979DA3),
                                          size: 24,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF979DA3),
                                            fontSize: 12,
                                            lineHeight: 1,
                                          ),
                                      keyboardType: TextInputType.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFAFD5FF),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(0),
                                          ),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Số ngày nghỉ',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFFFF5),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(0),
                                          ),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              furloughNP.numberFurlough
                                                  .toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .customColor3,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFAFD5FF),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(8),
                                          ),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Số phép tối đa',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFFFF5),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(8),
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(0),
                                          ),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              numberFurloughMaxUse.toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .customColor3,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: BtsChiTietPhepPChedoWidget(
                                          listFurlough: listDateArray),
                                    );
                                  },
                                ).then((value) => setState(() {}));
                              },
                              text: 'Xem chi tiết nghỉ',
                              icon: Icon(
                                FFIcons.kcalendar,
                                size: 15,
                              ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 30,
                                elevation: 0,
                                color:
                                    FlutterFlowTheme.of(context).tertiaryColor,
                                textStyle: FlutterFlowTheme.of(context)
                                    .subtitle2
                                    .override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context)
                                          .stadeBlue3,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildNote(txtGhiChuNP),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildFileUpload(),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildCancelSend(() {
                              cancelTicket("NP");
                            }, () {
                              submitTicketNPCD();
                            })
                          ] else if (showNPBHXH!) ...[
                            FlutterFlowDropDown(
                              options: listReasonFurlough!
                                  .where((i) =>
                                      i["FurloughType"].toString() == "BHXH")
                                  .toList()
                                  .map((e) => e["ReasonName"].toString())
                                  .toList(),
                              // listReasonFurlough!.map((e) => e["ReasonName"].toString()).toList(),
                              onChanged: (val) => setState(() => {
                                    dropDownTypeNPBHXH = val,
                                    changeNumberFurloughMax(dropDownTypeNPBHXH!)
                                  }),
                              width: double.infinity,
                              height: 52,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF979DA3),
                                  ),
                              hintText: 'Loại phép',
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: FlutterFlowTheme.of(context).theme3,
                                size: 26,
                              ),
                              fillColor: Colors.white,
                              elevation: 0,
                              borderColor:
                                  FlutterFlowTheme.of(context).lineColor,
                              borderWidth: 0,
                              borderRadius: 8,
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                              hidesUnderline: true,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 5, 0),
                                    child: TextField(
                                      readOnly: true,
                                      controller: fromDateNP,                                
                                      decoration: InputDecoration(
                                        labelText: 'Nghỉ từ ngày',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor:
                                            FlutterFlowTheme.of(context).theme2,
                                        suffixIcon: Icon(
                                          FFIcons.kcalendarAddOn,
                                          color: Color(0xFF979DA3),
                                          size: 24,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF979DA3),
                                            fontSize: 12,
                                            lineHeight: 1,
                                          ),
                                      keyboardType: TextInputType.none,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 0, 0),
                                    child: TextFormField(
                                      controller: toDateNP,
                                      onTap: () async {
                                        DateTime? pickeddate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101));
                                        if (pickeddate != null) {
                                          setState(() {
                                            addDateNP(pickeddate);
                                          });
                                        }
                                      },
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Nghỉ đến ngày',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .stateRED2,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor:
                                            FlutterFlowTheme.of(context).theme2,
                                        suffixIcon: Icon(
                                          FFIcons.kcalendarAddOn,
                                          color: Color(0xFF979DA3),
                                          size: 24,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF979DA3),
                                            fontSize: 12,
                                            lineHeight: 1,
                                          ),
                                      keyboardType: TextInputType.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFAFD5FF),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(0),
                                          ),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Số ngày nghỉ',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFFFF5),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(0),
                                          ),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              furloughNP.numberFurlough
                                                  .toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .customColor3,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFAFD5FF),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(8),
                                          ),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Số phép tối đa',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFFFF5),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(8),
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(0),
                                          ),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              numberFurloughMaxUse.toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .customColor3,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildNote(txtGhiChuNP),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildFileUpload(),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildCancelSend(() {
                              cancelTicket("NP");
                            }, () {
                              submitTicketNPBHXH();
                            })
                          ]
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildNote(TextEditingController txtGhiChu) {
    return TextFormField(
      controller: txtGhiChu,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Lý do',
        labelStyle: FlutterFlowTheme.of(context).bodyText1.override(
              fontFamily: 'Inter',
              color: Color(0xFF979DA3),
              lineHeight: 4,
            ),
        hintStyle: FlutterFlowTheme.of(context).bodyText2,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).lineColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).lineColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBtnText,
      ),
      style: FlutterFlowTheme.of(context).bodyText1.override(
            fontFamily: 'Inter',
            color: Color(0xFF979DA3),
            fontSize: 12,
            lineHeight: 2,
          ),
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildFileUpload() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'File đính kèm',
          style: FlutterFlowTheme.of(context).bodyText1.override(
                fontFamily: 'Inter',
                fontSize: 16,
              ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
          child: FlutterFlowIconButton(
            borderColor: FlutterFlowTheme.of(context).lineColor,
            borderRadius: 10,
            borderWidth: 1,
            buttonSize: 40,
            fillColor: Color(0xFF979DA3),
            icon: Icon(
              Icons.add,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 20,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCancelSend(void cancel(), void send()) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
            child: FFButtonWidget(
              onPressed: () {
                cancel();
              },
              text: 'Huỷ phiếu',
              icon: Icon(
                FFIcons.kclose,
                size: 25,
              ),
              options: FFButtonOptions(
                width: double.infinity,
                height: 48,
                color: FlutterFlowTheme.of(context).stateRED3,
                textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                elevation: 2,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
            child: FFButtonWidget(
              onPressed: () async {
                send();
              },
              text: 'Gửi đi',
              icon: Icon(
                FFIcons.kemail234,
                size: 25,
              ),
              options: FFButtonOptions(
                width: double.infinity,
                height: 48,
                color: FlutterFlowTheme.of(context).customColor3,
                textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                elevation: 2,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListTS(
      String typeTS,
      String ticketId,
      String createdDate,
      String updateDate,
      String date,
      dynamic reason,
      String status,
      int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                deletedTicket(ticketId, updateDate, index, "TS");
              },
              icon: FFIcons.kdelete,
              backgroundColor: Colors.red,
              label: "Hủy phiếu",
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          height: 75,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: status == 'APP'
                          ? Color.fromARGB(255, 1, 247, 9)
                          : status == 'ACC'
                              ? Color.fromARGB(255, 252, 227, 3)
                              : Color.fromARGB(255, 255, 20, 3),
                    ),
                  ),
                  child: Icon(
                    status == 'APP'
                        ? Icons.check_circle
                        : status == 'ACC'
                            ? Icons.hourglass_empty
                            : Icons.clear,
                    color: status == 'APP'
                        ? Color.fromARGB(255, 1, 247, 9)
                        : status == 'ACC'
                            ? Color.fromARGB(255, 252, 227, 3)
                            : Color.fromARGB(255, 255, 20, 3),
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 3, 0, 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            returnNameTypeTS(typeTS),
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 5),
                            child: Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(DateTime.parse(createdDate)),
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF979DA3),
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                            child: Text(
                              'Ngày xin:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(date)),
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .override(
                                  fontFamily: 'Inter',
                                  color:
                                      FlutterFlowTheme.of(context).stadeBlue3,
                                  fontSize: 13,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                            child: Text(
                              'Lý do:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              reason == null ? "" : reason,
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    color:
                                        FlutterFlowTheme.of(context).stadeBlue3,
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCT(
      String typeCT,
      String ticketId,
      String createdDate,
      String updateDate,
      String date,
      dynamic reason,
      String status,
      int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                deletedTicket(ticketId, updateDate, index, "CT");
              },
              icon: FFIcons.kdelete,
              backgroundColor: Colors.red,
              label: "Hủy phiếu",
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          height: 75,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 10, 0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: status == 'APP'
                          ? Color.fromARGB(255, 1, 247, 9)
                          : status == 'ACC'
                              ? Color.fromARGB(255, 252, 227, 3)
                              : Color.fromARGB(255, 255, 20, 3),
                    ),
                  ),
                  child: Icon(
                    status == 'APP'
                        ? Icons.check_circle
                        : status == 'ACC'
                            ? Icons.hourglass_empty
                            : Icons.clear,
                    color: status == 'APP'
                        ? Color.fromARGB(255, 1, 247, 9)
                        : status == 'ACC'
                            ? Color.fromARGB(255, 252, 227, 3)
                            : Color.fromARGB(255, 255, 20, 3),
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 3, 0, 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phiếu công tác',
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 5),
                            child: Text(
                              DateFormat("dd/MM/yyyy HH:mm")
                                  .format(DateTime.parse(createdDate)),
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF979DA3),
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                            child: Text(
                              'Ngày công tác:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                          Text(
                            DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(date)),
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .override(
                                  fontFamily: 'Inter',
                                  color:
                                      FlutterFlowTheme.of(context).stadeBlue3,
                                  fontSize: 13,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                            child: Text(
                              'Loại công tác:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                          Text(
                            returnNameTypeCT(typeCT),
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .override(
                                  fontFamily: 'Inter',
                                  color:
                                      FlutterFlowTheme.of(context).stadeBlue3,
                                  fontSize: 13,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTC(
      String ticketId,
      String createdDate,
      String updateDate,
      String date,
      dynamic reason,
      String status,
      dynamic otHours,
      dynamic otHoursApproved,
      int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                deletedTicket(ticketId, updateDate, index, "TC");
              },
              icon: FFIcons.kdelete,
              backgroundColor: Colors.red,
              label: "Hủy phiếu",
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
            ),
          ],
        ),
        child: Container(
          height: 95,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 10, 0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: status == 'APP'
                          ? Color.fromARGB(255, 1, 247, 9)
                          : status == 'ACC'
                              ? Color.fromARGB(255, 252, 227, 3)
                              : Color.fromARGB(255, 255, 20, 3),
                    ),
                  ),
                  child: Icon(
                    status == 'APP'
                        ? Icons.check_circle
                        : status == 'ACC'
                            ? Icons.hourglass_empty
                            : Icons.clear,
                    color: status == 'APP'
                        ? Color.fromARGB(255, 1, 247, 9)
                        : status == 'ACC'
                            ? Color.fromARGB(255, 252, 227, 3)
                            : Color.fromARGB(255, 255, 20, 3),
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 3, 0, 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phiếu tăng ca',
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 5),
                            child: Text(
                              DateFormat("dd/MM/yyyy HH:mm")
                                  .format(DateTime.parse(createdDate)),
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF979DA3),
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                            child: Text(
                              'Ngày tăng ca:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                          Text(
                            DateFormat("dd/MM/yyyy")
                                .format(DateTime.parse(date)),
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .override(
                                  fontFamily: 'Inter',
                                  color:
                                      FlutterFlowTheme.of(context).stadeBlue3,
                                  fontSize: 13,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                            child: Text(
                              'Lý do:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              reason,
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    color:
                                        FlutterFlowTheme.of(context).stadeBlue3,
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 5, 0),
                                  child: Text(
                                    'Giờ đề xuất:',
                                    style:
                                        FlutterFlowTheme.of(context).bodyText1,
                                  ),
                                ),
                                Text(
                                  otHours.toString(),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context)
                                            .stateOrange3,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 5, 0),
                                  child: Text(
                                    'Giờ duyệt:',
                                    style:
                                        FlutterFlowTheme.of(context).bodyText1,
                                  ),
                                ),
                                Text(
                                  otHoursApproved.toString(),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context)
                                            .stateRED3,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListNP(
      String ticketId,
      String createdDate,
      String updateDate,
      String typeNP,
      String fromDate,
      String toDate,
      String typeTicket,
      String numberFurlough,
      String noSalary,
      String tempLeave,
      String note,
      String status,
      int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                deletedTicket(ticketId, updateDate, index, "NP");
              },
              icon: FFIcons.kdelete,
              backgroundColor: Colors.red,
              label: "Hủy phiếu",
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(2, 4),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Material(
                color: Colors.transparent,
                elevation: 1,
                child: Container(
                  width: double.infinity,
                  height: 38,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).stadeBlue3,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'Phiếu đã gửi',
                          style: FlutterFlowTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: 'Inter',
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).tertiaryColor,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 10, 0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: status == 'APP'
                                ? Color.fromARGB(255, 1, 247, 9)
                                : (status == 'ACC' || status == "AC2")
                                    ? Color.fromARGB(255, 252, 227, 3)
                                    : Color.fromARGB(255, 255, 20, 3),
                          ),
                        ),
                        child: Icon(
                          status == 'APP'
                              ? Icons.check_circle
                              : (status == 'ACC' || status == 'AC2')
                                  ? Icons.hourglass_empty
                                  : Icons.clear,
                          color: status == 'APP'
                              ? Color.fromARGB(255, 1, 247, 9)
                              : (status == 'ACC' || status == "AC2")
                                  ? Color.fromARGB(255, 252, 227, 3)
                                  : Color.fromARGB(255, 255, 20, 3),
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Phiếu nghỉ phép',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 5, 5),
                                  child: Text(
                                    DateFormat("dd/MM/yyyy HH:mm")
                                        .format(DateTime.parse(createdDate)),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF979DA3),
                                          fontSize: 11,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 3, 0),
                                  child: Text(
                                    'Loại phiếu: ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                        ),
                                  ),
                                ),
                                Text(
                                  typeTicket == 'TT'
                                      ? 'Nghỉ phép năm'
                                      : typeTicket == 'CD'
                                          ? 'Nghỉ chế độ'
                                          : 'Nghỉ BHXH',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context)
                                            .stadeBlue3,
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (typeTicket != 'TT')
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 3, 0),
                                    child: Text(
                                      'Loại phép: ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            fontSize: 13,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    typeNP,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .stadeBlue3,
                                          fontSize: 13,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          if (typeTicket == 'TT') ...[
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 3, 0),
                                    child: Text(
                                      'Ngày nghỉ: ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            fontSize: 13,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat("dd/MM/yyyy")
                                        .format(DateTime.parse(toDate)),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .stadeBlue3,
                                          fontSize: 13,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 5, 0),
                                          child: Text(
                                            'Từ: ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                          ),
                                        ),
                                        Text(
                                          DateFormat("dd/MM/yyyy")
                                              .format(DateTime.parse(fromDate)),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .stadeBlue3,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 5, 0),
                                          child: Text(
                                            'Đến: ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                          ),
                                        ),
                                        Text(
                                          DateFormat("dd/MM/yyyy")
                                              .format(DateTime.parse(toDate)),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .stadeBlue3,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (typeTicket == 'TT') ...[
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 5, 0),
                                          child: Text(
                                            'Phép:',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                          ),
                                        ),
                                        Text(
                                          numberFurlough,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .stateRED3,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 5, 0),
                                          child: Text(
                                            'Nghỉ KL:',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                          ),
                                        ),
                                        Text(
                                          noSalary,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .stateOrange3,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 5, 0),
                                          child: Text(
                                            'Tạm ứng:',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1,
                                          ),
                                        ),
                                        Text(
                                          tempLeave,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .stateOrange3,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 3, 0),
                                    child: Text(
                                      'Số ngày: ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            fontSize: 13,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    numberFurlough,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .stateRED3,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 3, 0),
                                  child: Text(
                                    'Lý do: ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                        ),
                                  ),
                                ),
                                Text(
                                  note,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context)
                                            .stadeBlue3,
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
