// To parse this JSON data, do
//
//     final addPasswordManagerResponse = addPasswordManagerResponseFromJson(jsonString);

import 'dart:convert';

import 'package:password_manager/api/response/base_response.dart';
import 'package:password_manager/model/password_manager.dart';

AddPasswordManagerResponse addPasswordManagerResponseFromJson(String str) =>
    AddPasswordManagerResponse.fromJson(json.decode(str));

class AddPasswordManagerResponse extends BaseResponse {
  AddPasswordManagerResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  PasswordManager data;
  @override
  String message;
  @override
  String status;

  factory AddPasswordManagerResponse.fromJson(Map<String, dynamic> json) =>
      AddPasswordManagerResponse(
        data: PasswordManager.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );
}
