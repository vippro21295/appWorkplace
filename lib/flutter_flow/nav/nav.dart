import 'dart:async';
import 'package:app_workplace/profile_page/edit_profile1.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import '../../bottom_navigation/bottom_navigation_bar.dart';
import '../../index.dart';
import 'serialization_util.dart';
export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, _) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: Colors.transparent,
                child: Image.asset(
                  'assets/images/Splash_Screenslash.png',
                  fit: BoxFit.contain,
                ),
              ),
            )
          : LogInWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: Colors.transparent,
                    child: Image.asset(
                      'assets/images/Splash_Screenslash.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : LogInWidget(),
          routes: [
            FFRoute(
              name: 'LogIn',
              path: 'logIn',
              builder: (context, params) => LogInWidget(),
            ),
            FFRoute(
              name: 'NavigationBar',
              path: 'NavigationBar',
              builder: (context, params) => NavigationBarWidget(),
            ),
            FFRoute(
              name: 'ForgotPassword',
              path: 'forgotPassword',
              builder: (context, params) => ForgotPasswordWidget(),
            ),
            FFRoute(
              name: 'NewPassword',
              path: 'newPassword',
              builder: (context, params) => NewPasswordWidget(),
            ),
            FFRoute(
              name: 'ChamCong',
              path: 'chamCong',
              builder: (context, params) => ChamCongWidget(),
            ),
            FFRoute(
              name: 'LichChamCong-Thang',
              path: 'lichChamCongThang',
              builder: (context, params) => LichChamCongThangWidget(),
            ),
            FFRoute(
              name: 'LichChamCong-Tuan',
              path: 'lichChamCongTuan',
              builder: (context, params) => LichChamCongTuanWidget(),
            ),
            FFRoute(
              name: 'ChamCongChiTiet-Congtac',
              path: 'chamCongChiTietCongtac',
              builder: (context, params) => ChamCongChiTietCongtacWidget(
                dateSelected: params.getParam('dateSelected', ParamType.String),
              ),
            ),
            FFRoute(
              name: 'ChamCongChiTiet-TangCa',
              path: 'chamCongChiTietTangCa',
              builder: (context, params) => ChamCongChiTietTangCaWidget(),
            ),
            FFRoute(
              name: 'ChamCongChiTiet-TreSom',
              path: 'chamCongChiTietTreSom',
              builder: (context, params) => ChamCongChiTietTreSomWidget(
                dateSelected: params.getParam('dateSelected', ParamType.String),
              ),
            ),
            FFRoute(
              name: 'ChamCongChiTiet-Phep',
              path: 'chamCongChiTietPhep',
              builder: (context, params) => ChamCongChiTietPhepWidget(),
            ),
            FFRoute(
              name: 'DanhSachPhieuDoiTour',
              path: 'danhSachPhieuDoiTour',
              builder: (context, params) => DanhSachPhieuDoiTourWidget(),
            ),
            FFRoute(
              name: 'ChamCongChiTiet-Phep-Phnam',
              path: 'chamCongChiTietPhepPhnam',
              builder: (context, params) => ChamCongChiTietPhepPhnamWidget(),
            ),
            FFRoute(
              name: 'BaoCaoPhep',
              path: 'baoCaoPhep',
              builder: (context, params) => BaoCaoPhepWidget(),
            ),
            FFRoute(
              name: 'TinTuc',
              path: 'tinTuc',
              builder: (context, params) => TinTucWidget(),
            ),
          
            FFRoute(
              name: 'DanhMucTinTuc',
              path: 'danhMucTinTuc',
              builder: (context, params) => DanhMucTinTucWidget(),
            ),
            FFRoute(
              name: 'LichChamCong-ThangCopy',
              path: 'lichChamCongThangCopy',
              builder: (context, params) => LichChamCongThangCopyWidget(),
            ),
            FFRoute(
              name: 'ChiTietTinTuc',
              path: 'chiTietTinTuc',
              builder: (context, params) => ChiTietTinTucWidget(),
            ),
            FFRoute(
              name: 'ProfilePage',
              path: 'ProfilePage',
              builder: (context, params) => ProfilePageWidget(),
            ),
            FFRoute(
                name: 'EditProfile1',
                path: 'EditProfile1',
                builder: (context, params) => EditProfile1Widget()),
            FFRoute(
              name: 'ChamCongChiTiet-TreSomCopy',
              path: 'chamCongChiTietTreSomCopy',
              builder: (context, params) => ChamCongChiTietTreSomCopyWidget(
                dateSelected: params.getParam('dateSelected', ParamType.String),
              ),
            )
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ).toRoute(appStateNotifier),
      ],
      urlPathStrategy: UrlPathStrategy.path,
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(params)
    ..addAll(queryParams)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam(String paramName, ParamType type) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam(param, type);
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}
