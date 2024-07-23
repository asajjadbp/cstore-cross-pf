class SaveOsdPhoto {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SaveOsdPhotoData> planograms;

  SaveOsdPhoto({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.planograms,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'osd': planograms.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveOsdPhotoData {
  final int clientId;
  final int typeId;
  final int brandId;
  final int quantity;
  final String reasonId;
  final List<SavePhotoData> images;

  SaveOsdPhotoData({
    required this.clientId,
    required this.typeId,
    required this.brandId,
    required this.quantity,
    required this.reasonId,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'type_id': typeId,
      'brand_id': brandId,
      'quantity': quantity,
      'reason_id': reasonId,
      'images': images.map((image) => image.toJson()).toList(),
    };
  }
}

class SavePhotoData {
  final String imageName;

  SavePhotoData({
    required this.imageName,
  });

  Map<String, dynamic> toJson() {
    return {
      'image_name': imageName,
    };
  }
}