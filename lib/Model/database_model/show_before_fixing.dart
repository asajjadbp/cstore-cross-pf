import 'dart:io';

import 'package:cstore/database/table_name.dart';

class GetTransBeforeFixing {
  late int id=-1;
  late String clientName = "";
  late int trans_photo_type_id = 1;
  late String img_name = "";
  late int gcs_status = 0;
  late int client_id = -1;
  late int cat_id = -1;
  late int upload_status = 0;
  late String dateTime = "";
  File? imageFile;
  late String categoryEnName = "";
  late String categoryArName = "";

  GetTransBeforeFixing(
      {
        required this.id,
        required this.clientName,
        required this.trans_photo_type_id,
        required this.img_name,
        required this.gcs_status,
        required this.client_id,
        required this.cat_id,
        required this.upload_status,
        required this.dateTime,
        required this.imageFile,
        required this.categoryEnName,
        required this.categoryArName});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      TableName.sysId: id,
      TableName.sys_client_name: clientName,
      TableName.transPhotoTypeId: trans_photo_type_id,
      TableName.imageName: img_name,
      TableName.clientIds: client_id,
      "cat_id": cat_id,
      TableName.dateTime:dateTime,
      TableName.gcsStatus: gcs_status,
      TableName.uploadStatus: upload_status,
      TableName.enName: categoryEnName,
      TableName.arName: categoryArName,
    };
  }

  @override
  String toString() {
    return 'GetTransBeforeFixing{clientName: $clientName,date_time: $dateTime, trans_photo_type_id: $trans_photo_type_id, img_name: $img_name, gcs_status: $gcs_status, client_id: $client_id, cat_id: $cat_id, upload_status: $upload_status, imageFile: $imageFile, categoryEnName: $categoryEnName, categoryArName: $categoryArName}';
  }
}
