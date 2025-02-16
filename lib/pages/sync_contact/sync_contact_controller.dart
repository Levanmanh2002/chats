import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SyncContactController extends GetxController {
  final IProfileRepository profileRepository;

  SyncContactController({required this.profileRepository});

  var isLoading = false.obs;
  RxList<Map<String, String>> contactsList = <Map<String, String>>[].obs;

  Future<List<Map<String, String>>> getContactsNameAndPhone() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (!permissionStatus.isGranted) {
      throw Exception("Quyền truy cập danh bạ không được cấp!");
    }

    Iterable<Contact> contacts = await ContactsService.getContacts();

    List<Map<String, String>> formattedContacts = contacts.map((contact) {
      String name = contact.displayName ?? "Không có tên";
      String phone = "";
      if (contact.phones != null && contact.phones!.isNotEmpty) {
        phone = contact.phones!.first.value ?? "";
      }
      return {
        "name": name,
        "phone": phone,
      };
    }).toList();

    contactsList.value = formattedContacts;
    return formattedContacts;
  }

  void syncContacts() async {
    try {
      isLoading.value = true;
      Iterable<Contact> rawContacts = await ContactsService.getContacts();

      List<Map<String, String>> formattedContacts = rawContacts.map((contact) {
        return {
          "contact_name": contact.displayName ?? "Không có tên",
          "phone": (contact.phones?.isNotEmpty ?? false) ? contact.phones?.first.value ?? "" : "",
        };
      }).toList();

      Map<String, dynamic> params = {
        "contacts": formattedContacts,
      };

      final response = await profileRepository.syncContacts(params);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
