import 'package:chats/models/chat_tags/chat_tags_model.dart';
import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IChatsRepository extends IBaseRepository {
  Future<Response> chatListAll({
    required int page,
    required int limit,
    String search = '',
    List<int>? tagId,
  });
  Future<Response> sendForwardMessage({required int chatId, required int messageId});
  Future<Response> sendForwardGroupMessage({required int chatId, required int messageId});

  Future<Response> chatTagsAll({required int page, required int limit, String name = ''});
  Future<ChatCategory?> chatTagDetail({required int id});
  Future<ChatCategory?> createChatTag({required String name, String? color, String? icon, int? order});
  Future<ChatCategory?> updateChatTag(
    int id, {
    required String name,
    String? color,
    String? icon,
    int? order,
    bool? isActive,
  });
  Future<bool> deleteChatTag({required int id});
  Future<Response> assignChatTag({required int chatId, required List<int> tagId});
  Future<Response> removeChatTag({required int chatId, required List<int> tagId});
}
