part of 'core_bloc.dart';

class CoreState {
  final InAppNotificationData? inAppNotificationData;
  final InAppFailureData? inAppFailureData;
  final InAppToastData? infoToastData;

  const CoreState({
    required this.inAppNotificationData,
    required this.inAppFailureData,
    required this.infoToastData,
  });

  factory CoreState.initial() {
    return const CoreState(
      inAppNotificationData: null,
      inAppFailureData: null,
      infoToastData: null,
    );
  }

  CoreState updateInAppNotification({InAppNotificationData? data}) {
    return CoreState(
      inAppNotificationData: data,
      inAppFailureData: inAppFailureData,
      infoToastData: infoToastData,
    );
  }

  CoreState updateInAppFailure({InAppFailureData? data}) {
    return CoreState(
      inAppNotificationData: inAppNotificationData,
      inAppFailureData: data,
      infoToastData: infoToastData,
    );
  }

  CoreState updateInAppToast({InAppToastData? data}) {
    return CoreState(
      inAppNotificationData: inAppNotificationData,
      inAppFailureData: inAppFailureData,
      infoToastData: data,
    );
  }
}
