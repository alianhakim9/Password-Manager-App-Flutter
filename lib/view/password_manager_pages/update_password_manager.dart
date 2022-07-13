import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/password_manager/password_manager_req_res.dart';
import 'package:password_manager/api/password_manager/password_manager_service.dart';
import 'package:password_manager/model/password_manager/password_manager.dart';
import 'package:password_manager/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    UpdatePasswordManagerRequest request = UpdatePasswordManagerRequest(
        pmUsername: username, pmPassword: password, pmWebsite: website);
    showLoading();
    service.update(request, data.id).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
          (route) => false);
    }).catchError((err) {
      hideLoading();
      log('err $err');
    });
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
              IconButton(
                  onPressed: () {
                    _update(username, password, website);
                  },
                  icon: const Icon(Icons.done))
            ],
          ),
          SliverToBoxAdapter(
              child: _isLoading
                  ? const LinearProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            onChanged: (e) => username = e,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Username'),
                          ),
                          TextFormField(
                              controller: _passwordController,
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
                                          : Icons.visibility_off)))),
                          TextFormField(
                            controller: _websiteController,
                            onChanged: (e) => website = e,
                            decoration: const InputDecoration(
                                border: InputBorder.none, labelText: 'Website'),
                          ),
                        ],
                      ),
                    ))
        ],
      ),
    );
  }
}
