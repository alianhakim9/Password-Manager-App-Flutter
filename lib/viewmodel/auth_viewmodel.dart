import 'package:password_manager/api/api_service.dart';
import 'package:password_manager/api/response/global_response.dart';

class AuthViewModel {
  final ApiService _apiService = ApiService();

  Future<GlobalResponse?> login(String username, String password) {
    return _apiService.login(username, password);
  }

  Future<GlobalResponse?> register(
      String name, String username, String password) {
    return _apiService.register(name, username, password);
  }
}
