import 'package:shared_preferences/shared_preferences.dart';

class Data {
  // initialize the data class
  static final Data _instance = Data._internal();
  factory Data() {
    return _instance;
  }
  Data._internal();

  // shared preferences instance
  SharedPreferences? _prefs;
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // variables
  final Map<String, dynamic> _data = {};
  Map<String, dynamic> get data => _data;
  // set data
  void setData(String key, dynamic value) {
    _data[key] = value;
    _prefs?.setString(key, value.toString());
  }

  // load the data from shared preferences
  Future<void> loadData() async {
    _data.clear();
    if (_prefs != null) {
      for (String key in _prefs!.getKeys()) {
        _data[key] = _prefs!.get(key);
      }
    }
  }

  // write data to shared preferences
  Future<void> writeData() async {
    if (_prefs != null) {
      for (String key in _data.keys) {
        // determine the type of the value
        var value = _data[key];
        if (value is int) {
          await _prefs!.setInt(key, value);
        } else if (value is double) {
          await _prefs!.setDouble(key, value);
        } else if (value is bool) {
          await _prefs!.setBool(key, value);
        } else if (value is String) {
          await _prefs!.setString(key, value);
        } else {
          // if the value is not one of the above types, convert it to a string
          await _prefs!.setString(key, value.toString());
        }
      }
    }
  }

  // clear data
  Future<void> clearData() async {
    _data.clear();
    if (_prefs != null) {
      await _prefs!.clear();
    }
  }

  // remove a specific key
  Future<void> removeKey(String key) async {
    _data.remove(key);
    if (_prefs != null) {
      await _prefs!.remove(key);
    }
  }
}
