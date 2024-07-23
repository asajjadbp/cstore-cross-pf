import 'dart:math';

import '../../database/table_name.dart';

class TransOSDCModel {
  late int id;
  late int brand_id;
  late int type_id;
  late int client_id;
  late int reason_id;
  late int quantity;
  late int gcs_status;
  late int upload_status;
  late String date_time = "";
  late int working_id;

  TransOSDCModel({
    required this.brand_id,
    required this.type_id,
    required this.client_id,
    required this.reason_id,
    required this.quantity,
    required this.gcs_status,
    required this.upload_status,
    required this.date_time,
    required this.working_id,});

  Map<String, Object?> toMap() {
    return {
      TableName.trans_osdc_brand_id: brand_id,
      TableName.trans_osdc_type_id: type_id,
      TableName.trans_osdc_client_id: client_id,
      TableName.trans_osdc_reason_id: reason_id,
      TableName.trans_osdc_quantity: quantity,
      TableName.trans_osdc_gcs_status: gcs_status,
      TableName.trans_upload_status: upload_status,
      TableName.trans_date_time: date_time,
      TableName.trans_osdc_working_id:working_id,
    };
  }

  TransOSDCModel.fromJson(Map<String, dynamic> json) {
    brand_id = json[TableName.trans_osdc_brand_id];
    type_id = json[TableName.trans_osdc_type_id];
    client_id = json[TableName.trans_osdc_client_id];
    reason_id = json[TableName.trans_osdc_reason_id];
    quantity = json[TableName.trans_osdc_quantity];
    gcs_status = json[TableName.trans_osdc_gcs_status];
    upload_status = json[TableName.trans_upload_status];
    date_time = json[TableName.trans_date_time];
    working_id = json[TableName.trans_osdc_working_id];

  }
}
