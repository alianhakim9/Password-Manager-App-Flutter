class Note {
  Note({
    required this.id,
    required this.noteTitle,
    required this.noteDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String noteTitle;
  String noteDescription;
  String createdAt;
  String updatedAt;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        noteTitle: json["noteTitle"],
        noteDescription: json["noteDescription"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );
}
