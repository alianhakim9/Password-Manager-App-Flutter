import 'package:password_manager/api/api_service.dart';

class MainViewModel {
  final ApiService _apiService = ApiService();

  Future<String> getUserId() async {
    return _apiService.getUserId();
  }

  Future getPasswordManager(userId) {
    return _apiService.getPasswordManagerByUserId(userId);
  }
}
