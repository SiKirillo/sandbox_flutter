class SignInData {
  final String email;
  final String password;

  const SignInData({
    required this.email,
    required this.password,
  });

  static const emailKey = 'email';
  static const passwordKey = 'password';

  Map<String, dynamic> toJson() {
    return {
      emailKey: email,
      passwordKey: password,
    };
  }
}
