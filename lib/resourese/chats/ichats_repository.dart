import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IChatsRepository extends IBaseRepository {
  Future<Response> chatListAll({required int page, required int limit, String search = ''});
  Future<Response> sendForwardMessage({required int chatId, required int messageId});
  Future<Response> sendForwardGroupMessage({required int chatId, required int messageId});
}
