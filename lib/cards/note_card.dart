// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:password_manager/api/notes/note_service.dart';
import 'package:password_manager/model/note_model.dart';
import 'package:password_manager/view/home.dart';
import 'package:password_manager/view/note_pages/detail_note_page.dart';

import 'package:password_manager/utils/helper.dart' as global;

Widget NoteCard(BuildContext context, Note data) {
  final NoteServiceImpl service = NoteServiceImpl();

  void _delete(String id) async {
    global.showLoaderDialog(context);
    service
        .delete(id)
        .then((value) =>
            global.customPushRemoveNavigator(context, const HomePage()))
        .catchError((err) {
      Navigator.pop(context);
      global.showSnackbar(context, 'Gagal menghapus data');
    });
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
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
                _delete(data.id);
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
      onTap: () {
        global.customPushOnlyNavigator(context, NoteDetailPage(data: data));
      },
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: Icon(Icons.note_outlined),
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
                  Text(
                    data.noteDescription,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              )),
          Expanded(
              child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  context: context,
                  builder: (context) {
                    return Container(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          title: const Text(
                            'Hapus',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _showMyDialog();
                          },
                        ),
                      ],
                    ));
                  });
            },
            icon: const Icon(Icons.more_vert),
          ))
        ],
      ),
    ),
  );
}
