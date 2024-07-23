import '../../database/table_name.dart';

class CategoryModel {
  late  int id;
  late  String en_name;
  late String ar_name;
  late  int client;

  CategoryModel({
    required this.id,
    required this.en_name,
    required this.ar_name,
    required this.client,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.cat_id: id,
      TableName.cat_en_name: en_name,
      TableName.cat_ar_name:ar_name,
      TableName.cat_client_id: client,
    };
  }

  CategoryModel.fromJson(Map<String, dynamic> json) {
    en_name = json[TableName.cat_id];
    en_name = json[TableName.cat_en_name];
    en_name = json[TableName.cat_ar_name];
    client = json[TableName.cat_client_id];
  }

}
