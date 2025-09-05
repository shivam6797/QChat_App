class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? profile;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      phone: json["phone"],
      profile: json["profile"],
    );
  }
}
