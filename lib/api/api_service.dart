import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:password_manager/model/base_response_model.dart';
import 'package:password_manager/model/password_manager_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://paman-api.herokuapp.com/api/v1";
  Client client = Client();

  // auth
  Future<BaseResponseModel?> login(String username, String password) async {
    try {
      final response = await client.post(Uri.parse("$baseUrl/auth/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password}));

      if (response.statusCode == 400 || response.statusCode == 404) {
        return baseResponseModelFromJson(response.body);
      } else if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        BaseResponseModel model = BaseResponseModel.fromJson(jsonResponse);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', model.data);
        return baseResponseModelFromJson(response.body);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  Future<BaseResponseModel?> register(
      String name, String username, String password) async {
    try {
      final response = await client.post(Uri.parse("$baseUrl/auth/register"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
              {'name': name, 'username': username, 'password': password}));
      return baseResponseModelFromJson(response.body);
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }

  // password manager
  Future<List<Paman>?> getPasswordManagerByUserId(String userId) async {
    try {
      final response = await client.get(
          Uri.parse('$baseUrl/password-manager/user/$userId'),
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        PasswordManagerResponse passwordManagerResponse =
            PasswordManagerResponse.fromJson(jsonResponse);
        return passwordManagerResponse.data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }
}
