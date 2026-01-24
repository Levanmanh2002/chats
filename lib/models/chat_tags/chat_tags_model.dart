import 'package:json_annotation/json_annotation.dart';

part 'chat_tags_model.g.dart';

extension ChatsModelsExtension on ChatTagsModel {
  bool get hasNext => ((data?.length ?? 0)) < (totalCount ?? 0);
}

@JsonSerializable()
class ChatTagsModel {
  List<ChatCategory>? data;
  int? totalPage;
  int? totalCount;
  int? page;
  int? size;

  ChatTagsModel({
    this.data,
    this.totalPage,
    this.totalCount,
    this.page,
    this.size,
  });

  factory ChatTagsModel.fromJson(Map<String, dynamic> json) => _$ChatTagsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatTagsModelToJson(this);
}

@JsonSerializable()
class ChatCategory {
  int? id;
  String? name;
  String? color;
  String? icon;
  int? order;

  @JsonKey(name: 'is_active')
  bool? isActive;

  @JsonKey(name: 'chats_count')
  int? chatsCount;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(name: 'updated_at')
  String? updatedAt;

  ChatCategory({
    this.id,
    this.name,
    this.color,
    this.icon,
    this.order,
    this.isActive,
    this.chatsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatCategory.fromJson(Map<String, dynamic> json) => _$ChatCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ChatCategoryToJson(this);
}
