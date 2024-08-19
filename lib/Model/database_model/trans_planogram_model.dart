import '../../database/table_name.dart';

class TransPlanogramModel {
  late int id;
  late int client_id;
  late int cat_id;
  late int brand_id;
  late String image_name;
  late int working_id;
  late int is_adherence;
  late int gcs_status;
  late int upload_status;
  late String date_time = "";
  late int reason;

  TransPlanogramModel({
    required this.client_id,
    required this.cat_id,
    required this.brand_id,
    required this.image_name,
    required this.working_id,
    required this.is_adherence,
    required this.gcs_status,
    required this.upload_status,
    required this.date_time,
    required this.reason});

  Map<String, Object?> toMap() {
    return {
      TableName.clientIds: client_id,
      TableName.sysCategoryId: cat_id,
      TableName.brandId: brand_id,
      TableName.imageName: image_name,
      TableName.workingId: working_id,
      TableName.trans_planogram_is_adherence: is_adherence,
      TableName.gcsStatus:gcs_status,
      TableName.uploadStatus:upload_status,
      TableName.dateTime: date_time,
      TableName.trans_planogram_reason_id: reason,
    };
  }

  TransPlanogramModel.fromJson(Map<String, dynamic> json) {
    client_id = json[TableName.clientIds];
    cat_id = json[TableName.sysCategoryId];
    brand_id = json[TableName.brandId];
    image_name = json[TableName.imageName];
    working_id = json[TableName.workingId];
    is_adherence = json[TableName.trans_planogram_is_adherence];
    gcs_status = json[TableName.gcsStatus];
    upload_status = json[TableName.uploadStatus];
    date_time = json[TableName.dateTime];
    reason = json[TableName.trans_planogram_reason_id];
  }
}
