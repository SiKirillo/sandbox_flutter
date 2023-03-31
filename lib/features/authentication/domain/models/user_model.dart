class UserData {
  final String email;
  final String password;
  final String nickname;
  final String? firstName;
  final String? lastName;

  const UserData({
    required this.email,
    required this.password,
    required this.nickname,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nickname': nickname,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
