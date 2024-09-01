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
  late String not_en_adherence_reason;
  late String not_ar_adherence_reason;
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
    required this.not_en_adherence_reason,
    required this.not_ar_adherence_reason,
    required this.client_id,
    required this.cat_id,
    required this.brand_id,
    required this.reason_id,

  });

  Map<String, Object?> toMap() {
    return {
      TableName.sysId: id,
      'client_id': client_id,
      'cat_id': cat_id,
      'reason_id': reason_id,
      'brand_id': brand_id,
      'date_time': dateTime,
      TableName.enName: cat_en_name,
      TableName.arName: cat_ar_name,
     TableName.sys_client_name:client_name,
      TableName.enName: brand_en_name,
      TableName.arName: brand_ar_name,
      TableName.imageName: image_name,
      TableName.gcsStatus: gcs_status,
      TableName.uploadStatus: upload_status,
      TableName.transPlanogramIsAdherence: is_adherence,
      TableName.transPlanogramReasonId: not_en_adherence_reason,
      'not_ar_adherence_reason': not_ar_adherence_reason,
    };
  }

  ShowPlanogramModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    client_id = json['client_id'];
    cat_id = json['cat_id'];
    brand_id = json['brand_id'];
    reason_id = json['reason_id'];
    dateTime = json['date_time'];
    cat_en_name = json[TableName.enName];
    cat_ar_name = json[TableName.arName];
    client_name = json[TableName.sys_client_name];
    brand_en_name = json[TableName.enName];
    brand_ar_name = json[TableName.arName];
    image_name = json[TableName.imageName];
    gcs_status = json[TableName.gcsStatus];
    upload_status = json[TableName.uploadStatus];
    is_adherence = json[TableName.transPlanogramIsAdherence];
    not_en_adherence_reason = json[TableName.transPlanogramReasonId];
    not_ar_adherence_reason = json['not_ar_adherence_reason'];
  }

  @override
  String toString() {
    return 'ShowPlanogramModel{id: $id,client_id: $client_id,date_time:$dateTime,cat_id: $cat_id,brand_id: $brand_id,reason_id: $reason_id, cat_en_name: $cat_en_name, client_name: $client_name, cat_ar_name: $cat_ar_name, brand_en_name: $brand_en_name, brand_ar_name: $brand_ar_name, image_name: $image_name, gcs_status: $gcs_status, upload_status: $upload_status, imageFile: $imageFile, is_adherence: $is_adherence, not_adherence_reason: $not_en_adherence_reason}, not_ar_adherence_reason: $not_ar_adherence_reason';
  }
}
