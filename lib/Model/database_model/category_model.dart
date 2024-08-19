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
      TableName.sysCategoryId: id,
      TableName.enName: en_name,
      TableName.arName:ar_name,
      TableName.clientIds: client,
    };
  }

  CategoryModel.fromJson(Map<String, dynamic> json) {
    en_name = json[TableName.sysCategoryId];
    en_name = json[TableName.enName];
    en_name = json[TableName.arName];
    client = json[TableName.clientIds];
  }

}
