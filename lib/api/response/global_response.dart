// To parse this JSON data, do
//
//     final GlobalResponse = GlobalResponseFromJson(jsonString);

import 'dart:convert';

import 'package:password_manager/api/response/base_response.dart';

GlobalResponse GlobalResponseFromJson(String str) =>
    GlobalResponse.fromJson(json.decode(str));

class GlobalResponse extends BaseResponse {
  GlobalResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  String data;
  @override
  String message;
  @override
  String status;

  factory GlobalResponse.fromJson(Map<String, dynamic> json) => GlobalResponse(
        data: json["data"],
        message: json["message"],
        status: json["status"],
      );
}
