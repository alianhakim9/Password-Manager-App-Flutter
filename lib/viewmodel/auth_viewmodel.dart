import 'package:password_manager/api/api_service.dart';
import 'package:password_manager/api/response/auth_response.dart';
import 'package:password_manager/model/base_response_model.dart';

class AuthViewModel {
  final ApiService _apiService = ApiService();

  Future<AuthResponse?> login(String username, String password) {
    return _apiService.login(username, password);
  }

  Future<AuthResponse?> register(
      String name, String username, String password) {
    return _apiService.register(name, username, password);
  }
}
