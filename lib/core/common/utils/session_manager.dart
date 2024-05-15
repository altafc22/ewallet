import 'dart:convert';

import 'package:ewallet/core/common/utils/log_utils.dart';
import 'package:ewallet/features/auth/data/model/auth_model.dart';

import 'shared_preference.dart';

class SessionManager {
  final SharedPrefsUtil _sharedPrefsUtil;

  SessionManager(this._sharedPrefsUtil);

  final _sessionData = 'access_token';

  Future<void> saveSession(AuthModel authResponse) async {
    final Map<String, dynamic> jsonData = authResponse.toJson();
    final String jsonString = jsonEncode(jsonData);
    await _sharedPrefsUtil.setString(_sessionData, jsonString);
    printInfo("session saved");
  }

  Future<AuthModel?> getSession() async {
    final String? jsonString = await _sharedPrefsUtil.getString(_sessionData);
    if (jsonString != null) {
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      return AuthModel.fromJson(jsonData);
    }
    return null;
  }

  Future<String?> getAuthToken() async {
    var session = await getSession();
    return session?.accessToken;
  }

  Future<void> clearSession() async {
    await _sharedPrefsUtil.remove(_sessionData);
  }
}
