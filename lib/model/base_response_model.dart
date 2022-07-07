// To parse this JSON data, do
//
//     final baseResponseModel = baseResponseModelFromJson(jsonString);

import 'dart:convert';

BaseResponseModel baseResponseModelFromJson(String str) =>
    BaseResponseModel.fromJson(json.decode(str));

String baseResponseModelToJson(BaseResponseModel data) =>
    json.encode(data.toJson());

class BaseResponseModel {
  BaseResponseModel({
    required this.data,
    required this.message,
    required this.status,
  });

  String data;
  String message;
  String status;

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) =>
      BaseResponseModel(
        data: json["data"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "message": message,
        "status": status,
      };
}
