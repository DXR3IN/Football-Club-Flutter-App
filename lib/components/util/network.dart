import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_const.dart';

class Network {
  static Dio dioClient([String? url]) {
    BaseOptions options = BaseOptions(
      baseUrl: url ?? AppConst.appUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    );
    final Dio dio = Dio(options);
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestBody: true,
          requestHeader: true,
        ),
      );
    }
    return dio;
  }
}

class UnauthorizedException implements Exception {}
