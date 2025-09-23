// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesModels _$FilesModelsFromJson(Map<String, dynamic> json) => FilesModels(
      id: (json['id'] as num?)?.toInt(),
      fileUrl: json['file_url'] as String?,
      fileType: json['file_type'] as String?,
      isLocal: json['isLocal'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$FilesModelsToJson(FilesModels instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file_url': instance.fileUrl,
      'file_type': instance.fileType,
      'isLocal': instance.isLocal,
      'created_at': instance.createdAt,
    };
