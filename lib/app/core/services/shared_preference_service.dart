import 'package:feed_app/app/core/injection/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static const String isLoggedInKey = 'is_logged_in';
  static const String userUidKey = 'user_uid';

  final SharedPreferences _prefs = sl<SharedPreferences>();

  Future<bool> setIsLoggedIn(bool value) async {
    return await _prefs.setBool(isLoggedInKey, value);
  }

  bool getIsLoggedIn() {
    return _prefs.getBool(isLoggedInKey) ?? false;
  }

  Future<bool> setUserUid(String uid) async {
    return await _prefs.setString(userUidKey, uid);
  }

  String? getUserUid() {
    return _prefs.getString(userUidKey);
  }

  Future<bool> clearUserData() async {
    await _prefs.remove(isLoggedInKey);
    await _prefs.remove(userUidKey);
    return true;
  }
}