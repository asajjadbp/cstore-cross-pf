class SaveReplenishData {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SaveReplenishListData> replenishList;

  SaveReplenishData({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.replenishList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'replenish': replenishList.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveReplenishListData {
  final int skuId;
  final String reqPicklist;
  final String clientId;
  final String actPicklist;
  final String picklistReason;

  SaveReplenishListData({
    required this.skuId,
    required this.reqPicklist,
    required this.clientId,
    required this.picklistReason,
    required this.actPicklist,
  });

  Map<String, dynamic> toJson() {
    return {
      'sku_id': skuId,
      'client_id': clientId,
      'req_picklist': reqPicklist,
      'picklist_reason': picklistReason,
      'act_picklist': actPicklist,
    };
  }
}