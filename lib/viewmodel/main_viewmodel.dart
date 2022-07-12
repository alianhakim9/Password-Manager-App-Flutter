import 'package:password_manager/api/api_service.dart';

class MainViewModel {
  final ApiService _apiService = ApiService();

  Future<String> getUserId() async {
    return _apiService.getUserId();
  }

  Future getPasswordManager(userId) {
    return _apiService.getPasswordManagerByUserId(userId);
  }

  Future addPasswordManager(
      String username, String password, String website, String userId) {
    return _apiService.addPasswordManager(username, password, website, userId);
  }

  Future deletePasswordManager(String id) {
    return _apiService.deletePasswordManager(id);
  }
}
