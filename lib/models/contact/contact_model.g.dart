// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModelData _$ContactModelDataFromJson(Map<String, dynamic> json) =>
    ContactModelData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ContactModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPage: parseToInt(json['totalPage']),
      totalCount: parseToInt(json['totalCount']),
      page: parseToInt(json['page']),
      size: parseToInt(json['size']),
    );

Map<String, dynamic> _$ContactModelDataToJson(ContactModelData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalPage': instance.totalPage,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'size': instance.size,
    };

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) => ContactModel(
      id: (json['id'] as num?)?.toInt(),
      status: json['status'] as String?,
      friend: json['friend'] == null
          ? null
          : UserModel.fromJson(json['friend'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'friend': instance.friend,
      'created_at': instance.createdAt,
    };
