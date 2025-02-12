import 'package:chats/models/chats/chats_models.dart';
import 'package:chats/resourese/chats/ichats_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController with GetSingleTickerProviderStateMixin {
  final IChatsRepository chatsRepository;

  ChatsController({required this.chatsRepository});

  late final TabController tabController;

  Rx<ChatsModels?> chatsModels = Rx<ChatsModels?>(null);

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
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
}
