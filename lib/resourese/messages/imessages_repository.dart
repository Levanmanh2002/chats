import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IMessagesRepository extends IBaseRepository {
  Future<Response> getIdChatByUser(int userId);
  Future<Response> sendMessage(Map<String, String> body, List<MultipartBody> multipartBody);
  Future<Response> messageList(int chatId, {int page = 1, int limit = 10, String search = ''});
  Future<Response> revokeMessage(int messageId);
  Future<Response> heartMessage(int messageId);
  Future<Response> addInstantMess(Map<String, dynamic> params);
  Future<Response> getInstantMess(int chatId);
  Future<Response> updateInstantMess(Map<String, dynamic> params);
  Future<Response> deleteInstantMess(int id);
  Future<Response> getImageFileByChatId(int chatId, String type, {int page = 1, int limit = 10});
  Future<Response> deleteChat(int chatId);

  Future<Response> generateToken(Map<String, String> params);
  Future<Response> initCall(Map<String, String> params);
  Future<Response> rejectCall(Map<String, String> params);
  Future<Response> joinCall(Map<String, String> params);
  Future<Response> endCall(Map<String, String> params);

  Future<Response> hideChat(int chatId);
  Future<Response> exportMessage(int chatId, {required String startDate, required String endDate});

  Future<Response> changePrimaryName(int userId, String name);
}
