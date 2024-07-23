import '../../database/table_name.dart';

class TransFreshnessModel {
  late int id;
  late int sku_id;
  late String year;
  late String jan;
  late String feb;
  late String mar;
  late String apr;
  late String may;
  late String jun;
  late String jul;
  late String aug;
  late String sep;
  late String oct;
  late String nov;
  late String dec;
  late String cases;
  late String outer;
  late String pieces;
  late String specific_date;
  late final int working_id;

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
    required this.cases,
    required this.outer,
    required this.pieces,
    required this.specific_date,
    required this.working_id,
  });

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
      TableName.trans_freshness_cases: cases,
      TableName.trans_freshness_outer: outer,
      TableName.trans_freshness_pieces: pieces,
      TableName.trans_freshness_specific_date: specific_date,
      TableName.trans_freshness_working_id: working_id,
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
    cases = json[TableName.trans_freshness_cases];
    outer = json[TableName.trans_freshness_outer];
    pieces = json[TableName.trans_freshness_pieces];
    specific_date = json[TableName.trans_freshness_specific_date];
    working_id = json[TableName.trans_freshness_working_id];

  }
}
