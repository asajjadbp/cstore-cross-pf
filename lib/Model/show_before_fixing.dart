import 'dart:io';

import 'package:cstore/database/table_name.dart';

class GetTransBeforeFixing {
  late String clientName = "";
  late int trans_photo_type_id = 1;
  late String img_name = "";
  late int gcs_status = 1;
  File? imageFile;
  late String categoryEnName = "";
  late String categoryArName = "";

  GetTransBeforeFixing(
      {required this.clientName,
        required this.trans_photo_type_id,
        required this.img_name,
        required this.gcs_status,
        required this.imageFile,
        required this.categoryEnName,
        required this.categoryArName});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      TableName.sys_client_name: clientName,
      TableName.type_id: trans_photo_type_id,
      TableName.imageName: img_name,
      TableName.gcsStatus: gcs_status,
      TableName.enName: categoryEnName,
      TableName.arName: categoryArName,
    };
  }
  @override
  String toString() {
    return 'GetTransPhotoModel{client_name: $clientName, id: $trans_photo_type_id, image_name: $img_name, gcs_status: $gcs_status, en_name: $categoryEnName,imageFile:$imageFile, ar_name: $categoryArName}';
  }
}
