import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/pages/make_friends/make_friends_parameter.dart';
import 'package:chats/pages/message/message_parameter.dart';
import 'package:chats/pages/sent_request_contact/sent_request_contact_controller.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:get/get.dart';

class MakeFriendsController extends GetxController {
  final IContactRepository contactRepository;
  final IMessagesRepository messagesRepository;
  final MakeFriendsParameter parameter;

  UserModel? get contact => parameter.contact;

  MakeFriendsController({required this.contactRepository, required this.messagesRepository, required this.parameter});

  var isLoadingAdd = false.obs;
  var isLoadingRemove = false.obs;
  var isLoadingUnfriend = false.obs;
  var isLoadingMessage = false.obs;

  void addFriend() async {
    try {
      if (contact == null) return;
      isLoadingAdd.value = true;

      final response = await contactRepository.addFriend(parameter.id);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingAdd.value = false;
    }
  }

  void removeFriend() async {
    try {
      if (contact == null) return;
      isLoadingRemove.value = true;

      final response = await contactRepository.removeFriend(parameter.id);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        if (parameter.type == MakeFriendsType.friend) Get.find<SentRequestContactController>().removeSent(parameter.id);
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingRemove.value = false;
    }
  }

  void unfriend() async {
    try {
      if (contact == null) return;
      isLoadingUnfriend.value = true;

      final response = await contactRepository.unfriend(parameter.id);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        if (parameter.type == MakeFriendsType.friend) Get.find<ContactsController>().removeContact(parameter.id);
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingUnfriend.value = false;
    }
  }

  void onMessage() async {
    if (parameter.contact == null) return;
    try {
      isLoadingMessage.value = true;

      final response = await messagesRepository.getIdChatByUser(parameter.contact!.id!);

      if (response.statusCode == 200) {
        Get.toNamed(
          Routes.MESSAGE,
          arguments: MessageParameter(chatId: response.body['data']['id'], contact: contact),
        );
      } else {
        Get.toNamed(
          Routes.MESSAGE,
          arguments: MessageParameter(contact: contact),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingMessage.value = false;
    }
  }
}
