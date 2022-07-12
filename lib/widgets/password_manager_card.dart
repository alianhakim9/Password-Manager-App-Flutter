import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/password_manager/password_manager.dart';
import '../view/password_manager_pages/detail_password_manager.dart';
import '../viewmodel/main_viewmodel.dart';

class PasswordManagerCard extends StatefulWidget {
  const PasswordManagerCard({Key? key, required this.data}) : super(key: key);

  final PasswordManager data;

  @override
  State<PasswordManagerCard> createState() => _PasswordManagerCardState(data);
}

class _PasswordManagerCardState extends State<PasswordManagerCard> {
  PasswordManager? data;
  _PasswordManagerCardState(this.data);
  @override
  Widget build(BuildContext context) {
    MainViewModel viewModel = MainViewModel();

    Future _delete(String id) async {
      viewModel
          .deletePasswordManager(id)
          .then((value) => log('deleted'))
          .catchError((err) => log('error'));
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(data!.pmUsername),
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
                  // hapus data
                  _delete(data!.id);
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
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPasswordManager(
                      data: data!,
                    ))),
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
                      data!.pmWebsite,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(data!.pmUsername)
                  ],
                )),
            Expanded(
                flex: 2,
                child: IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: data!.pmPassword))
                          .then((value) => ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text('Password berhasil di copy'))));
                    },
                    icon: const Icon(Icons.copy))),
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
}
