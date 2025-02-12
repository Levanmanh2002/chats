import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IContactRepository extends IBaseRepository {
  Future<Response> searchContactPhone(String phone);
  Future<Response> findAccount(String phone);
  Future<Response> addFriend(int id);
  Future<Response> removeFriend(int id);
  Future<Response> getReceived({required int page, required int limit});
  Future<Response> getSent({required int page, required int limit});
  Future<Response> cancelFriendRequest(int id);
  Future<Response> acceptFriendRequest(int id);
  Future<Response> getContactAccepted({required int page, required int limit});
  Future<Response> unfriend(int id);
}
