class SaveFreshnessData {
  final String username;
  final String workingId;
  final String storeId;
  final String workingDate;
  final List<SaveFreshnessListData> freshnessList;

  SaveFreshnessData({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.workingDate,
    required this.freshnessList,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'working_id': workingId,
      'store_id': storeId,
      'working_date':workingDate,
      'freshness': freshnessList.map((image) => image.toJson()).toList(),
    };
  }
}

class SaveFreshnessListData {
  final int clientId;
  final int skuId;
  final int year;
  final int jan;
  final int feb;
  final int mar;
  final int apr;
  final int may;
  final int jun;
  final int jul;
  final int aug;
  final int sep;
  final int oct;
  final int nov;
  final int dec;
  final String dateTime;

  SaveFreshnessListData({
    required this.clientId,
    required this.skuId,
    required this.year,
    required this.dateTime,
    required this.jan,
    required this.feb,
    required this.mar,
    required this.apr,
    required this.may,
    required this.jun,
    required this.jul,
    required this.aug,
    required this.sep,
    required this.oct,
    required this.nov,
    required this.dec,
  });

  Map<String, dynamic> toJson() {
    return {
      'sku_id': skuId,
      'client_id': clientId,
      'year': year,
      'date_time': dateTime,
      'jan': jan,
      'feb': feb,
      'mar': mar,
      'apr': apr,
      'may': may,
      'jun': jun,
      'jul': jul,
      'aug': aug,
      'sep': sep,
      'oct': oct,
      'nov': nov,
      'dec': dec,

    };
  }
}