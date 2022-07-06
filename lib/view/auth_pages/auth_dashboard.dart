import 'dart:ui';

import 'package:flutter/material.dart';

class AuthDashboard extends StatefulWidget {
  const AuthDashboard({Key? key}) : super(key: key);

  @override
  State<AuthDashboard> createState() => _AuthDashboardState();
}

class _AuthDashboardState extends State<AuthDashboard> {
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(primary: Colors.amber),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(primary: Colors.amber),
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
