import 'package:chats/models/messages/files_models.dart';
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

extension GroupByMonth on List<FilesModels> {
  Map<String, List<FilesModels>> groupByMonth() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    return fold<Map<String, List<FilesModels>>>({}, (map, item) {
      if (item.createdAt == null) return map;
      final date = DateTime.parse(item.createdAt!);
      // final key = '${'month'.tr} ${date.month}/${date.year}';
      final String key;

      if (_isSameDate(date, now)) {
        key = 'today'.tr;
      } else if (_isSameDate(date, yesterday)) {
        key = 'yesterday'.tr;
      } else {
        key = '${'month'.tr} ${date.month}/${date.year}';
      }

      (map[key] ??= []).add(item);
      return map;
    });
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
