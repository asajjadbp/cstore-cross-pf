import 'dart:io';

class TransPlanoGuideGcsImagesListModel {
late int id;
late String imageName;
File? imageFile;

TransPlanoGuideGcsImagesListModel({
  required this.id,
  required this.imageFile,
  required this.imageName,
});
Map<String, Object?> toMap() {
  return {
   "id": id,
    "image_name": imageName,
  };
}


}