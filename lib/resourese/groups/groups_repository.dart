import 'dart:convert';

import 'package:chats/resourese/groups/igroups_repository.dart';
import 'package:chats/resourese/ibase_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class GroupsRepository extends IGroupsRepository {
  @override
  Future<Response> createGroup(Map<String, dynamic> params) async {
    try {
      final result = await clientPostData(AppConstants.createGroupUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> sendMessageGroup(Map<String, String> body, List<MultipartBody> multipartBody) async {
    try {
      final result = await clientPostMultipartData(AppConstants.sendMessageGroupUri, body, multipartBody);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> renameGroup(int id, String name) async {
    try {
      final result = await clientPostData(AppConstants.renameGroupUri, {
        "group_id": id,
        "group_name": name,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> addUserToGroup(Map<String, dynamic> params) async {
    try {
      final result = await clientPostData(AppConstants.addUserToGroupUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> removeUserFromGroup(Map<String, dynamic> params) async {
    try {
      final result = await clientDeleteData(AppConstants.removeUserFromGroupUri, body: jsonEncode(params));

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
  
  @override
  Future<Response> transferOwnership(Map<String, dynamic> params)async {
    try {
      final result = await clientPostData(AppConstants.transferOwnershipUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
