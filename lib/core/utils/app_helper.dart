import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AppHelper {
  const AppHelper._internal();

  static const instance = AppHelper._internal();

  Future<String?> getRole() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('selected_role');
  }

  Future<bool> setRole(String role) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString('selected_role', role);
  }

  Future<void> clearToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  Future<String> getEmail() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('email') ?? '';
  }

  Future<String> getName() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('name') ?? '';
  }

  Future<bool> setUserId(String id) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString('user_id', id);
  }

  Future<String?> getUserId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('user_id');
  }

  Future<bool> setAccessToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString('access_token', token);
  }

  Future<String?> getAccessToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('access_token');
  }

  Future<bool> setRefToken(String refreshToken) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString('refresh_token', refreshToken);
  }

  Future<String?>getRefToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('refresh_token');
  }

  Future<bool> setSecretKey(String secretKey) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString('secret_key', secretKey);
  }

  Future<String?> getSecretKey() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('secret_key');
  }

  Future<bool> setTokenValidity(int tokenValidity) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setInt('access_token_valid_till', tokenValidity);
  }

  Future<int?> getTokenValidity() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getInt('access_token_valid_till');
  }

  Future<String?> getAuthRole() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('role');
  }

  Future<bool> setAuthRole(String role) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString('role', role);
  }

  Future<bool> setCarImageId(String id) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString('car_image_id', id);
  }

  Future<String?> getCarImageId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('car_image_id');
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> clearAllPrefValue() async {
    final pref = await SharedPreferences.getInstance();
    try {
      pref.clear();
      pref.reload();
      return true;
    } catch (e) {
      return false;
    }
  }
}