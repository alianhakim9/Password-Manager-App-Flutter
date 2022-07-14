import 'package:password_manager/utils/base_response.dart';
import 'package:password_manager/model/password_manager_model.dart';

class AddPasswordManagerRequest {
  AddPasswordManagerRequest(
      {required this.pmUsername,
      required this.pmPassword,
      required this.pmWebsite,
      required this.userId});

  String pmUsername;
  String pmPassword;
  String pmWebsite;
  String userId;

  Map<String, dynamic> toJson() => {
        'pmUsername': pmUsername,
        'pmPassword': pmPassword,
        'pmWebsite': pmWebsite,
        'userId': userId
      };
}

class UpdatePasswordManagerRequest {
  UpdatePasswordManagerRequest(
      {required this.pmUsername,
      required this.pmPassword,
      required this.pmWebsite});

  String pmUsername;
  String pmPassword;
  String pmWebsite;

  Map<String, dynamic> toJson() => {
        'pmUsername': pmUsername,
        'pmPassword': pmPassword,
        'pmWebsite': pmWebsite,
      };
}

class GetPasswordManagerResponse extends BaseResponse {
  GetPasswordManagerResponse(
      {required this.data, required this.message, required this.status});

  List<PasswordManager> data;

  @override
  String message;

  @override
  String status;

  factory GetPasswordManagerResponse.fromJson(Map<String, dynamic> json) =>
      GetPasswordManagerResponse(
        data: List<PasswordManager>.from(
            json["data"].map((x) => PasswordManager.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );
}

class PasswordManagerResponse extends BaseResponse {
  PasswordManagerResponse(
      {required this.data, required this.message, required this.status});

  PasswordManager data;

  @override
  String message;

  @override
  String status;

  factory PasswordManagerResponse.fromJson(Map<String, dynamic> json) =>
      PasswordManagerResponse(
        data: PasswordManager.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );
}

class DeletePasswordManagerResponse extends BaseResponse {
  DeletePasswordManagerResponse(
      {required this.data, required this.message, required this.status});

  String data;

  @override
  String message;

  @override
  String status;
  factory DeletePasswordManagerResponse.fromJson(Map<String, dynamic> json) =>
      DeletePasswordManagerResponse(
        data: json["data"],
        message: json["message"],
        status: json["status"],
      );
}
