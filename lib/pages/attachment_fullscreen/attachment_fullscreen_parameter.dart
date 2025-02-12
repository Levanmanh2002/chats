import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/profile/user_model.dart';

class AttachmentFullscreenParameter {
  final List<FilesModels>? files;
  final int index;
  final UserModel? user;

  AttachmentFullscreenParameter({this.files, this.index = 0, this.user});
}
