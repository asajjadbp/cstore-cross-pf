import '../../database/table_name.dart';

class TransFreshnessModel {
  late int sku_id;
  late int year;
  late int jan;
  late int feb;
  late int mar;
  late int apr;
  late int may;
  late int jun;
  late int jul;
  late int aug;
  late int sep;
  late int oct;
  late int nov;
  late int dec;
  late String imgName;
  late String specific_date;
  late String client_id;
  late String sku_en_name;
  late String sku_ar_name;
  late int upload_status;

  Map<String, Object?> toMap() {
    return {
      TableName.trans_pricing_sku_id: sku_id,
      TableName.trans_freshness_year: year,
      TableName.trans_freshness_jan: jan,
      TableName.trans_freshness_feb: feb,
      TableName.trans_freshness_mar: mar,
      TableName.trans_freshness_apr: apr,
      TableName.trans_freshness_may: may,
      TableName.trans_freshness_jun: jun,
      TableName.trans_freshness_jul: jul,
      TableName.trans_freshness_aug: aug,
      TableName.trans_freshness_sep: sep,
      TableName.trans_freshness_oct: oct,
      TableName.trans_freshness_nov: nov,
      TableName.trans_freshness_dec: dec,
      TableName.trans_freshness_specific_date: specific_date,
      TableName.trans_upload_status: upload_status,
      "sku_en_name": sku_en_name,
      "sku_ar_name": sku_ar_name,
      "client_id": sku_en_name,
      "img_name": imgName,
    };
  }

  TransFreshnessModel.fromJson(Map<String, dynamic> json) {
    sku_id = json[TableName.trans_freshness_sku_id];
    year = json[TableName.trans_freshness_year];
    jan = json[TableName.trans_freshness_jan];
    feb = json[TableName.trans_freshness_feb];
    mar = json[TableName.trans_freshness_mar];
    apr = json[TableName.trans_freshness_apr];
    may = json[TableName.trans_freshness_may];
    jun = json[TableName.trans_freshness_jun];
    jul = json[TableName.trans_freshness_jul];
    aug = json[TableName.trans_freshness_aug];
    sep = json[TableName.trans_freshness_sep];
    oct = json[TableName.trans_freshness_oct];
    sep = json[TableName.trans_freshness_sep];
    nov = json[TableName.trans_freshness_nov];
    dec = json[TableName.trans_freshness_dec];
    specific_date = json[TableName.trans_freshness_specific_date];
    upload_status = json[TableName.trans_upload_status];
    sku_en_name = json['sku_en_name'];
    sku_ar_name = json['sku_ar_name'];
    client_id = json['client_id'];
    imgName = json['img_name'];
  }

  TransFreshnessModel({
    required this.sku_id,
    required this.year,
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
    required this.specific_date,
    required this.client_id,
    required this.sku_en_name,
    required this.sku_ar_name,
    required this.upload_status,
    required this.imgName,
  });
}
