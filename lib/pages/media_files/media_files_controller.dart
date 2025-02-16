import 'package:chats/models/messages/media_file_model.dart';
import 'package:chats/pages/media_files/media_files_parameter.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaFilesController extends GetxController with GetSingleTickerProviderStateMixin {
  final IMessagesRepository messagesRepository;
  final MediaFilesParameter parameter;

  MediaFilesController({required this.messagesRepository, required this.parameter});

  late final TabController tabController;

  Rx<MediaFileModel?> mediaImageModel = Rx<MediaFileModel?>(null);  
  Rx<MediaFileModel?> mediaFileModel = Rx<MediaFileModel?>(null);

  var isLoadingImage = false.obs;
  var isLoadingFile = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchImages();
    fetchFiles();
  }

  Future<void> fetchImages({bool isRefresh = true}) async {
    if (parameter.chatId == null) return;
    try {
      if (isRefresh) isLoadingImage.value = true;

      final response = await messagesRepository.getImageFileByChatId(
        parameter.chatId!,
        'image',
        page: isRefresh ? 1 : (mediaImageModel.value?.page ?? 1) + 1,
        limit: 10,
      );

      if (response.statusCode == 200) {
        final model = MediaFileModel.fromJson(response.body['data']);

        mediaImageModel.value = MediaFileModel(
          items: [
            if (!isRefresh) ...(mediaImageModel.value?.items ?? []),
            ...(model.items ?? []),
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
      if (isRefresh) isLoadingImage.value = false;
    }
  }

  Future<void> fetchFiles({bool isRefresh = true}) async {
    if (parameter.chatId == null) return;
    try {
      if (isRefresh) isLoadingFile.value = true;

      final response = await messagesRepository.getImageFileByChatId(
        parameter.chatId!,
        'file',
        page: isRefresh ? 1 : (mediaFileModel.value?.totalPage ?? 1) + 1,
        limit: 10,
      );

      if (response.statusCode == 200) {
        final model = MediaFileModel.fromJson(response.body['data']);

        mediaFileModel.value = MediaFileModel(
          items: [
            if (!isRefresh) ...(mediaFileModel.value?.items ?? []),
            ...(model.items ?? []),
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
      if (isRefresh) isLoadingFile.value = false;
    }
  }
}
