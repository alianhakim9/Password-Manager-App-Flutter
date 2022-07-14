import 'package:flutter/material.dart';
import 'package:password_manager/view/auth_pages/auth_dashboard_page.dart';

void main() => runApp(MaterialApp(
      home: const AuthDashboard(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Roboto',
      ),
    ));
