import 'package:chats/resourese/ibase_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class MessagesRepository extends IMessagesRepository {
  @override
  Future<Response> getIdChatByUser(int userId) async {
    try {
      final result = await clientGetData(AppConstants.getIdChatByUser(userId));

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> sendMessage(Map<String, String> body, List<MultipartBody> multipartBody) async {
    try {
      final result = await clientPostMultipartData(AppConstants.sendMessage, body, multipartBody);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> chatList(int chatId, {int page = 1, int limit = 10}) async {
    try {
      final result = await clientGetData(AppConstants.chatList(chatId, page: page, limit: limit));

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
