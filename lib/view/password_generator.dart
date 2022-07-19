import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/utils/helper.dart' as global;

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
        backgroundColor: Colors.amber[600],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset('assets/illustrations/password_generator.png'),
          ),
          Container(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: password == ''
                          ? const Text('Generate password -> ')
                          : Text(password),
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
          ),
          Container(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    primary: Colors.grey[800]),
                onPressed: password != ''
                    ? () {
                        global.copyData(context, password, 'Password');
                      }
                    : null,
                child: const Text(
                  'Copy Password',
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }
}
