
import '../../database/table_name.dart';

class PlanogramReasonModel{

  late int id;
  late String en_name;
  late String ar_name;
  late int status;

  PlanogramReasonModel(
      {
        required this.id,
        required this.en_name,
        required this.ar_name,
        required this.status,
      });

  Map<String, Object?> toMap() {
    return {
      TableName.planogram_reason_id:id,
      TableName.planogram_reason_en_name: en_name,
      TableName.planogram_reason_ar_name: ar_name,
      TableName.planogram_status:status,
    };
  }

  PlanogramReasonModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.planogram_reason_id];
    en_name = json[TableName.planogram_reason_en_name].toString();
    ar_name = json[TableName.planogram_reason_ar_name].toString();
    status = json[TableName.planogram_status];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "en_name": en_name,
    "ar_name": ar_name,
    "status": status,
  };
}
