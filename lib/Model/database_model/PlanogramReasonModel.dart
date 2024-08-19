
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
      TableName.sysId:id,
      TableName.enName: en_name,
      TableName.arName: ar_name,
      TableName.status:status,
    };
  }

  PlanogramReasonModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    en_name = json[TableName.enName].toString();
    ar_name = json[TableName.arName].toString();
    status = json[TableName.status];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "en_name": en_name,
    "ar_name": ar_name,
    "status": status,
  };
}
