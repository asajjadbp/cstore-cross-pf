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
      TableName.trans_planogram_id: id,
      TableName.cat_en_name: cat_en_name,
      TableName.cat_ar_name: cat_ar_name,
      TableName.sys_client_name:client_name,
      TableName.sys_brand_en_name: brand_en_name,
      "total_cat_space": total_cat_space.toString(),
      "actual_space": actual_space.toString(),
      TableName.sys_brand_ar_name: brand_ar_name,
     "unit": unit,
    };
  }




  ShowTransSOSModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.trans_planogram_id];
    cat_en_name = json[TableName.cat_en_name];
    cat_ar_name = json[TableName.cat_ar_name];
    client_name = json[TableName.sys_client_name];
    brand_en_name = json[TableName.sys_brand_en_name];
    brand_ar_name = json[TableName.sys_brand_ar_name];
    total_cat_space = json["total_cat_space"].toString();
    actual_space = json["actual_space"].toString();
    unit = json["unit"];
  }
}
