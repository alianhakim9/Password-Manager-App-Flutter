// To parse this JSON data, do
//
//     final AuthResponse = AuthResponseFromJson(jsonString);

import 'dart:convert';

import 'package:password_manager/api/response/base_response.dart';

AuthResponse AuthResponseFromJson(String str) =>
    AuthResponse.fromJson(json.decode(str));

class AuthResponse extends BaseResponse {
  AuthResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  String data;
  @override
  String message;
  @override
  String status;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        data: json["data"],
        message: json["message"],
        status: json["status"],
      );
}
