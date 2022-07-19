// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:password_manager/api/password_manager/password_manager_service.dart';
import 'package:password_manager/model/password_manager_model.dart';
import 'package:password_manager/view/home.dart';
import 'package:password_manager/view/password_manager_pages/detail_password_manager_page.dart';

import 'package:password_manager/utils/helper.dart' as global;

Widget PasswordManagerCard(BuildContext context, PasswordManager data) {
  final PasswordManagerServiceImpl service = PasswordManagerServiceImpl();

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
          title: Text(data.pmUsername),
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
      onTap: () => global.customPushOnlyNavigator(
          context, DetailPasswordManager(data: data)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: 100,
              height: 50,
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.grey[300],
              ),
              child: const Icon(Icons.key),
            ),
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
                    data.pmWebsite,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(data.pmUsername)
                ],
              )),
          Expanded(
              flex: 2,
              child: IconButton(
                  onPressed: () {
                    global.copyData(context, data.pmPassword, 'Password');
                  },
                  icon: const Icon(Icons.copy))),
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
                          leading: const Icon(Icons.copy),
                          title: const Text('Copy username'),
                          onTap: () {
                            global.copyData(
                                context, data.pmUsername, 'Username');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.copy),
                          title: const Text('Copy password'),
                          onTap: () {
                            global.copyData(
                                context, data.pmPassword, 'Password');
                            Navigator.pop(context);
                          },
                        ),
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
