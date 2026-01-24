import 'package:chats/models/chat_tags/chat_tags_model.dart';
import 'package:chats/resourese/chats/ichats_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ChatsRepository extends IChatsRepository {
  @override
  Future<Response> chatListAll({
    required int page,
    required int limit,
    String search = '',
    List<int>? tagId,
  }) async {
    try {
      // String numberWithCountryCode =
      //     PhoneCodeModel().getCodeAsString() + (search.startsWith('0') ? search.substring(1) : search);

      String formatPhone(String search) {
        if (search.length == 4) return search;

        if (search.length > 8) {
          if (search.startsWith('0')) {
            return '+84${search.substring(1)}';
          } else if (search.startsWith('+84')) {
            return search;
          } else {
            return '+84$search';
          }
        }

        return search;
      }

      final phone = formatPhone(search);

      String uri = '${AppConstants.chatListAllUri}?page=$page&limit=$limit&search=$phone';

      if (tagId != null && tagId.isNotEmpty) {
        final tagsQuery = tagId.map((e) => 'tag_ids[]=$e').join('&');
        uri += '&$tagsQuery';
      }

      final result = await clientGetData(uri);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> sendForwardMessage({required int chatId, required int messageId}) async {
    try {
      final result = await clientPostData(
        AppConstants.sendForwardMessageUri,
        {'receiver_id': chatId, 'message_id': messageId},
      );

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> sendForwardGroupMessage({required int chatId, required int messageId}) async {
    try {
      final result = await clientPostData(
        AppConstants.sendForwardGroupMessageUri,
        {'chat_id': chatId, 'message_id': messageId},
      );

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> chatTagsAll({required int page, required int limit, String name = ''}) async {
    try {
      String uri = '${AppConstants.chatTagsAllUri}?page=$page&limit=$limit';

      if (name.isNotEmpty) {
        uri += '&name=$name';
      }

      final result = await clientGetData(uri);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<ChatCategory?> chatTagDetail({required int id}) async {
    try {
      final result = await clientGetData('${AppConstants.chatTagsAllUri}/$id');

      if (result.isOk) {
        return ChatCategory.fromJson(result.body['data']);
      }

      return null;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<ChatCategory?> createChatTag({required String name, String? color, String? icon, int? order}) async {
    try {
      final body = {
        'name': name,
        if (color != null) 'color': color,
        if (icon != null) 'icon': icon,
        if (order != null) 'order': order
      };

      final result = await clientPostData(AppConstants.createChatTagUri, body);

      if (result.isOk) {
        return ChatCategory.fromJson(result.body['data']);
      } else {
        DialogUtils.showErrorDialog(result.body['message'] ?? '');
        return null;
      }
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<ChatCategory?> updateChatTag(
    int id, {
    required String name,
    String? color,
    String? icon,
    int? order,
    bool? isActive,
  }) async {
    try {
      final body = {
        'name': name,
        if (color != null) 'color': color,
        if (icon != null) 'icon': icon,
        if (order != null) 'order': order,
        if (isActive != null) 'is_active': isActive,
      };

      final result = await clientPostData('${AppConstants.chatTagsAllUri}/$id/update', body);

      if (result.isOk) {
        return ChatCategory.fromJson(result.body['data']);
      } else {
        DialogUtils.showErrorDialog(result.body['message'] ?? '');
      }

      return null;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<bool> deleteChatTag({required int id}) async {
    try {
      final result = await clientDeleteData('${AppConstants.chatTagsAllUri}/$id/delete');

      if (!result.isOk) {
        DialogUtils.showErrorDialog(result.body['message'] ?? '');
      }

      return result.isOk;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> assignChatTag({required int chatId, required List<int> tagId}) async {
    try {
      final result = await clientPostData(AppConstants.assignChatTagUri, {'chat_id': chatId, 'tag_ids': tagId});

      if (!result.isOk) {
        DialogUtils.showErrorDialog(result.body['message'] ?? '');
      }

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> removeChatTag({required int chatId, required List<int> tagId}) async {
    try {
      final result = await clientPostData(AppConstants.removeChatTagUri, {'chat_id': chatId, 'tag_ids': tagId});

      if (!result.isOk) {
        DialogUtils.showErrorDialog(result.body['message'] ?? '');
      }

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
