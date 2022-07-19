// ignore_for_file: deprecated_member_use, invalid_return_type_for_catch_error

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/auth/auth.dart';
import 'package:password_manager/api/auth/auth_service.dart';
import 'package:password_manager/view/auth_pages/auth_register_page.dart';
import 'package:password_manager/view/auth_pages/reset_password_page.dart';
import 'package:password_manager/view/home.dart';
import 'package:password_manager/utils/helper.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscure = true;
  bool _isLoading = false;
  String username = '';
  String password = '';
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final AuthServiceImpl service = AuthServiceImpl();

  Future getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usernamePrefs = prefs.getString('username');
    if (usernamePrefs != null) {
      _controllerUsername.text = usernamePrefs;
      username = usernamePrefs.toString();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void login() async {
    LoginRequest request = LoginRequest(username: username, password: password);
    if (username != '' && password != '') {
      showLoading();
      service.login(request).then((value) {
        hideLoading();
        log('$value');
        if (value != null) {
          global.customPushRemoveNavigator(context, const HomePage());
        } else {
          global.showSnackbar(
              context, 'Login gagal, cek kembali email dan password');
        }
      }).catchError((err) {
        hideLoading();
        log('err $err');
        global.showSnackbar(context, 'Terjadi kesalahan server');
      });
    } else {
      global.showSnackbar(context, 'Tidak boleh kosong');
    }
  }

  @override
  void dispose() {
    _controllerPassword.dispose();
    _controllerUsername.dispose();
    super.dispose();
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
                      height: 10,
                    ),
                    SizedBox(
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => login(),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            primary: Colors.amber[600]),
                        child: _isLoading
                            ? const Text(
                                'Sedang Login...',
                                style: TextStyle(color: Colors.black),
                              )
                            : const Text(
                                'Masuk',
                                style: TextStyle(color: Colors.black),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Belum punya akun ?'),
                        TextButton(
                          onPressed: () {
                            global.customPushOnlyNavigator(
                                context, const Register());
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.amber[600],
                          ),
                          child: const Text('Daftar'),
                        )
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        global.customPushOnlyNavigator(
                            context, const ReserPasswordPage());
                      },
                      style: TextButton.styleFrom(primary: Colors.amber[600]),
                      child: const Text('Reset Password'),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
