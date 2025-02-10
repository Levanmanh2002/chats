import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ContactRepository extends IContactRepository {
  @override
  Future<Response> searchContactPhone(String phone) async {
    try {
      final result = await clientGetData(AppConstants.searchContactPhoneUri + phone);

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
}
