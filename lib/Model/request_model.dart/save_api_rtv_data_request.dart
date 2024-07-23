class SaveRtvData {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SaveRtvDataListData> rtvList;

  SaveRtvData({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.rtvList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'rtv': rtvList.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveRtvDataListData {
  final int clientId;
  final int skuId;
  final int pieces;
  final String expireDate;
  final String rtvImageName;
  final String rtvReasonId;

  SaveRtvDataListData({
    required this.clientId,
    required this.skuId,
    required this.pieces,
    required this.expireDate,
    required this.rtvImageName,
    required this.rtvReasonId,
  });

  Map<String, dynamic> toJson() {
    return {
      'sku_id': skuId,
      'client_id': clientId,
      'pieces': pieces,
      'expire_date': expireDate.toString(),
      'image_name': rtvImageName.toString(),
      'rtv_reason_id': rtvReasonId.toString(),
    };
  }
}