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
      TableName.trans_planogram_client_id: client_id,
      TableName.trans_planogram_cat_id: cat_id,
      TableName.trans_planogram_brand_id: brand_id,
      TableName.trans_planogram_image_name: image_name,
      TableName.trans_planogram_working_id: working_id,
      TableName.trans_planogram_is_adherence: is_adherence,
      TableName.trans_planogram_gcs_status:gcs_status,
      TableName.trans_upload_status:upload_status,
      TableName.trans_date_time: date_time,
      TableName.trans_planogram_reason_id: reason,
    };
  }

  TransPlanogramModel.fromJson(Map<String, dynamic> json) {
    client_id = json[TableName.trans_planogram_client_id];
    cat_id = json[TableName.trans_planogram_cat_id];
    brand_id = json[TableName.trans_planogram_brand_id];
    image_name = json[TableName.trans_planogram_image_name];
    working_id = json[TableName.trans_planogram_working_id];
    is_adherence = json[TableName.trans_planogram_is_adherence];
    gcs_status = json[TableName.trans_planogram_gcs_status];
    upload_status = json[TableName.trans_upload_status];
    date_time = json[TableName.trans_date_time];
    reason = json[TableName.trans_planogram_reason_id];
  }
}
