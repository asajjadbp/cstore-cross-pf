class SaveAvailability {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SaveAvailabilityData> availabilityList;

  SaveAvailability({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.availabilityList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'availability': availabilityList.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveAvailabilityData {
  final int clientId;
  final int skuId;
  final int avlStatus;

  SaveAvailabilityData({
    required this.clientId,
    required this.skuId,
    required this.avlStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'sku_id': skuId,
      'avl_status': avlStatus,
    };
  }
}


class SavePickList {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SavePickListData> pickList;

  SavePickList({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.pickList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'picklist': pickList.map((image) => image.toJson()).toList(),
    };
  }
}

class SavePickListData {
  final int clientId;
  final int skuId;
  final int reqPicklist;

  SavePickListData({
    required this.clientId,
    required this.skuId,
    required this.reqPicklist,
  });

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'sku_id': skuId,
      'req_picklist': reqPicklist,
    };
  }
}