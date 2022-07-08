import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/illustrations/logo_only.png"),
            const Text(
              "Kelola password lebih mudah\ndengan password manager",
              textAlign: TextAlign.center,
            )
          ],
        ),
      )),
    );
  }
}
