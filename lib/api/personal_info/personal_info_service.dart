import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:password_manager/api/personal_info/personal_info_req_res.dart';
import 'package:password_manager/model/personal_info_model.dart';
import 'package:password_manager/utils/helper.dart' as globals;

abstract class PersonalInfoService {
  void create(AddPersonalInfoRequest request);
  void get(String userId);
  void update(UpdatePersonalInfoRequest request, String id);
  void delete(String id);
}

class PersonalInfoServiceImpl implements PersonalInfoService {
  @override
  Future<PersonalInfoResponse?> create(AddPersonalInfoRequest request) async {
    try {
      final response = await http.post(
          Uri.parse('${globals.baseUrl}/personal-info/'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(request.toJson()));
      if (response.statusCode == 200) {
        log('response : ${response.body}');
        final jsonResponse = jsonDecode(response.body);
        return PersonalInfoResponse.fromJson(jsonResponse);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  @override
  Future<DeletePersonalInfoResponse?> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${globals.baseUrl}/personal-info/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        log('response ${response.body}');
        final jsonResponse = jsonDecode(response.body);
        return DeletePersonalInfoResponse.fromJson(jsonResponse);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  @override
  Future<List<PersonalInfo>?> get(String userId) async {
    try {
      final response = await http.get(
          Uri.parse('${globals.baseUrl}/personal-info/user/$userId'),
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        var data =
            GetPersonalInfoResponse.fromJson(jsonDecode(response.body)).data;
        return data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  @override
  Future<PersonalInfoResponse?> update(
      UpdatePersonalInfoRequest request, String id) async {
    try {
      final response = await http.put(
          Uri.parse('${globals.baseUrl}/personal-info/$id'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: json.encode(request.toJson()));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return PersonalInfoResponse.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }
}
