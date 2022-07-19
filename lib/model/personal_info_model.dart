class PersonalInfo {
  PersonalInfo(
      {required this.id,
      required this.piPhoneNumber,
      required this.piAddress,
      required this.piWebsite,
      required this.piEmail,
      required this.createdAt,
      required this.updatedAt});

  String id;
  String piPhoneNumber;
  String piAddress;
  String piWebsite;
  String piEmail;
  String createdAt;
  String updatedAt;

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
      id: json["id"],
      piPhoneNumber: json["piPhoneNumber"],
      piAddress: json["piAddress"],
      piWebsite: json["piWebsite"],
      piEmail: json["piEmail"],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt']);
}
