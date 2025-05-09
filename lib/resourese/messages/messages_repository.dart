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
      final result = await clientPostMultipartData(AppConstants.sendMessageUri, body, multipartBody);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> messageList(int chatId, {int page = 1, int limit = 10, String search = ''}) async {
    try {
      final result = await clientGetData(AppConstants.messageList(chatId, page: page, limit: limit, search: search));

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> heartMessage(int messageId) async {
    try {
      final result = await clientPostData(AppConstants.heartMessage(messageId), {});

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> revokeMessage(int messageId) async {
    try {
      final result = await clientPostData(AppConstants.revokeMessage(messageId), {});

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> addInstantMess(Map<String, dynamic> params) async {
    try {
      final result = await clientPostData(AppConstants.addInstantMessUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> getInstantMess(int? chatId) async {
    try {
      Response<dynamic> result;
      if (chatId != null) {
        result = await clientGetData('${AppConstants.getQuickMessageUri}?chat_id=$chatId');
      } else {
        result = await clientGetData(AppConstants.getQuickMessageUri);
      }

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> updateInstantMess(Map<String, dynamic> params) async {
    try {
      final result = await clientPostData(AppConstants.updateInstantMessUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> deleteInstantMess(int id) async {
    try {
      final result = await clientDeleteData('${AppConstants.deleteInstantMessUri}?id=$id');

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> getImageFileByChatId(int chatId, String type, {int page = 1, int limit = 10}) async {
    try {
      final result = await clientGetData(AppConstants.getImageFileByChatId(chatId, type, page: page, limit: limit));

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> deleteChat(int chatId) async {
    try {
      final result = await clientDeleteData(AppConstants.deleteChat(chatId));

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> generateToken(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.generateTokentUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> initCall(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.initCallUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> rejectCall(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.rejectCallUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> joinCall(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.joinCallUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> endCall(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.endCallUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> hideChat(int chatId) async {
    try {
      final result = await clientPostData(AppConstants.hideChatUri, {'chat_id': chatId});

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> exportMessage(int chatId, {required String startDate, required String endDate}) async {
    try {
      final result = await clientPostData(AppConstants.exportMessageUri, {
        'chat_id': chatId,
        'start_date': startDate,
        'end_date': endDate,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> changePrimaryName(int userId, String name) async {
    try {
      final result = await clientPostData(
        AppConstants.changePrimaryNameUri,
        {"user_id": userId, "primary_name": name},
      );

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
  
  @override
  Future<Response> checkCall(Map<String, String> params) async{
    try {
      final result = await clientPostData(AppConstants.checkCallUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
