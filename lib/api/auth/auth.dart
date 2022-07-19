// ignore_for_file: non_constant_identifier_names

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

class ResetPasswordRequest {
  ResetPasswordRequest({required this.username, required this.newPassword});

  String username;
  String newPassword;

  Map<String, dynamic> toJson() =>
      {'username': username, 'newPassword': newPassword};
}

class ResetPasswordResponse {
  ResetPasswordResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  Data data;
  String message;
  String status;

  factory ResetPasswordResponse.fromRawJson(String str) =>
      ResetPasswordResponse.fromJson(json.decode(str));

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ResetPasswordResponse(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );
}

class Data {
  Data();

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
