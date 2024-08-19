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
      TableName.sysId: id,
      TableName.enName: en_name,
      TableName.arName:ar_name,
      TableName.clientIds: client,
    };
  }

  SYS_BrandModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sysId];
    en_name = json[TableName.enName];
    en_name = json[TableName.arName];
    client = json[TableName.clientIds];
  }

}
