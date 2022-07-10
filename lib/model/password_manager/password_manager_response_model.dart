// To parse this JSON data, do
//
//     final passwordManagerResponse = passwordManagerResponseFromJson(jsonString);

import 'dart:convert';

PasswordManagerResponse passwordManagerResponseFromJson(String str) =>
    PasswordManagerResponse.fromJson(json.decode(str));

String passwordManagerResponseToJson(PasswordManagerResponse data) =>
    json.encode(data.toJson());

class PasswordManagerResponse {
  PasswordManagerResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  List<Paman> data;
  String message;
  String status;

  factory PasswordManagerResponse.fromJson(Map<String, dynamic> json) =>
      PasswordManagerResponse(
        data: List<Paman>.from(json["data"].map((x) => Paman.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class Paman {
  Paman({
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

  factory Paman.fromJson(Map<String, dynamic> json) => Paman(
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
