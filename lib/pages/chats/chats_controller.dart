import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/chats/chats_models.dart';
import 'package:chats/models/contact/friend_request.dart';
import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/models/pusher/pusher_chat.dart';
import 'package:chats/models/pusher/pusher_group_message.dart';
import 'package:chats/models/pusher/pusher_message_model.dart';
import 'package:chats/models/pusher/pusher_model.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
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

  Future<void> fetchChatList({bool isRefresh = true, String search = '', bool isShowLoad = true}) async {
    try {
      if (isShowLoad && isRefresh) isLoading.value = true;

      final response = await chatsRepository.chatListAll(
        page: isRefresh ? 1 : (chatsModels.value?.page ?? 1) + 1,
        limit: 10,
        search: search,
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
      if (isShowLoad && isRefresh) isLoading.value = false;
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

  void onSearchChat(String value) async {
    if (value.isNotEmpty) {
      fetchChatList(search: value);
    } else {
      fetchChatList();
    }
  }

  void updateChatLastMessage(MessageDataModel message, {bool isRead = true}) {
    final chatList = chatsModels.value?.chat;
    if (chatList == null) return;

    final index = chatList.indexWhere((e) => e.id == message.chatId);
    if (index != -1) {
      final chat = chatList.removeAt(index);
      if (isRead == true) chat.isRead = false;
      chat.latestMessage = message;
      chatList.insert(0, chat);
      chatsModels.refresh();
    }
  }

  void addNewChat(ChatDataModel chat) {
    final chatList = chatsModels.value?.chat;
    if (chatList == null) return;

    final isExist = chatList.any((e) => e.id == chat.id);
    if (!isExist) {
      chatList.insert(0, chat..isRead = false);
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

  void updateReadStatus(int chatId) {
    final chat = chatsModels.value?.chat?.firstWhereOrNull((e) => e.id == chatId);
    if (chat != null) {
      chat.isRead = true;
      chatsModels.refresh();
    }
  }

  void initStreamPusher() {
    _initStream();
  }

  void _initStream() {
    _chatSubscription = PusherService().stream.listen(
      (event) {
        if (event is PusherEvent) {
          final json = jsonDecode(event.data) as Map<String, dynamic>;

          try {
            if (json['payload']['data']['chat_id'] != null) {
              final message = PusherMesageModel.fromJson(json);

              if (message.payload != null && message.payload?.type == PusherType.NEW_MESSAGE_EVENT) {
                updateChatLastMessage(message.payload!.data!);
              } else if (message.payload != null && message.payload?.type == PusherType.GROUP_RENAME_EVENT) {
                updateGroupName(json['payload']['data']['id'], json['payload']['data']['name']);
              }
            } else {
              try {
                final groupMessage = PusherGroupMessageModel.fromJson(json);

                if (groupMessage.payload != null && groupMessage.payload?.type == PusherType.NEW_MESSAGE_EVENT) {
                  if (groupMessage.payload?.type == PusherType.NEW_MESSAGE_EVENT) {
                    updateChatLastMessage(groupMessage.payload!.data!.chat!.latestMessage!);
                    if (groupMessage.payload?.data?.message?.hasUserRemovedFromGroup == 1 &&
                        (groupMessage.payload?.data?.users ?? []).isNotEmpty) {
                      removeListUser(groupMessage.payload!.data!.chat!.id!, groupMessage.payload!.data!.users!);
                    } else if (groupMessage.payload?.data?.message?.hasUserAddedToGroup == 1) {
                      updateListUser(groupMessage.payload!.data!.chat!.id!, groupMessage.payload!.data!.chat!.users!);
                    }
                  }
                }
              } catch (_) {}
            }
          } catch (e, a) {
            log(e.toString(), name: 'ERROR_STREAM_EVENT_CHATS_LIST');
            log(a.toString(), name: 'ERROR_STREAM_EVENT_CHATS_LIST');
          }

          try {
            final pusherModel = PusherModel.fromJson(
              json,
              (json) => ChatDataModel.fromJson(json as Map<String, dynamic>),
            );

            if (pusherModel.payload != null && pusherModel.payload?.type == PusherType.ADD_TO_GROUP_EVENT) {
              addNewChat(pusherModel.payload!.data!);
            }
          } catch (_) {}

          try {
            final chats = PusherChatModel.fromJson(json);

            if (chats.payload != null && chats.payload?.type == PusherType.NEW_MESSAGE_FOR_LIST_EVENT) {
              final newChat = chats.payload!.data!;
              final currentChats = chatsModels.value?.chat;
              final exists = currentChats?.any((chat) => chat.id == newChat.id) ?? false;

              if (!exists) {
                currentChats?.insert(0, newChat..isRead = false);
                chatsModels.refresh();
              }
            }
          } catch (e) {
            log(e.toString(), name: 'ERROR_STREAM_EVENT_CHATS_LIST');
          }

          try {
            final pusherModel = PusherModel.fromJson(
              json,
              (json) => FriendRequest.fromJson(json as Map<String, dynamic>),
            );

            if (pusherModel.payload != null && pusherModel.payload?.type == PusherType.UNFRIEND_EVENT) {
              Get.find<ContactsController>().removeContact(json['payload']['data']['user_id']);
            } else if (pusherModel.payload != null && pusherModel.payload?.type == PusherType.ACCEPTED_INVITE_EVENT) {
              Get.find<ContactsController>().updateContact(pusherModel.payload!.data!.receiver!);
            } else if (pusherModel.payload != null && pusherModel.payload?.type == PusherType.UNFRIEND_EVENT) {}
          } catch (_) {}
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
