import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/messages/likes.dart';
import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/models/messages/message_models.dart';
import 'package:chats/models/messages/quick_message.dart';
import 'package:chats/models/messages/reply_message.dart';
import 'package:chats/models/pusher/pusher_message_model.dart';
import 'package:chats/models/tickers/tickers_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/message/message_parameter.dart';
import 'package:chats/pages/message_search/message_search_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/resourese/ibase_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/resourese/service/pusher_service.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/app/pusher_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MessageController extends GetxController {
  final IMessagesRepository messagesRepository;
  final MessageParameter parameter;

  MessageController({required this.messagesRepository, required this.parameter});

  final TextEditingController messageController = TextEditingController();
  // final scrollController = ScrollController();
  var isShowScrollToBottom = false.obs;
  var isShowNewMessScroll = false.obs;
  var isLoadingSendMess = false.obs;
  var isLoadingSearch = false.obs;

  var imageFile = <XFile>[].obs;
  var messageValue = ''.obs;

  var isLoading = false.obs;
  var isShowSearch = true.obs;

  var isTickers = false.obs;

  Rx<MessageModels?> messageModel = Rx<MessageModels?>(null);
  Rx<MessageModels?> messageSearchModel = Rx<MessageModels?>(null);
  Rx<MessageDataModel?> messageData = Rx<MessageDataModel?>(null);
  Rx<MessageDataModel?> messageReply = Rx<MessageDataModel?>(null);

  RxList<QuickMessage> quickMessagesList = <QuickMessage>[].obs;
  Rx<QuickMessage?> quickMessage = Rx<QuickMessage?>(null);

  StreamSubscription? _chatSubscription;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  Rx<TickersModel?> selectedTickers = Rx<TickersModel?>(null);

  @override
  void onInit() async {
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

    await PusherService().connect();
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

  void onSearchMessage(String value) async {
    if (value.isEmpty) return;
    try {
      isLoadingSearch.value = true;
      final response = await messagesRepository.messageList(parameter.chatId!, search: value);

      if (response.statusCode == 200) {
        messageSearchModel.value = MessageModels.fromJson(response.body['data']);
        if (messageSearchModel.value != null) {
          Get.toNamed(
            Routes.MESSAGE_SEARCH_RESULT,
            arguments: MessageSearchParameter(searchMessage: messageSearchModel.value!),
          );
        }
      }
    } catch (e) {
      print(e);
    } finally {
      if (value.isNotEmpty) isLoadingSearch.value = false;
    }
  }

  int get messageId {
    return parameter.chatId ?? messageModel.value?.chat?.id ?? messageModel.value?.listMessages?.first.chatId ?? 0;
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

    // final files = pickedFiles.length > 3 ? pickedFiles.sublist(0, 3) : pickedFiles;

    // imageFile.assignAll(files);

    for (var file in pickedFiles) {
      if (imageFile.length >= 3) {
        imageFile.removeLast();
      }
      imageFile.insert(0, file);
    }

    // if (pickedFiles.isNotEmpty) {
    //   imageFile.addAll(pickedFiles);
    //   // onSendMessage();
    // }
  }

  void toggleTickers() {
    isTickers.value = !isTickers.value;
    FocusScope.of(Get.context!).unfocus();
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

      final tempFiles = imageFile
          .map((file) => FilesModels(
                id: DateTime.now().millisecondsSinceEpoch,
                fileUrl: file.path,
                fileType: file.path.resolveMimeType,
                isLocal: true,
              ))
          .toList();

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
        chatId: parameter.contact?.id,
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
        "receiver_id": parameter.contact?.id.toString() ?? '',
        if (messageText.isNotEmpty) "message": messageText,
        if (reply != null) "reply_message_id": reply.id.toString(),
        if (sticker != null) "sticker_id": sticker.id.toString(),
      };

      List<MultipartBody> multipartBody = [
        if (imageFile.isNotEmpty) ...imageFile.map((file) => MultipartBody('files[]', file)),
      ];

      final response = await messagesRepository.sendMessage(params, multipartBody);

      if (response.statusCode == 200) {
        messageData.value = MessageDataModel.fromJson(response.body['data']);
        if (parameter.chatId == null) {
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

  void onRevokeMessageLocal(int? messageId, {bool isRollback = true}) {
    int index = messageModel.value?.listMessages?.indexWhere((msg) => msg.id == messageId) ?? -1;

    if (index != -1) {
      messageModel.value?.listMessages![index] = messageModel.value!.listMessages![index].copyWith(
        isRollback: isRollback,
      );

      messageModel.refresh();
    }

    if (isRollback == true) onRevokeMessage(messageId);
  }

  void onRevokeMessage(int? messageId) async {
    try {
      if (messageId == null) return;
      final response = await messagesRepository.revokeMessage(messageId);

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 500) {
        return;
      } else {
        onRevokeMessageLocal(messageId, isRollback: false);
      }
    } catch (e) {
      print(e);
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

    if (isCallServer = true) onHeartMessage(messageId);
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

  String getChatAvatar(ChatDataModel? chat) =>
      (chat?.users ?? []).firstWhereOrNull((u) => u.id != Get.find<ProfileController>().user.value?.id)?.avatar ?? '';

  void _initStream() {
    _chatSubscription = PusherService().stream.listen(
      (event) {
        if (event is PusherEvent) {
          try {
            final json = jsonDecode(event.data) as Map<String, dynamic>;
            if (json['payload']['data']['chat_id'] == parameter.chatId) {
              final message = PusherMesageModel.fromJson(json);
              if (message.payload == null) return;

              switch (message.payload?.type) {
                case PusherType.NEW_MESSAGE_EVENT:
                  onInsertMessage(message.payload!.data!);
                  break;
                case PusherType.ROLLBACK_EVENT:
                  int index =
                      messageModel.value?.listMessages?.indexWhere((msg) => msg.id == message.payload!.data!.id) ?? -1;
                  if (index != -1) {
                    messageModel.value?.listMessages![index] =
                        messageModel.value!.listMessages![index].copyWith(isRollback: true);
                    messageModel.refresh();
                  }
                  break;

                case PusherType.LIKE_MESSAGE_EVENT:
                  onHeartMessageLocal(message.payload!.data!.id, isCallServer: false);
                  break;
                default:
              }
            }
          } catch (e) {
            log(e.toString(), name: 'ERROR_STREAM_EVENT_MESSAGE');
          }
        }
      },
    );
  }

  @override
  void onClose() {
    // scrollController.dispose();
    messageController.dispose();
    _chatSubscription?.cancel();
    itemPositionsListener.itemPositions.removeListener(_scrollListener);
    super.onClose();
  }

  @override
  void dispose() {
    messageController.dispose();
    _chatSubscription?.cancel();
    itemPositionsListener.itemPositions.removeListener(_scrollListener);
    super.dispose();
  }
}
