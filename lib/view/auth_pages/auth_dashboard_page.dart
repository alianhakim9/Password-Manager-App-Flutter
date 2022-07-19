import 'package:flutter/material.dart';

import 'package:password_manager/utils/helper.dart' as global;
import 'package:password_manager/view/auth_pages/auth_login_page.dart';
import 'package:password_manager/view/auth_pages/auth_register_page.dart';

class AuthDashboardPage extends StatelessWidget {
  const AuthDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Image(
            image: AssetImage("assets/illustrations/auth_dashboard.png"),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  "PAMAN.ID",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Text("Aplikasi password manager"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      global.customPushOnlyNavigator(context, const Login());
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber[600],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      "Masuk",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 50.0,
                  child: OutlinedButton(
                    onPressed: () {
                      global.customPushOnlyNavigator(context, const Register());
                    },
                    style: OutlinedButton.styleFrom(
                        primary: Colors.amber[600],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      "Daftar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          context: context,
                          builder: (context) {
                            return Container(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: const [
                                    Text(
                                      "Apa itu PAMAN ID?",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        "Aplikasi password manager adalah sebuah aplikasi berbasis mobile untuk mengelola password atau kata sandi yang digunakan untuk otentikasi sistem, menglola catatan, dan mengelola data info personal.")
                                  ],
                                ));
                          });
                    },
                    child: const Text("FAQ"),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
