// To parse this JSON data, do
//
//     final passwordManagerResponse = passwordManagerResponseFromJson(jsonString);

import 'dart:convert';

import 'package:password_manager/api/response/base_response.dart';
import 'package:password_manager/model/password_manager/password_manager.dart';

PasswordManagerResponse passwordManagerResponseFromJson(String str) =>
    PasswordManagerResponse.fromJson(json.decode(str));

class PasswordManagerResponse extends BaseResponse {
  PasswordManagerResponse({
    required this.data,
    required message,
    required status,
  });

  List<PasswordManager> data;

  factory PasswordManagerResponse.fromJson(Map<String, dynamic> json) =>
      PasswordManagerResponse(
        data: List<PasswordManager>.from(
            json["data"].map((x) => PasswordManager.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );
}
