import 'dart:io';

import 'package:cstore/database/table_name.dart';

class GetTransPhotoModel {
  late String clientName = "";
  late int trans_photo_type_id = 1;
  late int client_id = -1;
  late int cat_id = -1;
  late int type_id = -1;
  late String img_name = "";
  late int gcs_status = 1;
  late int upload_status = 1;
  File? imageFile;
  late String categoryEnName = "";
  late String categoryArName = "";
  late String type_en_name = "";
  late String type_ar_name = "";
  late String dateTime = "";


  GetTransPhotoModel(
      {required this.clientName,
      required this.trans_photo_type_id,
      required this.img_name,
      required this.client_id,
      required this.cat_id,
      required this.type_id,
      required this.gcs_status,
      required this.upload_status,
      required this.imageFile,
      required this.categoryEnName,
      required this.categoryArName,
      required this.type_en_name,
      required this.type_ar_name,
      required this.dateTime,
      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      TableName.sys_client_name: clientName,
      TableName.type_id: trans_photo_type_id,
      TableName.imageName: img_name,
      "cat_id": cat_id,
      "client_id": client_id,
      "type_id" : type_id,
      TableName.gcsStatus: gcs_status,
      TableName.uploadStatus: upload_status,
      TableName.enName: categoryEnName,
      TableName.arName: categoryArName,
      TableName.dateTime: dateTime,
      TableName.enName: type_en_name,
      TableName.arName: type_ar_name,
    };
  }

  @override
  String toString() {
    return 'GetTransPhotoModel{clientName: $clientName, trans_photo_type_id: $trans_photo_type_id,date_time:$dateTime,client_id: $client_id,type_id:$type_id ,cat_id: $cat_id, img_name: $img_name, gcs_status: $gcs_status, upload_status: $upload_status, imageFile: $imageFile, categoryEnName: $categoryEnName, categoryArName: $categoryArName, type_en_name: $type_en_name, type_ar_name: $type_ar_name}';
  }
}
