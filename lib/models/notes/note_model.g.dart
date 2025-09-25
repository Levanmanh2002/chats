// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModels _$NoteModelsFromJson(Map<String, dynamic> json) => NoteModels(
      notes: (json['notes'] as List<dynamic>?)
          ?.map((e) => NoteItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPage: parseToInt(json['totalPage']),
      totalCount: parseToInt(json['totalCount']),
      page: parseToInt(json['page']),
      size: parseToInt(json['size']),
    );

Map<String, dynamic> _$NoteModelsToJson(NoteModels instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'totalPage': instance.totalPage,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'size': instance.size,
    };

NoteItem _$NoteItemFromJson(Map<String, dynamic> json) => NoteItem(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      reminderAt: json['reminder_at'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] == null
          ? null
          : NoteCategoryModel.fromJson(
              json['category'] as Map<String, dynamic>),
      startDate: json['start_date'] as String? ?? '',
      noteStatus: json['status'] == null
          ? null
          : NoteStatus.fromJson(json['status'] as Map<String, dynamic>),
      endDate: json['end_date'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );

Map<String, dynamic> _$NoteItemToJson(NoteItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'reminder_at': instance.reminderAt,
      'description': instance.description,
      'category': instance.category,
      'start_date': instance.startDate,
      'status': instance.noteStatus,
      'end_date': instance.endDate,
      'created_at': instance.createdAt,
    };

NoteStatus _$NoteStatusFromJson(Map<String, dynamic> json) => NoteStatus(
      key: json['key'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$NoteStatusToJson(NoteStatus instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
    };
