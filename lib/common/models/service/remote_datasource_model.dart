import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dartz/dartz.dart';

import '../../../features/authentication/domain/bloc/auth_bloc.dart';
import '../../../features/authentication/domain/datasources/auth_secure_storage.dart';
import '../../../features/authentication/domain/usecases/auth_refresh_tokens.dart';
import '../../../features/authentication/domain/usecases/auth_sign_out.dart';
import '../../../injection_container.dart';
import '../../providers/charles_provider.dart';
import '../../services/device_service.dart';
import '../../services/logger_service.dart';
import '../../../constants/failures.dart';
import 'failure_model.dart';
import 'usecase_model.dart';

/// Abstract model of http request model based on [Dio] client
abstract class AbstractRemoteDatasource {
  static final _servicesWithoutToken = <String>[
    "${_url()}/auth/no_token",
  ];

  static Dio _client() {
    final client = Dio(BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    /// If you want to use interceptors
    // client.interceptors.clear();
    // client.interceptors.add(
    //   QueuedInterceptorsWrapper(
    //     onRequest: (options, handler) async {
    //       /// Add the access token to the request header
    //       final tokensData = locator<AuthBloc>().state.tokensData ?? await locator<AuthSecureStorage>().readTokensData();
    //       if (tokensData == null) {
    //         return handler.next(options);
    //       }
    //
    //       if (options.path == "${_url()}/auth/refresh-token") {
    //         options.headers['Authorization'] = 'Bearer ${tokensData.refreshToken}';
    //       } else {
    //         options.headers['Authorization'] = 'Bearer ${tokensData.accessToken}';
    //       }
    //
    //       return handler.next(options);
    //     },
    //     onError: (error, handler) async {
    //       if (error.requestOptions.path == "${_url()}/auth/refresh-token") {
    //         await locator<AuthSignOut>().call(NoParams());
    //         return handler.reject(error);
    //       } else if (error.response?.statusCode == 401 && !_servicesWithoutToken.contains(error.requestOptions.path)) {
    //         /// If a 401 response is received, refresh the access token
    //         await locator<AuthRefreshTokens>().call(null);
    //
    //         /// Update the request header with the new access token
    //         await Future.delayed(const Duration(milliseconds: 100));
    //         final tokensData = locator<AuthBloc>().state.tokensData ?? await locator<AuthSecureStorage>().readTokensData();
    //         if (tokensData?.accessToken != null) {
    //           error.requestOptions.headers['Authorization'] = 'Bearer ${tokensData?.accessToken}';
    //         }
    //
    //         /// Repeat the request with the updated header
    //         return handler.resolve(await client.fetch(error.requestOptions));
    //       }
    //
    //       return handler.next(error);
    //     },
    //   ),
    // );

    /// If you want to enable Charles Proxy:
    /// You can set constant true value to listen http requests or add switch button somewhere in the app
    /// By default you must run/build app for debug and activate switch button
    if (locator<DeviceService>().currentBuildMode() == BuildMode.dev) {
      if (locator<CharlesProvider>().isEnabled) {
        (client.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
          client.findProxy = (uri) => locator<DeviceService>().isPhysicalDevice ? 'PROXY ${locator<CharlesProvider>().proxyIP};' : 'DIRECT';
          client.badCertificateCallback = (cert, host, port) => Platform.isAndroid;
          return client;
        };
      }
    }

    return client;
  }

  static String _url() {
    switch (locator<DeviceService>().currentBuildMode()) {
      case BuildMode.prod:
        return 'https://www.google.com/';

      default:
        return 'https://www.google.com/';
    }
  }

  Future<Either<Failure, T>> requestWithAuthTokensHandler<T>({
    required Future<Either<Failure, T>> Function(dynamic tokensData) onRequest,
  }) async {
    final response = await onRequest(null);
    return response.fold(
      (failure) async {
        if (failure is HTTPFailure && failure.type == HttpErrorType.badAuthTokens) {
          /// Update auth tokens
          // final refreshResponse = await locator<AuthRefreshTokens>().call(NoParams());
          // return refreshResponse.fold(
          //   (failure) {
          //     return Left(failure);
          //   },
          //   (result) async {
          //     return await onRequest(result);
          //   },
          // );
        }
        return Left(failure);
      },
      (result) {
        return Right(result);
      },
    );
  }

  Future<Either<Failure, T>> get<T>({
    required String requestURL,
    Map<String, dynamic>? queryParameters,
    String? bearer,
    String? authToken,
    required Either<Failure, T> Function(Response) onResponse,
  }) async {
    final url = _generateRequestURL(requestURL);
    Response? response;
    try {
      _handleRequest(url, null);
      response = await _client().get(
        url,
        queryParameters: queryParameters,
        options: bearer != null || authToken != null
            ? Options(
                headers: {'Authorization': authToken ?? 'Bearer $bearer'},
              )
            : null,
      );
    } on DioException catch (e) {
      return Left(_handleResponseErrors(requestURL, e));
    }

    try {
      return onResponse(response);
    } catch (exception) {
      return Left(HTTPFailure(
        message: 'Response failure',
        comment: exception.toString(),
      ));
    }
  }

  Future<Either<Failure, T>> post<T>({
    required String requestURL,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    String? bearer,
    String? authToken,
    required Either<Failure, T> Function(Response) onResponse,
  }) async {
    final url = _generateRequestURL(requestURL);
    Response? response;

    try {
      _handleRequest(url, body);
      response = await _client().post(
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
      return Left(_handleResponseErrors(requestURL, e));
    }

    try {
      return onResponse(response);
    } catch (exception) {
      return Left(HTTPFailure(
        message: 'Response failure',
        comment: exception.toString(),
      ));
    }
  }

  Future<Either<Failure, T>> put<T>({
    required String requestURL,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    String? bearer,
    String? authToken,
    required Either<Failure, T> Function(Response) onResponse,
  }) async {
    final url = _generateRequestURL(requestURL);
    Response? response;

    try {
      _handleRequest(url, body);
      response = await _client().put(
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
      return Left(_handleResponseErrors(requestURL, e));
    }

    try {
      return onResponse(response);
    } catch (exception) {
      return Left(HTTPFailure(
        message: 'Response failure',
        comment: exception.toString(),
      ));
    }
  }

  Future<Either<Failure, T>> patch<T>({
    required String requestURL,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    String? bearer,
    String? authToken,
    required Either<Failure, T> Function(Response) onResponse,
  }) async {
    final url = _generateRequestURL(requestURL);
    Response? response;

    try {
      _handleRequest(url, body);
      response = await _client().patch(
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
      return Left(_handleResponseErrors(requestURL, e));
    }

    try {
      return onResponse(response);
    } catch (exception) {
      return Left(HTTPFailure(
        message: 'Response failure',
        comment: exception.toString(),
      ));
    }
  }

  Future<Either<Failure, T>> delete<T>({
    required String requestURL,
    Map<String, dynamic>? queryParameters,
    String? bearer,
    String? authToken,
    required Either<Failure, T> Function(Response) onResponse,
  }) async {
    final url = _generateRequestURL(requestURL);
    Response? response;

    try {
      _handleRequest(url, null);
      response = await _client().delete(
        url,
        queryParameters: queryParameters,
        options: bearer != null || authToken != null
            ? Options(
                headers: {'Authorization': authToken ?? 'Bearer $bearer'},
              )
            : null,
      );
    } on DioException catch (e) {
      return Left(_handleResponseErrors(requestURL, e));
    }

    try {
      return onResponse(response);
    } catch (exception) {
      return Left(HTTPFailure(
        message: 'Response failure',
        comment: exception.toString(),
      ));
    }
  }

  static String _generateRequestURL(String requestURL) {
    return '${_url()}$requestURL';
  }

  /// This method calls if something in request was wrong
  /// Your project may have a different error structure
  static HTTPFailure _handleResponseErrors(String url, DioException exception) {
    int? errorCode;
    String? errorType;
    String? errorMessage;

    try {
      errorCode = exception.response?.statusCode;
      errorType = exception.response?.statusMessage;
      errorMessage = exception.response?.data['detail'] ?? exception.message;
    } catch (exception) {
      LoggerService.logDebug('FAILURE: $url: _handleResponseErrors() ${exception.toString()}');
    }

    LoggerService.logDebug('Response status code = $errorCode, type: $errorType, message: $errorMessage');
    return HttpErrorExtension.getErrorByCode(errorCode, errorMessage);
  }

  /// Just prints your request in console
  static void _handleRequest(String requestURL, Map<String, dynamic>? body) {
    LoggerService.logDebug('---> HTTP REQUEST:');
    LoggerService.logDebug(requestURL);
    if (body != null) {
      LoggerService.logDebug(body.toString());
    }
  }
}
