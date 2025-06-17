import 'package:json_annotation/json_annotation.dart';

part 'socket_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SocketModel<T> {
  String? title;
  T? data;
  String? type;

  SocketModel({
    this.title,
    this.data,
    this.type,
  });

  factory SocketModel.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$SocketModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$SocketModelToJson(this, toJsonT);
}
