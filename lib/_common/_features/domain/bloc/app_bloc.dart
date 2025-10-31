part of '../../../common.dart';

class AppBloc extends Bloc<AppBlocEvent, AppState> {
  AppBloc(super.initialState) {
    /// Common
    on<Init_AppEvent>(_onInit);
    on<UpdateStatus_AppEvent>(_onUpdateStatus);
    /// Service
    on<Reset_AppEvent>(_onReset);
    on<HandleFailure_AppEvent>(_onHandleFailure);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    locator<InAppOverlayProvider>().hide();
    add(HandleFailure_AppEvent());
  }

  /// Common
  Future<void> _onInit(Init_AppEvent event, Emitter<AppState> emit) async {
    await locator<AppRepository>().init();
    // final response = await locator<AuthRepository>().init();
    // response.fold(
    //   (failure) {
    //     _onUpdateStatus(UpdateStatus_AppEvent(status: AppStatus.welcome), emit);
    //   },
    //   (result) {
    //     _onUpdateStatus(UpdateStatus_AppEvent(status: AppStatus.loggedIn), emit);
    //   },
    // );
  }

  void _onUpdateStatus(UpdateStatus_AppEvent event, Emitter<AppState> emit) {
    emit(state.copyWith(status: event.status));
  }

  /// Service
  void _onReset(Reset_AppEvent event, Emitter<AppState> emit) {
    if (event.isSessionExpired) {
      emit(state.sessionExpired());
    } else {
      emit(state.signOut());
    }
  }

  void _onHandleFailure(HandleFailure_AppEvent event, Emitter<AppState> emit) {
    emit(state.copyWith(isLocked: false));
  }
}
