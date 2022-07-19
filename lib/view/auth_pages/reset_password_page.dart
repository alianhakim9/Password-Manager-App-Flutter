import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_manager/api/auth/auth.dart';
import 'package:password_manager/api/auth/auth_service.dart';
import 'package:password_manager/utils/helper.dart' as global;

class ReserPasswordPage extends StatefulWidget {
  const ReserPasswordPage({Key? key}) : super(key: key);

  @override
  State<ReserPasswordPage> createState() => _ReserPasswordPageState();
}

class _ReserPasswordPageState extends State<ReserPasswordPage> {
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  bool _isLoading = false;
  String username = '';
  String newPassword = '';
  String confirmPassword = '';

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerNewPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  final AuthServiceImpl service = AuthServiceImpl();

  @override
  void dispose() {
    _controllerUsername.dispose();
    _controllerNewPassword.dispose();
    _controllerConfirmPassword.dispose();
    super.dispose();
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

  void _resetPassword() async {
    ResetPasswordRequest request =
        ResetPasswordRequest(username: username, newPassword: newPassword);
    if (username != '' && newPassword != '' && confirmPassword != '') {
      if (newPassword != confirmPassword) {
        global.showSnackbar(context, 'Password tidak sama');
      } else if (newPassword.length < 8) {
        global.showSnackbar(context, 'Password minimal 8 karakter');
      } else {
        showLoading();
        service.resetPassword(request).then((value) {
          hideLoading();
          log('$value');
          if (value != null) {
            global.showSnackbar(
                context, 'Password berhasil di reset, silahkan login');
          } else {
            global.showSnackbar(context, 'username tidak ditemukan');
          }
        }).catchError((err) {
          hideLoading();
          log('err $err');
          global.showSnackbar(context, 'Terjadi kesalahan server');
        });
      }
    } else {
      global.showSnackbar(context, 'Tidak boleh kosong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/illustrations/reset_password.png'),
              if (_isLoading) const LinearProgressIndicator(),
              const Text(
                'Halaman\nReset Password',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(255, 179, 0, 1))),
                ),
                controller: _controllerUsername,
                onChanged: (e) => username = e,
              ),
              const SizedBox(
                height: 10,
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
                      borderSide:
                          BorderSide(color: Color.fromRGBO(255, 179, 0, 1))),
                ),
                onChanged: (e) => {newPassword = e},
                obscureText: _isObscure,
                enableSuggestions: false,
                autocorrect: false,
                controller: _controllerNewPassword,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Konfirmasi password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscureConfirm = !_isObscureConfirm;
                        });
                      },
                      icon: Icon(_isObscure
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(255, 179, 0, 1))),
                ),
                onChanged: (e) => {confirmPassword = e},
                obscureText: _isObscureConfirm,
                enableSuggestions: false,
                autocorrect: false,
                controller: _controllerConfirmPassword,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  _resetPassword();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.amber[600],
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: _isLoading
                    ? const Text(
                        'Harap tunggu...',
                        style: TextStyle(color: Colors.black),
                      )
                    : const Text(
                        'Reset password',
                        style: TextStyle(color: Colors.black),
                      ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
