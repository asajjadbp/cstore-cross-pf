import '../../database/table_name.dart';

class SYS_BrandModel {
  late  int id;
  late  String en_name;
  late String ar_name;
  late  int client;

  SYS_BrandModel({
    required this.id,
    required this.en_name,
    required this.ar_name,
    required this.client,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.sys_brand_id: id,
      TableName.sys_brand_en_name: en_name,
      TableName.sys_brand_ar_name:ar_name,
      TableName.sys_brand_client_id: client,
    };
  }

  SYS_BrandModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sys_brand_id];
    en_name = json[TableName.sys_brand_en_name];
    en_name = json[TableName.sys_brand_ar_name];
    client = json[TableName.sys_brand_client_id];
  }

}
