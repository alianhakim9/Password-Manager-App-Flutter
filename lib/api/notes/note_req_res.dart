import 'package:password_manager/model/note_model.dart';
import 'package:password_manager/utils/base_response.dart';

class AddUpdateNoteRequest {
  AddUpdateNoteRequest(
      {required this.noteTitle,
      required this.noteDescription,
      required this.userId});

  String noteTitle;
  String noteDescription;
  String userId;

  Map<String, dynamic> toJson() => {
        'noteTitle': noteTitle,
        'noteDescription': noteDescription,
        'userId': userId
      };
}

class NoteResponse extends BaseResponse {
  NoteResponse(
      {required this.data, required this.message, required this.status});

  Note data;

  @override
  String message;

  @override
  String status;

  factory NoteResponse.fromJson(Map<String, dynamic> json) => NoteResponse(
        data: Note.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );
}

class ListNoteResponse extends BaseResponse {
  ListNoteResponse(
      {required this.data, required this.message, required this.status});

  List<Note> data;

  @override
  String message;

  @override
  String status;

  factory ListNoteResponse.fromJson(Map<String, dynamic> json) =>
      ListNoteResponse(
        data: List<Note>.from(json["data"].map((x) => Note.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );
}

class DeleteNoteResponse extends BaseResponse {
  DeleteNoteResponse(
      {required this.data, required this.message, required this.status});

  String data;

  @override
  String message;

  @override
  String status;

  factory DeleteNoteResponse.fromJson(Map<String, dynamic> json) =>
      DeleteNoteResponse(
        data: json["data"],
        message: json["message"],
        status: json["status"],
      );
}
