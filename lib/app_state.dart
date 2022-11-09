import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/lat_lng.dart';

class FFAppState {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('ff_userName') ?? _userName;
    _imageUser = prefs.getString('ff_imageUser') ?? _imageUser;
    _passWord = prefs.getString('ff_passWord') ?? _passWord;
  }

  late SharedPreferences prefs;

  String _userName = '';
  String get userName => _userName;
  set userName(String _value) {
    _userName = _value;
    prefs.setString('ff_userName', _value);
  }

  String _passWord = '';
  String get passWord => _passWord;
  set passWord(String _value) {
    _passWord = _value;
    prefs.setString('ff_passWord', _value);
  }

  String _imageUser = '';
  String get imageUser => _imageUser;
  set imageUser(String _value) {
    _imageUser = _value;
    prefs.setString('ff_imageUser', _value);
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}
