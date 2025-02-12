import 'package:chats/models/chats/chat_models.dart';
import 'package:chats/pages/message/message_parameter.dart';
import 'package:chats/resourese/ibase_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MessageController extends GetxController {
  final IMessagesRepository messagesRepository;
  final MessageParameter parameter;

  MessageController({required this.messagesRepository, required this.parameter});

  final TextEditingController messageController = TextEditingController();

  var isLoadingSendMess = false.obs;

  var imageFile = <XFile>[].obs;

  var messageValue = ''.obs;

  Rx<ChatModels?> chatModels = Rx<ChatModels?>(null);
  Rx<Message?> message = Rx<Message?>(null);

  @override
  void onInit() {
    super.onInit();
    if (parameter.id != null) {
      fetchChatList(parameter.id!);
    }
  }

  void fetchChatList(int chatId, {bool isRefresh = true}) async {
    try {
      final response = await messagesRepository.chatList(
        chatId,
        page: isRefresh ? 1 : (chatModels.value?.totalPage ?? 1) + 1,
        limit: 10,
      );
      if (response.statusCode == 200) {
        final model = ChatModels.fromJson(response.body['data']);

        chatModels.value = ChatModels(
          listMessages: [
            if (!isRefresh) ...(chatModels.value?.listMessages ?? []),
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
    }
  }

  void updateMessage(String value) {
    messageValue.value = value;
  }

  void pickImages() async {
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      imageFile.addAll(pickedFiles);
      // onSendMessage();
    }
  }

  void onSendMessage() async {
    try {
      isLoadingSendMess.value = true;

      Map<String, String> params = {
        "receiver_id": parameter.contact?.id.toString() ?? '',
        "message": messageController.text.trim(),
      };

      List<MultipartBody> multipartBody = [
        if (imageFile.isNotEmpty) ...imageFile.map((file) => MultipartBody('files[]', file)),
      ];

      final response = await messagesRepository.sendMessage(params, multipartBody);

      if (response.statusCode == 200) {
        message.value = Message.fromJson(response.body['data']);
        clearMessage();
        if (chatModels.value != null) {
          fetchChatList(message.value!.chatId!, isRefresh: false);
          onInsertMessage(message.value!);
        } else {
          onInsertMessage(message.value!);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingSendMess.value = false;
    }
  }

  void onInsertMessage(Message newMessages) {
    chatModels.value = chatModels.value?.copyWith(
      listMessages: chatModels.value?.listMessages?..insert(0, newMessages),
    );
    chatModels.refresh();
  }

  void clearMessage() {
    messageController.clear();
    imageFile.clear();
    messageValue.value = '';
  }
}
