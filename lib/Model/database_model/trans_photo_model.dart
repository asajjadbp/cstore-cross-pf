import 'package:cstore/database/table_name.dart';

class TransPhotoModel {
  late int id = 1;
  late int client_id = 1;
  late int photo_type_id = 1;
  late int cat_id = 1;
  late int type_id = 1;
  late String img_name = "";
  late int gcs_status = 0;
  late int upload_status = 0;
  late String date_time = "";
  late int working_id = 1;

  TransPhotoModel({
    required this.client_id,
    required this.photo_type_id,
    required this.cat_id,
    required this.type_id,
    required this.img_name,
    required this.gcs_status,
    required this.upload_status,
    required this.date_time,
    required this.working_id,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      TableName.clientIds: client_id,
      TableName.transPhotoTypeId: photo_type_id,
      TableName.sysCategoryId: cat_id,
      TableName.type_id: type_id,
      TableName.imageName: img_name,
      TableName.gcsStatus: gcs_status,
      TableName.uploadStatus: upload_status,
      TableName.dateTime: date_time,
      TableName.workingId: working_id,
    };
  }

}
