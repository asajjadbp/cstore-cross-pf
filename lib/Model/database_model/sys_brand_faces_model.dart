import '../../database/table_name.dart';

class SysBrandFacesModel {
  late int storeId;
  late int clientId;
  late int catId;
  late int brand_id;
  late String given_faces;

  SysBrandFacesModel({
    required this.storeId,
    required this.clientId,
    required this.catId,
    required this.brand_id,
    required this.given_faces
  });

  Map<String, Object?> toMap() {
    return {
      TableName.sys_brand_faces_storeId: storeId,
     TableName.sys_client_id:clientId,
      TableName.sys_brand_faces_catId: catId.toString(),
      TableName.sys_brand_faces_brandId: brand_id.toString(),
      TableName.sys_brand_faces_givenFaces:given_faces.toString(),
    };
  }

  SysBrandFacesModel.fromJson(Map<String, dynamic> json) {
    storeId = json[TableName.sys_brand_faces_storeId];
    clientId = json[TableName.sys_client_id];
    catId = json[TableName.sys_brand_faces_catId];
    brand_id = json[TableName.sys_brand_faces_brandId];
    given_faces = json[TableName.sys_brand_faces_givenFaces].toString();
  }
  Map<String, dynamic> toJson() => {
    TableName.sys_brand_faces_storeId: storeId.toString(),
   TableName.sys_client_id:clientId,
    TableName.sys_brand_faces_catId: catId.toString(),
    TableName.sys_brand_faces_brandId: brand_id.toString(),
    TableName.sys_brand_faces_givenFaces: given_faces.toString(),
  };

  @override
  String toString() {
    return 'SysBrandFacesModel{storeId: $storeId,clientId: $clientId, catId: $catId, brand_id: $brand_id, given_faces: $given_faces}';
  }
}
