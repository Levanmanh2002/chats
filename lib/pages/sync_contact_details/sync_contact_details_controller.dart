import 'package:chats/models/sync_contact/sync_contact_model.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:get/get.dart';

class SyncContactDetailsController extends GetxController {
  final IContactRepository contactRepository;

  SyncContactDetailsController({required this.contactRepository});

  var isLoading = false.obs;

  Rx<SyncContactModel?> syncContactModel = Rx<SyncContactModel?>(null);

  var searchValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSyncContacts();
  }

  Future<void> fetchSyncContacts({bool isRefresh = true, String search = ''}) async {
    try {
      if (isRefresh) isLoading.value = true;

      final response = await contactRepository.getSyncContacts(
        page: isRefresh ? 1 : (syncContactModel.value?.totalPage ?? 1) + 1,
        limit: 10,
        search: search,
      );

      if (response.statusCode == 200) {
        final model = SyncContactModel.fromJson(response.body['data']);

        syncContactModel.value = SyncContactModel(
          contacts: [
            if (!isRefresh) ...(syncContactModel.value?.contacts ?? []),
            ...(model.contacts ?? []),
          ],
          totalPage: model.totalPage,
          totalCount: model.totalCount,
          page: model.page,
          size: model.size,
          lastSyncContacts: model.lastSyncContacts,
        );
      }
    } catch (e) {
      print(e);
    } finally {
      if (isRefresh) isLoading.value = false;
    }
  }

  void onSearch(String value) {
    searchValue.value = value;
    if (value.isEmpty) {
      fetchSyncContacts();
    }
  }
}
