class SaveBrandShare {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SaveBrandShareListData> brandShares;

  SaveBrandShare({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.brandShares,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'brandShares': brandShares.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveBrandShareListData {
  final int clientId;
  final int id;
  final int catId;
  final int brandId;
  final String givenFaces;
  final String actualFaces;

  SaveBrandShareListData({
    required this.clientId,
    required this.id,
    required this.catId,
    required this.brandId,
    required this.givenFaces,
    required this.actualFaces,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'category_id': catId,
      'brand_id': brandId,
      'given_faces': givenFaces,
      'actual_faces': actualFaces.toString(),
    };
  }
}