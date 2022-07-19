import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:password_manager/api/notes/note_req_res.dart';
import 'package:password_manager/model/note_model.dart';
import 'package:password_manager/utils/helper.dart' as globals;
import 'package:http/http.dart' as http;

abstract class NoteInterface {
  void create(AddUpdateNoteRequest request);

  void get(String id);

  void update(AddUpdateNoteRequest request, String id);

  void delete(String id);
}

class NoteServiceImpl extends NoteInterface {
  @override
  Future<NoteResponse?> create(AddUpdateNoteRequest request) async {
    try {
      final response = await http.post(Uri.parse('${globals.baseUrl}/note/'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(request.toJson()));
      if (response.statusCode == 200) {
        log('response : ${response.body}');
        final jsonResponse = jsonDecode(response.body);
        return NoteResponse.fromJson(jsonResponse);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  @override
  Future<DeleteNoteResponse?> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${globals.baseUrl}/note/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        log('response ${response.body}');
        final jsonResponse = jsonDecode(response.body);
        return DeleteNoteResponse.fromJson(jsonResponse);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  @override
  Future<List<Note>?> get(String id) async {
    try {
      final response = await http.get(
          Uri.parse('${globals.baseUrl}/note/user/$id'),
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        var data = ListNoteResponse.fromJson(jsonDecode(response.body)).data;
        return data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw const SocketException('tidak ada koneksi internet');
    }
  }

  @override
  Future<NoteResponse?> update(AddUpdateNoteRequest request, String id) async {
    try {
      final response = await http.put(Uri.parse('${globals.baseUrl}/note/$id'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: json.encode(request.toJson()));
      if (response.statusCode == 200) {
        log(response.body);
        final jsonResponse = jsonDecode(response.body);
        return NoteResponse.fromJson(jsonResponse);
      } else {
        log(response.body);
        return null;
      }
    } catch (e) {
      log('error kesini');
      throw const SocketException('tidak ada koneksi internet');
    }
  }
}
