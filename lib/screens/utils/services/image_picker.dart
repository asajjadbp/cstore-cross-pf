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
    XFile waterMarkFile = await addWatermark(XFile(image.path),DateTime.now().toString());
    print(waterMarkFile.path);
    print(waterMarkFile.name);
    File imageFile = File(waterMarkFile.path);
    return imageFile;
  }
}
