part of '../common.dart';

class PushNotificationService {
  static String pushNotificationID = '';
  static String apnsID = '';
  static final _notificationService = FlutterLocalNotificationsPlugin();
  static const _androidChannel = AndroidNotificationChannel(
    'high_importance_channel_id',
    'High Importance Notifications Title',
    importance: Importance.high,
  );

  Future<void> init({
    required Function(String) onTokenRefresh,
    required Function(RemoteMessage) onMessageReceived,
    required Function(RemoteMessage) onMessageClicked,
    Future Function(RemoteMessage)? onMessageBackground,
  }) async {
    LoggerService.logDebug('PushNotificationService -> init()');
    await Firebase.initializeApp();
    await Future.delayed(const Duration(seconds: 1));

    final permission = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    apnsID = await FirebaseMessaging.instance.getAPNSToken() ?? '';
    pushNotificationID = await FirebaseMessaging.instance.getToken() ?? '';
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      pushNotificationID = token;
      onTokenRefresh(token);
    });

    await _notificationService.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_androidChannel);
    await _notificationService.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (permission.authorizationStatus != AuthorizationStatus.authorized && permission.authorizationStatus != AuthorizationStatus.provisional) {
      return;
    }

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      onMessageReceived(initialMessage);
    }

    FirebaseMessaging.onMessage.listen((message) {
      onMessageReceived(message);
      showLocalizedNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onMessageClicked(message);
    });

    if (onMessageBackground != null) {
      FirebaseMessaging.onBackgroundMessage(onMessageBackground);
    }
  }

  static Future<void> showLocalizedNotification(RemoteMessage message, {BuildContext? context}) async {
    final titleKey = message.data['title_loc_key'];
    final titleArgsKey = message.data['title_loc_args'];
    final bodyKey = message.data['body_loc_key'];
    final bodyArgsKey = message.data['body_loc_args'];

    /// Data values are provided as strings i.e. "["10", "BYN", "Купала"]"
    final titleParsedArgs = titleArgsKey != null ? json.decode(titleArgsKey) as List<dynamic> : null;
    final bodyParsedArgs = bodyArgsKey != null ? json.decode(bodyArgsKey) as List<dynamic> : null;

    final title = titleKey != null ? 'push_notifications.$titleKey'.tr(
      args: titleParsedArgs?.map((e) => e.toString()).toList(),
      context: context,
    ) : null;

    final body = bodyKey != null ? 'push_notifications.$bodyKey'.tr(
      args: bodyParsedArgs?.map((e) => e.toString()).toList(),
      context: context,
    ) : null;

    if (title == null && body == null) {
      return;
    }

    _notificationService.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.messageId,
    );
  }
}