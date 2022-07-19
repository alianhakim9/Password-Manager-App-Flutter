import 'package:password_manager/model/personal_info_model.dart';
import 'package:password_manager/utils/base_response.dart';

class AddPersonalInfoRequest {
  AddPersonalInfoRequest(
      {required this.piAddress,
      required this.piEmail,
      required this.piPhoneNumber,
      required this.piWebsite,
      required this.userId});

  String piAddress;
  String piEmail;
  String piPhoneNumber;
  String piWebsite;
  String userId;

  Map<String, dynamic> toJson() => {
        'piAddress': piAddress,
        'piEmail': piEmail,
        'piPhoneNumber': piPhoneNumber,
        'piWebsite': piWebsite,
        'userId': userId
      };
}

class UpdatePersonalInfoRequest {
  UpdatePersonalInfoRequest(
      {required this.piAddress,
      required this.piEmail,
      required this.piPhoneNumber,
      required this.piWebsite,
      required this.userId});

  String piAddress;
  String piEmail;
  String piPhoneNumber;
  String piWebsite;
  String userId;

  Map<String, dynamic> toJson() => {
        'piAddress': piAddress,
        'piEmail': piEmail,
        'piPhoneNumber': piPhoneNumber,
        'piWebsite': piWebsite,
        'userId': userId
      };
}

class GetPersonalInfoResponse extends BaseResponse {
  GetPersonalInfoResponse(
      {required this.data, required this.message, required this.status});

  List<PersonalInfo> data;

  @override
  String message;

  @override
  String status;

  factory GetPersonalInfoResponse.fromJson(Map<String, dynamic> json) =>
      GetPersonalInfoResponse(
        data: List<PersonalInfo>.from(
            json["data"].map((x) => PersonalInfo.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );
}

class PersonalInfoResponse extends BaseResponse {
  PersonalInfoResponse(
      {required this.data, required this.message, required this.status});

  PersonalInfo data;

  @override
  String message;

  @override
  String status;

  factory PersonalInfoResponse.fromJson(Map<String, dynamic> json) =>
      PersonalInfoResponse(
        data: PersonalInfo.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );
}

class DeletePersonalInfoResponse extends BaseResponse {
  DeletePersonalInfoResponse(
      {required this.data, required this.message, required this.status});

  String data;

  @override
  String message;

  @override
  String status;
  factory DeletePersonalInfoResponse.fromJson(Map<String, dynamic> json) =>
      DeletePersonalInfoResponse(
        data: json["data"],
        message: json["message"],
        status: json["status"],
      );
}
