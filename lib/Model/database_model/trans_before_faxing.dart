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

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      TableName.trans_photo_client_id: client_id,
      TableName.trans_photo_type_id: photo_type_id,
      TableName.trans_photo_cat_id: cat_id,
      TableName.trans_photo_name: img_name,
      TableName.trans_photo_gcs_status: gcs_status,
      TableName.trans_upload_status: upload_status,
      TableName.trans_date_time: date_time,
      TableName.trans_photo_working_id: working_id,
    };
  }

  @override
  String toString() {
    return 'TransBeforeFaxingModel{id: $id, client_id: $client_id, photo_type_id: $photo_type_id, cat_id: $cat_id, img_name: $img_name, gcs_status: $gcs_status, upload_status: $upload_status, date_time: $date_time, working_id: $working_id}';
  }
}
