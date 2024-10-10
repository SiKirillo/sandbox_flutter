part of '../../common.dart';

/// We use [dartz] as usecases (request body)
/// To learn more visit https://pub.dev/packages/dartz
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}