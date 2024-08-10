import 'dart:io';

import '../../database/table_name.dart';

class ShowPlanogramModel {
  late int id;
  late String cat_en_name;
  late String client_name;
  late String cat_ar_name;
  late String brand_en_name;
  late String brand_ar_name;
  late String image_name;
  late String dateTime;
  late int gcs_status = 1;
  late int upload_status = 0;
  File? imageFile;
  late String is_adherence;
  late String not_adherence_reason;
  late int cat_id;
  late int client_id;
  late int brand_id;
  late int reason_id;

  ShowPlanogramModel({
    required this.id,
    required this.cat_en_name,
    required this.cat_ar_name,
    required this.client_name,
    required this.brand_en_name,
    required this.brand_ar_name,
    required this.image_name,
    required this.gcs_status,
    required this.dateTime,
    required this.upload_status,
    required this.imageFile,
    required this.is_adherence,
    required this.not_adherence_reason,
    required this.client_id,
    required this.cat_id,
    required this.brand_id,
    required this.reason_id,

  });

  Map<String, Object?> toMap() {
    return {
      TableName.trans_planogram_id: id,
      'client_id': client_id,
      'cat_id': cat_id,
      'reason_id': reason_id,
      'brand_id': brand_id,
      'date_time': dateTime,
      TableName.cat_en_name: cat_en_name,
      TableName.cat_ar_name: cat_ar_name,
     TableName.sys_client_name:client_name,
      TableName.sys_brand_en_name: brand_en_name,
      TableName.sys_brand_ar_name: brand_ar_name,
      TableName.trans_planogram_image_name: image_name,
      TableName.trans_planogram_gcs_status: gcs_status,
      TableName.trans_upload_status: upload_status,
      TableName.trans_planogram_is_adherence: is_adherence,
      TableName.trans_planogram_reason_id: not_adherence_reason,
    };
  }

  ShowPlanogramModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.trans_planogram_id];
    client_id = json['client_id'];
    cat_id = json['cat_id'];
    brand_id = json['brand_id'];
    reason_id = json['reason_id'];
    dateTime = json['date_time'];
    cat_en_name = json[TableName.cat_en_name];
    cat_ar_name = json[TableName.cat_ar_name];
    client_name = json[TableName.sys_client_name];
    brand_en_name = json[TableName.sys_brand_en_name];
    brand_ar_name = json[TableName.sys_brand_ar_name];
    image_name = json[TableName.trans_planogram_image_name];
    gcs_status = json[TableName.trans_planogram_gcs_status];
    upload_status = json[TableName.trans_upload_status];
    is_adherence = json[TableName.trans_planogram_is_adherence];
    not_adherence_reason = json[TableName.trans_planogram_reason_id];
  }

  @override
  String toString() {
    return 'ShowPlanogramModel{id: $id,client_id: $client_id,date_time:$dateTime,cat_id: $cat_id,brand_id: $brand_id,reason_id: $reason_id, cat_en_name: $cat_en_name, client_name: $client_name, cat_ar_name: $cat_ar_name, brand_en_name: $brand_en_name, brand_ar_name: $brand_ar_name, image_name: $image_name, gcs_status: $gcs_status, upload_status: $upload_status, imageFile: $imageFile, is_adherence: $is_adherence, not_adherence_reason: $not_adherence_reason}';
  }
}
