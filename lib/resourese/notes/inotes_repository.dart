import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class INotesRepository extends IBaseRepository {
  Future<Response> getCategoriesList();
  Future<Response> getNotesList({
    int page = 1,
    required int categoryId,
    String startDate = '',
    String endDate = '',
  });
  Future<Response> notesUpcoming({int page = 1});
  Future<Response> noteDetail(int id);
  Future<Response> deleteNotes(int noteId);
  Future<Response> createNotes({
    String title = '',
    String content = '',
    required int categoryId,
    String startDate = '',
    String endDate = '',
  });
  Future<Response> updateNotes({
    required int id,
    String title = '',
    String content = '',
    required int categoryId,
    String startDate = '',
    String endDate = '',
  });
}
