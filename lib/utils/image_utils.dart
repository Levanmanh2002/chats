import 'package:chats/utils/dialog_utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static Future<XFile?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final name = pickedFile.name;
      final extension = name.split('.').last.toLowerCase();

      if (['jpeg', 'jpg', 'png', 'gif', 'svg'].contains(extension)) {
        return pickedFile;
      } else {
        DialogUtils.showErrorDialog('invalid_file_format'.tr);
        return null;
      }
    }

    return null;
  }
}
