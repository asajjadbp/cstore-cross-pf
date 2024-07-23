class SavePricingData {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SavePricingDataListData> pricingList;

  SavePricingData({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.pricingList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'pricings': pricingList.map((image) => image.toJson()).toList(),
    };
  }
}

class SavePricingDataListData {
  final int clientId;
  final int skuId;
  final String regularPrice;
  final String promoPrice;

  SavePricingDataListData({
    required this.clientId,
    required this.skuId,
    required this.regularPrice,
    required this.promoPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'sku_id': skuId,
      'client_id': clientId,
      'regular_price': regularPrice,
      'promo_price': promoPrice,
    };
  }
}