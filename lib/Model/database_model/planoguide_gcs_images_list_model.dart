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

class TransOnePlusOneGcsImagesListModel {
  late int id;
  late String imageName;
  late String docImageName;
  File? imageFile;
  File? docImageFile;

  TransOnePlusOneGcsImagesListModel({
    required this.id,
    required this.imageFile,
    required this.imageName,
    required this.docImageName,
    required this.docImageFile,
  });
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "image_name": imageName,
      "doc_image": imageName,
    };
  }

}