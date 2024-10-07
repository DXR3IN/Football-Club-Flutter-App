import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../util/command_query.dart';

typedef AppWidgetErrorBuilder = Widget Function(String message);
typedef AppWidgetExceptionBuilder = Widget Function(Exception e);
typedef AppWidgetDataBuilder = Widget Function(dynamic data);
typedef AppWidgetOnLoadBuilder = Widget Function();

class AppObserverBuilder extends StatelessWidget {
  const AppObserverBuilder({
    super.key,
    required this.commandQuery,
    this.child,
    this.onLoading,
    this.onError,
    this.onException,
  });

  final CommandQuery commandQuery;
  final AppWidgetDataBuilder? child;
  final AppWidgetOnLoadBuilder? onLoading;
  final AppWidgetErrorBuilder? onError;
  final AppWidgetExceptionBuilder? onException;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (commandQuery.isExecuting) {
          debugPrint("CommandQuery is executing...");
          return onLoading?.call() ??
              const Center(
                child: CircularProgressIndicator(),
              );
        }

        if (commandQuery.thrownExceptions != null) {
          debugPrint("Exception encountered: ${commandQuery.thrownExceptions}");
          return onException?.call(commandQuery.thrownExceptions!) ??
              const Center(child: Text('An error occurred.'));
        }

        if (commandQuery.onErrorMessage.isNotEmpty) {
          debugPrint("Error message: ${commandQuery.onErrorMessage}");
          return onError?.call(commandQuery.onErrorMessage) ??
              const Center(child: Text('An error occurred.'));
        }

        if (commandQuery.onData == null) {
          debugPrint("No data available.");
          return const Center(child: Text('No data available.'));
        }

        return child?.call(commandQuery.onData) ?? const SizedBox();
      },
    );
  }
}
