import 'package:app_workplace/backend/api_requests/api_calls.dart';
import 'package:app_workplace/custom_code/actions/shimmer.dart';
import 'package:app_workplace/flutter_flow/flutter_flow_util.dart';
import 'package:app_workplace/index.dart';
import 'package:app_workplace/tin_tuc/search_tin_tuc_widget.dart';

import '../app_state.dart';
import '../backend/api_requests/api_manager.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'chi_tiet_tin_tuc_widget.dart';

class TinTucWidget extends StatefulWidget {
  const TinTucWidget({Key? key}) : super(key: key);

  @override
  _TinTucWidgetState createState() => _TinTucWidgetState();
}

class _TinTucWidgetState extends State<TinTucWidget> {
  TextEditingController? textSearch;
  List<dynamic> listObj = [];
  List<dynamic> listNews = [];
  List<dynamic> listNewsHot = [];
  List<dynamic> listNewsQTDUC = [];
  List<dynamic> listNewsVH5T = [];
  List<dynamic> listNewsSKIEN = [];
  List<dynamic> listNewsCTY = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late int current;

  @override
  void initState() {
    super.initState();
    textSearch = TextEditingController();
    textSearch!.text = "";
  }

  @override
  void dispose() {
    textSearch?.dispose();
    super.dispose();
  }

  void searchNews(String search) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TimKiemTinTucWidget(
                    textSearch: search,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: PTCGetNews.call(searchNews: textSearch!.text),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ShimmerLoading();
        }
        if (getJsonField(snapshot.data!.jsonBody, r'''$.isSuccess''')) {
          listObj =
              getJsonField(snapshot.data!.jsonBody, r'''$.listObj''').toList();
          listNewsHot = listObj
              .where((i) => i["IsHotNews"].toString() == 'true')
              .toList();
          listNews = listObj
              .where((i) => i["IsHotNews"].toString() == 'false')
              .toList();
          listNewsQTDUC = listNews
              .where((i) => i["CateCode"].toString() == "TQTD")
              .toList();
          listNewsVH5T = listNews
              .where((i) => i["CateCode"].toString() == "VH5T")
              .toList();
          listNewsSKIEN = listNews
              .where((i) => i["CateCode"].toString() == "SKNB")
              .toList();
          listNewsCTY = listNews
              .where((i) => i["CateCode"].toString() == "TCTY")
              .toList();
        }

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).theme2,
            automaticallyImplyLeading: false,
            title: Text(
              'Tin Tức',
              style: FlutterFlowTheme.of(context).subtitle2.override(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
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
                  child: Image.network(
                    FFAppState().imageUser,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
            centerTitle: true,
            elevation: 1,
          ),
          backgroundColor: FlutterFlowTheme.of(context).theme2,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
                                    controller: textSearch,
                                    //autofocus: true,
                                    //obscureText: false,
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (String value) {
                                      searchNews(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Tìm kiếm',
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
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              5, 0, 5, 0),
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .stadeBlue3,
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
                                Icons.filter_list_rounded,
                                color: FlutterFlowTheme.of(context).stadeBlue3,
                                size: 24,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tin nổi bật',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            // Text(
                            //   'Tất cả',
                            //   style: FlutterFlowTheme.of(context)
                            //       .bodyText1
                            //       .override(
                            //         fontFamily: 'Inter',
                            //         color:
                            //             FlutterFlowTheme.of(context).stadeBlue3,
                            //         fontWeight: FontWeight.w600,
                            //       ),
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                        child: Container(
                          width: double.infinity,
                          height: 220,
                          child: CarouselSlider(
                            options: CarouselOptions(
                                height: 400.0,
                                viewportFraction: 1,
                                autoPlay: true,
                                reverse: false,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.easeIn,
                                initialPage: 0,
                                enlargeCenterPage: true,
                                onPageChanged: (index, _) {
                                  setState(() {
                                    current = index;
                                  });
                                }),
                            items: listNewsHot.map<Widget>((imgURL) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChiTietTinTucWidget(
                                                Id: imgURL["Id"].toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                  imgURL["Images"],
                                                  fit: BoxFit.fill),
                                            ),
                                            Opacity(
                                              opacity: 0.3,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Text(
                                                imgURL["NewsName"],
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  foreground: Paint()
                                                    ..style = PaintingStyle.fill
                                                    ..strokeWidth = 2
                                                    ..color = Color.fromARGB(
                                                        255, 255, 255, 255),
                                                  shadows: [
                                                    Shadow(
                                                        offset: Offset(2, 2),
                                                        blurRadius: 2.0,
                                                        color: Color.fromARGB(
                                                            31, 21, 5, 245))
                                                  ],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  //color: Colors.white
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 4, 10, 0),
                                                  child: Text(
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.parse(
                                                            imgURL[
                                                                "UpdatedDate"])),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      if (listNewsCTY.length > 0) ...[
                        newsTitle(context, 'Tin công ty'),
                        newsContent(listNewsCTY),
                      ],
                      if(listNewsQTDUC.length > 0)...[
                         newsTitle(context, 'Tin Quỹ trí đức'),
                        newsContent(listNewsQTDUC),
                      ],
                      if (listNewsVH5T.length > 0) ...[
                        newsTitle(context, 'Tin văn hóa 5T'),
                        newsContent(listNewsVH5T),
                      ],
                      if(listNewsSKIEN.length > 0)...[
                         newsTitle(context, 'Tin sự kiện'),
                        newsContent(listNewsSKIEN),
                      ]
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

  Padding newsContent(List<dynamic> listContent) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 6, 16, 0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: listContent.length,
        itemBuilder: ((context, index) {
          final item = listContent[index];
          return InkWell(
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
            child: Column(
              children: [
                Container(
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
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(item["Images"],
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(item["NewsName"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                    decoration: BoxDecoration(
                                      color:
                                          Color(int.parse(item["CateColor"])),
                                      border: Border.all(
                                          color: Color(int.parse(
                                              item["CateColorBorder"]))),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item["CateName"],
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(item["UpdatedDate"])),
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic),
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
                // Divider(
                //   height: 1,
                //   thickness: 1,
                //   color: FlutterFlowTheme.of(context).lineColor,
                // ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Padding newsTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: FlutterFlowTheme.of(context).bodyText1.override(
                  color: Colors.blue,
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            'Tất cả',
            style: FlutterFlowTheme.of(context).bodyText1.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).stadeBlue3,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
