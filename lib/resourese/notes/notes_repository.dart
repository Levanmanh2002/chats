import 'package:chats/resourese/notes/inotes_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class NotesRepository extends INotesRepository {
  @override
  Future<Response> getCategoriesList() async {
    try {
      final result = await clientGetData(AppConstants.noteCategorieUri);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> getNotesList({int page = 1, required int categoryId}) async {
    try {
      final result = await clientGetData(
        '${AppConstants.noteListUri}?page=$page&limit=${AppConstants.LIMIT}&category_id=$categoryId',
      );

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> notesUpcoming({int page = 1}) async {
    try {
      final result = await clientGetData('${AppConstants.noteUpcomingUri}?page=$page&limit=${AppConstants.LIMIT}');

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> noteDetail(int id) async {
    try {
      final result = await clientGetData(AppConstants.noteDetail(id));

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> createNotes({
    String title = '',
    String content = '',
    required int categoryId,
    String reminderAt = '',
  }) async {
    try {
      final body = {
        'title': title,
        'content': content,
        'category_id': categoryId,
        'reminder_at': reminderAt,
      };
      final result = await clientPostData(AppConstants.createNotesUri, body);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> deleteNotes(int noteId) async {
    try {
      final result = await clientDeleteData(AppConstants.deleteNotesUri(noteId));

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> updateNotes({
    required int id,
    String title = '',
    String content = '',
    required int categoryId,
    String reminderAt = '',
  }) async {
    try {
      final body = {
        'title': title,
        'content': content,
        'category_id': categoryId,
        'reminder_at': reminderAt,
      };
      final result = await clientPostData(AppConstants.updateNotesUri(id), body);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
