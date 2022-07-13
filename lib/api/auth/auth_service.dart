import 'dart:convert';
import 'dart:io';

import 'package:password_manager/api/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'package:password_manager/utils/globals.dart' as globals;
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
        prefs.setString('userId', userId);
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
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }
}
