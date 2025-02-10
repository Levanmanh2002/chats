import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  final bool success;
  final String message;
  final int errorCode;
  final T? data;

  BaseResponse({
    required this.success,
    required this.message,
    required this.errorCode,
    this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) => _$BaseResponseToJson(this, toJsonT);
}
