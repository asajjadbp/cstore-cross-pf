import 'dart:io';

import '../../database/table_name.dart';

class ShowTransSOSModel {
  late int id;
  late String cat_en_name;
  late String cat_ar_name;
  late String client_name;
  late String brand_en_name;
  late String brand_ar_name;
  late String total_cat_space;
  late String actual_space;
  late String unit;

  ShowTransSOSModel({
    required this.id,
    required this.cat_en_name,
    required this.cat_ar_name,
    required this.client_name,
    required this.brand_en_name,
    required this.brand_ar_name,
    required this.total_cat_space,
    required this.actual_space,
    required this.unit});

  Map<String, Object?> toMap() {
    return {
      TableName.sysId: id,
      TableName.enName: cat_en_name,
      TableName.arName: cat_ar_name,
      TableName.sys_client_name:client_name,
      TableName.enName: brand_en_name,
      "total_cat_space": total_cat_space.toString(),
      "actual_space": actual_space.toString(),
      TableName.arName: brand_ar_name,
     "unit": unit,
    };
  }




  ShowTransSOSModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    cat_en_name = json[TableName.enName];
    cat_ar_name = json[TableName.arName];
    client_name = json[TableName.sys_client_name];
    brand_en_name = json[TableName.enName];
    brand_ar_name = json[TableName.arName];
    total_cat_space = json["total_cat_space"].toString();
    actual_space = json["actual_space"].toString();
    unit = json["unit"];
  }
}
