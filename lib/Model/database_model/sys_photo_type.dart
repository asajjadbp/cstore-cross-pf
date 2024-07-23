import '../../database/table_name.dart';

class Sys_PhotoTypeModel {
  late int id;
  late String en_name;
  late String ar_name;

  Sys_PhotoTypeModel({
    required this.id,
    required this.en_name,
    required this.ar_name,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.sys_photo_type_id: id,
      TableName.sys_photo_type_en_name: en_name,
      TableName.sys_photo_type_ar_name: ar_name,
    };
  }

  Sys_PhotoTypeModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sys_photo_type_id];
    en_name = json[TableName.sys_photo_type_en_name].toString();
    ar_name = json[TableName.sys_photo_type_ar_name].toString();
  }
  Map<String, dynamic> toJson() => {
    TableName.sys_photo_type_id: id,
    TableName.sys_photo_type_en_name: en_name.toString(),
    TableName.sys_photo_type_ar_name: ar_name.toString(),
  };
}
