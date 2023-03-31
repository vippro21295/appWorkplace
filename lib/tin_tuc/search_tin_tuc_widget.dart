import 'package:app_workplace/backend/api_requests/api_calls.dart';
import 'package:app_workplace/custom_code/actions/shimmer.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chi_tiet_tin_tuc_widget.dart';

class TimKiemTinTucWidget extends StatefulWidget {
  const TimKiemTinTucWidget({Key? key, this.textSearch}) : super(key: key);

  final String? textSearch;
  @override
  _TimKiemTinTucWidgetState createState() => _TimKiemTinTucWidgetState();
}

class _TimKiemTinTucWidgetState extends State<TimKiemTinTucWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? textSearchtext;
  late List<dynamic> listObj = [];
  late List<dynamic> listNews = [];

  @override
  void initState() {
    super.initState();
    textSearchtext = TextEditingController();
    textSearchtext!.text = widget.textSearch!;
  }

  @override
  void dispose() {
    textSearchtext?.dispose();
    super.dispose();
  }

  void searchNews(String value) {
    setState(() {
      textSearchtext!.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: PTCGetNews.call(searchNews: textSearchtext!.text),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ShimmerLoading();
        }

        listObj =
            getJsonField(snapshot.data!.jsonBody, r'''$.listObj''').toList();
        listNews =
            listObj.where((i) => i["IsHotNews"].toString() == 'false').toList();

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
                color: FlutterFlowTheme.of(context).backgroundComponents,
                size: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Tìm kiếm tin tức',
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
                  child: Image.asset(
                    'assets/images/AnhCaNhan.png',
                  ),
                ),
              ),
            ],
            centerTitle: false,
            elevation: 1,
          ),
          body: SafeArea(
            child: GestureDetector(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 10, 0),
                                  child: TextFormField(
                                    controller: textSearchtext,
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (value) {
                                      searchNews(value);
                                    },
                                    // autofocus: true,
                                    // obscureText: false,
                                    decoration: InputDecoration(
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyText2,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .stadeBlue3,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .stadeBlue3,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              5, 0, 5, 0),
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                      ),
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyText1,
                                  ),
                                ),
                              ),
                            ),
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 10,
                              borderWidth: 1,
                              buttonSize: 44,
                              fillColor: Color(0x51175ACD),
                              icon: Icon(
                                Icons.search,
                                color: FlutterFlowTheme.of(context).stadeBlue3,
                                size: 24,
                              ),
                              onPressed: () {
                                // searchNews();
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 6, 16, 0),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listNews.length,
                          itemBuilder: ((context, index) {
                            final item = listNews[index];
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChiTietTinTucWidget(
                                          Id: item["Id"].toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 95,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6),
                                          child: Container(
                                            height: 80,
                                            width: 100,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                    item["Images"],
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    maxLines: 2),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              8, 2, 8, 2),
                                                      decoration: BoxDecoration(
                                                        color: Color(int.parse(
                                                            item["CateColor"])),
                                                        border: Border.all(
                                                            color: Color(
                                                                int.parse(item[
                                                                    "CateColorBorder"]))),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Text(
                                                        item["CateName"],
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(DateTime
                                                              .parse(item[
                                                                  "UpdatedDate"])),
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
                        ),
                      ),
                    ],
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
