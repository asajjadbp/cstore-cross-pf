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
      TableName.sys_store_pog_storeid: storeId.toString(),
      TableName.sys_client_id:  clientId,
      TableName.sys_store_pog_catId: catId.toString(),
      TableName.sys_store_pog: pog.toString(),
      TableName.sys_store_pog_image: pogImage.toString(),
    };
  }

  SysStorePogModel.fromJson(Map<String, dynamic> json) {
    storeId = json[TableName.sys_store_pog_storeid];
    clientId = json[TableName.sys_client_id];
    catId = json[TableName.sys_store_pog_catId];
    pog = json[TableName.sys_store_pog].toString();
    pogImage = json[TableName.sys_store_pog_image].toString();
  }
  Map<String, dynamic> toJson() => {
    TableName.sys_store_pog_storeid: storeId,
    TableName.sys_client_id : clientId,
    TableName.sys_store_pog_catId: catId.toString(),
    TableName.sys_store_pog: pog.toString(),
    TableName.sys_store_pog_image: pogImage.toString(),
  };

  @override
  String toString() {
    return 'SysStorePogModel{storeId: $storeId,clientId: $clientId, catId: $catId, pog: $pog, pogImage: $pogImage}';
  }
}
