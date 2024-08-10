
class SaveOtherPhoto {
  final String username;
  final String workingId;
  final String workingDate;
  final String storeId;
  final List<SaveOtherPhotoData> images;

  SaveOtherPhoto({
    required this.username,
    required this.workingId,
    required this.workingDate,
    required this.storeId,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'working_date':workingDate,
      'store_id': storeId,
      'images': images.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveOtherPhotoData {
  final int transPhotoId;
  final int clientId;
  final int categoryId;
  final int typeId;
  final String imageName;

  SaveOtherPhotoData({
    required this.transPhotoId,
    required this.clientId,
    required this.categoryId,
    required this.typeId,
    required this.imageName,
  });

  Map<String, dynamic> toJson() {
    return {
      'trans_photo_id': transPhotoId,
      'client_id': clientId,
      'cat_id': categoryId,
      'photo_type_id': typeId,
      'image_name': imageName,
    };
  }
}
