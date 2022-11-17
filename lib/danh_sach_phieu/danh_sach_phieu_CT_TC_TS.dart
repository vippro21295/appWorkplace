import 'package:app_workplace/backend/api_requests/api_calls.dart';
import 'package:app_workplace/custom_code/actions/shimmer.dart';
import '../cham_cong/cham_cong_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../custom_code/actions/index.dart' as actions;

class DanhSachPhieuUpdateWidget extends StatefulWidget {
  const DanhSachPhieuUpdateWidget({Key? key, this.typeTicket})
      : super(key: key);
  final String? typeTicket;

  @override
  _DanhSachPhieuUpdateWidgetState createState() =>
      _DanhSachPhieuUpdateWidgetState();
}

class _DanhSachPhieuUpdateWidgetState
    extends State<DanhSachPhieuUpdateWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool? isLoading = false;
  ApiCallResponse? responseApiService;
  ApiCallResponse? responseDelete;
  final _filter = [
    "Tháng chấm công hiện tại",
    "Tháng chấm công trước",
  ];

  final _sort = [
    "Mới nhất",
    "Cũ nhất",
  ];

  String? _selectedVal = '';
  String? _selectedValSort = '';
  String? fromDateFilter = '';
  String? toDateFilter = '';
  String? sortFilter = 'DESC';
  String? titleMonth = '';
  String? titleAppBar = '';

  int numberACC = 0;
  int numberAPP = 0;
  int numberNAP = 0;

  List<dynamic> listUpdateTemp = [];
  List<dynamic> listUpdate = [];

  bool isALL = true;
  bool isAPP = false;
  bool isACC = false;
  bool isNAP = false;

  @override
  void initState() {
    setTitleAppbar();
    setMonth("NOW");
    setState(() {
      _selectedVal = _filter[0];
      _selectedValSort = _sort[0];
    });
    getlistUpdateFromServices();
    super.initState();
  }

  void getlistUpdateFromServices() async {
    setState(() {
      isLoading = true;
    });
    responseApiService = await PTCGetListUpdateTicket.call(
        userName: FFAppState().userName,
        type: widget.typeTicket,
        fromDate: fromDateFilter,
        toDate: toDateFilter,
        sort: sortFilter);

    if (responseApiService != null) {
      setState(() {
        isLoading = false;
        numberACC = 0;
        numberAPP = 0;
        numberNAP = 0;
      });

      listUpdate =
          getJsonField(responseApiService!.jsonBody, r'''$.listObj''').toList();

      listUpdateTemp = listUpdate;

      listUpdate.forEach((element) => {
            if (element["Status"] == "ACC")
              numberACC = numberACC + 1
            else if (element["Status"] == "APP")
              numberAPP = numberAPP + 1
            else if (element["Status"] == "NAP")
              numberNAP = numberNAP + 1
          });
    }
  }

  void changeFilter() {
    if (_selectedVal == _filter[0]) {
      setMonth("NOW");
      getlistUpdateFromServices();
    } else if (_selectedVal == _filter[1]) {
      setMonth("BEFORE");
      getlistUpdateFromServices();
    }
  }

  void changeSort() {
    if (_selectedValSort == _sort[0]) {
      setState(() {
        sortFilter = "DESC";
        getlistUpdateFromServices();
      });
    } else if (_selectedValSort == _sort[1]) {
      setState(() {
        sortFilter = "ASC";
        getlistUpdateFromServices();
      });
    }
  }

  void setTitleAppbar() {
    if (widget.typeTicket == "CT") titleAppBar = 'Quản lý phiếu công tác';
    if (widget.typeTicket == "TC") titleAppBar = 'Quản lý phiếu tăng ca';
    if (widget.typeTicket == "TS") titleAppBar = 'Quản lý phiếu trễ sớm';
  }

  void setMonth(String type) {
    DateTime getDate = DateTime.now();
    var day = getDate.day;
    var month = type == "NOW" ? getDate.month : (getDate.month - 1);
    var year = getDate.year;

    if (day <= 20) {
      setState(() {
        titleMonth = "THÁNG " + month.toString() + "/" + year.toString();
        fromDateFilter = "21/" + (month - 1).toString() + "/" + year.toString();
        toDateFilter = "20/" + month.toString() + "/" + year.toString();
      });
    } else {
      int nextMonth = month + 1;
      if (nextMonth > 12) {
        setState(() {
          titleMonth = "THÁNG 01/" + (year + 1).toString();
          fromDateFilter = "21/12/" + year.toString();
          toDateFilter = "20/01/" + (year + 1).toString();
        });
      } else {
        setState(() {
          titleMonth =
              "THÁNG " + (month + 1).toString() + "/" + year.toString();
          fromDateFilter = "21/" + month.toString() + "/" + year.toString();
          toDateFilter = "20/" + (month + 1).toString() + "/" + year.toString();
        });
      }
    }
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
    }

    actions.popupConfirm(context, content, () async {
      setState(() {
        isLoading = true;
      });

     
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
          getlistUpdateFromServices();
        } else {
          actions.toastMessage(context, "Error", "Thất bại",
              getJsonField((responseDelete?.jsonBody ?? ''), r'''$.message'''));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading!)
      return ShimmerLoading();
    else
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
            onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ChamCongWidget()));
            },
          ),
          title: Text(
            titleAppBar!,
            style: FlutterFlowTheme.of(context).subtitle2.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).backgroundComponents,
                ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
              child: Container(
                width: 70,
                height: 70,
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
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 1,
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 15, 16, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).tertiaryColor,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 5, 0),
                                  child: Icon(
                                    Icons.filter_list_rounded,
                                    color:
                                        FlutterFlowTheme.of(context).stadeBlue3,
                                    size: 24,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 5, 0),
                                  child: DropdownButton(
                                    value: _selectedVal,
                                    items: _filter
                                        .map((e) => DropdownMenuItem(
                                            child: Text(e,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .stadeBlue3,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        )),
                                            value: e))
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedVal = val;
                                        changeFilter();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: DropdownButton(
                              value: _selectedValSort,
                              items: _sort
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .stadeBlue3,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                )),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedValSort = val;
                                  changeSort();
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 1, 8, 1),
                            child: FFButtonWidget(
                              onPressed: () {
                                setState(() {
                                  isALL = true;
                                  isAPP = false;
                                  isACC = false;
                                  isNAP = false;
                                  listUpdateTemp = listUpdate;
                                });
                              },
                              text: 'Tất cả (' +
                                  listUpdate.length.toString() +
                                  ')',
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 6, 12, 6),
                                color: isALL
                                    ? Color(0xFF00558F)
                                    : FlutterFlowTheme.of(context).lineColor,
                                textStyle: FlutterFlowTheme.of(context)
                                    .subtitle2
                                    .override(
                                      fontFamily: 'Inter',
                                      color: isALL
                                          ? Colors.white
                                          : FlutterFlowTheme.of(context)
                                              .backgroundComponents,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                elevation: 2,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).lineColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 1, 8, 1),
                            child: FFButtonWidget(
                              onPressed: () {
                                setState(() {
                                  isALL = false;
                                  isAPP = true;
                                  isACC = false;
                                  isNAP = false;
                                  listUpdateTemp = listUpdate
                                      .where((ele) => ele["Status"] == "APP")
                                      .toList();
                                });
                              },
                              text: 'Duyệt (' + numberAPP.toString() + ')',
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 6, 12, 6),
                                color: isAPP
                                    ? Color(0xFF00558F)
                                    : FlutterFlowTheme.of(context).lineColor,
                                textStyle: FlutterFlowTheme.of(context)
                                    .subtitle2
                                    .override(
                                      fontFamily: 'Inter',
                                      color: isAPP
                                          ? Colors.white
                                          : FlutterFlowTheme.of(context)
                                              .backgroundComponents,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                elevation: 2,
                                borderSide: BorderSide(
                                  color: Color(0xFFD9D9D9),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 1, 8, 1),
                            child: FFButtonWidget(
                              onPressed: () {
                                setState(() {
                                  isALL = false;
                                  isAPP = false;
                                  isACC = true;
                                  isNAP = false;
                                  listUpdateTemp = listUpdate
                                      .where((ele) => ele["Status"] == "ACC")
                                      .toList();
                                });
                              },
                              text: 'Chờ duyệt (' + numberACC.toString() + ')',
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 6, 12, 6),
                                color: isACC
                                    ? Color(0xFF00558F)
                                    : FlutterFlowTheme.of(context).lineColor,
                                textStyle: FlutterFlowTheme.of(context)
                                    .subtitle2
                                    .override(
                                      fontFamily: 'Inter',
                                      color: isACC
                                          ? Colors.white
                                          : FlutterFlowTheme.of(context)
                                              .backgroundComponents,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                elevation: 2,
                                borderSide: BorderSide(
                                  color: Color(0xFFD9D9D9),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 1, 8, 1),
                            child: FFButtonWidget(
                              onPressed: () {
                                setState(() {
                                  isALL = false;
                                  isAPP = false;
                                  isACC = false;
                                  isNAP = true;
                                  listUpdateTemp = listUpdate
                                      .where((ele) => ele["Status"] == "NAP")
                                      .toList();
                                });
                              },
                              text: 'Từ chối (' + numberNAP.toString() + ')',
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 6, 12, 6),
                                color: isNAP
                                    ? Color(0xFF00558F)
                                    : FlutterFlowTheme.of(context).lineColor,
                                textStyle: FlutterFlowTheme.of(context)
                                    .subtitle2
                                    .override(
                                      fontFamily: 'Inter',
                                      color: isNAP
                                          ? Colors.white
                                          : FlutterFlowTheme.of(context)
                                              .backgroundComponents,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                elevation: 2,
                                borderSide: BorderSide(
                                  color: Color(0xFFD9D9D9),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).lineColor,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 10, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        titleMonth!,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'Inter',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .stateRED3,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                            ),
                            for (int i = 0; i < listUpdateTemp.length; i++) ...[
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 5, 0),
                                  child: widget.typeTicket == "CT"
                                      ? _buildlistCT(
                                          listUpdateTemp[i]["ReasonType"],
                                          listUpdateTemp[i]["TicketID"],
                                          listUpdateTemp[i]["CreatedDate"],
                                          listUpdateTemp[i]["UpdatedDate"],
                                          listUpdateTemp[i]["RequestingDate"],
                                          listUpdateTemp[i]["Note"],
                                          listUpdateTemp[i]["Status"],
                                          listUpdateTemp[i]["Name"],
                                          i)
                                      : widget.typeTicket == "TC"
                                          ? _buildlistTC(
                                              listUpdateTemp[i]["TicketID"],
                                              listUpdateTemp[i]["CreatedDate"],
                                              listUpdateTemp[i]["UpdatedDate"],
                                              listUpdateTemp[i]
                                                  ["RequestingDate"],
                                              listUpdateTemp[i]["Note"],
                                              listUpdateTemp[i]["Status"],
                                              listUpdateTemp[i]["OTHours"],
                                              listUpdateTemp[i]
                                                  ["ApprovedOTHours"],
                                              i)
                                          : _buildlistTS(
                                              listUpdateTemp[i]["ReasonType"],
                                              listUpdateTemp[i]["TicketID"],
                                              listUpdateTemp[i]["CreatedDate"],
                                              listUpdateTemp[i]["UpdatedDate"],
                                              listUpdateTemp[i]
                                                  ["RequestingDate"],
                                              listUpdateTemp[i]["Note"],
                                              listUpdateTemp[i]["Status"],
                                              listUpdateTemp[i]["Name"],
                                              i)
                                  //PhieuCongTacWidget(),
                                  ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                                color: FlutterFlowTheme.of(context).lineColor,
                              ),
                            ],
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

  Widget _buildlistCT(
      String typeCT,
      String ticketId,
      String createdDate,
      String updateDate,
      String date,
      dynamic reason,
      String status,
      String nameTypeCT,
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
                //deletedTicket(ticketId, updateDate, index, "CT");
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
                            nameTypeCT,
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

  Widget _buildlistTC(
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
                // deletedTicket(ticketId, updateDate, index, "TC");
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

  Widget _buildlistTS(
      String typeTS,
      String ticketId,
      String createdDate,
      String updateDate,
      String date,
      dynamic reason,
      String status,
      String name,
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
                            name,
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
}
