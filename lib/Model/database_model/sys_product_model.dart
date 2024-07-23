import '../../database/table_name.dart';

class Sys_ProductModel {
  late int id;
  late int client_id;
  late String en_name;
  late String ar_name;
  late String image;
  late String principal_id;
  late String cluster_id;
  late String cat_id;
  late String sub_cat_id;
  late String brand_id;
  late String rsp;
  late String sku_weight;

  Sys_ProductModel({
    required this.id,
    required this.client_id,
    required this.en_name,
    required this.ar_name,
    required this.image,
    required this.principal_id,
    required this.cluster_id,
    required this.cat_id,
    required this.sub_cat_id,
    required this.brand_id,
    required this.rsp,
    required this.sku_weight,
  });

  Map<String, Object?> toMap() {
    return {
      TableName.sys_product_id: id,
      TableName.sys_product_client_id: client_id,
      TableName.sys_product_en_name: en_name,
      TableName.sys_product_ar_name: ar_name,
      TableName.sys_product_image: image,
      TableName.sys_product_principal_id: principal_id,
      TableName.sys_product_cluster_id: cluster_id,
      TableName.sys_product_cat_id: cat_id,
      TableName.sys_product_sub_cat_id: sub_cat_id,
      TableName.sys_product_brand_id: brand_id,
      TableName.sys_product_rsp: rsp,
      TableName.sys_product_sku_weight: sku_weight,

    };
  }

  Sys_ProductModel.fromJson(Map<String, dynamic> json) {
    id = json[TableName.sys_product_id];
    client_id = json[TableName.sys_product_client_id];
    en_name = json[TableName.sys_product_en_name].toString();
    ar_name = json[TableName.sys_product_ar_name].toString();
    image = json[TableName.sys_product_image].toString();
    principal_id = json[TableName.sys_product_principal_id].toString();
    cluster_id = json[TableName.sys_product_cluster_id].toString();
    cat_id = json[TableName.sys_product_cat_id].toString();
    sub_cat_id = json[TableName.sys_product_sub_cat_id].toString();
    brand_id = json[TableName.sys_product_brand_id].toString();
    rsp = json[TableName.sys_product_rsp].toString();
    sku_weight = json[TableName.sys_product_sku_weight].toString();
  }

  Map<String, dynamic> toJson() => {
    TableName.sys_product_id: id,
    TableName.sys_product_client_id: client_id,
    TableName.sys_product_en_name: en_name,
    TableName.sys_product_ar_name: ar_name,
    TableName.sys_product_image: image,
    TableName.sys_product_principal_id: principal_id,
    TableName.sys_product_cluster_id: cluster_id,
    TableName.sys_product_cat_id: cat_id,
    TableName.sys_product_sub_cat_id: sub_cat_id,
    TableName.sys_product_brand_id: brand_id,
    TableName.sys_product_rsp: rsp,
    TableName.sys_product_sku_weight: sku_weight,
  };
}
