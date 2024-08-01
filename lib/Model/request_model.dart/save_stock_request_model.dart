class SaveStockData {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SaveStockListData> stockList;

  SaveStockData({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.stockList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'stocks': stockList.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveStockListData {
  final int clientId;
  final int skuId;
  final int cases;
  final int outer;
  final int pieces;
  final String dateTime;

  SaveStockListData({
    required this.clientId,
    required this.skuId,
    required this.cases,
    required this.outer,
    required this.pieces,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'sku_id': skuId,
      'client_id': clientId,
      'cases': cases,
      'outer': outer,
      'pieces': pieces,
      'date_time': dateTime,
    };
  }
}