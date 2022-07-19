// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/password_manager/password_manager_req_res.dart';
import 'package:password_manager/api/password_manager/password_manager_service.dart';
import 'package:password_manager/model/password_manager_model.dart';
import 'package:password_manager/view/home.dart';

import 'package:password_manager/utils/helper.dart' as global;

class UpdatePasswordManager extends StatefulWidget {
  UpdatePasswordManager({Key? key, required this.data}) : super(key: key);

  PasswordManager data;

  @override
  State<UpdatePasswordManager> createState() {
    return _UpdatePasswordManagerState(data);
  }
}

class _UpdatePasswordManagerState extends State<UpdatePasswordManager> {
  PasswordManager data;
  _UpdatePasswordManagerState(this.data);

  bool _isObscure = true;
  bool _isLoading = false;
  String username = '';
  String password = '';
  String website = '';

  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final PasswordManagerServiceImpl service = PasswordManagerServiceImpl();

  @override
  void initState() {
    super.initState();
    _usernameController.text = data.pmUsername;
    _passwordController.text = data.pmPassword;
    _websiteController.text = data.pmWebsite;

    username = data.pmUsername;
    password = data.pmPassword;
    website = data.pmWebsite;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void _update(String username, String password, String website) async {
    if (username != '' && password != '' && website != '') {
      UpdatePasswordManagerRequest request = UpdatePasswordManagerRequest(
          pmUsername: username, pmPassword: password, pmWebsite: website);
      showLoading();
      service.update(request, data.id).then((value) {
        hideLoading();
        global.showSnackbar(context, 'Data berhasil di update');
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            global.customPushRemoveNavigator(context, const HomePage());
          });
        });
      }).catchError((err) {
        hideLoading();
        log('err $err');
      });
    } else {
      global.showSnackbar(context, 'Tidak boleh kosong');
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.data.pmWebsite,
              ),
            ),
            actions: [
              _isLoading
                  ? Center(
                      child: Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(right: 30),
                          child: CircularProgressIndicator(
                            color: Colors.grey[800],
                          )),
                    )
                  : IconButton(
                      onPressed: () {
                        _update(username, password, website);
                      },
                      icon: const Icon(Icons.done))
            ],
            backgroundColor: Colors.amber[600],
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  onChanged: (e) => username = e,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    onChanged: (e) => password = e,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off)))),
                TextFormField(
                  controller: _websiteController,
                  onChanged: (e) => website = e,
                  decoration: const InputDecoration(labelText: 'Website'),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
