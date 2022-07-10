import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/model/password_manager_response_model.dart';

Widget PasswordManagerCard(Paman data) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: InkWell(
      onTap: () => log('onTap!'),
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
              child:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.copy))),
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
