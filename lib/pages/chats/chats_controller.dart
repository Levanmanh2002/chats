import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:chats/constant/date_format_constants.dart';
import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/chats/chats_models.dart';
import 'package:chats/models/contact/friend_request.dart';
import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/messages/likes.dart';
import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/models/messages/message_models.dart';
import 'package:chats/models/messages/quick_message.dart';
import 'package:chats/models/messages/reply_message.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/models/pusher/pusher_chat.dart';
import 'package:chats/models/pusher/pusher_group_message.dart';
import 'package:chats/models/pusher/pusher_message_model.dart';
import 'package:chats/models/pusher/pusher_model.dart';
import 'package:chats/models/tickers/tickers_model.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/pages/forward/forward_parameter.dart';
import 'package:chats/pages/group_message_search/group_message_search_parameter.dart';
import 'package:chats/pages/message_search/message_search_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/resourese/chats/ichats_repository.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/resourese/groups/igroups_repository.dart';
import 'package:chats/resourese/ibase_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/resourese/service/pusher_service.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/app/pusher_type.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatsController extends GetxController with GetSingleTickerProviderStateMixin {
  final IChatsRepository chatsRepository;
  final IMessagesRepository messagesRepository;
  final IContactRepository contactRepository;
  final IGroupsRepository groupsRepository;

  ChatsController({
    required this.chatsRepository,
    required this.messagesRepository,
    required this.contactRepository,
    required this.groupsRepository,
  });

  final TextEditingController searchController = TextEditingController();

  var searchValue = ''.obs;

  Rx<ChatsModels?> chatsModels = Rx<ChatsModels?>(null);
  RxList<QuickMessage> quickMessagesList = <QuickMessage>[].obs;
  Rx<QuickMessage?> quickMessage = Rx<QuickMessage?>(null);

  var isLoading = false.obs;

  StreamSubscription? _chatSubscription;
  StreamSubscription? _chatSubscriptionMessage;

  @override
  void onInit() {
    super.onInit();
    fetchChatList();
    _fetchQuickMessage();
    itemPositionsListener.itemPositions.addListener(() {
      _scrollListener();
    });

    FocusManager.instance.addListener(() {
      if (FocusManager.instance.primaryFocus?.hasFocus == true) {
        isTickers.value = false;
      }
    });
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

  void _scrollListener() {
    final positions = itemPositionsListener.itemPositions.value;

    if (positions.isNotEmpty) {
      final minIndex = positions.map((e) => e.index).reduce((a, b) => a < b ? a : b);

      if (minIndex > 2 && !isShowScrollToBottom.value) {
        isShowScrollToBottom.value = true;
      } else if (minIndex <= 2 && isShowScrollToBottom.value) {
        isShowScrollToBottom.value = false;
      }
    }
  }

  void _fetchQuickMessage() async {
    try {
      final response = await messagesRepository.getInstantMess(null);

      if (response.statusCode == 200) {
        quickMessagesList.value = QuickMessage.listFromJson(response.body['data']);
      }
    } catch (e) {
      print(e);
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
    PusherService().connect();

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
          final json = jsonDecode(jsonEncode(event.data)) as Map<String, dynamic>;

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

  /* ================================================== */

  final TextEditingController messageController = TextEditingController();
  var isShowScrollToBottom = false.obs;
  var isShowNewMessScroll = false.obs;
  var isLoadingSendMess = false.obs;
  var isLoadingSearch = false.obs;
  var isLoadingAddFriend = false.obs;
  var isLoadingRemoveFriend = false.obs;
  var isLoadingCancelFriend = false.obs;
  var isLoadingAcceptFriend = false.obs;

  var imageFile = <XFile>[].obs;
  var messageValue = ''.obs;

  var isShowSearch = true.obs;

  var isTickers = false.obs;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  Rx<TickersModel?> selectedTickers = Rx<TickersModel?>(null);
  Rx<MessageDataModel?> messageReply = Rx<MessageDataModel?>(null);

  Rx<MessageModels?> messageModel = Rx<MessageModels?>(null);
  Rx<MessageDataModel?> messageData = Rx<MessageDataModel?>(null);
  Rx<MessageModels?> messageSearchModel = Rx<MessageModels?>(null);

  var isGroup = false.obs;

  Future<void> getMessageList(int chatId, {bool isRefresh = true, bool isShowLoad = true}) async {
    try {
      if (isRefresh && isShowLoad) EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);
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
          isFriend: model.isFriend,
          isSenderRequestFriend: model.isSenderRequestFriend,
          isReceiverIdRequestFriend: model.isReceiverIdRequestFriend,
          requestFriend: model.requestFriend,
        );

        await PusherService().connect();
        _initStreamMessage();
      }
    } catch (e) {
      print(e);
    } finally {
      if (isRefresh && isShowLoad) EasyLoading.dismiss();
    }
  }

  void toggleTickers() {
    isTickers.value = !isTickers.value;
  }

  void updateMessage(String value) {
    messageValue.value = value;
    updateQuickMessage(value);
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

  void onSendQuickMessage() {
    if (quickMessage.value != null) {
      messageController.text = quickMessage.value?.content ?? '';
      quickMessage.value = null;
    }
  }

  void pickImages({bool isGroup = false}) async {
    isTickers.value = false;
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isEmpty) return;

    imageBytes.value = await pickedFiles.first.readAsBytes();
    imageName.value = pickedFiles.first.name;
    for (var file in pickedFiles) {
      if (imageFile.length >= 3) {
        imageFile.removeLast();
      }
      imageFile.insert(0, file);
    }

    if (isGroup == true) {
      onSendGroupMessage();
    } else {
      onSendMessage();
    }
  }

  Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null);
  var imageName = ''.obs;

  Rx<Uint8List?> fileBytes = Rx<Uint8List?>(null);
  var fileName = ''.obs;

  Future<void> pickedFile({bool isGroup = false}) async {
    isTickers.value = false;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile platformFile = result.files.first;

      fileBytes.value = platformFile.bytes!;
      fileName.value = platformFile.name;

      log("File selected: ${platformFile.name}");

      if (fileBytes.value != null && fileName.value.isNotEmpty) {
        if (isGroup == true) {
          onSendGroupMessage();
        } else {
          onSendMessage();
        }
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
      final fileBytes = this.fileBytes.value;
      final fileName = this.fileName.value;
      final imageBytes = this.imageBytes.value;
      final imageName = this.imageName.value;

      final tempFiles = imageFile.isNotEmpty
          ? imageFile
              .map((file) => FilesModels(
                    id: DateTime.now().millisecondsSinceEpoch,
                    fileUrl: file.path,
                    fileType: file.path.resolveMimeType,
                    isLocal: true,
                  ))
              .toList()
          : (fileBytes != null && fileName.isNotEmpty)
              ? [
                  FilesModels(
                    id: DateTime.now().millisecondsSinceEpoch,
                    fileUrl: fileBytes.toString() + fileName,
                    fileType: fileName.resolveMimeType,
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
        chatId: messageModel.value?.chat?.id,
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

      _sendAndUpdateMessageLocal(
        tempMessage,
        messageText,
        imageFile,
        replyMessageLocal,
        tempSticker,
        fileBytes,
        fileName,
        imageBytes,
        imageName,
      );
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
    Uint8List? fileBytes,
    String? fileName,
    Uint8List? imageBytes,
    String? imageName,
  ) async {
    try {
      final otherUsers = messageModel.value?.chat?.users
          ?.firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id);

      Map<String, String> params = {
        "receiver_id": otherUsers?.id.toString() ?? '',
        if (messageText.isNotEmpty) "message": messageText,
        if (reply != null) "reply_message_id": reply.id.toString(),
        if (sticker != null) "sticker_id": sticker.id.toString(),
      };

      List<MultipartBody> multipartBody = [
        if (imageFile.isNotEmpty)
          ...imageFile.map(
            (file) => MultipartBody.web('files[]', imageBytes!, imageName),
          ),

        // if (imageFile.isNotEmpty) ...imageFile.map((file) => MultipartBody('files[]', file)),
        // if (selectedFile.value != null) MultipartBody('files[]', selectedFile.value),
        if (fileBytes != null && (fileName ?? '').isNotEmpty) MultipartBody.web('files[]', fileBytes, fileName),
      ];

      final response = await messagesRepository.sendMessage(params, multipartBody);

      if (response.statusCode == 200) {
        messageData.value = MessageDataModel.fromJson(response.body['data']);

        messageModel.value?.listMessages?.removeWhere((msg) => msg.id == tempMessage.id);
        onInsertMessage(messageData.value!);
      } else {
        replaceTemporaryMessage(tempMessage.id!, tempMessage.copyWith(status: MessageStatus.failed));
      }
    } catch (e, a) {
      print(e);
      log(a.toString(), name: 'ERROR_SEND_MESSAGE');
    }
  }

  void onInsertMessage(MessageDataModel newMessages) {
    final currentList = messageModel.value?.listMessages ?? [];
    currentList.removeWhere((msg) => msg.id == newMessages.id);

    messageModel.value = messageModel.value?.copyWith(
      listMessages: messageModel.value?.listMessages?..insert(0, newMessages),
    );
    messageModel.refresh();
    updateChatLastMessage(newMessages, isRead: false);
  }

  void replaceTemporaryMessage(int tempId, MessageDataModel newMessage) {
    int index = (messageModel.value?.listMessages ?? []).indexWhere((msg) => msg.id == tempId);
    if (index != -1) {
      messageModel.value?.listMessages?[index] = newMessage;
      messageModel.refresh();
    }
  }

  void clearMessage() {
    messageController.clear();
    imageFile.clear();
    messageValue.value = '';
    messageReply.value = null;
    selectedTickers.value = null;
    fileBytes.value = null;
    fileName.value = '';
    imageBytes.value = null;
    imageName.value = '';
  }

  void scrollToBottom() {
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

  void onReplyMessage(MessageDataModel message) {
    messageReply.value = message;
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

  void addFriend() async {
    try {
      isLoadingAddFriend.value = true;

      List<UserModel> filteredUsers = (messageModel.value?.chat?.users ?? [])
          .where((user) => user.id != Get.find<ProfileController>().user.value?.id)
          .toList();

      if (filteredUsers.isEmpty) return;

      final response = await contactRepository.addFriend(filteredUsers.first.id!);

      if (response.statusCode == 200) {
        messageModel.value = messageModel.value?.copyWith(isSenderRequestFriend: true);
        messageModel.refresh();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingAddFriend.value = false;
    }
  }

  void removeFriend() async {
    try {
      isLoadingRemoveFriend.value = true;

      final requestFriend = messageModel.value?.requestFriend;
      if (requestFriend == null) return;

      final response = await contactRepository.removeFriend(requestFriend.id!);

      if (response.statusCode == 200) {
        messageModel.value = messageModel.value?.copyWith(isSenderRequestFriend: false);
        messageModel.refresh();

        // fetchChatList(messageModel.value?.chat?.id ?? chatId!, isShowLoad: false);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingRemoveFriend.value = false;
    }
  }

  void cancelFriendRequest(int chatId) async {
    try {
      isLoadingCancelFriend.value = true;

      final requestFriend = messageModel.value?.requestFriend;
      if (requestFriend == null) return;

      final response = await contactRepository.cancelFriendRequest(requestFriend.id!);

      if (response.statusCode == 200) {
        messageModel.value = messageModel.value?.copyWith(
          isFriend: false,
          isSenderRequestFriend: false,
          isReceiverIdRequestFriend: false,
        );
        messageModel.refresh();
        // fetchChatList(messageModel.value?.chat?.id ?? chatId!, isShowLoad: false);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingCancelFriend.value = false;
    }
  }

  void acceptFriendRequest(int chatId) async {
    try {
      isLoadingAcceptFriend.value = true;

      final requestFriend = messageModel.value?.requestFriend;
      if (requestFriend == null) return;

      final response = await contactRepository.acceptFriendRequest(requestFriend.id!);

      if (response.statusCode == 200) {
        messageModel.value = messageModel.value?.copyWith(isFriend: true);
        messageModel.refresh();
        // fetchChatList(messageModel.value?.chat?.id ?? chatId!, isShowLoad: false);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingAcceptFriend.value = false;
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

  String calculateCallDuration(String startTime, String endTime) {
    DateTime start = DateFormat(DateConstants.yyyyMMddMMmmss).parse(startTime);
    DateTime end = DateFormat(DateConstants.yyyyMMddMMmmss).parse(endTime);

    Duration duration = end.difference(start);

    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;

    if (minutes > 0) {
      return "$minutes phút ${seconds > 0 ? '$seconds giây' : ''}";
    } else {
      return "$seconds giây";
    }
  }

  String getChatAvatar(ChatDataModel? chat) =>
      (chat?.users ?? []).firstWhereOrNull((u) => u.id != Get.find<ProfileController>().user.value?.id)?.avatar ?? '';

  void _initStreamMessage() {
    _chatSubscriptionMessage = PusherService().stream.listen(
      (event) {
        if (event is PusherEvent) {
          try {
            if (event.data is Map<String, dynamic>) {
              final jsons = event.data as Map<String, dynamic>;
              _processEventData(jsons);
            } else if (event.data is String) {
              final jsons = json.decode(event.data) as Map<String, dynamic>;
              _processEventData(jsons);
            } else {
              Map<String, dynamic> jsons = jsonDecode(jsonEncode(event.data)) as Map<String, dynamic>;
              _processEventData(jsons);

              log('Received data is not Map or String: ${event.data.runtimeType}',
                  name: 'ERROR_STREAM_EVENT_MESSAGE_TYPE_NOT_MAP_OR_STRING');
            }
          } catch (e) {
            log('Error while processing event: $e', name: 'ERROR_STREAM_EVENT_MESSAGE');
          }
        }
      },
    );
  }

  void _processEventData(Map<String, dynamic> jsons) {
    try {
      if (jsons['payload']['data']['chat_id'] == messageModel.value?.chat?.id) {
        final message = PusherMesageModel.fromJson(jsons);
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
      log('Error while processing event data: $e', name: 'ERROR_STREAM_EVENT_MESSAGE_PROCESSING_DATA');
    }
  }

  /* ================================================== */

  void onSendGroupMessage() async {
    try {
      final messageText = messageController.text.trim();
      final imageFile = this.imageFile.toList();
      final replyMessageLocal = messageReply.value;
      final fileBytes = this.fileBytes.value;
      final fileName = this.fileName.value;
      final imageBytes = this.imageBytes.value;
      final imageName = this.imageName.value;

      final tempFiles = imageFile.isNotEmpty
          ? imageFile
              .map((file) => FilesModels(
                    id: DateTime.now().millisecondsSinceEpoch,
                    fileUrl: file.path,
                    fileType: file.path.resolveMimeType,
                    isLocal: true,
                  ))
              .toList()
          : (fileBytes != null && fileName.isNotEmpty)
              ? [
                  FilesModels(
                    id: DateTime.now().millisecondsSinceEpoch,
                    fileUrl: fileBytes.toString() + fileName,
                    fileType: fileName.resolveMimeType,
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
        chatId: messageModel.value?.chat?.id,
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

      _sendAndUpdateGroupMessageLocal(
        tempMessage,
        messageText,
        imageFile,
        replyMessageLocal,
        tempSticker,
        fileBytes,
        fileName,
        imageBytes,
        imageName,
      );
      scrollToBottom();
    } catch (e) {
      print(e);
    }
  }

  void _sendAndUpdateGroupMessageLocal(
    MessageDataModel tempMessage,
    String messageText,
    List<XFile> imageFile,
    MessageDataModel? reply,
    TickersModel? sticker,
    Uint8List? fileBytes,
    String? fileName,
    Uint8List? imageBytes,
    String? imageName,
  ) async {
    try {
      Map<String, String> params = {
        "chat_id": messageModel.value?.chat?.id.toString() ?? '',
        if (messageText.isNotEmpty) "message": messageText,
        if (reply != null) "reply_message_id": reply.id.toString(),
        if (sticker != null) "sticker_id": sticker.id.toString(),
      };

      List<MultipartBody> multipartBody = [
        // if (imageFile.isNotEmpty) ...imageFile.map((file) => MultipartBody('files[]', file)),
        if (imageFile.isNotEmpty)
          ...imageFile.map(
            (file) => MultipartBody.web('files[]', imageBytes!, imageName),
          ),
        // if (selectedFile.value != null) MultipartBody('files[]', selectedFile.value),
        if (fileBytes != null && (fileName ?? '').isNotEmpty) MultipartBody.web('files[]', fileBytes, fileName),
      ];

      final response = await groupsRepository.sendMessageGroup(params, multipartBody);

      if (response.statusCode == 200) {
        messageData.value = MessageDataModel.fromJson(response.body['data']);
        // if (messageModel.value != null) {
        // fetchChatList(messageData.value!.chatId!, isShowLoad: false);
        // messageModel.value?.listMessages?.removeWhere((msg) => msg.id == tempMessage.id);
        // onInsertMessage(messageData.value!);
        // } else {
        messageModel.value?.listMessages?.removeWhere((msg) => msg.id == tempMessage.id);
        onInsertMessage(messageData.value!);
        // }
      } else {
        replaceTemporaryMessage(tempMessage.id!, tempMessage.copyWith(status: MessageStatus.failed));
      }
    } catch (e) {
      print(e);
    }
  }

  void onSearchMessage(String value, {bool isGroup = false}) async {
    if (value.isEmpty) return;
    try {
      isLoadingSearch.value = true;
      final response = await messagesRepository.messageList(messageModel.value!.chat!.id!, search: value);

      if (response.statusCode == 200) {
        messageSearchModel.value = MessageModels.fromJson(response.body['data']);
        if (messageSearchModel.value != null) {
          if (isGroup == true) {
            Get.toNamed(
              Routes.GROUP_MESSAGE_SEARCH_RESULT,
              arguments: GroupMessageSearchParameter(searchMessage: messageSearchModel.value!),
            );
          } else {
            if (messageSearchModel.value != null) {
              Get.toNamed(
                Routes.MESSAGE_SEARCH_RESULT,
                arguments: MessageSearchParameter(searchMessage: messageSearchModel.value!),
              );
            }
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      if (value.isNotEmpty) isLoadingSearch.value = false;
    }
  }

  Future<void> fetchChatListMessageUntilPage({
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
            isFriend: model.isFriend,
            isSenderRequestFriend: model.isSenderRequestFriend,
            isReceiverIdRequestFriend: model.isReceiverIdRequestFriend,
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

  void clearHideMessage() {
    messageSearchModel.value = null;
    messageValue.value = '';
    messageController.clear();
    imageFile.clear();
    messageReply.value = null;
    selectedTickers.value = null;
    fileBytes.value = null;
    fileName.value = '';
    imageBytes.value = null;
    imageName.value = '';
    messageModel.value = null;
    messageData.value = null;
    messageModel.refresh();
    isGroup.value = false;
  }

  @override
  void dispose() {
    super.dispose();
    _chatSubscription?.cancel();
    _chatSubscriptionMessage?.cancel();
    searchController.dispose();
  }
}
