import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/resourese/chats/ichats_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ChatsRepository extends IChatsRepository {
  @override
  Future<Response> chatListAll({required int page, required int limit, String search = ''}) async {
    try {
      String numberWithCountryCode =
          PhoneCodeModel().getCodeAsString() + (search.startsWith('0') ? search.substring(1) : search);

      final result = await clientGetData(
        '${AppConstants.chatListAllUri}?page=$page&limit=$limit&search=$numberWithCountryCode',
      );

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
}
