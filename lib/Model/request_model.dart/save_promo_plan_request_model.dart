class SavePromoPlanData {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SavePromoPlanDataListData> promoPlanList;

  SavePromoPlanData({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.promoPlanList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'promo_plan': promoPlanList.map((image) => image.toJson()).toList(),
    };
  }
}

class SavePromoPlanDataListData {
  final int clientId;
  final int skuId;
  final int promoId;
  final String deployed;
  final String reason;
  final String imageName;

  SavePromoPlanDataListData({
    required this.clientId,
    required this.skuId,
    required this.promoId,
    required this.deployed,
    required this.reason,
    required this.imageName,
  });

  Map<String, dynamic> toJson() {
    return {
      'sku_id': skuId,
      'client_id': clientId,
      'promo_id': promoId,
      'deployed': deployed,
      'reason': reason,
      'image': imageName,
    };
  }
}