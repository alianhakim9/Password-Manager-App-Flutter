import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/notes/note_service.dart';
import 'package:password_manager/model/note_model.dart';

import '../view/home.dart';

Widget NoteCard(BuildContext context, Note data) {
  final NoteServiceImpl service = NoteServiceImpl();

  void _delete(String id) async {
    service
        .delete(id)
        .then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
            (route) => false))
        .catchError((err) => log('error $err'));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data.noteTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Apakah anda yakin akan menghapus data ini?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                // _delete(data.id);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: InkWell(
      onTap: () {},
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: Icon(Icons.key),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    data.noteTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(data.noteDescription)
                ],
              )),
          Expanded(
              flex: 1,
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: const [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 20,
                          ),
                          Text('Hapus')
                        ],
                      ))
                ],
                onSelected: (value) {
                  if (value == 1) {
                    _showMyDialog();
                  }
                },
              )),
        ],
      ),
    ),
  );
}
