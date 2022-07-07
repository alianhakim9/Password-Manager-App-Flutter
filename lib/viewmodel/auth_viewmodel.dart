import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:password_manager/model/user.dart';

class AuthViewModel {
  late User _user;

  login(User user) {
    _user = user;
  }
}
