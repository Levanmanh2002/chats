// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncContactModel _$SyncContactModelFromJson(Map<String, dynamic> json) =>
    SyncContactModel(
      contacts: (json['data'] as List<dynamic>?)
          ?.map((e) => SyncContact.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPage: parseToInt(json['totalPage']),
      totalCount: parseToInt(json['totalCount']),
      page: parseToInt(json['page']),
      size: parseToInt(json['size']),
      lastSyncContacts: json['last_sync_contacts'] as String?,
    );

Map<String, dynamic> _$SyncContactModelToJson(SyncContactModel instance) =>
    <String, dynamic>{
      'data': instance.contacts,
      'totalPage': instance.totalPage,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'size': instance.size,
      'last_sync_contacts': instance.lastSyncContacts,
    };

SyncContact _$SyncContactFromJson(Map<String, dynamic> json) => SyncContact(
      id: (json['id'] as num?)?.toInt(),
      contactName: json['contact_name'] as String?,
      phone: json['phone'] as String?,
      userContact: json['userContact'] == null
          ? null
          : UserModel.fromJson(json['userContact'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$SyncContactToJson(SyncContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contact_name': instance.contactName,
      'phone': instance.phone,
      'userContact': instance.userContact,
      'created_at': instance.createdAt,
    };
