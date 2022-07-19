import 'dart:convert';
import 'dart:io';

import 'package:password_manager/api/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'package:password_manager/utils/helper.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthServiceInterace {
  void login(LoginRequest request);
  void register(RegisterRequest request);
}

class AuthServiceImpl implements AuthServiceInterace {
  @override
  Future<AuthResponse?> login(LoginRequest request) async {
    try {
      final response = await http.post(
          Uri.parse('${globals.baseUrl}/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request.toJson()));
      if (response.statusCode == 200) {
        var userId = AuthResponse.fromJson(jsonDecode(response.body)).data;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        prefs.setString('userId', userId);
        prefs.setString('username', request.username);
        return AuthResponseFromJson(response.body);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  @override
  Future<AuthResponse?> register(RegisterRequest request) async {
    try {
      final response = await http.post(
          Uri.parse('${globals.baseUrl}/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request.toJson()));
      if (response.statusCode == 200) {
        return AuthResponseFromJson(response.body);
      } else if (response.statusCode == 409) {
        return AuthResponseFromJson(response.body);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  Future<ResetPasswordResponse?> resetPassword(
      ResetPasswordRequest request) async {
    try {
      final response = await http.put(
          Uri.parse('${globals.baseUrl}/auth/reset-password'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request.toJson()));
      if (response.statusCode == 200) {
        return ResetPasswordResponse.fromRawJson(response.body);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }
}
