part of '../common.dart';

class SupabaseService {
  static late final SupabaseClient _supabase;
  static SupabaseClient get client => _supabase;

  Future<void> init() async {
    LoggerService.logTrace('SupabaseService -> init()');

    await Supabase.initialize(
      url: EnvironmentConstants.supabaseURL,
      anonKey: EnvironmentConstants.supabaseAnonKey,
      debug: false,
    );

    _supabase = Supabase.instance.client;
  }

  Future<void> onStartListener() async {
    LoggerService.logTrace('SupabaseService -> onStartListener()');

    _supabase.auth.onAuthStateChange.listen((data) {
      LoggerService.logDebug('SupabaseService -> onAuthStateChange(state: ${data.event.toString()})');

      switch (data.event) {
        case AuthChangeEvent.initialSession: {
          // locator<AppInit>().call(data.session?.refreshToken).then((response) {
          //   response.fold(
          //     (failure) {
          //       locator<AuthBloc>().add(UpdateAuthStateEvent(event: AuthStateType.welcome));
          //     },
          //     (result) {
          //       locator<AuthBloc>().add(UpdateAuthStateEvent(event: AuthStateType.signedIn));
          //     },
          //   );
          // });
          break;
        }

        case AuthChangeEvent.signedIn: {
          break;
        }

        case AuthChangeEvent.signedOut: {
          // locator<AuthBloc>().add(UpdateAuthStateEvent(event: AuthStateType.signedOut));
          break;
        }

        case AuthChangeEvent.passwordRecovery: {
          break;
        }

        case AuthChangeEvent.tokenRefreshed: {
          break;
        }

        case AuthChangeEvent.userUpdated: {
          // locator<AuthSupabaseService>().getUserData(data.session?.user).then((response) {
          //   response.fold(
          //     (failure) {
          //       LoggerService.logFailure('SupabaseService -> onAuthStateChange(state: ${data.event.toString()}): ${failure.message}');
          //     },
          //     (result) {
          //       locator<AuthBloc>().add(UpdateUserDataEvent(user: result));
          //     },
          //   );
          // });
          break;
        }

        case AuthChangeEvent.userDeleted: {
          // locator<AuthSignOut>().call(NoParams());
          break;
        }

        case AuthChangeEvent.mfaChallengeVerified: {
          break;
        }
      }
    });
  }
}