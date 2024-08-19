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

  static Future<List<File?>> galleryImageSelect() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100,
        maxHeight: 1000,
        maxWidth: 1000);
    if (pickedFile == null || pickedFile == []) {
      return [];
    }

    List<File> selectedImages = [];

    List<XFile> filePick = pickedFile;

    if (filePick.isNotEmpty) {
      for (var i = 0; i < filePick.length; i++) {
        selectedImages.add(File(filePick[i].path));
      }

      return selectedImages;
  } else {
      return [];
    }
    }
}
