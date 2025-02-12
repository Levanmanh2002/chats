import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

import 'chat_data_model.dart';

part 'chats_models.g.dart';

extension ChatsModelsExtension on ChatsModels {
  bool get hasNext => ((chat?.length ?? 0)) < (totalPage ?? 0);
}

@JsonSerializable()
class ChatsModels {
  @JsonKey(name: 'data')
  List<ChatDataModel>? chat;

  @JsonKey(fromJson: parseToInt)
  int? totalPage;

  @JsonKey(fromJson: parseToInt)
  int? totalCount;

  @JsonKey(fromJson: parseToInt)
  int? page;

  @JsonKey(fromJson: parseToInt)
  int? size;

  ChatsModels({
    this.chat,
    this.totalPage,
    this.totalCount,
    this.page,
    this.size,
  });

  factory ChatsModels.fromJson(Map<String, dynamic> json) => _$ChatsModelsFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsModelsToJson(this);

  ChatsModels copyWith({
    List<ChatDataModel>? chat,
    int? totalPage,
    int? totalCount,
    int? page,
    int? size,
  }) {
    return ChatsModels(
      chat: chat ?? this.chat,
      totalPage: totalPage ?? this.totalPage,
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }
}
