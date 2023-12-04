class SignUpData {
  final String email;
  final String password;
  final String nickname;
  final String? firstName;
  final String? lastName;

  const SignUpData({
    required this.email,
    required this.password,
    required this.nickname,
    this.firstName,
    this.lastName,
  });

  static const emailKey = 'email';
  static const passwordKey = 'password';
  static const nicknameKey = 'nickname';
  static const firstNameKey = 'first_name';
  static const lastNameKey = 'last_name';

  Map<String, dynamic> toJson() {
    return {
      emailKey: email,
      passwordKey: password,
      nicknameKey: nickname,
      firstNameKey: firstName,
      lastNameKey: lastName,
    };
  }
}
