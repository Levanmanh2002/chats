import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IMessagesRepository extends IBaseRepository {
  Future<Response> getIdChatByUser(int userId);
  Future<Response> sendMessage(Map<String, String> body, List<MultipartBody> multipartBody);
  Future<Response> chatList(int chatId, {int page = 1, int limit = 10});
}
