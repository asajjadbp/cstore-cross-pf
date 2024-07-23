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
      TableName.sys_osdc_type_id: id.toString(),
      TableName.sys_osdc_type_en_name: en_name.toString(),
      TableName.sys_osdc_type_ar_name: ar_name.toString(),
    };
  }

  Sys_OSDCTypeModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sys_osdc_type_id];
    en_name = json[TableName.sys_osdc_type_en_name].toString();
    ar_name = json[TableName.sys_osdc_type_ar_name].toString();
  }
  Map<String, dynamic> toJson() => {
    TableName.sys_osdc_type_id: id,
    TableName.sys_osdc_type_en_name: en_name.toString(),
    TableName.sys_osdc_type_ar_name: ar_name.toString(),
  };
}
