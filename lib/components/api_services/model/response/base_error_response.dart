class ErrorResponse {
  final bool? error;
  final Alerts? alerts;
  final dynamic data;

  ErrorResponse({this.error, this.alerts, this.data});

  ErrorResponse copyWith({bool? error, Alerts? alerts, dynamic data}) =>
      ErrorResponse(
          error: error ?? this.error,
          alerts: alerts ?? this.alerts,
          data: data ?? this.data);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
      error: json['error'],
      alerts: json['alerts'] == null ? null : Alerts.fromJson(json['alerts']),
      data: json['data']);

  Map<String, dynamic> toJson() => {
        "error": error,
        "alerts": alerts?.toJson()
      };
}

class Alerts {
  final String? code;
  final String? message;

  int get codeInt => int.tryParse(code ?? '') ?? -1;

  Alerts({
    this.code,
    this.message,
  });

  Alerts copyWith({
    String? code,
    String? message,
  }) =>
      Alerts(
        code: code ?? this.code,
        message: message ?? this.message,
      );

  factory Alerts.fromJson(Map<String, dynamic> json) => Alerts(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
