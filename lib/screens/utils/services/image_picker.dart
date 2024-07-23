import 'dart:io';
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
