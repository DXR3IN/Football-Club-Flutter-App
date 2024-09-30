import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String? notificationId;
  final String? title;
  final String? content;
  final bool? isRead;
  final dynamic type;
  final String? normalizedType;
  final int? topic;
  final String? redirectTo;
  final String? readAt;
  final DateTime? createdAt;

  NotificationModel({
    this.notificationId,
    this.title,
    this.content,
    this.isRead,
    this.type,
    this.normalizedType,
    this.topic,
    this.redirectTo,
    this.readAt,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
