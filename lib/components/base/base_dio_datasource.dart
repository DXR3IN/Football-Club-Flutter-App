import 'package:dio/dio.dart';

import '../config/app_const.dart';

class BaseDioDataSource {
  final Dio _client;
  final _cancelToken = CancelToken();
  final _baseUrl = AppConst.appUrl;

  BaseDioDataSource(this._client);


  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options, ProgressCallback? onReceiveProgress}) {
    return _client.get(_baseUrl+path, queryParameters: queryParameters, options: options, cancelToken: _cancelToken, onReceiveProgress: onReceiveProgress);
  }


  Future<Response<T>> post<T>(String path, {data, Map<String, dynamic>? queryParameters, Options? options, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress}) {

    return _client.post(_baseUrl+path, data: data, queryParameters: queryParameters, options: options, cancelToken: _cancelToken, onSendProgress : onSendProgress, onReceiveProgress : onReceiveProgress);
  }


  Future<Response<T>> put<T>(String path, {data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress}) {
    return _client.put(_baseUrl+path, data: data, queryParameters: queryParameters, options: options, cancelToken:_cancelToken, onSendProgress : onSendProgress, onReceiveProgress : onReceiveProgress);
  }


  Future<Response<T>> delete<T>(String path, {data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) {
    return _client.delete(_baseUrl+path, data:data, queryParameters: queryParameters, options: options, cancelToken: _cancelToken);
  }


  void close({bool force = false}) {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }

}