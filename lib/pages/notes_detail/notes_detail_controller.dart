import 'package:chats/models/notes/note_model.dart';
import 'package:chats/pages/notes/notes_controller.dart';
import 'package:chats/pages/notes_detail/notes_detail_parameter.dart';
import 'package:chats/resourese/notes/inotes_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class NotesDetailController extends GetxController {
  final NotesDetailParameter parameter;
  final INotesRepository notesRepository;
  final NotesController notesController;

  NotesDetailController({required this.parameter, required this.notesRepository, required this.notesController});

  Rx<NoteItem?> noteDetail = Rx<NoteItem?>(null);

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNoteDetail();
  }

  void fetchNoteDetail() async {
    try {
      isLoading.value = true;

      final response = await notesRepository.noteDetail(parameter.noteId);

      if (response.statusCode == 200) {
        noteDetail.value = NoteItem.fromJson(response.body['data']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void deleteNote() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await notesRepository.deleteNotes(parameter.noteId);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        notesController.removeNote(parameter.noteId);
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
  
}
