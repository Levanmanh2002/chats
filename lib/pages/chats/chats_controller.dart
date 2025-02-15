import 'package:chats/models/chats/chats_models.dart';
import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/resourese/chats/ichats_repository.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController with GetSingleTickerProviderStateMixin {
  final IChatsRepository chatsRepository;

  ChatsController({required this.chatsRepository});

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
}
