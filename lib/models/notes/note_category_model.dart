import 'package:json_annotation/json_annotation.dart';

part 'note_category_model.g.dart';

@JsonSerializable()
class NoteCategoryModel {
  int? id;
  String name;
  String color;
  String description;

  @JsonKey(name: "created_at")
  String createdAt;

  NoteCategoryModel({
    this.id,
    this.name = '',
    this.color = '',
    this.description = '',
    this.createdAt = '',
  });

  factory NoteCategoryModel.fromJson(Map<String, dynamic> json) => _$NoteCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteCategoryModelToJson(this);

  static List<NoteCategoryModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => NoteCategoryModel.fromJson(json)).toList();
  }
}
