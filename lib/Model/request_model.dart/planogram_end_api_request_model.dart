class SavePlanogramPhoto {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SavePlanogramPhotoData> planograms;

  SavePlanogramPhoto({
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
      'planograms': planograms.map((image) => image.toJson()).toList(),
    };
  }
}

class SavePlanogramPhotoData {
  final int id;
  final int clientId;
  final int categoryId;
  final int brandId;
  final String imageName;
  final String isAdherence;
  final int reasonId;

  SavePlanogramPhotoData({
    required this.id,
    required this.clientId,
    required this.categoryId,
    required this.brandId,
    required this.imageName,
    required this.isAdherence,
    required this.reasonId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'cat_id': categoryId,
      'brand_id': brandId,
      'image_name': imageName,
      'is_adherence': isAdherence,
      'reason_id': reasonId,
    };
  }
}