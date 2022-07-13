import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/password_manager/password_manager.dart';
import 'response/add_update_password_manager_response.dart';
import 'response/global_response.dart';
import 'response/password_manager_response.dart';

class ApiService {
  static const String baseUrl = "https://paman-api.herokuapp.com/api/v1";
  Client client = Client();

  // auth
  Future<GlobalResponse?> login(String username, String password) async {
    try {
      final response = await client.post(Uri.parse("$baseUrl/auth/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password}));

      if (response.statusCode == 400 || response.statusCode == 404) {
        return GlobalResponseFromJson(response.body);
      } else if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        GlobalResponse model = GlobalResponse.fromJson(jsonResponse);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', model.data);
        return GlobalResponseFromJson(response.body);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  Future<GlobalResponse?> register(
      String name, String username, String password) async {
    try {
      final response = await client.post(Uri.parse("$baseUrl/auth/register"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
              {'name': name, 'username': username, 'password': password}));
      return GlobalResponseFromJson(response.body);
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  // password manager
  Future<List<PasswordManager>?> getPasswordManagerByUserId(
      String userId) async {
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

  Future<AddPasswordManagerResponse?> addPasswordManager(
      String username, String password, String website, String userId) async {
    try {
      final response = await client.post(
          Uri.parse('$baseUrl/password-manager/'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'pmUsername': username,
            'pmPassword': password,
            'pmWebsite': website,
            'userId': userId
          }));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        AddPasswordManagerResponse addPasswordManagerResponse =
            AddPasswordManagerResponse.fromJson(jsonResponse);
        return addPasswordManagerResponse;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  Future<GlobalResponse?> deletePasswordManager(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/password-manager/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        log('response ${response.body}');
        final jsonResponse = jsonDecode(response.body);
        GlobalResponse globalResponse = GlobalResponse.fromJson(jsonResponse);
        return globalResponse;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  Future<AddPasswordManagerResponse?> updatePasswordManager(
      String pmUsername, String pmPassword, String pmWebsite, String id) async {
    try {
      final response = await client.put(
          Uri.parse('$baseUrl/password-manager/$id'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            'pmUsername': pmUsername,
            'pmPassword': pmPassword,
            'pmWebsite': pmWebsite,
          }));

      if (response.statusCode == 200) {
        return addPasswordManagerResponseFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }
}
