import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:password_manager/api/password_manager/password_manager_req_res.dart';
import 'package:http/http.dart' as http;
import 'package:password_manager/model/password_manager_model.dart';
import 'package:password_manager/utils/helper.dart' as globals;

abstract class PasswordManagerService {
  void create(AddPasswordManagerRequest request);
  void get(String userId);
  void update(UpdatePasswordManagerRequest request, String id);
  void delete(String id);
}

class PasswordManagerServiceImpl implements PasswordManagerService {
  @override
  Future<PasswordManagerResponse?> create(
      AddPasswordManagerRequest request) async {
    try {
      final response = await http.post(
          Uri.parse('${globals.baseUrl}/password-manager/'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(request.toJson()));
      if (response.statusCode == 200) {
        log('response : ${response.body}');
        final jsonResponse = jsonDecode(response.body);
        return PasswordManagerResponse.fromJson(jsonResponse);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  @override
  Future<DeletePasswordManagerResponse?> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${globals.baseUrl}/password-manager/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        log('response ${response.body}');
        final jsonResponse = jsonDecode(response.body);
        return DeletePasswordManagerResponse.fromJson(jsonResponse);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  @override
  Future<List<PasswordManager>?> get(String userId) async {
    try {
      final response = await http.get(
          Uri.parse('${globals.baseUrl}/password-manager/user/$userId'),
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        var data =
            GetPasswordManagerResponse.fromJson(jsonDecode(response.body)).data;
        return data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  @override
  Future<PasswordManagerResponse?> update(
      UpdatePasswordManagerRequest request, String id) async {
    try {
      final response = await http.put(
          Uri.parse('${globals.baseUrl}/password-manager/$id'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: json.encode(request.toJson()));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return PasswordManagerResponse.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }
}
