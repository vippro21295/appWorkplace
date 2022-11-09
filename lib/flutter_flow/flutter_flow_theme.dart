// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';
SharedPreferences? _prefs;

abstract class FlutterFlowTheme {
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static FlutterFlowTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? DarkModeTheme()
          : LightModeTheme();

  late Color primaryColor;
  late Color secondaryColor;
  late Color tertiaryColor;
  late Color alternate;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color primaryText;
  late Color secondaryText;

  late Color theme;
  late Color theme2;
  late Color theme3;
  late Color stateRED1;
  late Color stateRED2;
  late Color stateRED3;
  late Color stadeBlue1;
  late Color stadeBlue2;
  late Color stadeBlue3;
  late Color stateOrange1;
  late Color stateOrange2;
  late Color stateOrange3;
  late Color stateGreen1;
  late Color stateGreen2;
  late Color customColor3;
  late Color primaryBtnText;
  late Color lineColor;
  late Color filltext;
  late Color backgroundComponents;

  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  late Color primaryColor = const Color(0xFFD20101);
  late Color secondaryColor = const Color(0xFF003DA4);
  late Color tertiaryColor = const Color(0x00EE6060);
  late Color alternate = const Color(0xFFFF5963);
  late Color primaryBackground = const Color(0xFFF6F8FF);
  late Color secondaryBackground = const Color(0xFFFFFFFF);
  late Color primaryText = const Color(0xFF111111);
  late Color secondaryText = const Color(0xFFE00000);

  late Color theme = Color(0xFFF6F8FF);
  late Color theme2 = Color(0xFFFFFFFF);
  late Color theme3 = Color(0x1E000000);
  late Color stateRED1 = Color(0xFFFFE8EC);
  late Color stateRED2 = Color(0xFFFF3B30);
  late Color stateRED3 = Color(0xFFE00000);
  late Color stadeBlue1 = Color(0xFFEBF3FF);
  late Color stadeBlue2 = Color(0xFF007AFF);
  late Color stadeBlue3 = Color(0xFF003DA4);
  late Color stateOrange1 = Color(0xFFFFF6E8);
  late Color stateOrange2 = Color(0xFFFF9500);
  late Color stateOrange3 = Color(0xFFF49200);
  late Color stateGreen1 = Color(0xFFECFBE6);
  late Color stateGreen2 = Color(0xFF34C759);
  late Color customColor3 = Color(0xFF00A542);
  late Color primaryBtnText = Color(0xFFFFFFFF);
  late Color lineColor = Color(0xFFE0E3E7);
  late Color filltext = Color(0xFFF1F1F1);
  late Color backgroundComponents = Color(0xFF1D2428);
}

abstract class Typography {
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText2Family;
  TextStyle get bodyText2;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  String get title1Family => 'Inter';
  TextStyle get title1 => GoogleFonts.getFont(
        'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      );
  String get title2Family => 'Inter';
  TextStyle get title2 => GoogleFonts.getFont(
        'Inter',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      );
  String get title3Family => 'Inter';
  TextStyle get title3 => GoogleFonts.getFont(
        'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      );
  String get subtitle1Family => 'Inter';
  TextStyle get subtitle1 => GoogleFonts.getFont(
        'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );
  String get subtitle2Family => 'Inter';
  TextStyle get subtitle2 => GoogleFonts.getFont(
        'Inter',
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      );
  String get bodyText1Family => 'Inter';
  TextStyle get bodyText1 => GoogleFonts.getFont(
        'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
  String get bodyText2Family => 'Inter';
  TextStyle get bodyText2 => GoogleFonts.getFont(
        'Inter',
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12,
      );
}

class DarkModeTheme extends FlutterFlowTheme {
  late Color primaryColor = const Color(0xFF4B39EF);
  late Color secondaryColor = const Color(0xFF39D2C0);
  late Color tertiaryColor = const Color(0xFFEE8B60);
  late Color alternate = const Color(0xFFFF5963);
  late Color primaryBackground = const Color(0xFF1A1F24);
  late Color secondaryBackground = const Color(0xFF101213);
  late Color primaryText = const Color(0xFFFFFFFF);
  late Color secondaryText = const Color(0xFF95A1AC);

  late Color theme = Color(0xFF15FA5A);
  late Color theme2 = Color(0xFF53917F);
  late Color theme3 = Color(0xFF880393);
  late Color stateRED1 = Color(0xFFA2FC2D);
  late Color stateRED2 = Color(0xFF70A0C2);
  late Color stateRED3 = Color(0xFFF63B6C);
  late Color stadeBlue1 = Color(0xFF119143);
  late Color stadeBlue2 = Color(0xFF2BDAF0);
  late Color stadeBlue3 = Color(0xFFDC8C69);
  late Color stateOrange1 = Color(0xFFA3817C);
  late Color stateOrange2 = Color(0xFF776C9A);
  late Color stateOrange3 = Color(0xFFD26310);
  late Color stateGreen1 = Color(0xFFE0971B);
  late Color stateGreen2 = Color(0xFF40DEE0);
  late Color customColor3 = Color(0xFFE7B9B2);
  late Color primaryBtnText = Color(0xFFFFFFFF);
  late Color lineColor = Color(0xFF22282F);
  late Color filltext = Color(0xFFB7FFB2);
  late Color backgroundComponents = Color(0xFF1D2428);
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
