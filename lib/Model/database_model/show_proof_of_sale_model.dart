import 'dart:io';

import '../../database/table_name.dart';

class ShowProofOfSaleModel {
  late int id;
  late int sku_id;
  late int client_id;
  late int qty;
  late int gcs_status = 1;
  late int upload_status = 0;
  late String cat_en_name;
  late String cat_ar_name;
  late String pro_en_name;
  late String pro_ar_name;
  late String image_name;
  late String amount;
  late String name;
  late String email;
  late String phone;
  File? imageFile;
  ShowProofOfSaleModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    sku_id = json[TableName.skuId];
    client_id = json[TableName.clientIds];
    qty = json[TableName.quantity];
    gcs_status = json[TableName.gcsStatus];
    upload_status = json[TableName.uploadStatus];
    cat_en_name = json['cat_en_name'];
    cat_ar_name = json['cat_ar_name'];
    pro_en_name = json['pro_en_name'];
    pro_en_name = json['pro_ar_name'];
    image_name = json[TableName.imageName];
    name = json[TableName.trans_pos_name];
    email = json[TableName.trans_pos_email];
    phone = json[TableName.trans_pos_phone];
    amount = json[TableName.trans_pos_amount];
  }
  ShowProofOfSaleModel({
    required this.id,
    required this.sku_id,
    required this.client_id,
    required this.qty,
    required this.gcs_status,
    required this.upload_status,
    required this.cat_en_name,
    required this.cat_ar_name,
    required this.pro_en_name,
    required this.pro_ar_name,
    required this.image_name,
    required this.name,
    required this.email,
    required this.amount,
    required this.phone,
    this.imageFile,
  });
}
