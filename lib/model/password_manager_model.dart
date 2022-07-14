class PasswordManager {
  PasswordManager({
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

  factory PasswordManager.fromJson(Map<String, dynamic> json) =>
      PasswordManager(
        id: json["id"],
        pmUsername: json["pmUsername"],
        pmPassword: json["pmPassword"],
        pmWebsite: json["pmWebsite"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );
}
