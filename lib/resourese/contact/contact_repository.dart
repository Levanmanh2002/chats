import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ContactRepository extends IContactRepository {
  @override
  Future<Response> searchContactPhone(String phone) async {
    try {
      final result = await clientPostData(AppConstants.searchContactPhoneUri, {
        "search": phone,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> findAccount(String phone) async {
    try {
      final result = await clientPostData(AppConstants.findAccountUri, {
        "search": phone,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> addFriend(int id) async {
    try {
      final result = await clientPostData(AppConstants.addFriendUri, {
        "user_id": id,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> removeFriend(int id) async {
    try {
      final result = await clientPostData(AppConstants.removeFriendUri, {
        "id": id,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> getReceived({required int page, required int limit}) async {
    try {
      final result = await clientGetData("${AppConstants.getReceivedRequestContactUri}?page=$page&size=$limit");

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> getSent({required int page, required int limit}) async {
    try {
      final result = await clientGetData("${AppConstants.getSentRequestContactUri}?page=$page&size=$limit");

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> cancelFriendRequest(int id) async {
    try {
      final result = await clientPostData(AppConstants.cancelFriendRequestUri, {
        "id": id,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> acceptFriendRequest(int id) async {
    try {
      final result = await clientPostData(AppConstants.acceptFriendRequestUri, {
        "id": id,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> getContactAccepted() async {
    try {
      final result = await clientGetData(AppConstants.contactAcceptedUri);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> unfriend(int id) async {
    try {
      final result = await clientPostData(AppConstants.unfriendUri, {
        'id': id,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
