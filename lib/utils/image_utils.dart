import 'package:chats/utils/dialog_utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImageUtils {
  static Future<XFile?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileExtension = path.extension(pickedFile.path).toLowerCase();

      if (['.jpeg', '.jpg', '.png', '.gif', '.svg'].contains(fileExtension)) {
        return pickedFile;
      } else {
        DialogUtils.showErrorDialog('invalid_file_format'.tr);
        return null;
      }
    }
    return null;
  }
}
