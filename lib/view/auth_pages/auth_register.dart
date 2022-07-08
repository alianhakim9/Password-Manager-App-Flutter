// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:password_manager/api/api_service.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isObscure = true;
  bool _isLoading = false;
  bool _isButtonActive = false;
  String username = '';
  String password = '';
  String name = '';
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final ApiService _apiService = ApiService();

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
    _scaffoldState.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  void doRegister() {
    showLoading();
    _apiService.register(name, username, password).then((value) {
      String? userId = value?.data.toString();
      String? message = value?.message.toString();
      if (userId != 'NULL') {
        hideLoading();
        showSnackbar('berhasil mendaftar');
      } else if (value!.status == 'CONFLICT') {
        showSnackbar('username sudah terdaftar');
      } else {
        hideLoading();
        showSnackbar(message!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerName.addListener(() {
      _controllerUsername.addListener(() {
        _controllerPassword.addListener(() {
          setState(() {
            _isButtonActive = _controllerUsername.text.isNotEmpty &&
                _controllerPassword.text.isNotEmpty &&
                _controllerName.text.isNotEmpty;
          });
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
      key: _scaffoldState,
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
                    ElevatedButton(
                      onPressed: _isButtonActive
                          ? () {
                              doRegister();
                            }
                          : null,
                      style:
                          ElevatedButton.styleFrom(primary: Colors.amber[600]),
                      child: _isLoading
                          ? const Text(
                              'Sedang Mendatar...',
                              style: TextStyle(color: Colors.black),
                            )
                          : const Text(
                              'Daftar',
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
