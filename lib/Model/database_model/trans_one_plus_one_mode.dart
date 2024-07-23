import 'dart:math';

import '../../database/table_name.dart';

class TransOnePlusOneModel {
  late int id;
  late int sku_id;
  late int quantity;
  late String doc_no;
  late String comment;
  late String type;
  late String image;
  late String doc_image;
  late int working_id;

  TransOnePlusOneModel({
    required this.sku_id,
    required this.quantity,
    required this.doc_no,
    required this.comment,
    required this.type,
    required this.image,
    required this.doc_image,
    required this.working_id,});

  Map<String, Object?> toMap() {
    return {
      TableName.trans_one_plus_one_sku_id: sku_id,
      TableName.trans_one_plus_one_quantity: quantity,
      TableName.trans_one_plus_one_doc_no: doc_no,
      TableName.trans_one_plus_one_comment: comment,
      TableName.trans_one_plus_one_type: type,
      TableName.trans_one_plus_one_image: image,
      TableName.trans_one_plus_one_doc_image: doc_image,
      TableName.trans_one_plus_one_working_id:working_id,
    };
  }

  TransOnePlusOneModel.fromJson(Map<String, dynamic> json) {
    sku_id = json[TableName.trans_one_plus_one_sku_id];
    quantity = json[TableName.trans_one_plus_one_quantity];
    doc_no = json[TableName.trans_one_plus_one_doc_no];
    comment = json[TableName.trans_one_plus_one_comment];
    type = json[TableName.trans_one_plus_one_type];
    image = json[TableName.trans_one_plus_one_image];
    doc_image = json[TableName.trans_one_plus_one_doc_image];
    working_id = json[TableName.trans_one_plus_one_working_id];

  }
}
