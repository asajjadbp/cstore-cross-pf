import 'package:cstore/Database/table_name.dart';

class CategoryModel {
  late int id = 0;
  late String name = "";
  late int client = 0;

  CategoryModel({
    required this.name,
    required this.client,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.cat_id: id,
      TableName.cat_name: name,
      TableName.cat_client_id: client,
    };
  }

  CategoryModel.fromJson(Map<String, dynamic> json) {
    name = json[TableName.cat_name];
    client = json[TableName.cat_client_id];
  }

  @override
  String toString() {
    return 'ClientModels{id: $id, name: $name, client: $client}';
  }
}
