import 'package:flutter/material.dart';

class TableName {
  final GlobalKey<ScaffoldState> drawerKey = new GlobalKey<ScaffoldState>();
  // Define your constants here
  static const String tbl_drop_reason = "drop_reason";
  static const String tbl_agency_dashboard = "sys_agency_dashboard";
  static const String tbl_sys_client = "sys_client";
  static const String tbl_sys_category = "sys_category";
  static const String tbl_sys_principal = "sys_principal";
  static const String tbl_sys_cluster = "sys_cluster";
  static const String tbl_sys_subcategory = "sys_subcategory";

  //Transcition tables
  static const String tbl_trans_photo = "trans_photo";

  //Transtion table column
  static const String trans_photo_id = "id";
  static const String trans_photo_client_id = "client_id";
  static const String trans_photo_type_id = "photo_type_id";
  static const String trans_photo_cat_id = "cat_id";
  static const String trans_photo_name = "image_name";
  static const String trans_photo_gcs_status = "gcs_status";

  static const String drop_id = "id";
  static const String drop_en_name = "en_name";
  static const String drop_ar_name = "ar_name";
  static const String drop_status = "status";

  static const String agency_dash_id = "id";
  static const String agency_dash_en_name = "en_name";
  static const String agency_dash_ar_name = "ar_name";
  static const String agency_dash_icon = "icon_svg";
  static const String agency_dash_start_date = "start_date";
  static const String agency_dash_end_date = "end_date";
  static const String agency_dash_status = "status";

  static const String sys_id = "id";
  static const String sys_client_id = "client_id";
  static const String sys_client_name = "client_name";
  static const String sys_client_logo = "logo";
  static const String sys_client_classification = "is_classification";
  static const String sys_client_chainSku_code = "is_chain_sku_codes";
  static const String sys_client_is_dayFreshness = "is_day_freshness";
  static const String sys_client_order_avl = "is_suggeted_order_avl";
  static const String sys_client_is_survey = "is_survey";
  static const String sys_client_geo_req = "is_geo_required";

  static const String cat_id = "id";
  static const String cat_name = "name";
  static const String cat_client_id = "client";

  static const String principal_id = "id";
  static const String principal_name = "name";
  static const String principal_client = "client";

  static const String cluster_id = "id";
  static const String cluster_name = "name";
  static const String cluster_client = "client";

  static const String sub_cat_id = "id";
  static const String sub_cat_name = "name";
  static const String sub_cat_client = "client";
}
