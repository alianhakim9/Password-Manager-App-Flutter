import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/notes/note_req_res.dart';
import 'package:password_manager/api/notes/note_service.dart';
import 'package:password_manager/view/note_pages/update_note_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/note_model.dart';
import '../home.dart';

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
    final TextEditingController _controllerTitle = TextEditingController();
    late final TextEditingController _controllerDescription =
        TextEditingController();

    String title = '';
    String description = '';

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
                child: const Text('Hapus'),
                onPressed: () {
                  _delete('data.id');
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                      (route) => false);
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateNotePage(
                              data: data!,
                            )));
              }
            },
          )
        ],
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
              SelectableText(data!.noteDescription)
            ],
          ),
        ),
      ),
    );
  }
}
