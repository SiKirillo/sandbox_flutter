part of '../../common.dart';

/// Abstract model of http request model based on [Dio] client
abstract class AbstractRemoteDatasource {
  static final client = Dio(BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  static Future<void> init() async {
    client.interceptors.clear();
    /// Add service data to request
    client.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.method != 'POST') {
            return handler.next(options);
          }

          try {
            final body = <String, dynamic>{
              ...options.data,
              'requestTime': DateTime.now().toString().substring(0, 19),
            };

            options.data = body;
            return handler.next(options);
          } on Exception catch (e) {
            LoggerService.logFailure(e.toString());
          }
        },
      ),
    );

    /// Error handler
    client.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (error, handler) async {
          /// Timeout
          if (error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.sendTimeout || error.type == DioExceptionType.receiveTimeout) {
            return handler.reject(error);
          }

          /// Access token has expired
          if (true) {
            try {
              handler.resolve(await client.fetch(error.requestOptions));
              return handler.next(error);
            } on Exception catch (e) {
              LoggerService.logFailure(e.toString());
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  static String _url() {
    switch (locator<DeviceService>().getBuildModeFromFlavor()) {
      case BuildMode.prod:
        return EnvironmentConstants.prodAPI;

      default:
        return EnvironmentConstants.testAPI;
    }
  }

  Future<dartz.Either<Failure, T>> requestWithTokensHandler<T>({
    required Future<dartz.Either<Failure, T>> Function() onRequest,
  }) async {
    final response = await onRequest();
    return response.fold(
      (failure) async {
        /// If token has expired
        if (true) {
          /// Update auth tokens
          // await onRefreshTokenCallback(onRequest);
        }
        return dartz.Left(failure);
      },
      (result) {
        return dartz.Right(result);
      },
    );
  }

  Future<dartz.Either<Failure, T>> get<T>({
    required String requestURL,
    Map<String, dynamic>? queryParameters,
    String? bearer,
    String? authToken,
    required dartz.Either<Failure, T> Function(Response) onResponse,
  }) async {
    final url = _generateRequestURL(requestURL);
    Response? response;
    try {
      _handleRequest(url, null);
      response = await client.get(
        url,
        queryParameters: queryParameters,
        options: bearer != null || authToken != null
            ? Options(
                headers: {'Authorization': authToken ?? 'Bearer $bearer'},
              )
            : null,
      );
    } on DioException catch (e) {
      return dartz.Left(_handleResponseErrors(url, e.response));
    }

    try {
      final responseData = response.data as Map<String, dynamic>;
      final statusCode = _handleRequestStatusCode(responseData);
      if (response.statusCode == 200 && statusCode == 0) {
        _handleResponse(url, response);
        return onResponse(response);
      } else {
        return dartz.Left(_handleResponseErrors(url, response));
      }
    } catch (e) {
      return dartz.Left(HttpFailure(
        message: 'errors.description.other.unknown'.tr(),
        comment: e.toString(),
      ));
    }
  }

  Future<dartz.Either<Failure, T>> post<T>({
    required String requestURL,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    String? bearer,
    String? authToken,
    required dartz.Either<Failure, T> Function(Response) onResponse,
  }) async {
    final url = _generateRequestURL(requestURL);
    Response? response;

    try {
      _handleRequest(url, body);
      response = await client.post(
        url,
        data: body,
        queryParameters: queryParameters,
        options: bearer != null || authToken != null
            ? Options(
                headers: {'Authorization': authToken ?? 'Bearer $bearer'},
              )
            : null,
      );
    } on DioException catch (e) {
      return dartz.Left(_handleResponseErrors(url, e.response));
    }

    try {
      final responseData = response.data as Map<String, dynamic>;
      final statusCode = _handleRequestStatusCode(responseData);
      if (response.statusCode == 200 && statusCode == 0) {
        _handleResponse(url, response);
        return onResponse(response);
      } else {
        return dartz.Left(_handleResponseErrors(url, response));
      }
    } catch (e) {
      return dartz.Left(HttpFailure(
        message: 'errors.description.other.unknown'.tr(),
        comment: e.toString(),
      ));
    }
  }

  Future<dartz.Either<Failure, T>> put<T>({
    required String requestURL,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    String? bearer,
    String? authToken,
    required dartz.Either<Failure, T> Function(Response) onResponse,
  }) async {
    final url = _generateRequestURL(requestURL);
    Response? response;

    try {
      _handleRequest(url, body);
      response = await client.put(
        url,
        queryParameters: queryParameters,
        data: body,
        options: bearer != null || authToken != null
            ? Options(
                headers: {'Authorization': authToken ?? 'Bearer $bearer'},
              )
            : null,
      );
    } on DioException catch (e) {
      return dartz.Left(_handleResponseErrors(url, e.response));
    }

    try {
      final responseData = response.data as Map<String, dynamic>;
      final statusCode = _handleRequestStatusCode(responseData);
      if (response.statusCode == 200 && statusCode == 0) {
        _handleResponse(url, response);
        return onResponse(response);
      } else {
        return dartz.Left(_handleResponseErrors(url, response));
      }
    } catch (e) {
      return dartz.Left(HttpFailure(
        message: 'errors.description.other.unknown'.tr(),
        comment: e.toString(),
      ));
    }
  }

  Future<dartz.Either<Failure, T>> patch<T>({
    required String requestURL,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    String? bearer,
    String? authToken,
    required dartz.Either<Failure, T> Function(Response) onResponse,
  }) async {
    final url = _generateRequestURL(requestURL);
    Response? response;

    try {
      _handleRequest(url, body);
      response = await client.patch(
        url,
        queryParameters: queryParameters,
        data: body,
        options: bearer != null || authToken != null
            ? Options(
                headers: {'Authorization': authToken ?? 'Bearer $bearer'},
              )
            : null,
      );
    } on DioException catch (e) {
      return dartz.Left(_handleResponseErrors(url, e.response));
    }

    try {
      final responseData = response.data as Map<String, dynamic>;
      final statusCode = _handleRequestStatusCode(responseData);
      if (response.statusCode == 200 && statusCode == 0) {
        _handleResponse(url, response);
        return onResponse(response);
      } else {
        return dartz.Left(_handleResponseErrors(url, response));
      }
    } catch (e) {
      return dartz.Left(HttpFailure(
        message: 'errors.description.other.unknown'.tr(),
        comment: e.toString(),
      ));
    }
  }

  Future<dartz.Either<Failure, T>> delete<T>({
    required String requestURL,
    Map<String, dynamic>? queryParameters,
    String? bearer,
    String? authToken,
    required dartz.Either<Failure, T> Function(Response) onResponse,
  }) async {
    final url = _generateRequestURL(requestURL);
    Response? response;

    try {
      _handleRequest(url, null);
      response = await client.delete(
        url,
        queryParameters: queryParameters,
        options: bearer != null || authToken != null
            ? Options(
                headers: {'Authorization': authToken ?? 'Bearer $bearer'},
              )
            : null,
      );
    } on DioException catch (e) {
      return dartz.Left(_handleResponseErrors(url, e.response));
    }

    try {
      final responseData = response.data as Map<String, dynamic>;
      final statusCode = _handleRequestStatusCode(responseData);
      if (response.statusCode == 200 && statusCode == 0) {
        _handleResponse(url, response);
        return onResponse(response);
      } else {
        return dartz.Left(_handleResponseErrors(url, response));
      }
    } catch (e) {
      return dartz.Left(HttpFailure(
        message: 'errors.description.other.unknown'.tr(),
        comment: e.toString(),
      ));
    }
  }

  static String _generateRequestURL(String requestURL) {
    return '${_url()}$requestURL';
  }

  static int _handleRequestStatusCode(Map<String, dynamic> responseData) {
    if (responseData['status'] != null) {
      return responseData['status'] is int ? responseData['status'] : int.parse(responseData['status']);
    }

    return 0;
  }

  /// This method calls if something in request was wrong
  /// Your project may have a different error structure
  static HttpFailure _handleResponseErrors(String url, Response? response) {
    int? errorCode;
    String? errorDescription;

    try {
      final responseData = response?.data as Map<String, dynamic>;
      errorCode = responseData['status'] is int ? responseData['status'] : int.parse(responseData['status']);
      errorDescription = responseData['statusDescription'];
    } catch (e) {
      LoggerService.logFailure('FAILURE: $url: _handleResponseErrors() ${e.toString()}');
    }

    LoggerService.logFailure('Response status code = $errorCode, description: $errorDescription');
    return HttpFailureExtension.get(errorCode);
  }

  /// Just prints your request in console
  static void _handleRequest(String requestURL, Map<String, dynamic>? body) {
    LoggerService.logInfo('---> HTTP REQUEST: URL: $requestURL');
    if (body != null) {
      LoggerService.logInfo('---> HTTP REQUEST: BODY: ${body.toString()}');
    }
  }

  /// Just prints your response in console
  static void _handleResponse(String requestURL, Response response) {
    LoggerService.logInfo('<--- HTTP RESPONSE: URL: $requestURL');
    if (response.data != null) {
      LoggerService.logInfo('<--- HTTP RESPONSE: DATA: ${response.data.toString()}');
    }
  }
}

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}