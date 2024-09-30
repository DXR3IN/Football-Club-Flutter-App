// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      notificationId: json['notificationId'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      isRead: json['isRead'] as bool?,
      type: json['type'],
      normalizedType: json['normalizedType'] as String?,
      topic: (json['topic'] as num?)?.toInt(),
      redirectTo: json['redirectTo'] as String?,
      readAt: json['readAt'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'title': instance.title,
      'content': instance.content,
      'isRead': instance.isRead,
      'type': instance.type,
      'normalizedType': instance.normalizedType,
      'topic': instance.topic,
      'redirectTo': instance.redirectTo,
      'readAt': instance.readAt,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
