import 'package:chats/extension/date_time_extension.dart';
import 'package:chats/models/notes/note_category_model.dart';
import 'package:chats/models/notes/note_model.dart';
import 'package:chats/resourese/notes/inotes_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/widget/dialog/show_notes_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class NotesController extends GetxController {
  final INotesRepository notesRepository;

  NotesController({required this.notesRepository});

  RxList<NoteCategoryModel> categories = <NoteCategoryModel>[].obs;
  Rx<NoteCategoryModel?> selectedCategory = Rx<NoteCategoryModel?>(null);

  Rx<NoteModels?> notes = Rx<NoteModels?>(null);
  Rx<NoteModels?> upcomingNotes = Rx<NoteModels?>(null);

  Rx<DateTime?> selectedReminder = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchUpcomingNotes();
  }

  void fetchCategories() async {
    try {
      final response = await notesRepository.getCategoriesList();

      if (response.statusCode == 200) {
        categories.value = NoteCategoryModel.listFromJson(response.body['data']);
        selectedCategory.value = categories.first;
        fetchNotes();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchNotes({bool isRefresh = true}) async {
    try {
      final response = await notesRepository.getNotesList(
        page: isRefresh ? 1 : (notes.value?.page ?? 1) + 1,
        categoryId: selectedCategory.value?.id ?? categories.first.id!,
      );

      if (response.statusCode == 200) {
        final model = NoteModels.fromJson(response.body['data']);

        notes.value = NoteModels(
          notes: [
            if (!isRefresh) ...(notes.value?.notes ?? []),
            ...(model.notes ?? []),
          ],
          totalPage: model.totalPage,
          totalCount: model.totalCount,
          page: model.page,
          size: model.size,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchUpcomingNotes({bool isRefresh = true}) async {
    try {
      final response = await notesRepository.notesUpcoming(
        page: isRefresh ? 1 : (upcomingNotes.value?.page ?? 1) + 1,
      );

      if (response.statusCode == 200) {
        final model = NoteModels.fromJson(response.body['data']);

        upcomingNotes.value = NoteModels(
          notes: [
            if (!isRefresh) ...(upcomingNotes.value?.notes ?? []),
            ...(model.notes ?? []),
          ],
          totalPage: model.totalPage,
          totalCount: model.totalCount,
          page: model.page,
          size: model.size,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void createNote({
    String title = '',
    String content = '',
    required int categoryId,
  }) async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await notesRepository.createNotes(
        title: title,
        content: content,
        categoryId: categoryId,
        reminderAt: selectedReminder.value?.toyyyyMMdd ?? '',
      );

      if (response.isOk) {
        DialogUtils.showSuccessDialog(response.body['message']);
        await fetchNotes();
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void updateNote({
    required int id,
    String title = '',
    String content = '',
    required int categoryId,
  }) async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await notesRepository.updateNotes(
        id: id,
        title: title,
        content: content,
        categoryId: categoryId,
        reminderAt: selectedReminder.value?.toyyyyMMdd ?? '',
      );

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        await fetchNotes();
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void loadNoteListToCategory(NoteCategoryModel category) async {
    selectCategory(category);

    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);
      await fetchNotes();
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void selectCategory(NoteCategoryModel? category) {
    selectedCategory.value = category;
  }

  void selectReminder(DateTime? date) {
    selectedReminder.value = date;
  }

  void showAddNote() {
    showNotesDialog(this);
  }

  void showEditNote(NoteItem? note) {
    showNotesDialog(this, note: note);
  }

  void removeNote(int noteId) {
    notes.value?.notes?.removeWhere((element) => element.id == noteId);
    notes.refresh();
  }
}
