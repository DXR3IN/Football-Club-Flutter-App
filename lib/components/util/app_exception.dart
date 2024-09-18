import 'package:dio/dio.dart';

import '../api_services/model/response/base_error_response.dart';

class AppException implements Exception {
  final String message;
  AppException({required this.message});

  @override
  String toString() => message;
}

class AppDioException extends DioException {
  final ErrorResponse errorResponse;

  AppDioException({
    required this.errorResponse,
    required super.requestOptions,
  });

  @override
  String toString() => errorResponse.alerts?.message ?? super.toString();
  
}
