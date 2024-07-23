class SaveSosPhoto {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SaveSosData> sosList;

  SaveSosPhoto({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.sosList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'sos': sosList.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveSosData {
  final int clientId;
  final int categoryId;
  final int brandId;
  final String catSpace;
  final String actualSpace;
  final String unit;

  SaveSosData({
    required this.clientId,
    required this.categoryId,
    required this.brandId,
    required this.catSpace,
    required this.actualSpace,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'cat_id': categoryId,
      'brand_id': brandId,
      'cat_space': catSpace,
      'actual_space': actualSpace,
      'unit': unit,
    };
  }
}