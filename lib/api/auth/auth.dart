import 'dart:convert';

import 'package:password_manager/utils/base_response.dart';

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

class LoginRequest {
  LoginRequest({
    required this.username,
    required this.password,
  });

  String username;
  String password;

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

class RegisterRequest {
  RegisterRequest(
      {required this.name, required this.username, required this.password});

  String name;
  String username;
  String password;

  Map<String, dynamic> toJson() =>
      {'name': name, 'username': username, 'password': password};
}
