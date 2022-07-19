// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/password_manager/password_manager_req_res.dart';
import 'package:password_manager/api/password_manager/password_manager_service.dart';
import 'package:password_manager/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:password_manager/utils/helper.dart' as global;
import 'dart:math' as math;

class AddPasswordManager extends StatefulWidget {
  const AddPasswordManager({Key? key}) : super(key: key);

  @override
  State<AddPasswordManager> createState() => _AddPasswordManagerState();
}

class _AddPasswordManagerState extends State<AddPasswordManager> {
  String username = '';
  String password = '';
  String website = '';
  bool _isObscure = true;
  bool _isLoading = false;
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerWebsite = TextEditingController();

  final PasswordManagerServiceImpl service = PasswordManagerServiceImpl();

  @override
  void dispose() {
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    _controllerWebsite.dispose();
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

  addData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId') ?? false;
    if (userId != '') {
      addpaswordManager(userId);
    }
  }

  void addpaswordManager(userId) async {
    AddPasswordManagerRequest request = AddPasswordManagerRequest(
        pmUsername: username,
        pmPassword: password,
        pmWebsite: website,
        userId: userId);
    if (username != '' && password != '' && website != '') {
      showLoading();
      service.create(request).then((value) {
        if (value != null) {
          hideLoading();
          Navigator.pop(context);
          hideLoading();
          global.showSnackbar(context, 'Data berhasil ditambahkan');
          Future.delayed(const Duration(milliseconds: 2000), () {
            setState(() {
              global.customPushRemoveNavigator(context, const HomePage());
            });
          });
        } else {
          hideLoading();
          log('value ${value!.data}');
          global.showSnackbar(context, 'Gagal menambahkan data');
        }
      }).onError((error, stackTrace) {
        hideLoading();
        global.showSnackbar(context, 'Terjadi kesalahan saat menambahkan data');
        log('error : $error');
      });
    } else {
      global.showSnackbar(context, 'Tidak boleh kosong');
    }
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
            flexibleSpace: const FlexibleSpaceBar(
              title: Text(
                'Tambah password',
                style: TextStyle(fontSize: 15),
              ),
              centerTitle: true,
              background: Icon(
                Icons.key,
                size: 100.0,
              ),
            ),
            backgroundColor: Colors.amber[600],
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  onChanged: (e) => {username = e},
                  controller: _controllerUsername,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
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
                            : Icons.visibility_off)),
                  ),
                  onChanged: (e) => {password = e},
                  obscureText: _isObscure,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _controllerPassword,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Website',
                  ),
                  onChanged: (e) => {website = e},
                  controller: _controllerWebsite,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.grey[800],
                        minimumSize: const Size.fromHeight(50),
                        elevation: 0),
                    onPressed: _isLoading
                        ? null
                        : () {
                            addData();
                          },
                    icon: _isLoading
                        ? Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(right: 30),
                            child: CircularProgressIndicator(
                              color: Colors.grey[800],
                            ))
                        : const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                    label: _isLoading
                        ? const Text(
                            'Sedang menambahkan data...',
                            style: TextStyle(color: Colors.white),
                          )
                        : const Text(
                            'Tambah',
                            style: TextStyle(color: Colors.white),
                          ))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
