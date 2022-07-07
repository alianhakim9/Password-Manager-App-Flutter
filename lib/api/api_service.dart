import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:password_manager/model/base_response_model.dart';

class ApiService {
  static const String baseUrl = "http://3e92-103-147-9-169.ngrok.io/api/v1";
  Client client = Client();

  Future<BaseResponseModel?> login(String username, String password) async {
    final response = await client.post(Uri.parse("$baseUrl/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}));

    if (response.statusCode == 400 || response.statusCode == 404) {
      return baseResponseModelFromJson(response.body);
    } else if (response.statusCode == 200) {
      return baseResponseModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
