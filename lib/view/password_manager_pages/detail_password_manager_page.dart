// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:password_manager/model/password_manager_model.dart';

import 'package:password_manager/utils/helper.dart' as global;
import 'package:password_manager/view/password_manager_pages/update_password_manager_page.dart';

class DetailPasswordManager extends StatefulWidget {
  const DetailPasswordManager({Key? key, required this.data}) : super(key: key);

  final PasswordManager data;

  @override
  State<DetailPasswordManager> createState() =>
      _DetailPasswordManagerState(data);
}

class _DetailPasswordManagerState extends State<DetailPasswordManager> {
  PasswordManager? data;
  _DetailPasswordManagerState(this.data);
  late String password = '';
  late final TextEditingController _textPassController =
      TextEditingController();
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;
  bool _isObscure = true;

  @override
  void initState() {
    _textPassController.text = data!.pmPassword;
    password = data!.pmPassword;
    super.initState();
  }

  @override
  void dispose() {
    _textPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.data.pmWebsite,
                style: const TextStyle(fontSize: 12),
              ),
              background: const Icon(
                Icons.key,
                size: 50,
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    global.customPushOnlyNavigator(
                        context, UpdatePasswordManager(data: data!));
                  },
                  icon: const Icon(Icons.edit))
            ],
            backgroundColor: Colors.amber[600],
          ),
          SliverToBoxAdapter(
              child: Card(
            elevation: 0,
            margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          readOnly: true,
                          controller: TextEditingController()
                            ..text = data!.pmUsername,
                          onChanged: (e) => password = e,
                          decoration: const InputDecoration(
                              border: InputBorder.none, labelText: 'Username'),
                        ),
                      ),
                      Expanded(
                          child: TextButton(
                        onPressed: () {
                          global.copyData(
                              context, data!.pmUsername, 'Username');
                        },
                        child: const Text('COPY'),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: TextFormField(
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = data!.pmPassword,
                              obscureText: _isObscure,
                              onChanged: (e) => password = e,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                      icon: Icon(_isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off))))),
                      Expanded(
                          child: TextButton(
                        onPressed: () {
                          global.copyData(
                              context, data!.pmPassword, 'Password');
                        },
                        child: const Text('COPY'),
                      ))
                    ],
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController()..text = data!.createdAt,
                    decoration: const InputDecoration(
                        border: InputBorder.none, labelText: 'Dibuat'),
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController()
                      ..text = data!.updatedAt == 'null'
                          ? 'Belum pernah diperbarui'
                          : data!.updatedAt,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Terakhir diperbarui'),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
