// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:password_manager/api/personal_info/personal_info_service.dart';
import 'package:password_manager/model/personal_info_model.dart';
import 'package:password_manager/view/home.dart';
import 'package:password_manager/view/personal_info_pages/detail_personal_info_page.dart';

import 'package:password_manager/utils/helper.dart' as global;

Widget PersonalInfoCard(BuildContext context, PersonalInfo data, int position) {
  final PersonalInfoServiceImpl service = PersonalInfoServiceImpl();

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
          title: Text('Personal Info ${position + 1}'),
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
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            context: context,
            builder: (context) {
              return SizedBox(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.data_array,
                    ),
                    title: const Text(
                      'Detail personal info',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      global.customPushOnlyNavigator(
                          context, DetailPersonalInfo(data: data));
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
      child: Row(
        children: [
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
                    'Personal Info ${position + 1}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Email : ${data.piEmail}'),
                  Text('Website : ${data.piWebsite}'),
                  Text('Alamat : ${data.piAddress}'),
                  Text('No Telepon : ${data.piPhoneNumber}')
                ],
              )),
        ],
      ),
    ),
  );
}
