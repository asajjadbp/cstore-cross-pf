import 'dart:math';

import '../../database/table_name.dart';

class TransOSDCModel {
  late int id;
  late int brand_id;
  late int type_id;
  late String client_id;
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
      TableName.brandId: brand_id,
      TableName.type_id: type_id,
      TableName.clientIds: client_id,
      TableName.trans_osdc_reason_id: reason_id,
      TableName.trans_osdc_quantity: quantity,
      TableName.gcsStatus: gcs_status,
      TableName.uploadStatus: upload_status,
      TableName.dateTime: date_time,
      TableName.workingId:working_id,
    };
  }

  TransOSDCModel.fromJson(Map<String, dynamic> json) {
    brand_id = json[TableName.brandId];
    type_id = json[TableName.type_id];
    client_id = json[TableName.clientIds];
    reason_id = json[TableName.trans_osdc_reason_id];
    quantity = json[TableName.trans_osdc_quantity];
    gcs_status = json[TableName.gcsStatus];
    upload_status = json[TableName.uploadStatus];
    date_time = json[TableName.dateTime];
    working_id = json[TableName.workingId];

  }
}
