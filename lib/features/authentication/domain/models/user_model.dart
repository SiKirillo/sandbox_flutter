import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final String uid;
  final String email;

  const UserData({
    required this.uid,
    required this.email,
  });

  static const uidKey = 'uid';
  static const emailKey = 'email';

  factory UserData.firebase(User firebaseUser) {
    return UserData(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
    );
  }

  static UserData fromJson(Map<String, dynamic> json) {
    return UserData(
      uid: json[uidKey],
      email: json[emailKey],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      uidKey: uid,
      emailKey: email,
    };
  }

  UserData copyWith({
    String? email,
  }) {
    return UserData(
      uid: uid,
      email: email ?? this.email,
    );
  }
}
