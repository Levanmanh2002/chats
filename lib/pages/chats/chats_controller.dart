import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chats/models/chats/chats_models.dart';
import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/models/pusher/pusher_group_message.dart';
import 'package:chats/models/pusher/pusher_message_model.dart';
import 'package:chats/resourese/chats/ichats_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/resourese/service/pusher_service.dart';
import 'package:chats/utils/app/pusher_type.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatsController extends GetxController with GetSingleTickerProviderStateMixin {
  final IChatsRepository chatsRepository;
  final IMessagesRepository messagesRepository;

  ChatsController({required this.chatsRepository, required this.messagesRepository});

  Rx<ChatsModels?> chatsModels = Rx<ChatsModels?>(null);

  var isLoading = false.obs;

  StreamSubscription? _chatSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchChatList();
  }

  Future<void> fetchChatList({bool isRefresh = true}) async {
    try {
      isLoading.value = true;

      final response = await chatsRepository.chatListAll(
        page: isRefresh ? 1 : (chatsModels.value?.totalPage ?? 1) + 1,
        limit: 10,
      );

      if (response.statusCode == 200) {
        final model = ChatsModels.fromJson(response.body['data']);

        chatsModels.value = ChatsModels(
          chat: [
            if (!isRefresh) ...(chatsModels.value?.chat ?? []),
            ...(model.chat ?? []),
          ],
          totalPage: model.totalPage,
          totalCount: model.totalCount,
          page: model.page,
          size: model.size,
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void deleteChat(int chatId) async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await messagesRepository.deleteChat(chatId);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        removeChat(chatId);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void updateChatLastMessage(MessageDataModel message) {
    final chat = chatsModels.value?.chat?.firstWhereOrNull((e) => e.id == message.chatId);
    if (chat != null) {
      chat.latestMessage = message;
      chatsModels.refresh();
    }
  }

  void updateGroupName(int chatId, String groupName) {
    final chat = chatsModels.value?.chat?.firstWhereOrNull((e) => e.id == chatId);
    if (chat != null) {
      chat.name = groupName;
      chatsModels.refresh();
    }
  }

  void removeChat(int chatId) {
    chatsModels.value?.chat?.removeWhere((e) => e.id == chatId);
    chatsModels.refresh();
  }

  void removeListUser(int chatId, List<int> userIds) {
    final chat = chatsModels.value?.chat?.firstWhereOrNull((e) => e.id == chatId);
    if (chat != null) {
      chat.users?.removeWhere((e) => userIds.contains(e.id));
      chatsModels.refresh();
    }

    if (userIds.contains(Get.find<UserModel>().id)) {
      removeChat(chatId);
    }
  }

  void updateListUser(int chatId, List<UserModel> users) {
    final chat = chatsModels.value?.chat?.firstWhereOrNull((e) => e.id == chatId);
    if (chat != null) {
      chat.users = users;
      chatsModels.refresh();
    }
  }

  void initStreamPusher() {
    PusherService().connect();
    _initStream();
  }

  void _initStream() {
    _chatSubscription = PusherService().stream.listen(
      (event) {
        if (event is PusherEvent) {
          try {
            final json = jsonDecode(event.data) as Map<String, dynamic>;
            if (json['payload']['data']['chat_id'] != null) {
              final message = PusherMesageModel.fromJson(json);
              if (message.payload == null) return;
              switch (message.payload?.type) {
                case PusherType.NEW_MESSAGE_EVENT:
                  updateChatLastMessage(message.payload!.data!);
                  break;
                case PusherType.GROUP_RENAME_EVENT:
                  updateGroupName(json['payload']['data']['id'], json['payload']['data']['name']);
                  break;
                default:
              }
            } else {
              final groupMessage = PusherGroupMessageModel.fromJson(json);

              if (groupMessage.payload != null && groupMessage.payload?.type == PusherType.NEW_MESSAGE_EVENT) {
                updateChatLastMessage(groupMessage.payload!.data!.chat!.latestMessage!);
                if (groupMessage.payload?.data?.message?.hasUserRemovedFromGroup == 1 &&
                    (groupMessage.payload?.data?.users ?? []).isNotEmpty) {
                  removeListUser(groupMessage.payload!.data!.chat!.id!, groupMessage.payload!.data!.users!);
                } else if (groupMessage.payload?.data?.message?.hasUserAddedToGroup == 1) {
                  updateListUser(groupMessage.payload!.data!.chat!.id!, groupMessage.payload!.data!.chat!.users!);
                }
              }
            }
          } catch (e) {
            log(e.toString(), name: 'ERROR_STREAM_EVENT_CHATS_LIST');
          }
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chatSubscription?.cancel();
  }
}
