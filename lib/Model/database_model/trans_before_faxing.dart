import 'package:cstore/database/table_name.dart';

class TransBeforeFaxingModel {
  late int id = 1;
  late int client_id = 1;
  late int photo_type_id = 1;
  late int cat_id = 1;
  late String img_name = "";
  late int gcs_status = 1;
  late int upload_status = 0;
  late String date_time = "";
  late int working_id = 1;

  TransBeforeFaxingModel({
    required this.client_id,
    required this.photo_type_id,
    required this.cat_id,
    required this.img_name,
    required this.gcs_status,
    required this.upload_status,
    required this.date_time,
    required this.working_id,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.clientIds: client_id,
      TableName.transPhotoTypeId: photo_type_id,
      TableName.sysCategoryId: cat_id,
      TableName.imageName: img_name,
      TableName.gcsStatus: gcs_status,
      TableName.uploadStatus: upload_status,
      TableName.dateTime: date_time,
      TableName.workingId: working_id,
    };
  }

  @override
  String toString() {
    return 'TransBeforeFaxingModel{id: $id, client_id: $client_id, photo_type_id: $photo_type_id, cat_id: $cat_id, img_name: $img_name, gcs_status: $gcs_status, upload_status: $upload_status, date_time: $date_time, working_id: $working_id}';
  }
}
