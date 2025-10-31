part of 'logger_service.dart';

/// [Dio] http client logger on [Talker] base
///
/// [talker] filed is current [Talker] instance.
/// Provide your instance if your application used [Talker] as default logger
/// Common Talker instance will be used by default
class CustomDioLogger extends Interceptor {
  final Talker talker;

  /// [CustomDioLogger] settings and customization
  TalkerDioLoggerSettings settings;

  /// Talker addon functionality
  /// addon id for create a lot of addons
  final String? addonId;

  CustomDioLogger({
    required this.talker,
    this.settings = const TalkerDioLoggerSettings(),
    this.addonId,
  });

  /// Method to update [settings] of [CustomDioLogger]
  void configure({
    bool? printResponseData,
    bool? printResponseHeaders,
    bool? printResponseMessage,
    bool? printErrorData,
    bool? printErrorHeaders,
    bool? printErrorMessage,
    bool? printRequestData,
    bool? printRequestHeaders,
    AnsiPen? requestPen,
    AnsiPen? responsePen,
    AnsiPen? errorPen,
  }) {
    settings = settings.copyWith(
      printRequestData: printRequestData,
      printRequestHeaders: printRequestHeaders,
      printResponseData: printResponseData,
      printErrorData: printErrorData,
      printErrorHeaders: printErrorHeaders,
      printErrorMessage: printErrorMessage,
      printResponseHeaders: printResponseHeaders,
      printResponseMessage: printResponseMessage,
      requestPen: requestPen,
      responsePen: responsePen,
      errorPen: errorPen,
    );
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    super.onRequest(options, handler);
    if (!settings.enabled) {
      return;
    }

    final accepted = settings.requestFilter?.call(options) ?? true;
    if (!accepted) {
      return;
    }

    try {
      return talker.logCustom(
        _DioRequestLog(
          message: '${options.uri}',
          requestOptions: options,
          settings: settings,
        ),
      );
    } catch (_) {}
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    if (!settings.enabled) {
      return;
    }

    final accepted = settings.responseFilter?.call(response) ?? true;
    if (!accepted) {
      return;
    }

    if (response.requestOptions.responseType == ResponseType.bytes || response.requestOptions.responseType == ResponseType.stream) {
      return talker.logCustom(
        _DioResponseLog(
          message: '${response.requestOptions.uri}',
          response: response,
          settings: settings.copyWith(
            printResponseData: false,
          ),
        ),
      );
    }

    try {
      return talker.logCustom(
        _DioResponseLog(
          message: '${response.requestOptions.uri}',
          response: response,
          settings: settings,
        ),
      );
    } catch (_) {}
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (!settings.enabled) {
      return;
    }

    final accepted = settings.errorFilter?.call(err) ?? true;
    if (!accepted) {
      return;
    }

    try {
      return talker.logCustom(
        _DioErrorLog(
          message: '${err.requestOptions.uri}',
          dioException: err,
          settings: settings,
        ),
      );
    } catch (_) {}
  }
}

const _encoder = JsonEncoder.withIndent('  ');

class _DioRequestLog extends TalkerLog {
  final RequestOptions requestOptions;
  final TalkerDioLoggerSettings settings;

  _DioRequestLog({
    required String message,
    required this.requestOptions,
    required this.settings,
  }) : super(message);

  static const logKey = 'http_request_key';
  static final logColor = Color(0xFF00D7FF);

  @override
  String get title => 'HTTP';

  @override
  String? get key => logKey;

  @override
  AnsiPen get pen => AnsiPen()..xterm(045);

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer.write('📡 | [$title - Request] | ${displayTime(timeFormat: timeFormat)}');
    buffer.write('\n$displayMessage [${requestOptions.method}]');

    final headers = requestOptions.headers;
    final data = requestOptions.data;

    try {
      if (settings.printRequestHeaders && headers.isNotEmpty) {
        final prettyHeaders = _encoder.convert(headers);
        buffer.write('\nHeaders: $prettyHeaders');
      }

      if (settings.printRequestData && data != null) {
        final prettyData = _encoder.convert(data);
        buffer.write('\nData: $prettyData');
      }
    } catch (_) {}

    return buffer.toString();
  }
}

class _DioResponseLog extends TalkerLog {
  final Response<dynamic> response;
  final TalkerDioLoggerSettings settings;

  _DioResponseLog({
    required String message,
    required this.response,
    required this.settings,
  }) : super(message);

  static const logKey = 'http_response_key';
  static final logColor = Color(0xFF00FF00);

  @override
  String get title => 'HTTP';

  @override
  String? get key => logKey;

  @override
  AnsiPen get pen => AnsiPen()..xterm(046);

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer.write('📡 | [$title - Response] | ${displayTime(timeFormat: timeFormat)}');
    buffer.write('\n$displayMessage [${response.requestOptions.method}]');

    final responseMessage = response.statusMessage;
    final headers = response.headers.map;
    final data = response.data;
    final extra = response.extra;

    buffer.write('\nStatus: ${response.statusCode}');

    if (settings.printResponseMessage && responseMessage != null) {
      buffer.write('\nMessage: $responseMessage');
    }

    try {
      if (settings.printResponseHeaders && headers.isNotEmpty) {
        final prettyHeaders = _encoder.convert(headers);
        buffer.write('\nHeaders: $prettyHeaders');
      }

      if (settings.printResponseData && data != null) {
        final prettyData = _encoder.convert(data);
        buffer.write('\nData: $prettyData');
      }

      if (extra.isNotEmpty) {
        final prettyExtra = _encoder.convert(extra);
        buffer.write('\nExtra: $prettyExtra');
      }
    } catch (_) {}

    return buffer.toString();
  }
}

class _DioErrorLog extends TalkerLog {
  final DioException dioException;
  final TalkerDioLoggerSettings settings;

  _DioErrorLog({
    required String message,
    required this.dioException,
    required this.settings,
  }) : super(message);

  static const logKey = 'http_error_key';
  static final logColor = Color(0xFFFF0000);

  @override
  String get title => 'HTTP';

  @override
  String? get key => logKey;

  @override
  AnsiPen get pen => AnsiPen()..xterm(196);

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final buffer = StringBuffer();
    buffer.write('📡 | [$title - Error] | ${displayTime(timeFormat: timeFormat)}');
    buffer.write('\n$displayMessage [${dioException.requestOptions.method}]');

    final responseMessage = dioException.message;
    final statusCode = dioException.response?.statusCode;
    final data = dioException.response?.data;
    final headers = dioException.response?.headers;

    if (statusCode != null) {
      buffer.write('\nStatus: ${dioException.response?.statusCode}');
    }

    if (settings.printErrorMessage && responseMessage != null) {
      buffer.write('\nMessage: $responseMessage');
    }

    if (settings.printErrorHeaders && !(headers?.isEmpty ?? true)) {
      final prettyHeaders = _encoder.convert(headers!.map);
      buffer.write('\nHeaders: $prettyHeaders');
    }

    if (settings.printErrorData && data != null) {
      final prettyData = _encoder.convert(data);
      buffer.write('\nData: $prettyData');
    }

    return buffer.toString();
  }
}
