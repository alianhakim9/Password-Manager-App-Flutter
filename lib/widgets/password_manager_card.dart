import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/model/password_manager/password_manager.dart';

import '../view/password_manager_pages/detail_password_manager.dart';

Widget PasswordManagerCard(BuildContext context, PasswordManager data) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPasswordManager(
                    data: data,
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
                    Clipboard.setData(ClipboardData(text: data.pmPassword))
                        .then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text('Password berhasil di copy'))));
                  },
                  icon: const Icon(Icons.copy))),
          Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              )),
        ],
      ),
    ),
  );
}
