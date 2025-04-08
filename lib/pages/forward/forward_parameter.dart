import 'package:chats/models/messages/files_models.dart';

class ForwardParameter {
  final int? messageId;
  final String? message;
  final List<FilesModels>? files;

  const ForwardParameter({
    this.messageId,
    this.message,
    this.files,
  });
}
