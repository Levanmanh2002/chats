import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_models.g.dart';

extension MessageModelsExtension on MessageModels {
  bool get hasNext => ((listMessages?.length ?? 0)) < (totalCount ?? 0);
}

@JsonSerializable()
class MessageModels {
  ChatDataModel? chat;

  @JsonKey(name: 'listMessages')
  List<MessageDataModel>? listMessages;

  @JsonKey(fromJson: parseToInt)
  int? totalPage;

  @JsonKey(fromJson: parseToInt)
  int? totalCount;

  @JsonKey(fromJson: parseToInt)
  int? page;

  @JsonKey(fromJson: parseToInt)
  int? size;

  MessageModels({
    this.chat,
    this.listMessages,
    this.totalPage,
    this.totalCount,
    this.page,
    this.size,
  });

  factory MessageModels.fromJson(Map<String, dynamic> json) => _$MessageModelsFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelsToJson(this);

  MessageModels copyWith({
    ChatDataModel? chat,
    List<MessageDataModel>? listMessages,
    int? totalPage,
    int? totalCount,
    int? page,
    int? size,
  }) {
    return MessageModels(
      chat: chat ?? this.chat,
      listMessages: listMessages ?? this.listMessages,
      totalPage: totalPage ?? this.totalPage,
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }
}
