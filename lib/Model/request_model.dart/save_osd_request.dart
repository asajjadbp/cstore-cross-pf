class SaveOsdData {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SaveOsdListData> osdList;

  SaveOsdData({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.osdList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'osd': osdList.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveOsdListData {
  final int id;
  final int brandId;
  final String clientId;
  final int typeId;
  final int reasonId;
  final int quantity;
  final List<SaveOsdImageNameListData> osdImagesList;

  SaveOsdListData({
    required this.id,
    required this.clientId,
    required this.brandId,
    required this.typeId,
    required this.reasonId,
    required this.quantity,
    required this.osdImagesList,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'brand_id': brandId,
      'type_id': typeId,
      'reason_id': reasonId,
      'quantity': quantity,
      'images': osdImagesList.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveOsdImageNameListData {
  final int id;
  final String imageName;

  SaveOsdImageNameListData({
    required this.id,
    required this.imageName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_name': imageName,
    };
  }
}