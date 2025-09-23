// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaFileModel _$MediaFileModelFromJson(Map<String, dynamic> json) =>
    MediaFileModel(
      items: (json['data'] as List<dynamic>?)
          ?.map((e) => FilesModels.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPage: parseToInt(json['totalPage']),
      totalCount: parseToInt(json['totalCount']),
      page: parseToInt(json['page']),
      size: parseToInt(json['size']),
    );

Map<String, dynamic> _$MediaFileModelToJson(MediaFileModel instance) =>
    <String, dynamic>{
      'data': instance.items,
      'totalPage': instance.totalPage,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'size': instance.size,
    };
