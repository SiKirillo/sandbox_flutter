part of '../common.dart';

/// Abstract model of http request model based on [Dio] client
abstract class AbstractRemoteDatasource {
  static DioTokenEntity? _tokenData;

  static set tokenData(DioTokenEntity? tokenData) {
    _tokenData = tokenData;
  }

  static final client = Dio(BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  ));

  static Future<void> init({
    Future<void> Function()? onRefreshToken,
    Future<void> Function()? onExpiredToken,
  }) async {
    client.interceptors.clear();
    client.interceptors.addAll([
      LoggerService.talkerDio,
      _CustomHttpInterceptor(onRefreshToken: onRefreshToken, onExpiredToken: onExpiredToken),
    ]);
  }

  Future<dartz.Either<Failure, T>> get<T>({
    required String requestUrl,
    ResponseType? responseType,
    String? contentType,
    String? authToken,
    Map<String, dynamic>? header,
    Map<String, dynamic>? query,
    bool showRequestLogs = true,
    bool showResponseLogs = true,
    bool isFullUrl = false,
    required dartz.Either<Failure, T> Function(Response) onResponse,
  }) async {
    return _request(
      method: 'GET',
      requestUrl: requestUrl,
      responseType: responseType,
      contentType: contentType,
      authToken: authToken,
      header: header,
      query: query,
      showRequestLogs: showRequestLogs,
      showResponseLogs: showResponseLogs,
      isFullUrl: isFullUrl,
      body: null,
      onResponse: onResponse,
    );
  }

  Future<dartz.Either<Failure, T>> post<T>({
    required String requestUrl,
    ResponseType? responseType,
    String? contentType,
    String? authToken,
    Map<String, dynamic>? header,
    Map<String, dynamic>? query,
    bool showRequestLogs = true,
    bool showResponseLogs = true,
    bool isFullUrl = false,
    dynamic body,
    required dartz.Either<Failure, T> Function(Response) onResponse,
  }) async {
    return _request(
      method: 'POST',
      requestUrl: requestUrl,
      responseType: responseType,
      contentType: contentType,
      authToken: authToken,
      header: header,
      query: query,
      showRequestLogs: showRequestLogs,
      showResponseLogs: showResponseLogs,
      isFullUrl: isFullUrl,
      body: body,
      onResponse: onResponse,
    );
  }

  Future<dartz.Either<Failure, T>> put<T>({
    required String requestUrl,
    ResponseType? responseType,
    String? contentType,
    String? authToken,
    Map<String, dynamic>? header,
    Map<String, dynamic>? query,
    bool showRequestLogs = true,
    bool showResponseLogs = true,
    bool isFullUrl = false,
    dynamic body,
    required dartz.Either<Failure, T> Function(Response) onResponse,
  }) async {
    return _request(
      method: 'PUT',
      requestUrl: requestUrl,
      responseType: responseType,
      contentType: contentType,
      authToken: authToken,
      header: header,
      query: query,
      showRequestLogs: showRequestLogs,
      showResponseLogs: showResponseLogs,
      isFullUrl: isFullUrl,
      body: body,
      onResponse: onResponse,
    );
  }

  Future<dartz.Either<Failure, T>> patch<T>({
    required String requestUrl,
    ResponseType? responseType,
    String? contentType,
    String? authToken,
    Map<String, dynamic>? header,
    Map<String, dynamic>? query,
    bool showRequestLogs = true,
    bool showResponseLogs = true,
    bool isFullUrl = false,
    dynamic body,
    required dartz.Either<Failure, T> Function(Response) onResponse,
  }) async {
    return _request(
      method: 'PATCH',
      requestUrl: requestUrl,
      responseType: responseType,
      contentType: contentType,
      authToken: authToken,
      header: header,
      query: query,
      showRequestLogs: showRequestLogs,
      showResponseLogs: showResponseLogs,
      isFullUrl: isFullUrl,
      body: body,
      onResponse: onResponse,
    );
  }

  Future<dartz.Either<Failure, T>> delete<T>({
    required String requestUrl,
    ResponseType? responseType,
    String? contentType,
    String? authToken,
    Map<String, dynamic>? header,
    Map<String, dynamic>? query,
    bool showRequestLogs = true,
    bool showResponseLogs = true,
    bool isFullUrl = false,
    dynamic body,
    required dartz.Either<Failure, T> Function(Response) onResponse,
  }) async {
    return _request(
      method: 'DELETE',
      requestUrl: requestUrl,
      responseType: responseType,
      contentType: contentType,
      authToken: authToken,
      header: header,
      query: query,
      showRequestLogs: showRequestLogs,
      showResponseLogs: showResponseLogs,
      isFullUrl: isFullUrl,
      body: body,
      onResponse: onResponse,
    );
  }

  Future<dartz.Either<Failure, T>> _request<T>({
    required String method,
    required String requestUrl,
    ResponseType? responseType,
    String? contentType,
    String? authToken,
    Map<String, dynamic>? header,
    Map<String, dynamic>? query,
    bool showRequestLogs = true,
    bool showResponseLogs = true,
    bool isFullUrl = false,
    dynamic body,
    required dartz.Either<Failure, T> Function(Response) onResponse,
  }) async {
    final url = isFullUrl ? requestUrl : requestUrl;
    if (showRequestLogs == false) {
      LoggerService.addPathToIgnoreRequestLogs(url);
    }

    if (showResponseLogs == false) {
      LoggerService.addPathToIgnoreResponseLogs(url);
    }

    Response? response;
    final options = Options(
      method: method,
      responseType: responseType,
      contentType: contentType,
      headers: {
        ...?header,
        if (authToken != null)
          'Authorization': 'Bearer $authToken',
      },
    );

    try {
      response = await client.request(
        url,
        data: body,
        queryParameters: query,
        options: options,
      );
    } on DioException catch (e) {
      return dartz.Left(_handleResponseErrors(requestUrl, method, e.response, e.type));
    }

    try {
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! <= 299) {
        return onResponse(response);
      } else {
        return dartz.Left(_handleResponseErrors(requestUrl, method, response, null));
      }
    } on Exception catch (e) {
      return dartz.Left(HttpFailure(
        message: 'errors.description.other.unknown'.tr(),
        comment: e.toString(),
      ));
    }
  }

  /// This method calls if something in request was wrong
  /// Your project may have a different error structure
  static Failure _handleResponseErrors(
    String requestUrl,
    String requestMethod,
    Response? response,
    DioExceptionType? errorType,
  ) {
    final statusCode = response?.statusCode;
    String? errorCode;
    String? errorMessage;

    if (errorType == DioExceptionType.connectionTimeout ||
        errorType == DioExceptionType.sendTimeout ||
        errorType == DioExceptionType.receiveTimeout) {
      return HttpFailure(message: 'errors.http.server_errors.504'.tr());
    }

    try {
      if (response?.data is Map<String, dynamic>) {
        errorCode = response?.data['errorCode'];
        errorMessage = response?.data['errorMessage'];
      }

      if (response?.data is String) {
        errorCode = null;
        errorMessage = response?.data;
      }
    } on Exception catch (e) {
      return CommonFailure(message: e.toString());
    }

    return HttpFailure.get(
      requestUrl: requestUrl,
      requestMethod: requestMethod,
      statusCode: statusCode,
      errorCode: errorCode,
      errorMessage: errorMessage,
    );
  }
}

