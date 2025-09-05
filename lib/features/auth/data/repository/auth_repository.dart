import 'package:shared_preferences/shared_preferences.dart';
import 'package:qchat_app/core/errors/api_exception.dart';
import 'package:qchat_app/core/network/api_client.dart';
import 'package:qchat_app/core/network/api_endpoint.dart';
import 'package:qchat_app/features/auth/data/models/login_response.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<LoginResponse> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {"email": email, "password": password, "role": role},
      );

      final loginResponse = LoginResponse.fromJson(response);

      // Save userId and token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", loginResponse.token);
      await prefs.setString("userId", loginResponse.user.id);

      return loginResponse;
    } catch (error) {
      throw ApiException.fromDioError(error);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }
}
