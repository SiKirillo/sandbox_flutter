part of 'logger_service.dart';

/// [BLoC] logger on [Talker] base
///
/// [talker] field is the current [Talker] instance.
/// Provide your instance if your application uses [Talker] as the default logger
/// Common Talker instance will be used by default
class CustomBlocObserver extends BlocObserver {
  final Talker talker;
  final TalkerBlocLoggerSettings settings;

  CustomBlocObserver({
    required this.talker,
    this.settings = const TalkerBlocLoggerSettings(),
  });

  @override
  @mustCallSuper
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (!settings.enabled || !settings.printEvents) {
      return;
    }

    final accepted = settings.eventFilter?.call(bloc, event) ?? true;
    if (!accepted) {
      return;
    }

    talker.logCustom(
      _BlocEventLog(
        bloc: bloc,
        event: event,
        settings: settings,
      ),
    );
  }

  @override
  @mustCallSuper
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (!settings.enabled || !settings.printTransitions) {
      return;
    }

    final accepted = settings.transitionFilter?.call(bloc, transition) ?? true;
    if (!accepted) {
      return;
    }

    talker.logCustom(_BlocStateLog(
      bloc: bloc,
      transition: transition,
      settings: settings,
    ));
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (!settings.enabled || !settings.printChanges) {
      return;
    }

    talker.logCustom(
      _BlocChangeLog(
        bloc: bloc,
        change: change,
        settings: settings,
      ),
    );
  }

  @override
  @mustCallSuper
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    talker.logCustom(
      _BlocErrorLog(
        bloc: bloc,
        message: '${bloc.runtimeType}',
        exception: error,
        stackTrace: stackTrace,
      ),
    );
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (!settings.enabled || !settings.printCreations) {
      return;
    }

    talker.logCustom(_BlocCreateLog(bloc: bloc));
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (!settings.enabled || !settings.printClosings) {
      return;
    }

    talker.logCustom(_BlocCloseLog(bloc: bloc));
  }
}

/// [Bloc] event log model
class _BlocEventLog extends TalkerLog {
  final Bloc bloc;
  final Object? event;
  final TalkerBlocLoggerSettings settings;

  _BlocEventLog({
    required this.bloc,
    required this.event,
    required this.settings,
  }) : super('${bloc.runtimeType} -> onEvent(): ${event.runtimeType}');

  static const logKey = 'bloc_event_key';
  static final logColor = Color(0xFF5F5FD7);

  @override
  String get title => 'Bloc';

  @override
  String? get key => logKey;

  @override
  AnsiPen get pen => AnsiPen()..xterm(062);

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer.write('📘 | [$title - Event] | ${displayTime(timeFormat: timeFormat)}');
    buffer.write('\n$displayMessage');
    return buffer.toString();
  }
}

/// [Bloc] state transition log model
class _BlocStateLog extends TalkerLog {
  final Bloc bloc;
  final Transition transition;
  final TalkerBlocLoggerSettings settings;

  _BlocStateLog({
    required this.bloc,
    required this.transition,
    required this.settings,
  }) : super('${bloc.runtimeType} -> onTransition(): ${transition.event.runtimeType}');

  static const logKey = 'bloc_transition_key';
  static final logColor = Color(0xFF5F5FD7);

  @override
  String get title => 'Bloc';

  @override
  String? get key => logKey;

  @override
  AnsiPen get pen => AnsiPen()..xterm(062);

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer.write('📘 | [$title - Transition] | ${displayTime(timeFormat: timeFormat)}');
    buffer.write('\n$displayMessage');
    buffer.write('\n${'Current state: ${settings.printStateFullData ? '\n${transition.currentState}' : transition.currentState.runtimeType}'}');
    buffer.write('\n${'Next state: ${settings.printStateFullData ? '\n${transition.nextState}' : transition.nextState.runtimeType}'}');
    return buffer.toString();
  }
}

/// [Bloc] state changed log model
class _BlocChangeLog extends TalkerLog {
  final BlocBase bloc;
  final Change change;
  final TalkerBlocLoggerSettings settings;

  _BlocChangeLog({
    required this.bloc,
    required this.change,
    required this.settings,
  }) : super('${bloc.runtimeType} -> changed()');

  static const logKey = 'bloc_changed_key';
  static final logColor = Color(0xFF5F5FD7);

  @override
  String get title => 'Bloc';

  @override
  String? get key => logKey;

  @override
  AnsiPen get pen => AnsiPen()..xterm(062);

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer.write('📘 | [$title - Change] | ${displayTime(timeFormat: timeFormat)}');
    buffer.write('\n$displayMessage');
    buffer.write('\n${'Current state: ${settings.printStateFullData ? '\n${change.currentState}' : change.currentState.runtimeType}'}');
    buffer.write('\n${'Next state: ${settings.printStateFullData ? '\n${change.nextState}' : change.nextState.runtimeType}'}');
    return buffer.toString();
  }
}

/// [Bloc] error log model
class _BlocErrorLog extends TalkerLog {
  final BlocBase bloc;

  _BlocErrorLog({
    required this.bloc,
    required String message,
    Object? exception,
    StackTrace? stackTrace,
  }) : super('${bloc.runtimeType} -> onError(): $message', exception: exception, stackTrace: stackTrace);

  static const logKey = 'bloc_error_key';
  static final logColor = Color(0xFFFF0000);

  @override
  String get title => 'Bloc';

  @override
  String? get key => logKey;

  @override
  AnsiPen get pen => AnsiPen()..xterm(196);

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer.write('⛔ | [$title - Error] | ${displayTime(timeFormat: timeFormat)}');
    buffer.write('\n$displayMessage$displayException');

    if (stackTrace != null) {
      buffer.write('\n${List.generate(109, (i) => '-').join()}');
      buffer.write('\n${LoggerService._formatStackTrace(stackTrace, 10).toString()}');
    }

    return buffer.toString();
  }
}

/// [Bloc] created log model
class _BlocCreateLog extends TalkerLog {
  final BlocBase bloc;

  _BlocCreateLog({
    required this.bloc,
  }) : super('${bloc.runtimeType} -> created()');

  static const logKey = 'bloc_create_key';
  static final logColor = Color(0xFF5F5FD7);

  @override
  String get title => 'Bloc';

  @override
  String? get key => logKey;

  @override
  AnsiPen get pen => AnsiPen()..xterm(062);

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer.write('📘 | [$title - Create] | ${displayTime(timeFormat: timeFormat)}');
    buffer.write('\n$displayMessage');
    return buffer.toString();
  }
}

/// [Bloc] closed log model
class _BlocCloseLog extends TalkerLog {
  final BlocBase bloc;

  _BlocCloseLog({
    required this.bloc,
  }) : super('${bloc.runtimeType} -> closed()');

  static const logKey = 'bloc_close_key';
  static final logColor = Color(0xFF5F5FD7);

  @override
  String get title => 'Bloc';

  @override
  String? get key => logKey;

  @override
  AnsiPen get pen => AnsiPen()..xterm(062);

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer.write('📘 | [$title - Close] | ${displayTime(timeFormat: timeFormat)}');
    buffer.write('\n$displayMessage');
    return buffer.toString();
  }
}
