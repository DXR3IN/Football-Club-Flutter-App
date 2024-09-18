import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../main.dart';
import 'app_exception.dart';

typedef CommandHandler<TParam, TValue> = FutureOr<TValue> Function(
    TParam? param);
typedef CommandHandlerNoParam = FutureOr Function();
typedef CommandHandlerWithParam<TParam, TValue> = FutureOr<TValue> Function(
    TParam param);

class CommandQuery<TParam, TValue> {
  CommandHandler<TParam, TValue> handler;

  CommandQuery._(this.handler);

  static CommandQuery<TParam, TValue> create<TParam, TValue>(
    CommandHandlerNoParam handler,
  ) {
    return CommandQuery<TParam, TValue>._((_) async {
      return await handler();
    });
  }

  static CommandQuery<TParam, TValue> createWithParam<TParam, TValue>(
    CommandHandlerWithParam<TParam, TValue> handler,
  ) {
    return CommandQuery<TParam, TValue>._((param) async {
      if (param == null) {
        throw ArgumentError("Parameter cannot be null");
      }
      return handler(param);
    });
  }

  final _isExecuting = Observable<bool>(false);
  final _thrownExceptions = Observable<Exception?>(null);
  final _onData = Observable<TValue?>(null);

  bool get isExecuting => _isExecuting.value;
  TValue? get onData => _onData.value;
  Exception? get thrownExceptions => _thrownExceptions.value;
  String get onErrorMessage => _thrownExceptions.value?.toString() ?? '';

  void clearException() {
    _thrownExceptions.value = null;
  }

  Future execute([TParam? param]) async {
    if (_isExecuting.value) {
      return;
    }

    try {
      runInAction(() {
        _isExecuting.value = true;
        clearException();
      });

      final data = await handler(param);
      logger.i("Data >>> $data");
      _onData.value = data;
    } on Exception catch (e) {
      _thrownExceptions.value = e;
      if (e is! AppException && e is! AppDioException) {
        logger.e(e);
      }
    } finally {
      _isExecuting.value = false;
    }
  }
}
