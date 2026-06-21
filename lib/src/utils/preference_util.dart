import 'package:shared_preferences/shared_preferences.dart';

import 'app_constant.dart';

class PreferenceUtil {
  static void setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
  }

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language');
  }

  static void setLogin(bool isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_login', isLogin);
  }

  static Future<bool?> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_login');
  }

  static void setOnBoarding(bool isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_on_boarding', isLogin);
  }

  static Future<bool?> isOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_on_boarding');
  }

  static void setAccessToken(String? accessToken) async {
    ACCESS_TOKEN = accessToken ?? '';
    print('ACCESS SIGN ${accessToken}');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', accessToken ?? '');
  }

  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    var ss = prefs.getString('access_token') ?? '';
    ACCESS_TOKEN = ss;
    return ss;
  }

  static void setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  static void setUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);
  }

  static void setDeviceToken(String deviceToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('device_token', deviceToken);
  }

  static Future<String?> getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('device_token');
  }

  static void clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static void setFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('font_size', size);
  }

  static Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('font_size') ?? 1;
  }
}
