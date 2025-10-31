part of 'firebase_core_service.dart';

class FirebaseMessagingService {
  static const _channelId = 'high_importance_channel';
  static const _channelName = 'Important Notifications';
  // static final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static String apnsID = '';

  static void registerBackgroundMessageHandler() {
    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static Future<void> init({
    required Function(String) onTokenUpdated,
    required Function(Map<String, dynamic>) onMessageClicked,
  }) async {
    LoggerService.logTrace('FirebaseMessagingService -> init()');

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
    if (permission.authorizationStatus != AuthorizationStatus.authorized && permission.authorizationStatus != AuthorizationStatus.provisional) {
      return;
    }

    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    await FirebaseMessaging.instance.getAPNSToken();
    // await _requestFcmToken(onTokenUpdated);
    // _initNotifications(onMessageClicked);

    // FirebaseMessaging.instance.onTokenRefresh.listen(onTokenUpdated);
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   _showNotification(message);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   onMessageClicked(message.data);
    // });
  }

  // static Future<void> _initNotifications(Function(Map<String, dynamic>) onMessageClicked) async {
  //   final androidSettings = AndroidInitializationSettings('ic_uzbat_logo');
  //   final initSettings = InitializationSettings(
  //     android: androidSettings,
  //     iOS: DarwinInitializationSettings(),
  //   );
  //
  //   await _localNotificationsPlugin.initialize(
  //     initSettings,
  //     onDidReceiveNotificationResponse: (NotificationResponse response) {
  //       if (response.payload == null) return;
  //       final data = jsonDecode(response.payload!) as Map<String, dynamic>;
  //       onMessageClicked(data);
  //     },
  //   );
  //
  //   if (Platform.isAndroid) {
  //     _createNotificationChannel();
  //   }
  // }
  //
  // static void _createNotificationChannel() {
  //   const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     _channelId,
  //     _channelName,
  //     description: 'This channel is used for important notifications',
  //     importance: Importance.high,
  //   );
  //
  //   _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  // }
  //
  // static Future<void> _showNotification(RemoteMessage message) async {
  //   final androidDetails = AndroidNotificationDetails(
  //     _channelId,
  //     _channelName,
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     color: Color(0xFF0C3480),
  //   );
  //
  //   final iosDetails = DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );
  //
  //   final title = message.data['event'];
  //   // final title = type.getTitle(
  //   //   args: message.data['event'],
  //   //   lang: LanguageType.fromLocale(locale),
  //   // );
  //
  //   final body = message.data['event'];
  //   // final body = type.getBody(
  //   //   args: message.data['event'],
  //   //   currentLanguage: LanguageType.fromLocale(locale),
  //   // );
  //
  //   await _localNotificationsPlugin.show(
  //     message.messageId.hashCode.abs(),
  //     title,
  //     body,
  //     NotificationDetails(
  //       android: androidDetails,
  //       iOS: iosDetails,
  //     ),
  //     payload: jsonEncode(message.data),
  //   );
  // }
  //
  // static Future<void> _requestFcmToken(Function(String) onTokenUpdated) async {
  //   final token = await FirebaseMessaging.instance.getToken() ?? '';
  //   onTokenUpdated(token);
  // }
  //
  // static Future<void> revokeFcmToken() async {
  //   if (Firebase.apps.isNotEmpty) {
  //     LoggerService.logTrace('FirebaseMessagingService -> revokeFcmToken()');
  //     await FirebaseMessaging.instance.deleteToken();
  //   }
  // }
}

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   LoggerService.logTrace('FirebaseMessagingService -> firebaseMessagingBackgroundHandler()');
//
//   final plugin = FlutterLocalNotificationsPlugin();
//   const androidSettings = AndroidInitializationSettings('ic_uzbat_logo');
//   const initSettings = InitializationSettings(
//     android: androidSettings,
//     iOS: DarwinInitializationSettings(),
//   );
//
//   await plugin.initialize(initSettings);
//   const channel = AndroidNotificationChannel(
//     FirebaseMessagingService._channelId,
//     FirebaseMessagingService._channelName,
//     description: 'This channel is used for important notifications',
//     importance: Importance.high,
//   );
//
//   await plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
//   final localeCode = Platform.localeName.split('_').first;
//   final locale = Locale(localeCode);
//
//   final title = message.data['event'];
//   // final title = type.getTitle(
//   //   args: message.data['event'],
//   //   lang: LanguageType.fromLocale(locale),
//   // );
//
//   final body = message.data['event'];
//   // final body = type.getBody(
//   //   args: message.data['event'],
//   //   currentLanguage: LanguageType.fromLocale(locale),
//   // );
//
//   final androidDetails = AndroidNotificationDetails(
//     FirebaseMessagingService._channelId,
//     FirebaseMessagingService._channelName,
//     importance: Importance.max,
//     priority: Priority.high,
//     color: Color(0xFF0C3480),
//   );
//
//   final iosDetails = DarwinNotificationDetails(
//     presentAlert: true,
//     presentBadge: true,
//     presentSound: true,
//   );
//
//   final notificationDetails = NotificationDetails(
//     android: androidDetails,
//     iOS: iosDetails,
//   );
//
//   await plugin.show(
//     message.messageId.hashCode.abs(),
//     title,
//     body,
//     notificationDetails,
//     payload: jsonEncode(message.data),
//   );
// }
