// To parse this JSON data, do
//
//     final addPasswordManagerResponse = addPasswordManagerResponseFromJson(jsonString);

import 'dart:convert';

AddPasswordManagerResponse addPasswordManagerResponseFromJson(String str) =>
    AddPasswordManagerResponse.fromJson(json.decode(str));

String addPasswordManagerResponseToJson(AddPasswordManagerResponse data) =>
    json.encode(data.toJson());

class AddPasswordManagerResponse {
  AddPasswordManagerResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  Data data;
  String message;
  String status;

  factory AddPasswordManagerResponse.fromJson(Map<String, dynamic> json) =>
      AddPasswordManagerResponse(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class Data {
  Data({
    required this.id,
    required this.pmUsername,
    required this.pmPassword,
    required this.pmWebsite,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String pmUsername;
  String pmPassword;
  String pmWebsite;
  String createdAt;
  String updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        pmUsername: json["pmUsername"],
        pmPassword: json["pmPassword"],
        pmWebsite: json["pmWebsite"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pmUsername": pmUsername,
        "pmPassword": pmPassword,
        "pmWebsite": pmWebsite,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
