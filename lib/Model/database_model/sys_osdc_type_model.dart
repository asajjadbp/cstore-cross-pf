import '../../database/table_name.dart';

class Sys_OSDCTypeModel {
  late int id;
  late String en_name;
  late String ar_name;

  Sys_OSDCTypeModel({
    required this.id,
    required this.en_name,
    required this.ar_name,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.sysId: id.toString(),
      TableName.enName: en_name.toString(),
      TableName.arName: ar_name.toString(),
    };
  }

  Sys_OSDCTypeModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    en_name = json[TableName.enName].toString();
    ar_name = json[TableName.arName].toString();
  }
  Map<String, dynamic> toJson() => {
    TableName.sysId: id,
    TableName.enName: en_name.toString(),
    TableName.arName: ar_name.toString(),
  };
}
