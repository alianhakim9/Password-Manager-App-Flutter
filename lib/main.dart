import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/view/auth_pages/auth_dashboard_page.dart';
import 'package:password_manager/view/auth_pages/auth_login_page.dart';
import 'package:password_manager/view/splash_screen.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var username = prefs.getString('username');
//   runApp(MaterialApp(
//     home: username == null ? const AuthDashboardPage() : const Login(),
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(
//       primarySwatch: Colors.amber,
//       fontFamily: 'Roboto',
//     ),
//   ));
// }

void main() {
  runApp(MaterialApp(
    home: const SplashScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFEFEF),
        primarySwatch: Colors.amber,
        fontFamily: 'Roboto',
        useMaterial3: true),
  ));
}
