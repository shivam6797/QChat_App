import 'package:qchat_app/features/auth/data/models/user_model.dart';

class LoginResponse {
  final String token;
  final UserModel user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    return LoginResponse(
      token: data["token"] ?? "",
      user: UserModel.fromJson(data["user"]),
    );
  }
}
