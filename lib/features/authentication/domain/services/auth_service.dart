import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandbox_flutter/features/authentication/domain/models/sign_up_model.dart';
import 'package:sandbox_flutter/features/authentication/domain/models/user_model.dart';

import '../../../../common/models/service/failure_model.dart';
import '../../../../constants/failures.dart';
import '../models/sign_in_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Either<Failure, UserData>> signIn(SignInData data) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );

      if (userCredential.user == null) {
        return Left(AuthErrorExtension.getErrorByCode('user-not-found'));
      } else {
        return Right(UserData.firebase(userCredential.user!));
      }
    } on FirebaseAuthException catch (e) {
      return Left(AuthErrorExtension.getErrorByCode(e.code));
    } catch (e) {
      return Left(CommonFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, UserData>> signUp(SignUpData data) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );

      if (userCredential.user == null) {
        return Left(AuthErrorExtension.getErrorByCode('user-not-found'));
      } else {
        return Right(UserData.firebase(userCredential.user!));
      }
    } on FirebaseAuthException catch (e) {
      return Left(AuthErrorExtension.getErrorByCode(e.code));
    } catch (e) {
      return Left(CommonFailure(message: e.toString()));
    }
  }
}