// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tickers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TickersModel _$TickersModelFromJson(Map<String, dynamic> json) => TickersModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$TickersModelToJson(TickersModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
    };
