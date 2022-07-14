import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/model/password_manager_model.dart';

import 'update_password_manager_page.dart';

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
  Widget build(BuildContext context) {
    @override
    initState() {
      super.initState();
      _textPassController.text = data!.pmPassword;
      password = data!.pmPassword;
    }

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdatePasswordManager(
                                  data: data!,
                                )));
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                        Clipboard.setData(ClipboardData(text: data!.pmUsername))
                            .then((value) => ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content:
                                        Text('Username berhasil di copy'))));
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
                        Clipboard.setData(ClipboardData(text: data!.pmPassword))
                            .then((value) => ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content:
                                        Text('Password berhasil di copy'))));
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
          ))
        ],
      ),
    );
  }
}
