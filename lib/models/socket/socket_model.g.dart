// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketModel<T> _$SocketModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    SocketModel<T>(
      title: json['title'] as String?,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$SocketModelToJson<T>(
  SocketModel<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'title': instance.title,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'type': instance.type,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
