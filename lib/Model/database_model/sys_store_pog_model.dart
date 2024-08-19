import '../../database/table_name.dart';

class SysStorePogModel {
  late int storeId;
  late int clientId;
  late int catId;
  late String pog;
  late String pogImage;

  SysStorePogModel({
    required this.storeId,
    required this.clientId,
    required this.catId,
    required this.pog,
    required this.pogImage
  });

  Map<String, Object?> toMap() {
    return {
      TableName.storeId: storeId.toString(),
      TableName.clientIds:  clientId,
      TableName.sysCategoryId: catId.toString(),
      TableName.sys_store_pog: pog.toString(),
      TableName.sys_store_pog_image: pogImage.toString(),
    };
  }

  SysStorePogModel.fromJson(Map<String, dynamic> json) {
    storeId = json[TableName.storeId];
    clientId = json[TableName.clientIds];
    catId = json[TableName.sysCategoryId];
    pog = json[TableName.sys_store_pog].toString();
    pogImage = json[TableName.sys_store_pog_image].toString();
  }
  Map<String, dynamic> toJson() => {
    TableName.storeId: storeId,
    TableName.clientIds : clientId,
    TableName.sysCategoryId: catId.toString(),
    TableName.sys_store_pog: pog.toString(),
    TableName.sys_store_pog_image: pogImage.toString(),
  };

  @override
  String toString() {
    return 'SysStorePogModel{storeId: $storeId,clientId: $clientId, catId: $catId, pog: $pog, pogImage: $pogImage}';
  }
}
