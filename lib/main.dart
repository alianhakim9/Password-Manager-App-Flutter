import 'package:flutter/material.dart';
import 'package:password_manager/view/splash_screen.dart';

void main() => runApp(MaterialApp(
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Roboto',
      ),
    ));
