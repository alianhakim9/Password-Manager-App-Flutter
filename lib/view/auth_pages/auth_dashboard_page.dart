import 'package:flutter/material.dart';

import 'auth_login_page.dart';
import 'auth_register_page.dart';

class AuthDashboard extends StatelessWidget {
  const AuthDashboard({Key? key}) : super(key: key);

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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.amber[600]),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()));
                  },
                  style: OutlinedButton.styleFrom(primary: Colors.amber[600]),
                  child: const Text(
                    "Daftar",
                    style: TextStyle(color: Colors.black),
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