import 'dart:io';
import 'package:cstore/screens/utils/services/take_image_and_save_to_folder.dart';
import 'package:image_picker/image_picker.dart';

class ImageTakingService {
  static Future<File?> imageSelect() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 55);
    if (image == null) {
      return null;
    }

    return File(image.path);
  }
}
