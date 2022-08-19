import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

class Pref {

  // Functions
  static SharedPreferences? prefs;

  static const String token = "token";
  static const String brightness = 'brightness';
  static const String isBioEnable = 'isBioEnable';
  static const String username = 'username';
  static const String password = 'password';
  static const String hasAuth = 'auth';
  static const String platform = 'platform';
  static const String pushNotifications = 'pushNotifications';
  static const String contactTermAccepted = 'contactTermAccepted';
  static const String option1 = 'option1';
  static const String option2 = 'option2';
  static const String option3 = 'option3';
  static const String option4 = 'option4';
  static const String option5 = 'option5';
  static const String option6 = 'option6';
  static const String option7 = 'option7';
  static const String option8 = 'option8';
  static const String option9 = 'option9';


  static getPref() async {
    prefs = await SharedPreferences.getInstance();
  }
  static bool getPrefBoolean(String key, {defaultValue = false}) {
    return prefs!.getBool(key)??defaultValue;
  }
  static  String getPrefString(String key, {String defaultValue = Str.na}) {
    return prefs!.getString(key)??defaultValue;
  }
  static int getPrefInt(String key, {int defaultValue = 0}) {
    return prefs!.getInt(key)??defaultValue;
  }
  static double getPrefDouble(String key, {double defaultValue = 0.0}) {
    return prefs!.getDouble(key)??defaultValue;
  }

  static setPrefString(String prefsKey, String value) {
    prefs!.setString(prefsKey, value);
  }
  static setPrefDouble(String prefsKey, double value) {
    prefs!.setDouble(prefsKey, value);
  }
  static setPrefInt(String prefsKey, int value) {
    prefs!.setInt(prefsKey, value);
  }
  static setPrefBoolean(String key, bool value) {
    prefs!.setBool(key, value);
  }

}