part of '../common.dart';

class AppInit implements UseCase<dartz.Either<Failure, void>, NoParams> {
  final AppPreferencesStorage appPreferencesStorage;

  const AppInit({
    required this.appPreferencesStorage,
  });

  @override
  Future<dartz.Either<Failure, void>> call(NoParams params) async {
    LoggerService.logTrace('AppInit -> call()');
    final isRanBefore = await appPreferencesStorage.readAppRunConfigurationValue();
    if (!isRanBefore) {
      await Future.wait([
        AbstractSecureDatasource.deleteStorage(),
        AbstractSharedPreferencesDatasource.deletePreferences(),
        appPreferencesStorage.writeAppRunConfigurationValue(true),
      ]);
    }

    return dartz.Right(null);
  }
}
