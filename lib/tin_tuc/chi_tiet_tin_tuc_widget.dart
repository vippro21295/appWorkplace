import 'package:app_workplace/backend/api_requests/api_calls.dart';
import 'package:app_workplace/custom_code/actions/shimmer.dart';
import 'package:app_workplace/index.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import '../../custom_code/actions/index.dart' as actions;

class ChiTietTinTucWidget extends StatefulWidget {
  const ChiTietTinTucWidget({Key? key, this.Id}) : super(key: key);
  final String? Id;

  @override
  _ChiTietTinTucWidgetState createState() => _ChiTietTinTucWidgetState();
}

class _ChiTietTinTucWidgetState extends State<ChiTietTinTucWidget> {
  ApiCallResponse? responseCmt;
  ApiCallResponse? responseDel;
  TextEditingController cmt = new TextEditingController();
  var news;
  String sourceContent = '';
  List<dynamic> news_relate = [];
  List<dynamic> comment = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = FocusNode();
  bool isLike = false;
  bool showCmt = false;
  int numberLike = 0;

  List<String> tagList = [
    "#QuyTriDuc",
    "#VP16",
    "#CH165",
    "#VP220",
    "#PhatTienHolding",
    "#PhatTien1"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void unLike() async {
    setState(() {
      isLike = false;
      --numberLike;
    });
    await PTCUpdateLikeNews.call(
        userName: FFAppState().userName, Id: widget.Id, Like: "false");
  }

  void like() async {
    setState(() {
      isLike = true;
      ++numberLike;
    });
    await PTCUpdateLikeNews.call(
        userName: FFAppState().userName, Id: widget.Id, Like: "true");
  }

  void insertComment() async {
    responseCmt = await PTCInsertCommentNews.call(
        userName: FFAppState().userName, Id: widget.Id, comment: cmt.text);
    if (responseCmt != null) {
      if (getJsonField(
        (responseCmt?.jsonBody ?? ''),
        r'''$.isSuccess''',
      )) {
        setState(() {
          comment = getJsonField(
            (responseCmt?.jsonBody ?? ''),
            r'''$.cmt''',
          ).toList();
        });
      }
    }
    // đóng bàn phím
    _focusNode.unfocus();
    cmt.text = "";
  }

  void showHideCmt() {
    setState(() {
      showCmt = !showCmt;
    });
  }

  void deleteCmt(String IdCmt) {
    actions.popupConfirm(context, "Xác nhận xóa bình luận ra khỏi bài viết",
        () async {
      responseDel = await PTCDeleteCmtNews.call(id: widget.Id, IdCmt: IdCmt);
      if (responseDel != null) {
        if (getJsonField(responseDel?.jsonBody, r'''$.isSuccess''')) {
          setState(() {
            comment = getJsonField(
              (responseCmt?.jsonBody ?? ''),
              r'''$.cmt''',
            ).toList();
          });
        }
      }
    });
  }

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
    return FutureBuilder<ApiCallResponse>(
      future:
          PTCGetNewsDetail.call(userName: FFAppState().userName, Id: widget.Id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ShimmerLoading();
        }

        if (getJsonField(snapshot.data!.jsonBody, r'''$.isSuccess''')) {
          news = getJsonField(snapshot.data!.jsonBody, r'''$.news''');
          news_relate =
              getJsonField(snapshot.data!.jsonBody, r'''$.relate''').toList();
          sourceContent = news["SourceContent"] ?? "";
          sourceContent = '<div>' + sourceContent + '</div>';
          sourceContent = sourceContent.replaceAll('&nbsp;', ' ');
          numberLike = news["LikeNews"] ?? 0;
          isLike = getJsonField(snapshot.data!.jsonBody, r'''$.isLike''');
          comment =
              getJsonField(snapshot.data!.jsonBody, r'''$.comment''').toList();
        }

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).theme2,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).theme2,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              borderWidth: 1,
              buttonSize: 50,
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: FlutterFlowTheme.of(context).stadeBlue3,
                size: 24,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TinTucWidget()));
              },
            ),
            actions: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 10, 8),
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 10,
                  borderWidth: 1,
                  buttonSize: 40,
                  fillColor: FlutterFlowTheme.of(context).stadeBlue1,
                  icon: Icon(
                    Icons.share_sharp,
                    color: FlutterFlowTheme.of(context).stadeBlue3,
                    size: 20,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 10, 8),
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 10,
                  borderWidth: 1,
                  buttonSize: 40,
                  fillColor: FlutterFlowTheme.of(context).stadeBlue1,
                  icon: Icon(
                    Icons.bookmark_border_rounded,
                    color: FlutterFlowTheme.of(context).stadeBlue3,
                    size: 20,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 16, 8),
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 10,
                  borderWidth: 1,
                  buttonSize: 40,
                  fillColor: FlutterFlowTheme.of(context).stadeBlue1,
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: FlutterFlowTheme.of(context).stadeBlue3,
                    size: 20,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ),
            ],
            centerTitle: false,
            elevation: 1,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      news["Images"],
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    news["Quote"] ?? news["NewsName"],
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                        decoration: BoxDecoration(
                            color: Color(int.parse(news["CateColor"])),
                            border: Border.all(
                                color:
                                    Color(int.parse(news["CateColorBorder"])),
                                width: 1),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          news["CateName"].toString(),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.remove_red_eye_rounded,
                              color: Colors.blue),
                          Text(
                            ' ' + news["ViewNews"].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.blue),
                          Text(
                            ' ' + news["LikeNews"].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.comment, color: Colors.blue),
                          Text(
                            ' ' + news["CommentNews"].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  HtmlWidget(
                    sourceContent,
                    customStylesBuilder: (element) {
                      if (element.localName == "div") {
                        return {'color': 'black', 'text-align': 'justify'};
                      } else {
                        return null;
                      }
                    },
                    textStyle: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ...tagList.map((item) {
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 7, 112, 233),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Text(
                              item,
                              style: TextStyle(color: Colors.blue[800]),
                            ),
                          ),
                        );
                      }).toList()
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bài viết hay?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Row(
                        children: [
                          if (isLike)
                            InkWell(
                              onTap: () {
                                unLike();
                              },
                              child: Icon(
                                Icons.favorite,
                                color: Colors.blue,
                              ),
                            )
                          else
                            InkWell(
                              onTap: () {
                                like();
                              },
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.blue,
                              ),
                            ),
                          // số lượng thả tim
                          Text(
                            ' ' + numberLike.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 5, 0),
                                    child: Text(
                                      'Bình luận',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    news["CommentNews"].toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .stadeBlue3,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                child: InkWell(
                                  onTap: () {
                                    showHideCmt();
                                  },
                                  child: Icon(
                                    Icons.import_export,
                                    color:
                                        FlutterFlowTheme.of(context).stadeBlue3,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 2,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                clipBehavior: Clip.antiAlias,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: Image.network(
                                  FFAppState().imageUser,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                      focusNode: _focusNode,
                                      textInputAction: TextInputAction.go,
                                      controller: cmt,
                                      decoration: InputDecoration(
                                        hintText: 'Viết bình luận',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        filled: true,
                                        fillColor:
                                            FlutterFlowTheme.of(context).theme2,
                                      ),
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  onPressed: () {
                                    insertComment();
                                  },
                                  icon: Icon(
                                    Icons.send_rounded,
                                    color: Colors.blue,
                                    size: 26,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (showCmt) ...[
                          Divider(
                            height: 2,
                            thickness: 1,
                            indent: 15,
                            endIndent: 15,
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: comment.length,
                            itemBuilder: ((context, index) {
                              final item = comment[index];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10),
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      clipBehavior: Clip.antiAlias,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: Image.network(
                                        item["Img"],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Card(
                                          color: Color.fromARGB(
                                              255, 218, 216, 216),
                                          elevation: 3.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item["EmployeeName"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  item["Comment"].toString(),
                                                  softWrap: true,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 4, 0, 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                calculateTimeLeft(
                                                    item["CreatedDate"]
                                                        .toString()),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Thích',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              if (item["UserName"].toString() ==
                                                  FFAppState().userName) ...[
                                                InkWell(
                                                  onTap: () {
                                                    deleteCmt(
                                                        item["Id"].toString());
                                                  },
                                                  child: Text(
                                                    'Xóa',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                )
                                              ]
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }),
                          )
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tin tức liên quan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Text('Xem tất cả',
                          style: TextStyle(fontSize: 17, color: Colors.blue))
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: news_relate.length,
                    itemBuilder: ((context, index) {
                      final item = news_relate[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChiTietTinTucWidget(
                                    Id: item["Id"].toString(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 95,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Container(
                                      height: 80,
                                      width: 100,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(item["Images"],
                                              fit: BoxFit.fill)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(item["NewsName"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              maxLines: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    8, 2, 8, 2),
                                                decoration: BoxDecoration(
                                                  color: Color(int.parse(
                                                      item["CateColor"])),
                                                  border: Border.all(
                                                      color: Color(int.parse(item[
                                                          "CateColorBorder"]))),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  item["CateName"],
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                              ),
                                              Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    DateTime.parse(
                                                        item["UpdatedDate"])),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: FlutterFlowTheme.of(context).lineColor,
                          ),
                        ],
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
