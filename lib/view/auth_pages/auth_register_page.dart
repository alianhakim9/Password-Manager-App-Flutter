// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:password_manager/api/auth/auth.dart';
import 'package:password_manager/api/auth/auth_service.dart';
import 'package:password_manager/view/auth_pages/auth_login_page.dart';
import 'package:password_manager/utils/helper.dart' as global;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isObscure = true;
  bool _isLoading = false;
  String username = '';
  String password = '';
  String name = '';
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  AuthServiceImpl service = AuthServiceImpl();

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

  void _setFieldEmpty() {
    setState(() {
      _controllerName.text = '';
      _controllerUsername.text = '';
      _controllerPassword.text = '';
      username = '';
      password = '';
      name = '';
    });
  }

  void register() async {
    RegisterRequest request =
        RegisterRequest(name: name, username: username, password: password);
    if (name != '' && username != '' && password != '') {
      if (password.length > 8) {
        showLoading();
        service.register(request).then((value) {
          hideLoading();
          if (value != null) {
            if (value.status == 'CONFLICT') {
              global.showSnackbar(context, 'Username sudah terdaftar');
            } else {
              _setFieldEmpty();
              global.showSnackbar(
                context,
                'Berhasil mendaftar, silahkan login',
              );
            }
          } else {
            global.showSnackbar(context, 'Terjadi kesalahan saat mendaftar');
          }
        }).catchError((err) {
          hideLoading();
          global.showSnackbar(context, 'Terjadi kesalahan saat mendaftar');
        });
      } else {
        hideLoading();
        global.showSnackbar(context, 'Password minimal 8 karakter');
      }
    } else {
      hideLoading();
      global.showSnackbar(context, 'Tidak boleh kosong');
    }
  }

  @override
  void dispose() {
    _controllerName.dispose();
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
                    Image.asset('assets/illustrations/register.png'),
                    const Text(
                      'Silahkan Lengkapi\nData Untuk Mendaftar',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (e) => {name = e},
                      controller: _controllerName,
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
                    SizedBox(
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => register(),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isLoading
                            ? const Text(
                                'Sedang Mendatar...',
                                style: TextStyle(color: Colors.black),
                              )
                            : const Text(
                                'Daftar',
                                style: TextStyle(color: Colors.black),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Sudah punya akun ?'),
                        TextButton(
                            onPressed: () {
                              global.customPushReplaceNavigator(
                                  context, const Login());
                            },
                            child: const Text('Masuk'))
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
