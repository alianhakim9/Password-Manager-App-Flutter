import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordGeneratorPages extends StatefulWidget {
  const PasswordGeneratorPages({Key? key}) : super(key: key);

  @override
  State<PasswordGeneratorPages> createState() => _PasswordGeneratorPagesState();
}

class _PasswordGeneratorPagesState extends State<PasswordGeneratorPages> {
  String password = '';

  generatePassword({
    bool hasLetters = true,
    bool hasNumber = false,
    bool hasSpecial = false,
  }) {
    const length = 20;
    const letterLowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const letterUpperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const special = '@#=+!\$%&?(){}';

    String chars = '';

    if (hasLetters) chars += '$letterLowerCase$letterUpperCase';
    if (hasNumber) chars += numbers;
    if (hasSpecial) chars += special;

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(password),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        var test = generatePassword();
                        setState(() {
                          password = test;
                        });
                      },
                      icon: const Icon(Icons.restore),
                    ),
                  )
                ],
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: password)).then((value) =>
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Password berhasil di copy'))));
              },
              child: const Text('Copy Password'))
        ],
      ),
    );
  }
}
