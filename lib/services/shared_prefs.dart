import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;
  static const String _token = 'token';

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  String get token => _sharedPrefs?.getString(_token);

  set token(String value) => _sharedPrefs.setString(_token, value);
}
