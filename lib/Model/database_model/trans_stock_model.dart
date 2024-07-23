import 'dart:math';

import '../../database/table_name.dart';

class TransStockModel {
  late int id;
  late int sku_id;
  late int cases;
  late int outer;
  late String pieces;
  late int working_id;

  TransStockModel({
    required this.sku_id,
    required this.cases,
    required this.outer,
    required this.pieces,
    required this.working_id,});

  Map<String, Object?> toMap() {
    return {
      TableName.trans_stock_sku_id: sku_id,
      TableName.trans_stock_cases: cases,
      TableName.trans_stock_outer: outer,
      TableName.trans_stock_pieces: pieces,
      TableName.trans_stock_working_id:working_id,
    };
  }

  TransStockModel.fromJson(Map<String, dynamic> json) {
    sku_id = json[TableName.trans_stock_sku_id];
    cases = json[TableName.trans_stock_cases];
    outer = json[TableName.trans_stock_outer];
    pieces = json[TableName.trans_stock_pieces];
    working_id = json[TableName.trans_stock_working_id];

  }
}
