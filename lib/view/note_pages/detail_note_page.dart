// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/notes/note_service.dart';
import 'package:password_manager/model/note_model.dart';
import 'package:password_manager/view/home.dart';
import 'package:password_manager/view/note_pages/update_note_page.dart';
import 'package:password_manager/utils/helper.dart' as global;

class NoteDetailPage extends StatefulWidget {
  NoteDetailPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  Note data;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState(data);
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  Note? data;
  _NoteDetailPageState(this.data);
  @override
  Widget build(BuildContext context) {
    final NoteServiceImpl service = NoteServiceImpl();

    void _delete(String id) async {
      service
          .delete(id)
          .then((value) =>
              global.customPushRemoveNavigator(context, const HomePage()))
          .catchError((err) => log('error $err'));
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(data!.noteTitle),
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
                  _delete('data.id');
                  global.customPushRemoveNavigator(context, const HomePage());
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 0, child: Text('Ubah')),
              const PopupMenuItem(value: 1, child: Text('Hapus'))
            ],
            onSelected: (value) {
              if (value == 1) {
                _showMyDialog();
              } else {
                global.customPushOnlyNavigator(
                    context, UpdateNotePage(data: data!));
              }
            },
          )
        ],
        backgroundColor: Colors.amber[600],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SelectableText(
                data!.noteTitle,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: SizedBox(
                    width: 300,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(data!.noteDescription),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