class _CustomInterceptorEntity {
  final DioException error;
  final ErrorInterceptorHandler handler;

  const _CustomInterceptorEntity({
    required this.error,
    required this.handler,
  });
}

class _CustomHttpInterceptor extends Interceptor {
  final Future<void> Function()? onRefreshToken;
  final Future<void> Function()? onExpiredToken;

  _CustomHttpInterceptor({
    this.onRefreshToken,
    this.onExpiredToken,
  });

  final _requestsNeedRetry = <_CustomInterceptorEntity>[];
  bool _isRefreshing = false;
  bool _isBackendProcessing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    /// Add service data to request
    if (AbstractRemoteDatasource._tokenData != null && options.path != '/api/auth/refresh') {
      options.headers['Authorization'] = 'Bearer ${AbstractRemoteDatasource._tokenData?.token}';
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    /// Timeout
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return handler.reject(error);
    }

    /// Access token has expired & refresh token has revoked
    if (error.response?.statusCode == 400 && error.requestOptions.path == '/api/auth/refresh' && locator<AppBloc>().state.status == AppStatus.loggedIn) {
      locator<InAppOverlayProvider>().hide();
      if (onExpiredToken != null) {
        await onExpiredToken!();
      }

      _requestsNeedRetry.clear();
      _isRefreshing = false;
      return handler.reject(error);
    }

    /// Access token has expired
    if (error.response?.statusCode == 401 && error.requestOptions.path != '/api/user/validation') {
      try {
        if (_isRefreshing) {
          _requestsNeedRetry.add(_CustomInterceptorEntity(error: error, handler: handler));
          return;
        }

        _requestsNeedRetry.clear();
        _requestsNeedRetry.add(_CustomInterceptorEntity(error: error, handler: handler));

        _isRefreshing = true;
        if (onRefreshToken != null) {
          await onRefreshToken!();
        }

        await Future.delayed(OtherConstants.defaultDelayDuration);
        _isRefreshing = false;

        /// Repeat the request with the updated token
        for (final retry in _requestsNeedRetry) {
          retry.error.requestOptions.headers['Authorization'] = 'Bearer ${AbstractRemoteDatasource._tokenData?.token}';
          /// Reconstruct FormData for retry
          if (retry.error.requestOptions.data is FormData) {
            final currentFormData = retry.error.requestOptions.data as FormData;
            final updatedFormData = FormData();
            updatedFormData.fields.addAll(currentFormData.fields);
            for (final entry in currentFormData.files) {
              updatedFormData.files.add(MapEntry(entry.key, entry.value.clone()));
            }
            retry.error.requestOptions.data = updatedFormData;
          }

          try {
            retry.handler.resolve(await AbstractRemoteDatasource.client.fetch(retry.error.requestOptions));
          } catch (e) {
            LoggerService.logError('Retry requests failure', exception: e);
            if (e is DioException && e.response?.statusCode != 401) {
              return handler.next(e);
            }
          }
        }
      } on Exception catch (e) {
        LoggerService.logError('Access token has expired', exception: e);
      }
    }

    /// Backend error
    if (error.response?.statusCode != null && error.response!.statusCode! >= 500 && error.response!.statusCode! < 600) {
      try {
        if (_isBackendProcessing) {
          return;
        }

        _isBackendProcessing = true;
        locator<InAppOverlayProvider>().hide();
        locator<InAppNotificationProvider>().addNotification(InAppNotificationData.warning(
          message: 'notifications.other.backend_error'.tr(),
        ));

        _isBackendProcessing = false;
        return handler.reject(error);
      } on Exception catch (e) {
        LoggerService.logError('Backend error', exception: e);
      }
    }

    if (handler.isCompleted) {
      return;
    } else {
      return handler.next(error);
    }
  }
}

class DioTokenEntity {
  final String token;
  final String? refreshToken;

  const DioTokenEntity({
    required this.token,
    required this.refreshToken,
  });
}

/// Use to ignore bad certificate failure
class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
