import 'dart:async';
import 'dart:developer';

import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/messages/likes.dart';
import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/models/messages/message_models.dart';
import 'package:chats/models/messages/quick_message.dart';
import 'package:chats/models/messages/reply_message.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/models/socket/group_socket_model.dart';
import 'package:chats/models/socket/message_socket_model.dart';
import 'package:chats/models/tickers/tickers_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/forward/forward_parameter.dart';
import 'package:chats/pages/group_message/group_message_parameter.dart';
import 'package:chats/pages/group_message_search/group_message_search_parameter.dart';
import 'package:chats/pages/group_option/group_option_controller.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/resourese/groups/igroups_repository.dart';
import 'package:chats/resourese/ibase_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/resourese/service/socket_service.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/app/pusher_type.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class GroupMessageController extends GetxController {
  final IMessagesRepository messagesRepository;
  final IGroupsRepository groupsRepository;
  final GroupMessageParameter parameter;

  GroupMessageController({required this.messagesRepository, required this.groupsRepository, required this.parameter});

  final TextEditingController messageController = TextEditingController();
  // final scrollController = ScrollController();
  var isShowScrollToBottom = false.obs;
  var isShowNewMessScroll = false.obs;
  var isLoadingSendMess = false.obs;
  var isLoading = false.obs;

  var imageFile = <XFile>[].obs;
  var messageValue = ''.obs;

  var isShowSearch = true.obs;
  var isLoadingSearch = false.obs;

  var isTickers = false.obs;

  Rx<MessageModels?> messageModel = Rx<MessageModels?>(null);
  Rx<MessageModels?> messageSearchModel = Rx<MessageModels?>(null);
  Rx<MessageDataModel?> messageData = Rx<MessageDataModel?>(null);
  Rx<MessageDataModel?> messageReply = Rx<MessageDataModel?>(null);

  RxList<QuickMessage> quickMessagesList = <QuickMessage>[].obs;
  Rx<QuickMessage?> quickMessage = Rx<QuickMessage?>(null);

  StreamSubscription? _chatSubscription;

  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  Rx<TickersModel?> selectedTickers = Rx<TickersModel?>(null);
  Rx<XFile?> selectedFile = Rx<XFile?>(null);

  @override
  void onInit() {
    super.onInit();
    if (parameter.chatId != null) {
      fetchChatList(parameter.chatId!);
    }
    _fetchQuickMessage();
    // scrollController.addListener(_scrollListener);

    itemPositionsListener.itemPositions.addListener(() {
      _scrollListener();
    });

    FocusManager.instance.addListener(() {
      if (FocusManager.instance.primaryFocus?.hasFocus == true) {
        isTickers.value = false;
      }
    });

    // SocketService().initSocket();
    _initStream();
  }

  void _scrollListener() {
    // if (scrollController.offset > 100 && !isShowScrollToBottom.value) {
    //   isShowScrollToBottom.value = true;
    // } else if (scrollController.offset <= 100 && isShowScrollToBottom.value) {
    //   isShowScrollToBottom.value = false;
    // }
    final positions = itemPositionsListener.itemPositions.value;

    if (positions.isNotEmpty) {
      // Lấy vị trí index nhỏ nhất (ở trên cùng màn hình)
      final minIndex = positions.map((e) => e.index).reduce((a, b) => a < b ? a : b);

      if (minIndex > 2 && !isShowScrollToBottom.value) {
        isShowScrollToBottom.value = true;
      } else if (minIndex <= 2 && isShowScrollToBottom.value) {
        isShowScrollToBottom.value = false;
      }
    }
  }

  Future<void> fetchChatList(int chatId, {bool isRefresh = true, bool isShowLoad = true}) async {
    try {
      if (isRefresh && isShowLoad) isLoading.value = true;

      final response = await messagesRepository.messageList(
        chatId,
        page: isRefresh ? 1 : (messageModel.value?.page ?? 1) + 1,
        limit: 10,
      );

      if (response.statusCode == 200) {
        final model = MessageModels.fromJson(response.body['data']);

        messageModel.value = MessageModels(
          chat: model.chat,
          listMessages: [
            if (!isRefresh) ...(messageModel.value?.listMessages ?? []),
            ...(model.listMessages ?? []),
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
      if (isRefresh && isShowLoad) isLoading.value = false;
    }
  }

  int get messageId {
    return parameter.chatId ?? messageModel.value?.chat?.id ?? messageModel.value?.listMessages?.first.chatId ?? 0;
  }

  void onSearchMessage(String value) async {
    if (value.isEmpty) return;
    try {
      isLoadingSearch.value = true;
      final response = await messagesRepository.messageList(parameter.chatId!, search: value);

      if (response.statusCode == 200) {
        messageSearchModel.value = MessageModels.fromJson(response.body['data']);
        if (messageSearchModel.value != null) {
          Get.toNamed(
            Routes.GROUP_MESSAGE_SEARCH_RESULT,
            arguments: GroupMessageSearchParameter(searchMessage: messageSearchModel.value!),
          );
        }
      }
    } catch (e) {
      print(e);
    } finally {
      if (value.isNotEmpty) isLoadingSearch.value = false;
    }
  }

  Future<void> fetchChatListUntilPage({
    required int chatId,
    required int targetPage,
    required int messageId,
  }) async {
    try {
      isLoadingSearch.value = true;

      log(messageId.toString(), name: 'MESSAGE_ID');
      log(targetPage.toString(), name: 'TARGET_PAGE');
      log(chatId.toString(), name: 'CHAT_ID');
      final currentPage = messageModel.value?.page ?? 1;

      for (int page = currentPage; page <= targetPage; page++) {
        final response = await messagesRepository.messageList(
          chatId,
          page: page,
          limit: 10,
        );

        if (response.statusCode == 200) {
          final model = MessageModels.fromJson(response.body['data']);

          messageModel.value = MessageModels(
            listMessages: [
              ...(messageModel.value?.listMessages ?? []),
              ...(model.listMessages ?? []),
            ],
            totalPage: model.totalPage,
            totalCount: model.totalCount,
            page: model.page,
            size: model.size,
          );

          messageModel.refresh();

          bool messageFound = messageModel.value?.listMessages?.any((msg) => msg.id == messageId) ?? false;

          if (messageFound) {
            FocusScope.of(Get.context!).unfocus();
            scrollToMessage(messageId);
            break;
          }
        } else {
          break;
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingSearch.value = false;
    }
  }

  void scrollToMessage(int messageId) {
    int index = (messageModel.value?.listMessages ?? []).indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _fetchQuickMessage() async {
    try {
      final response = await messagesRepository.getInstantMess(messageId);

      if (response.statusCode == 200) {
        quickMessagesList.value = QuickMessage.listFromJson(response.body['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  void updateNewDataQuickMessage(List<QuickMessage> quickMessage) {
    quickMessagesList.value = quickMessage;
  }

  void updateQuickMessage(String value) {
    if (value.startsWith('/')) {
      final query = value.substring(1).trim();
      if (query.isEmpty) {
        quickMessage.value = quickMessagesList.isNotEmpty ? quickMessagesList.first : null;
      } else {
        try {
          final match = quickMessagesList.firstWhere(
            (msg) => (msg.shortKey ?? '').toLowerCase().startsWith(query.toLowerCase()),
          );
          quickMessage.value = match;
        } catch (e) {
          try {
            final match = quickMessagesList.firstWhere(
              (msg) => (msg.shortKey ?? '').toLowerCase().contains(query.toLowerCase()),
            );
            quickMessage.value = match;
          } catch (e) {
            quickMessage.value = null;
          }
        }
      }
    } else {
      quickMessage.value = null;
    }
  }

  void updateMessage(String value) {
    messageValue.value = value;
    updateQuickMessage(value);
  }

  void onSendQuickMessage() {
    if (quickMessage.value != null) {
      messageController.text = quickMessage.value?.content ?? '';
      quickMessage.value = null;
    }
  }

  void pickImages() async {
    isTickers.value = false;

    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isEmpty) return;

    // if (pickedFiles.isNotEmpty) {
    //   imageFile.addAll(pickedFiles);
    //   // onSendMessage();
    // }

    for (var file in pickedFiles) {
      if (imageFile.length >= 3) {
        imageFile.removeLast();
      }
      imageFile.insert(0, file);
    }

    onSendMessage();
  }

  void toggleTickers() {
    isTickers.value = !isTickers.value;
    FocusScope.of(Get.context!).unfocus();
  }

  Future<void> pickedFile() async {
    isTickers.value = false;
    FocusScope.of(Get.context!).unfocus();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile platformFile = result.files.first;
      XFile file = XFile(platformFile.path!);
      log("File selected: ${platformFile.name}");

      selectedFile.value = file;
      if (selectedFile.value != null) {
        onSendMessage();
      }
    }
  }

  void sendTicker(TickersModel ticker) {
    selectedTickers.value = ticker;
    isTickers.value = false;
    messageController.clear();
    imageFile.clear();
    messageValue.value = '';
    messageReply.value = null;
    onSendMessage();
  }

  void onSendMessage() async {
    try {
      final messageText = messageController.text.trim();
      final imageFile = this.imageFile.toList();
      final replyMessageLocal = messageReply.value;

      final tempFiles = imageFile.isNotEmpty
          ? imageFile
              .map((file) => FilesModels(
                    id: DateTime.now().millisecondsSinceEpoch,
                    fileUrl: file.path,
                    fileType: file.path.resolveMimeType,
                    isLocal: true,
                  ))
              .toList()
          : selectedFile.value != null
              ? [
                  FilesModels(
                    id: DateTime.now().millisecondsSinceEpoch,
                    fileUrl: selectedFile.value?.path ?? '',
                    fileType: selectedFile.value?.name,
                    isLocal: true,
                  )
                ]
              : null;

      final tempSticker = selectedTickers.value != null
          ? TickersModel(
              id: selectedTickers.value?.id,
              name: selectedTickers.value?.name,
              url: selectedTickers.value?.url,
            )
          : null;

      final tempMessage = MessageDataModel(
        id: DateTime.now().millisecondsSinceEpoch,
        message: messageText,
        sender: Get.find<ProfileController>().user.value,
        chatId: parameter.chatId,
        createdAt: DateTime.now().toString(),
        status: MessageStatus.sending,
        files: tempFiles,
        sticker: tempSticker,
        replyMessage: messageReply.value != null
            ? ReplyMessage(
                id: replyMessageLocal?.id,
                message: replyMessageLocal?.message,
                chatId: replyMessageLocal?.chatId,
                sender: replyMessageLocal?.sender,
                files: replyMessageLocal?.files,
                createdAt: replyMessageLocal?.createdAt,
              )
            : null,
      );

      messageModel.value?.listMessages?.insert(0, tempMessage);
      messageModel.refresh();

      clearMessage();

      _sendAndUpdateMessageLocal(tempMessage, messageText, imageFile, replyMessageLocal, tempSticker);
      scrollToBottom();
    } catch (e) {
      print(e);
    }
  }

  void _sendAndUpdateMessageLocal(
    MessageDataModel tempMessage,
    String messageText,
    List<XFile> imageFile,
    MessageDataModel? reply,
    TickersModel? sticker,
  ) async {
    try {
      Map<String, String> params = {
        "chat_id": parameter.chatId.toString(),
        if (messageText.isNotEmpty) "message": messageText,
        if (reply != null) "reply_message_id": reply.id.toString(),
        if (sticker != null) "sticker_id": sticker.id.toString(),
      };

      List<MultipartBody> multipartBody = [
        if (imageFile.isNotEmpty) ...imageFile.map((file) => MultipartBody('files[]', file)),
        if (selectedFile.value != null) MultipartBody('files[]', selectedFile.value),
      ];

      final response = await groupsRepository.sendMessageGroup(params, multipartBody);

      if (response.statusCode == 200) {
        messageData.value = MessageDataModel.fromJson(response.body['data']);
        if (messageModel.value != null) {
          fetchChatList(messageData.value!.chatId!, isShowLoad: false);
          messageModel.value?.listMessages?.removeWhere((msg) => msg.id == tempMessage.id);
          onInsertMessage(messageData.value!);
        } else {
          messageModel.value?.listMessages?.removeWhere((msg) => msg.id == tempMessage.id);
          onInsertMessage(messageData.value!);
        }
      } else {
        replaceTemporaryMessage(tempMessage.id!, tempMessage.copyWith(status: MessageStatus.failed));
      }
    } catch (e) {
      print(e);
    }
  }

  void replaceTemporaryMessage(int tempId, MessageDataModel newMessage) {
    int index = (messageModel.value?.listMessages ?? []).indexWhere((msg) => msg.id == tempId);
    if (index != -1) {
      messageModel.value?.listMessages?[index] = newMessage;
      messageModel.refresh();
    }
  }

  void onInsertMessage(MessageDataModel newMessages) {
    messageModel.value = messageModel.value?.copyWith(
      listMessages: messageModel.value?.listMessages?..insert(0, newMessages),
    );
    messageModel.refresh();
    Get.find<ChatsController>().updateChatLastMessage(newMessages, isRead: false);
  }

  void clearMessage() {
    messageController.clear();
    imageFile.clear();
    messageValue.value = '';
    messageReply.value = null;
    selectedTickers.value = null;
  }

  void scrollToBottom() {
    // scrollController.animateTo(
    //   0.0,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );
    itemScrollController.scrollTo(
      index: 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void updateReplyMessage(MessageDataModel? message) {
    messageReply.value = message;
  }

  void removeReplyMessage() {
    messageReply.value = null;
  }

  void onRevokeMessageLocal(int? messageId, {bool isRollback = true}) async {
    if (isRollback == true) {
      final result = await onRevokeMessage(messageId);

      if (result == true) {
        int index = messageModel.value?.listMessages?.indexWhere((msg) => msg.id == messageId) ?? -1;

        if (index != -1) {
          messageModel.value?.listMessages![index] = messageModel.value!.listMessages![index].copyWith(
            isRollback: isRollback,
          );

          messageModel.refresh();

          final chatAllList = Get.find<ChatsController>().chatsModels.value?.chat;

          if ((chatAllList ?? []).isNotEmpty) {
            int indexListChat = chatAllList?.indexWhere((msg) => msg.latestMessage?.id == messageId) ?? -1;

            if (indexListChat != -1) {
              chatAllList![index] = chatAllList[index].copyWith(
                latestMessage: messageModel.value?.listMessages?[index],
              );

              Get.find<ChatsController>().chatsModels.refresh();
            }
          }
        }
      }
    } else {
      int index = messageModel.value?.listMessages?.indexWhere((msg) => msg.id == messageId) ?? -1;

      if (index != -1) {
        messageModel.value?.listMessages![index] = messageModel.value!.listMessages![index].copyWith(
          isRollback: isRollback,
        );

        messageModel.refresh();

        final chatAllList = Get.find<ChatsController>().chatsModels.value?.chat;

        if ((chatAllList ?? []).isNotEmpty) {
          int indexListChat = chatAllList?.indexWhere((msg) => msg.latestMessage?.id == messageId) ?? -1;

          if (indexListChat != -1) {
            chatAllList![index] = chatAllList[index].copyWith(
              latestMessage: messageModel.value?.listMessages?[index],
            );

            Get.find<ChatsController>().chatsModels.refresh();
          }
        }
      }
    }
  }

  void onReplyMessage(MessageDataModel message) {
    messageReply.value = message;
  }

  Future<bool> onRevokeMessage(int? messageId) async {
    try {
      if (messageId == null) return false;
      final response = await messagesRepository.revokeMessage(messageId);

      if (response.isOk) {
        return true;
      } else if (response.statusCode == 500) {
        return false;
      } else if (response.statusCode == 400) {
        int index = messageModel.value?.listMessages?.indexWhere((msg) => msg.id == messageId) ?? -1;

        if (index != -1) {
          messageModel.value?.listMessages![index] = messageModel.value!.listMessages![index].copyWith(
            isRollback: false,
          );

          messageModel.refresh();
        }
        DialogUtils.showErrorDialog(response.body['message']);
        return false;
      } else {
        onRevokeMessageLocal(messageId, isRollback: false);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void onHeartMessageLocal(int? messageId, {bool isCallServer = true}) {
    if (messageId == null) return;

    final userId = Get.find<ProfileController>().user.value?.id;
    if (userId == null) return;

    int index = messageModel.value?.listMessages?.indexWhere((msg) => msg.id == messageId) ?? -1;
    if (index != -1) {
      final message = messageModel.value?.listMessages![index];
      List<LikeModel> likes = List.from(message?.likes ?? []);

      int likeIndex = likes.indexWhere((like) => like.user?.id == userId);

      if (likeIndex != -1) {
        likes.removeAt(likeIndex);
      } else {
        likes.add(
          LikeModel(
            id: DateTime.now().millisecondsSinceEpoch,
            user: Get.find<ProfileController>().user.value,
            createdAt: DateTime.now().toString(),
          ),
        );
      }
      messageModel.value?.listMessages![index] = message!.copyWith(likes: likes);
      messageModel.refresh();
    }

    if (isCallServer == true) onHeartMessage(messageId);
  }

  void onHeartMessage(int? messageId) async {
    try {
      if (messageId == null) return;
      final response = await messagesRepository.heartMessage(messageId);

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 500) {
        return;
      } else {
        removeUserLike(messageId);
      }
    } catch (e) {
      print(e);
    }
  }

  void removeUserLike(int? messageId) {
    if (messageId == null) return;

    final userId = Get.find<ProfileController>().user.value?.id;
    if (userId == null) return;

    int index = messageModel.value?.listMessages?.indexWhere((msg) => msg.id == messageId) ?? -1;

    if (index != -1) {
      final message = messageModel.value?.listMessages![index];
      List<LikeModel> likes = List.from(message?.likes ?? []);

      likes.removeWhere((like) => like.user?.id == userId);

      messageModel.value?.listMessages![index] = message!.copyWith(likes: likes);
      messageModel.refresh();
    }
  }

  void updateGroupName(String name) {
    messageModel.value = messageModel.value?.copyWith(chat: messageModel.value?.chat?.copyWith(name: name));
    messageModel.refresh();
  }

  void updateNewDataUserChat(ChatDataModel chat) {
    messageModel.value = messageModel.value?.copyWith(chat: chat);
    messageModel.refresh();
  }

  void removeUserInChatGroup(UserModel user) {
    messageModel.value?.chat?.users?.remove(user);
    messageModel.refresh();
  }

  void removeUsersInChatGroup(List<int> userIds) {
    if (messageModel.value?.chat?.users != null) {
      messageModel.value!.chat!.users!.removeWhere((user) => userIds.contains(user.id));
      messageModel.refresh();
    }
  }

  void updateNameGroupEvent(String name) {
    messageModel.value = messageModel.value?.copyWith(chat: messageModel.value?.chat?.copyWith(name: name));
    messageModel.refresh();
    if (Get.isRegistered<GroupOptionController>()) Get.find<GroupOptionController>().updateNameGroupEvent(name);
  }

  void updateListUser(List<UserModel> users) {
    messageModel.value = messageModel.value?.copyWith(chat: messageModel.value?.chat?.copyWith(users: users));
    messageModel.refresh();
  }

  void removeUserFromGroup(List<int> userIds) {
    if (messageModel.value?.chat?.users != null) {
      final initialLength = messageModel.value!.chat!.users!.length;

      messageModel.value!.chat!.users!.removeWhere((user) {
        if (userIds.contains(user.id)) {
          if (user.id == Get.find<ProfileController>().user.value?.id) {
            Get.back();
          }
          return true;
        }
        return false;
      });

      if (messageModel.value!.chat!.users!.length != initialLength) {
        messageModel.refresh();
      }
    }
  }

  void onForward(int? messageId, {String? message, List<FilesModels>? files}) async {
    if (messageId == null) return;
    Get.toNamed(
      Routes.FORWARD,
      arguments: ForwardParameter(
        messageId: messageId,
        message: message,
        files: files,
      ),
    );
  }

  void _initStream() {
    _chatSubscription = SocketService().stream.listen(
      (event) {
        if (event != null && event is Map<String, dynamic>) {
          try {
            final json = event;
            if (json['data']['chat_id'] == parameter.chatId) {
              final message = MessageSocketModel.fromJson(json);
              if (message.data == null) return;

              switch (message.type) {
                case PusherType.NEW_MESSAGE_EVENT:
                  onInsertMessage(message.data!);
                  break;
                case PusherType.ROLLBACK_EVENT:
                  int index = messageModel.value?.listMessages?.indexWhere((msg) => msg.id == message.data!.id) ?? -1;
                  if (index != -1) {
                    messageModel.value?.listMessages![index] =
                        messageModel.value!.listMessages![index].copyWith(isRollback: true);
                    messageModel.refresh();
                  }
                  break;
                case PusherType.LIKE_MESSAGE_EVENT:
                  onHeartMessageLocal(message.data!.id, isCallServer: false);
                  break;
                case PusherType.HAS_USER_REMOVED_FROM_GROUP_EVENT:
                  break;
                case PusherType.ADD_TO_GROUP_EVENT:
                  final groupMessage = GroupSocketModel.fromJson(json);
                  if (groupMessage.data != null) {
                    onInsertMessage(groupMessage.data!.chat!.latestMessage!);
                  }
                  break;

                case PusherType.GROUP_RENAME_EVENT:
                  updateNameGroupEvent(json['data']['name']);
                  break;

                default:
              }
            } else {
              final groupMessage = GroupSocketModel.fromJson(json);

              if (groupMessage.data?.chat?.id == parameter.chatId &&
                  groupMessage.type == PusherType.NEW_MESSAGE_EVENT) {
                onInsertMessage(groupMessage.data!.chat!.latestMessage!);

                if (groupMessage.data?.message?.hasUserRemovedFromGroup == 1 &&
                    (groupMessage.data?.users ?? []).isNotEmpty) {
                  removeUsersInChatGroup(groupMessage.data!.users!);
                  removeUserFromGroup(groupMessage.data!.users!);
                } else if (groupMessage.data?.message?.hasUserAddedToGroup == 1) {
                  updateListUser(groupMessage.data!.chat!.users!);
                }
              }
            }
          } catch (e) {
            log(e.toString(), name: 'ERROR_STREAM_EVENT_GROUP_MESSAGE');
          }
        }
      },
    );
  }

  @override
  void onClose() {
    // scrollController.dispose();
    messageController.dispose();
    itemPositionsListener.itemPositions.removeListener(_scrollListener);
    _chatSubscription?.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    messageController.dispose();
    itemPositionsListener.itemPositions.removeListener(_scrollListener);
    _chatSubscription?.cancel();
    super.dispose();
  }
}
