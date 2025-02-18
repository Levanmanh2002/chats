import 'package:chats/resourese/chats/ichats_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ChatsRepository extends IChatsRepository {
  @override
  Future<Response> chatListAll({required int page, required int limit, String search = ''}) async {
    try {
      final result = await clientGetData('${AppConstants.chatListAllUri}?page=$page&limit=$limit&search=$search');

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
