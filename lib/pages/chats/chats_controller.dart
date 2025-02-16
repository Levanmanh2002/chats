import 'package:chats/models/chats/chats_models.dart';
import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/resourese/chats/ichats_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController with GetSingleTickerProviderStateMixin {
  final IChatsRepository chatsRepository;
  final IMessagesRepository messagesRepository;

  ChatsController({required this.chatsRepository, required this.messagesRepository});

  Rx<ChatsModels?> chatsModels = Rx<ChatsModels?>(null);

  var isLoading = false.obs;

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
}
