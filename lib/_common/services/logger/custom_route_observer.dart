part of 'logger_service.dart';

/// Logging NavigatorObserver working on [Talker] base
/// This observer displays which routes were opened and closed in the application
class CustomRouteObserver extends NavigatorObserver {
  final Talker talker;

  CustomRouteObserver({required this.talker});

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == null) {
      return;
    }
    talker.logCustom(_TalkerRouteLog(route: route));
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name == null) {
      return;
    }
    talker.logCustom(_TalkerRouteLog(route: route, isPush: false));
  }
}

class _TalkerRouteLog extends TalkerLog {
  _TalkerRouteLog({
    required Route route,
    bool isPush = true,
  }) : super(_createMessage(route, isPush));

  static const logKey = 'route_key';
  static final logColor = Color(0xFFAf5FFF);

  @override
  String get title => 'Route';

  @override
  String? get key => logKey;

  @override
  AnsiPen get pen => AnsiPen()..xterm(135);

  static String _createMessage(
    Route<dynamic> route,
    bool isPush,
  ) {
    final buffer = StringBuffer();
    buffer.write('${isPush ? 'Open' : 'Close'} route named ');
    buffer.write('"${route.settings.name ?? 'null'}"');

    final args = route.settings.arguments;
    if (args != null) {
      buffer.write('\nArguments: $args');
    }

    return buffer.toString();
  }

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer.write('🌌 | [$title] | ${displayTime(timeFormat: timeFormat)}');
    buffer.write('\n$displayMessage');
    return buffer.toString();
  }
}
