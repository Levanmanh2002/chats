import 'package:chats/resourese/ibase_repository.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ProfileRepository extends IProfileRepository {
  @override
  Future<Response> profile() async {
    try {
      final result = await clientGetData(AppConstants.profileUri);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> logout() async {
    try {
      final result = await clientPostData(AppConstants.logoutUri, {});

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> updateAvatar(List<MultipartBody> multipartBody) async {
    try {
      final result = await clientPostMultipartData(AppConstants.updateAvatarUri, {}, multipartBody);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
