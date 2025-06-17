// import 'package:json_annotation/json_annotation.dart';

// part 'pusher_model.g.dart';

// @JsonSerializable(genericArgumentFactories: true)
// class PusherModel<T> {
//   @JsonKey(name: 'user_id')
//   int? userId;

//   PayloadData<T>? payload;

//   PusherModel({
//     this.userId,
//     this.payload,
//   });

//   factory PusherModel.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
//       _$PusherModelFromJson(json, fromJsonT);

//   Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$PusherModelToJson(this, toJsonT);
// }

// @JsonSerializable(genericArgumentFactories: true)
// class PayloadData<T> {
//   String? title;
//   T? data;
//   String? type;

//   PayloadData({
//     this.title,
//     this.data,
//     this.type,
//   });

//   factory PayloadData.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
//       _$PayloadDataFromJson(json, fromJsonT);

//   Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$PayloadDataToJson(this, toJsonT);
// }
