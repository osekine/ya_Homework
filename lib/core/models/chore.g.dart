// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chore _$ChoreFromJson(Map<String, dynamic> json) => Chore(
      name: json['text'] as String,
      deadlineInMs: (json['deadline'] as num?)?.toInt(),
      isDone: json['done'] as bool? ?? false,
      priority: $enumDecodeNullable(_$PriorityEnumMap, json['importance']) ??
          Priority.none,
      id: json['id'] as String?,
      chagedAt: (json['changed_at'] as num?)?.toInt(),
      createdAt: (json['created_at'] as num?)?.toInt(),
      deviceId: json['last_updated_by'] as String?,
    );

Map<String, dynamic> _$ChoreToJson(Chore instance) => <String, dynamic>{
      'text': instance.name,
      'deadline': instance.deadlineInMs,
      'done': instance.isDone,
      'importance': _$PriorityEnumMap[instance.priority]!,
      'created_at': instance.createdAt,
      'changed_at': instance.chagedAt,
      'id': instance.id,
      'last_updated_by': instance.deviceId,
    };

const _$PriorityEnumMap = {
  Priority.none: 'basic',
  Priority.low: 'low',
  Priority.high: 'important',
};
