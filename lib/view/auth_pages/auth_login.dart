// ignore_for_file: deprecated_member_use, invalid_return_type_for_catch_error

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/auth/auth.dart';
import 'package:password_manager/api/auth/auth_service.dart';
import 'package:password_manager/view/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscure = true;
  bool _isLoading = false;
  bool _isButtonActive = false;
  String username = '';
  String password = '';
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final AuthServiceImpl service = AuthServiceImpl();

  void hideLoading() {
    setState(() {
      _isLoading = false;
      _isButtonActive = true;
    });
  }

  void showLoading() {
    setState(() {
      _isLoading = true;
      _isButtonActive = false;
    });
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void login() async {
    LoginRequest request = LoginRequest(username: username, password: password);
    showLoading();
    service.login(request).then((value) {
      hideLoading();
      log('$value');
      if (value != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
            (route) => false);
      } else {
        showSnackbar('Login gagal, cek kembali email dan password');
      }
    }).catchError((err) {
      hideLoading();
      log('err $err');
      showSnackbar('Terjadi kesalahan server');
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerUsername.addListener(() {
      _controllerPassword.addListener(() {
        setState(() {
          _isButtonActive = _controllerUsername.text.isNotEmpty &&
              _controllerPassword.text.isNotEmpty;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controllerPassword.dispose();
    _controllerUsername.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset('assets/illustrations/login.png'),
                    const Text(
                      'Selamat Datang\nKembali!',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'username',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (e) => {username = e},
                      controller: _controllerUsername,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(255, 179, 0, 1))),
                      ),
                      onChanged: (e) => {password = e},
                      obscureText: _isObscure,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _controllerPassword,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: _isButtonActive ? () => login() : null,
                      style:
                          ElevatedButton.styleFrom(primary: Colors.amber[600]),
                      child: _isLoading
                          ? const Text(
                              'Sedang Login...',
                              style: TextStyle(color: Colors.black),
                            )
                          : const Text(
                              'Masuk',
                              style: TextStyle(color: Colors.black),
                            ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
