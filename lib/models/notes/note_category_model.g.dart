// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteCategoryModel _$NoteCategoryModelFromJson(Map<String, dynamic> json) =>
    NoteCategoryModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String? ?? '',
      color: json['color'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );

Map<String, dynamic> _$NoteCategoryModelToJson(NoteCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'description': instance.description,
      'created_at': instance.createdAt,
    };
