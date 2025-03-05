import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/contact/sender_request_friend.dart';
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

  List<MessageDataModel>? highlightedMessages;

  List<int>? highlightedPages;

  @JsonKey(name: 'is_friend', fromJson: parseToBool)
  bool? isFriend;

  @JsonKey(name: 'is_sender_request_friend', fromJson: parseToBool)
  bool? isSenderRequestFriend;

  @JsonKey(name: 'is_receiver_id_request_friend', fromJson: parseToBool)
  bool? isReceiverIdRequestFriend;

  @JsonKey(name: 'request_friend')
  SenderRequestFriend? requestFriend;

  MessageModels({
    this.chat,
    this.listMessages,
    this.totalPage,
    this.totalCount,
    this.page,
    this.size,
    this.highlightedMessages,
    this.highlightedPages,
    this.isFriend,
    this.isSenderRequestFriend,
    this.isReceiverIdRequestFriend,
    this.requestFriend,
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
    bool? isFriend,
    bool? isSenderRequestFriend,
    bool? isReceiverIdRequestFriend,
    SenderRequestFriend? requestFriend,
  }) {
    return MessageModels(
      chat: chat ?? this.chat,
      listMessages: listMessages ?? this.listMessages,
      totalPage: totalPage ?? this.totalPage,
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      size: size ?? this.size,
      isFriend: isFriend ?? this.isFriend,
      isSenderRequestFriend: isSenderRequestFriend ?? this.isSenderRequestFriend,
      isReceiverIdRequestFriend: isReceiverIdRequestFriend ?? this.isReceiverIdRequestFriend,
      requestFriend: requestFriend ?? this.requestFriend,
    );
  }
}
