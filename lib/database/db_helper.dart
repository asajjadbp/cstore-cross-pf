import 'dart:convert';
import 'dart:io';

import 'package:cstore/Model/database_model/picklist_model.dart';
import 'package:cstore/Model/database_model/sys_osdc_reason_model.dart';
import 'package:cstore/Model/database_model/sys_osdc_type_model.dart';
import 'package:cstore/Model/database_model/sys_rtv_reason_model.dart';
import 'package:cstore/Model/database_model/trans_freshness_model.dart';
import 'package:cstore/Model/database_model/trans_one_plus_one_mode.dart';
import 'package:cstore/Model/database_model/trans_sos_model.dart';
import 'package:cstore/Model/database_model/trans_stock_model.dart';
import 'package:cstore/database/table_name.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/database_model/app_setting_model.dart';
import '../Model/database_model/availability_show_model.dart';
import '../Model/database_model/avl_product_placement_model.dart';
import '../Model/database_model/planoguide_gcs_images_list_model.dart';
import '../Model/database_model/pricing_show_model.dart';
import '../Model/database_model/required_module_model.dart';
import '../Model/database_model/rtv_show_model.dart';
import '../Model/database_model/show_before_fixing.dart';
import '../Model/database_model/show_planogram_model.dart';
import '../Model/database_model/show_trans_osdc_model.dart';
import '../Model/database_model/show_trans_rtv_model.dart';
import '../Model/database_model/show_trans_sos.dart';
import '../Model/database_model/sys_brand_faces_model.dart';
import '../Model/database_model/sys_brand_model.dart';
import '../Model/database_model/sys_photo_type.dart';
import '../Model/database_model/sys_product_model.dart';
import '../Model/database_model/sys_product_placement_model.dart';
import '../Model/database_model/sys_store_pog_model.dart';
import '../Model/database_model/total_count_response_model.dart';
import '../Model/database_model/trans_before_faxing.dart';
import '../Model/database_model/trans_brand_shares_model.dart';
import '../Model/database_model/trans_osd_image_model.dart';
import '../Model/database_model/trans_osdc_model.dart';
import '../Model/database_model/trans_planogram_model.dart';
import '../Model/database_model/PlanogramReasonModel.dart';
import '../Model/database_model/category_model.dart';
import '../Model/database_model/client_model.dart';
import '../Model/database_model/dashboard_model.dart';
import '../Model/database_model/drop_reason_model.dart';
import '../Model/database_model/get_trans_photo_model.dart';
import '../Model/database_model/trans_photo_model.dart';
import '../Model/database_model/trans_planoguide_model.dart';
import '../Model/database_model/trans_pricing_model.dart';
import '../Model/database_model/trans_promo_model.dart';
import '../Model/database_model/trans_rtv_model.dart';
import '../Model/request_model.dart/availability_api_request_model.dart';
import '../Model/request_model.dart/brand_share_request.dart';
import '../Model/request_model.dart/planoguide_request_model.dart';
import '../Model/request_model.dart/ready_pick_list_request.dart';
import '../Model/request_model.dart/save_api_pricing_data_request.dart';
import '../Model/request_model.dart/save_api_rtv_data_request.dart';
import '../Model/response_model.dart/adherence_response_model.dart';
import '../Model/response_model.dart/syncronise_response_model.dart';

class DatabaseHelper {
  static var instance;
  static Future<Database?> get database async {
    // Get a location using getDatabasesPath()
    const databaseName = "cstore_pro.db";
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Create your tables here
      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_drop_reason +
          "(" +
          TableName.drop_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.drop_en_name +
          " TEXT, " +
          TableName.drop_ar_name +
          " TEXT, " +
          TableName.drop_status +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_agency_dashboard +
          "(" +
          TableName.agency_dash_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.agency_dash_en_name +
          " TEXT, " +
          TableName.agency_dash_ar_name +
          " TEXT, " +
          TableName.agency_dash_icon +
          " TEXT, " +
          TableName.agency_dash_start_date +
          " TEXT, " +
          TableName.agency_dash_end_date +
          " TEXT, " +
          TableName.agency_dash_accessTo +
          " TEXT, " +
          TableName.agency_dash_status +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_category +
          "(" +
          TableName.cat_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.cat_en_name +
          " TEXT, " +
          TableName.cat_ar_name +
          " TEXT, " +
          TableName.cat_client_id +
          " INTEGER" +
          ")");
      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_subcategory +
          "(" +
          TableName.cat_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.cat_en_name +
          " TEXT, " +
          TableName.cat_ar_name +
          " TEXT, " +
          TableName.cat_client_id +
          " INTEGER" +
          ")");
      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_client +
          "(" +
          TableName.sys_client_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.sys_client_name +
          " TEXT, " +
          TableName.sys_client_logo +
          " BLOB, " +
          TableName.sys_client_classification +
          " INTEGER, " +
          TableName.sys_client_chainSku_code +
          " INTEGER, " +
          TableName.sys_client_is_dayFreshness +
          " INTEGER, " +
          TableName.sys_client_geo_requried +
          " INTEGER, " +
          TableName.sys_client_order_avl +
          " INTEGER, " +
          TableName.sys_client_is_survey +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_planogram_reason +
          "(" +
          TableName.planogram_reason_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.planogram_reason_en_name +
          " TEXT, " +
          TableName.planogram_reason_ar_name +
          " INTEGER, " +
          TableName.planogram_status +
          " INTEGER" +
          ")");
      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_brand +
          "(" +
          TableName.sys_brand_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.sys_brand_en_name +
          " TEXT, " +
          TableName.sys_brand_ar_name +
          " TEXT, " +
          TableName.sys_brand_client_id +
          " INTEGER" +
          ")");

      ///Rtv Reason Table

      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_rtv_reason+
          "(" +
          TableName.sys_rtv_reason_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.sys_rtv_reason_en_name +
          " TEXT, " +
          TableName.sys_rtv_reason_ar_name +
          " TEXT, " +
          TableName.sys_rtv_reason_calendar +
          " INTEGER, " +
          TableName.sys_rtv_reason_status +
          " INTEGER" +
          ")");


      await db.execute('CREATE TABLE '+
          TableName.tbl_sys_photo_type+
          "(" +
          TableName.sys_photo_type_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.sys_photo_type_en_name +
          " TEXT, " +
          TableName.sys_photo_type_ar_name +
          " TEXT" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_osdc_type+
          "(" +
          TableName.sys_osdc_type_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.sys_osdc_type_en_name +
          " TEXT, " +
          TableName.sys_osdc_type_ar_name +
          " TEXT" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_osdc_reason+
          "(" +
          TableName.sys_osdc_reason_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.sys_osdc_reason_en_name +
          " TEXT, " +
          TableName.sys_osdc_reason_ar_name +
          " TEXT" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_product+
          "(" +
          TableName.sys_product_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.sys_product_client_id +
          " INTEGER, " +
          TableName.sys_product_en_name +
          " TEXT, " +
          TableName.sys_product_ar_name +
          " TEXT, " +
          TableName.sys_product_image +
          " TEXT, " +
          TableName.sys_product_principal_id +
          " INTEGER, " +
          TableName.sys_product_cluster_id +
          " INTEGER, " +
          TableName.sys_product_cat_id +
          " INTEGER, " +
          TableName.sys_product_sub_cat_id +
          " INTEGER, " +
          TableName.sys_product_brand_id +
          " INTEGER, " +
          TableName.sys_product_rsp +
          " TEXT, " +
          TableName.sys_product_sku_weight +
          " TEXT" +
          ")");

      await db.execute(
          'CREATE TABLE ' +
              TableName.tbl_sys_store_pog +
              ' (' +
              TableName.trans_photo_client_id + ' INTEGER, ' +
              TableName.sys_store_pog_storeid + ' INTEGER, ' +
              TableName.sys_store_pog_catId + ' INTEGER, ' +
              TableName.sys_store_pog + ' TEXT, ' +
              TableName.sys_store_pog_image + ' TEXT, ' +
              'CONSTRAINT unique_key UNIQUE (' +
              TableName.sys_store_pog_storeid + ', ' +
              TableName.sys_store_pog_catId + ', ' +
              TableName.sys_store_pog +
              ')' +
              ')');

      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_product_placement +
          "(" +
          TableName.sys_product_placement_id +
          " INTEGER, " +
          TableName.sys_product_placement_storeId +
          " INTEGER, " +
          TableName.sys_product_placement_cat_id +
          " INTEGER, " +
          TableName.sys_product_placement_pog +
          " TEXT, " +
          TableName.sys_product_placement_h_facing +
          " INTEGER, " +
          TableName.sys_product_placement_v_facing +
          " INTEGER, " +
          TableName.sys_product_placement_d_facing +
          " INTEGER, " +
          TableName.sys_product_placement_total_facing +
          " INTEGER, " +
          TableName.sys_product_placement_bay_no +
          " TEXT, " +
          TableName.sys_product_placement_shelf_no +
          " TEXT, " +
          TableName.sys_product_placement_rank_x +
          " TEXT, " +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.sys_product_placement_storeId + ', ' +
          TableName.sys_product_placement_id +
          ')' +
          ')');

      await db.execute(
          'CREATE TABLE ' +
              TableName.tbl_sys_brand_faces +
              ' (' +
              TableName.sys_brand_faces_storeId + ' INTEGER, ' +
              TableName.sys_client_id + ' INTEGER, ' +
              TableName.sys_brand_faces_catId + ' INTEGER, ' +
              TableName.sys_brand_faces_brandId + ' INTEGER, ' +
              TableName.sys_brand_faces_givenFaces + ' INTEGER, ' +
              'CONSTRAINT unique_key UNIQUE (' +
              TableName.sys_brand_faces_storeId + ', ' +
              TableName.sys_brand_faces_catId + ', ' +
              TableName.sys_brand_faces_brandId +
              ')' +
              ')');

      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_sos_units+
          "(" +
          TableName.sys_osdc_type_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.sys_osdc_type_en_name +
          " TEXT, " +
          TableName.sys_osdc_type_ar_name +
          " TEXT" +
          ")");
      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_daily_checklist+
          "(" +
          TableName.sys_osdc_type_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.sys_osdc_type_en_name +
          " TEXT, " +
          TableName.sys_osdc_type_ar_name +
          " TEXT" +
          ")");
      await db.execute('CREATE TABLE ' +
          TableName.tbl_sys_app_setting+
          "(" +
          TableName.sys_app_settingId +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.sys_app_settingBgServices +
          " TEXT, " +
          TableName.sys_app_settingBgServiceMinute +
          " TEXT, " +
          TableName.sys_app_settingPicklisService +
          " TEXT, " +
          TableName.sys_app_settingPicklisTime +
          " TEXT" +
          ")");

      //---------***********create trans table here*************---------
      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_before_faxing +
          "(" +
          TableName.trans_photo_id +
          " INTEGER PRIMARY KEY AUTOINCREMENT," +
          TableName.trans_photo_client_id +
          " INTEGER, " +
          TableName.trans_photo_type_id +
          " INTEGER, " +
          TableName.trans_photo_cat_id +
          " INTEGER, " +
          TableName.trans_photo_name +
          " TEXT, " +
          TableName.trans_photo_gcs_status +
          " INTEGER, " +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_upload_status+
          " INTEGER, " +
          TableName.trans_photo_working_id +
          " INTEGER" +
          ")");
      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_photo +
          "(" +
          TableName.trans_photo_id +
          " INTEGER PRIMARY KEY AUTOINCREMENT," +
          TableName.trans_photo_client_id +
          " INTEGER, " +
          TableName.trans_photo_type_id +
          " INTEGER, " +
          TableName.trans_photo_cat_id +
          " INTEGER, " +
          TableName.trans_other_photo_type_id +
          " INTEGER, " +
          TableName.trans_photo_name +
          " TEXT, " +
          TableName.trans_photo_gcs_status +
          " INTEGER, " +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_upload_status+
          " INTEGER, " +
          TableName.trans_photo_working_id +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_planogram +
          "(" +
          TableName.trans_planogram_id +
          " INTEGER PRIMARY KEY AUTOINCREMENT," +
          TableName.trans_planogram_client_id +
          " INTEGER, " +
          TableName.trans_planogram_cat_id +
          " INTEGER, " +
          TableName.trans_planogram_brand_id +
          " INTEGER, " +
          TableName.trans_planogram_image_name +
          " TEXT, " +
          TableName.trans_planogram_is_adherence +
          " INTEGER, " +
          TableName.trans_planogram_gcs_status +
          " INTEGER, " +
          TableName.trans_planogram_reason_id +
          " INTEGER," +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_upload_status+
          " INTEGER, " +
          TableName.trans_planogram_working_id +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_sos +
          "(" +
          TableName.trans_sos_id +
          " INTEGER PRIMARY KEY AUTOINCREMENT," +
          TableName.trans_sos_client_id +
          " INTEGER, " +
          TableName.trans_sos_cat_id +
          " INTEGER, " +
          TableName.trans_sos_brand_id +
          " INTEGER, " +
          TableName.trans_sos_cat_space +
          " TEXT, " +
          TableName.trans_sos_actual_space +
          " TEXT, " +
          TableName.trans_sos_unit +
          " TEXT, " +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_upload_status+
          " INTEGER, " +
          TableName.trans_sos_working_id +
          " INTEGER" +
          ")");
      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_availability +
          "(" +
          TableName.trans_avl_sku_id +
          " INTEGER , " +
          TableName.trans_avl_status +
          " INTEGER, " +
          TableName.trans_avl_activity_status +
          " INTEGER, " +
          TableName.trans_avl_req_picklist +
          " INTEGER, " +
          TableName.trans_avl_actual_picklist +
          " INTEGER, " +
          TableName.trans_avl_picklist_reason +
          " INTEGER, " +
          TableName.trans_avl_picklist_ready +
          " INTEGER, " +
          TableName.trans_pick_upload_status +
          " INTEGER, " +
          TableName.trans_avl_client_id +
          " INTEGER, " +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_avl_picker_name +
          " TEXT, " +
          TableName.trans_upload_status +
          " INTEGER, " +
          TableName.trans_avl_working_id +
          " INTEGER, " +
          TableName.trans_avl_send_time +
          " TEXT, " +
          TableName.trans_avl_receive_time +
          " TEXT, " +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.trans_avl_sku_id + ', ' +
          TableName.trans_avl_working_id +
          ')'+')');

      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_rtv +
          "(" +
          TableName.trans_rtv_id +
          " INTEGER PRIMARY KEY UNIQUE, " +
          TableName.trans_rtv_sku_id +
          " INTEGER " +
          TableName.trans_rtv_type_id +
          " INTEGER, " +
          TableName.trans_rtv_reason +
          " INTEGER, " +
          TableName.trans_rtv_pieces +
          " INTEGER, " +
          TableName.trans_rtv_expire_date+
          " TEXT, " +
          TableName.trans_rtv_image_name +
          " TEXT, " +
          TableName.trans_rtv_activity_status +
          " INTEGER, " +
          TableName.trans_rtv_gcs_status +
          " INTEGER, " +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_upload_status+
          " INTEGER, " +
          TableName.trans_rtv_working_id +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_pricing +
          "(" +
          TableName.trans_pricing_sku_id +
          " INTEGER , " +
          TableName.trans_pricing_regular +
          " TEXT, " +
          TableName.trans_pricing_promo +
          " TEXT, " +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_upload_status +
          " INTEGER, " +
          TableName.trans_rtv_activity_status +
          " INTEGER, " +
          TableName.trans_pricing_working_id +
          " INTEGER, " +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.trans_pricing_sku_id + ', ' +
          TableName.trans_pricing_working_id +
          ')' +
          ')');


      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_freshness +
          "(" +
          TableName.trans_freshness_id+
          " INTEGER PRIMARY KEY AUTOINCREMENT," +
          TableName.trans_freshness_sku_id +
          " INTEGER, " +
          TableName.trans_freshness_year +
          " INTEGER, " +
          TableName.trans_freshness_jan +
          " TEXT, " +
          TableName.trans_freshness_feb+
          " TEXT, " +
          TableName.trans_freshness_mar +
          " TEXT, " +
          TableName.trans_freshness_apr +
          " TEXT, " +
          TableName.trans_freshness_may +
          " TEXT, " +
          TableName.trans_freshness_jun+
          " TEXT, " +
          TableName.trans_freshness_jul +
          " TEXT, " +
          TableName.trans_freshness_aug +
          " TEXT, " +
          TableName.trans_freshness_sep +
          " TEXT, " +
          TableName.trans_freshness_oct+
          " TEXT, " +
          TableName.trans_freshness_nov +
          " TEXT, " +
          TableName.trans_freshness_dec +
          " TEXT, " +
          TableName.trans_freshness_cases+
          " TEXT, " +
          TableName.trans_freshness_outer+
          " TEXT, " +
          TableName.trans_freshness_pieces +
          " INTEGER, " +
          TableName.trans_freshness_specific_date +
          " TEXT, " +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_upload_status+
          " INTEGER, " +
          TableName.trans_freshness_working_id +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_stock +
          "(" +
          TableName.trans_stock_id+
          " INTEGER PRIMARY KEY AUTOINCREMENT," +
          TableName.trans_stock_sku_id +
          " INTEGER, " +
          TableName.trans_stock_cases +
          " TEXT, " +
          TableName.trans_stock_outer+
          " TEXT, " +
          TableName.trans_stock_pieces+
          " INTEGER, " +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_upload_status+
          " INTEGER, " +
          TableName.trans_stock_working_id +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_osdc +
          "(" +
          TableName.trans_osdc_id+
          " INTEGER PRIMARY KEY AUTOINCREMENT," +
          TableName.trans_osdc_brand_id +
          " INTEGER, " +
          TableName.trans_osdc_reason_id+
          " INTEGER, " +
          TableName.trans_osdc_quantity+
          " INTEGER, " +
          TableName.trans_osdc_gcs_status+
          " INTEGER, " +
          TableName.trans_osdc_type_id+
          " INTEGER, " +
          TableName.trans_osdc_client_id+
          " INTEGER, " +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_upload_status+
          " INTEGER, " +
          TableName.trans_osdc_working_id +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_osdc_images +
          "(" +
          TableName.trans_osdc_images_id+
          " INTEGER PRIMARY KEY AUTOINCREMENT," +
          TableName.trans_osdc_main_id +
          " INTEGER, " +
          TableName.trans_osdc_imagesName+
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_one_plus_one +
          "(" +
          TableName.trans_one_plus_one_id+
          " INTEGER PRIMARY KEY AUTOINCREMENT," +
          TableName.trans_one_plus_one_sku_id +
          " INTEGER, " +
          TableName.trans_one_plus_one_quantity +
          " INTEGER, " +
          TableName.trans_one_plus_one_doc_no+
          " TEXT, " +
          TableName.trans_one_plus_one_comment+
          " TEXT, " +
          TableName.trans_one_plus_one_type+
          " TEXT, " +
          TableName.trans_one_plus_one_image+
          " TEXT, " +
          TableName.trans_one_plus_one_doc_image+
          " TEXT, " +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_upload_status+
          " INTEGER, " +
          TableName.trans_one_plus_one_working_id +
          " INTEGER" +
          ")");

      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_promoplan +
          "(" +
          TableName.trans_promo_id+
          " INTEGER PRIMARY KEY AUTOINCREMENT," +
          TableName.trans_promo_db_id +
          " INTEGER, " +
          TableName.trans_promo_plan_id +
          " INTEGER, " +
          TableName.trans_promo_status+
          " INTEGER, " +
          TableName.trans_promo_reason+
          " TEXT, " +
          TableName.trans_promo_image_name+
          " TEXT, " +
          TableName.trans_date_time +
          " TEXT, " +
          TableName.trans_upload_status+
          " INTEGER, " +
          TableName.trans_promo_working_id +
          " INTEGER" +
          ")");


      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_planoguide +
          "(" +
          TableName.trans_planoguide_id +
          " INTEGER PRIMARY KEY AUTOINCREMENT, " +
          TableName.trans_planoguide_catId +
          " INTEGER, " +
          TableName.sys_client_id +
          " INTEGER, " +
          TableName.trans_planoguide_storeId +
          " INTEGER, " +
          TableName.trans_planoguide_pog +
          " TEXT, " +
          TableName.trans_planoguide_isAdherence +
          " TEXT, " +
          TableName.trans_planoguide_imageName +
          " TEXT, " +
          TableName.trans_planoguide_skuImageName +
          " TEXT, " +
          TableName.trans_planoguide_dateTime +
          " TEXT, " +
          TableName.trans_planoguide_upload_status +
          " INTEGER, " +
          TableName.trans_planoguide_activity_status +
          " INTEGER, " +
          TableName.trans_planoguide_gcs_status +
          " INTEGER, " +
          TableName.trans_planoguide_working_id +
          " INTEGER, " +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.trans_planoguide_storeId + ', ' +
          TableName.trans_planoguide_catId + ', ' +
          TableName.trans_planoguide_pog + ', ' +
          TableName.trans_planoguide_working_id +
          ')' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tbl_trans_BrandShare +
          "(" +
          TableName.trans_brand_shares_id +
          " INTEGER PRIMARY KEY AUTOINCREMENT, " +
          TableName.trans_brand_shares_catId +
          " INTEGER, " +
          TableName.sys_client_id +
          " INTEGER, " +
          TableName.trans_brand_shares_storeId +
          " INTEGER, " +
          TableName.trans_brand_shares_brandId +
          " INTEGER, " +
          TableName.trans_brand_shares_givenFaces +
          " TEXT, " +
          TableName.trans_brand_shares_actualFaces +
          " TEXT, " +
          TableName.trans_brand_shares_dateTime +
          " TEXT, " +
          TableName.trans_brand_shares_uploadStauts +
          " INTEGER, " +
          TableName.trans_planoguide_activity_status +
          " INTEGER, " +
          TableName.trans_brand_shares_workingId +
          " INTEGER, " +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.trans_brand_shares_storeId + ', ' +
          TableName.trans_brand_shares_brandId + ', ' +
          TableName.trans_brand_shares_catId + ', ' +
          TableName.trans_planoguide_working_id +
          ')' +
          ')');


      ///PickList Addition

      await db.execute('CREATE TABLE ' +
          TableName.tbl_picklist +
          "(" +
          TableName.picklist_id +
          " INTEGER PRIMARY KEY UNIQUE," +
          TableName.picklist_store_id +
          " INTEGER,"+
          TableName.picklist_category_id +
          " INTEGER,"+
          TableName.picklist_tmr_id +
          " INTEGER,"+
          TableName.picklist_tmr_name +
          " TEXT,"+
          TableName.picklist_stocker_id +
          " INTEGER," +
          TableName.picklist_stocker_name +
          " TEXT," +
          TableName.picklist_shift_time  +
          " TEXT," +
          TableName.picklist_en_cat_name +
          " TEXT," +
          TableName.picklist_ar_cat_name  +
          " TEXT," +
          TableName.picklist_sku_picture  +
          " TEXT," +
          TableName.picklist_en_sku_name   +
          " TEXT," +
          TableName.picklist_ar_sku_name    +
          " TEXT," +
          TableName.picklist_act_picklist    +
          " INTEGER,"+
          TableName.picklist_req_picklist    +
          " INTEGER,"+
          TableName.trans_upload_status +
          " INTEGER, " +
          TableName.picklist_picklist_ready  +
          " INTEGER, "+
          TableName.trans_avl_send_time +
          " TEXT, " +
          TableName.trans_avl_receive_time +
          " TEXT " +")");

      ///Required Modules List Addition
      await db.execute('CREATE TABLE ' +
          TableName.tblSysVisitReqModules +
          "(" +
          TableName.tblSysModuleId +
          " INTEGER," +
          TableName.tblSysVisitActivityType +
          " INTEGER,"+
          ' CONSTRAINT unique_key UNIQUE (' +
          TableName.tblSysModuleId + ', ' +
          TableName.tblSysVisitActivityType + ')' + ")"
      );


    });

  }
  static Future<Database> initDataBase() async {
    return await openDatabase('cstore_pro.db');
  }
  //   ---****** Check Duplicate Data In List-----********
  static Future<bool> hasDuplicateEntry(Database db, String tableName, Map<String, dynamic> fields) async {
    final whereClause = fields.keys.map((key) => '$key = ?').join(' AND ');
    final whereArgs = fields.values.toList();

    final results = await db.query(
      tableName,
      where: whereClause,
      whereArgs: whereArgs,
    );
    return results.isNotEmpty;
  }
  //   ---******insert Data using Array List Start-----********
  static Future<bool> insertAppSettingArray(List<SysAppSettingModel> modelList) async {
    var db = await initDataBase();

    for (SysAppSettingModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sys_app_settingBgServices: data.isBgServices.toString(),
        TableName.sys_app_settingBgServiceMinute: data.isBgMinute.toString(),
        TableName.sys_app_settingPicklisService: data.isPicklistService.toString(),
        TableName.sys_app_settingPicklisTime: data.isPicklistTime.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_app_setting, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry App Setting type");
      } else {
        await db.insert(
          TableName.tbl_sys_app_setting,
          {
            TableName.sys_app_settingBgServices: data.isBgServices.toString(),
            TableName.sys_app_settingBgServiceMinute: data.isBgMinute.toString(),
            TableName.sys_app_settingPicklisService: data.isPicklistService.toString(),
            TableName.sys_app_settingPicklisTime: data.isPicklistTime.toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return true;
  }

  ///Insert Required Modules to system table
  static Future<bool> insertSysRequiredModuleArray(List<RequiredModuleModel> modelList) async {
    var db = await initDataBase();

    for (RequiredModuleModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.tblSysModuleId: data.moduleId,
        TableName.tblSysVisitActivityType: data.visitActivityTypeId,

      };

      print("Sys Req Module Item");
      print(jsonEncode(data));

      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysVisitReqModules, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry sys Required Modules reason");
      } else {
        await db.insert(
          TableName.tblSysVisitReqModules,
          {
            TableName.tblSysModuleId: data.moduleId,
            TableName.tblSysVisitActivityType: data.visitActivityTypeId,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }




  static Future<bool> insertDailyCheckListArray(List<Sys_OSDCTypeModel> modelList) async {
    var db = await initDataBase();

    for (Sys_OSDCTypeModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sys_osdc_type_id: data.id,
        TableName.sys_osdc_type_en_name: data.en_name.toString(),
        TableName.sys_osdc_type_ar_name: data.ar_name.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_daily_checklist, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry DailyCheckList type");
      } else {
        await db.insert(
          TableName.tbl_sys_daily_checklist,
          {
            TableName.sys_osdc_type_id: data.id,
            TableName.sys_osdc_type_en_name: data.en_name.toString(),
            TableName.sys_osdc_type_ar_name: data.ar_name.toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return true;
  }
  static Future<bool> insertSOSUnitArray(List<Sys_OSDCTypeModel> modelList) async {
    var db = await initDataBase();

    for (Sys_OSDCTypeModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sys_osdc_type_id: data.id,
        TableName.sys_osdc_type_en_name: data.en_name.toString(),
        TableName.sys_osdc_type_ar_name: data.ar_name.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_sos_units, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry sos unit type");
      } else {
        await db.insert(
          TableName.tbl_sys_sos_units,
          {
            TableName.sys_osdc_type_id: data.id,
            TableName.sys_osdc_type_en_name: data.en_name.toString(),
            TableName.sys_osdc_type_ar_name: data.ar_name.toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return true;
  }
  static Future<bool> insertClientArray(List<SysClient> modelList) async {
    // final db = await getDatabase();
    var db = await initDataBase();
    for (SysClient data in modelList) {
      await db.insert(
        TableName.tbl_sys_client,
        {
          TableName.sys_client_id: data.clientId,
          TableName.sys_client_name: data.clientName,
          TableName.sys_client_logo: data.logo,
          TableName.sys_client_classification: data.isClassification,
          TableName.sys_client_chainSku_code: data.isChainSkuCodes,
          TableName.sys_client_is_dayFreshness: data.isDayFreshness,
          TableName.sys_client_order_avl: data.isSuggetedOrderAvl,
          TableName.sys_client_is_survey: data.isSurvey,
          TableName.sys_client_geo_requried: data.isGeoRequired
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return false;
  }
  static Future<bool> insertAgencyDashArray(List<SysAgencyDashboard> modelList) async {
    var db = await initDataBase();

    for (SysAgencyDashboard data in modelList) {
      Map<String, dynamic> fields = {
        TableName.agency_dash_id: data.id,
        TableName.agency_dash_en_name: data.enName,
        TableName.agency_dash_ar_name: data.arName,
        TableName.agency_dash_start_date: data.startDate,
        TableName.agency_dash_end_date: data.endDate,
        TableName.agency_dash_icon: data.iconSvg,
        TableName.agency_dash_status: data.status,
        TableName.agency_dash_accessTo: data.accessTo,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_agency_dashboard, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry drop reason");
      } else {
        await db.insert(
          TableName.tbl_sys_agency_dashboard,
          {
            TableName.agency_dash_id: data.id,
            TableName.agency_dash_en_name: data.enName,
            TableName.agency_dash_ar_name: data.arName,
            TableName.agency_dash_start_date: data.startDate,
            TableName.agency_dash_end_date: data.endDate,
            TableName.agency_dash_icon: data.iconSvg,
            TableName.agency_dash_status: data.status,
            TableName.agency_dash_accessTo: data.accessTo,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertDropReasonArray(List<Sys> modelList) async {
    var db = await initDataBase();

    for (Sys data in modelList) {
      Map<String, dynamic> fields = {
        TableName.drop_id: data.id,
        TableName.drop_en_name: data.enName,
        TableName.drop_ar_name: data.arName,
        TableName.drop_status: data.status,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_drop_reason, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry drop reason");
      } else {
        await db.insert(
          TableName.tbl_sys_drop_reason,
          {
            TableName.drop_id: data.id,
            TableName.drop_en_name: data.enName,
            TableName.drop_ar_name: data.arName,
            TableName.drop_status: data.status,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertBrandArray(List<CategoryResModel> modelList) async {
    var db = await initDataBase();

    for (CategoryResModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sys_brand_id: data.id,
        TableName.sys_brand_en_name: data.enName,
        TableName.sys_brand_ar_name: data.arName,
        TableName.sys_brand_client_id: data.clientId,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_brand, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry sys brand");
      } else {
        await db.insert(
          TableName.tbl_sys_brand,
          {
            TableName.sys_brand_id: data.id,
            TableName.sys_brand_en_name: data.enName,
            TableName.sys_brand_ar_name: data.arName,
            TableName.sys_brand_client_id: data.clientId,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertSysPlanoReasonArray(List<PlanogramReasonModel> modelList) async {
    var db = await initDataBase();

    for (PlanogramReasonModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.planogram_reason_id: data.id,
        TableName.planogram_reason_en_name: data.en_name,
        TableName.planogram_reason_ar_name: data.ar_name,
        TableName.planogram_status: data.status,

      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_planogram_reason, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry sys plano reason");
      } else {
        await db.insert(
          TableName.tbl_sys_planogram_reason,
          {
            TableName.planogram_reason_id: data.id,
            TableName.planogram_reason_en_name: data.en_name,
            TableName.planogram_reason_ar_name: data.ar_name,
            TableName.planogram_status: data.status,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }

  static Future<bool> insertSysRTVReasonArray(List<Sys_RTVReasonModel> modelList) async {
    var db = await initDataBase();

    for (Sys_RTVReasonModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sys_rtv_reason_id: data.id,
        TableName.sys_rtv_reason_en_name: data.en_name,
        TableName.sys_rtv_reason_ar_name: data.ar_name,
        TableName.sys_rtv_reason_calendar: data.calendar,
        TableName.sys_rtv_reason_status: data.status,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_rtv_reason, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry RTV reason");
      } else {
        await db.insert(
          TableName.tbl_sys_rtv_reason,
          {
            TableName.sys_rtv_reason_id: data.id,
            TableName.sys_rtv_reason_en_name: data.en_name,
            TableName.sys_rtv_reason_ar_name: data.ar_name,
            TableName.sys_rtv_reason_calendar: data.calendar,
            TableName.sys_rtv_reason_status: data.status,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertSysPhotoTypeArray(List<Sys_PhotoTypeModel> modelList) async {
    var db = await initDataBase();

    for (Sys_PhotoTypeModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sys_photo_type_id: data.id,
        TableName.sys_photo_type_en_name: data.en_name,
        TableName.sys_photo_type_ar_name: data.ar_name,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_photo_type, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry photo type");
      } else {
        await db.insert(
          TableName.tbl_sys_photo_type,
          {
            TableName.sys_photo_type_id: data.id,
            TableName.sys_photo_type_en_name: data.en_name,
            TableName.sys_photo_type_ar_name: data.ar_name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertOSDCTypeArray(List<Sys_OSDCTypeModel> modelList) async {
    var db = await initDataBase();

    for (Sys_OSDCTypeModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sys_osdc_type_id: data.id,
        TableName.sys_osdc_type_en_name: data.en_name.toString(),
        TableName.sys_osdc_type_ar_name: data.ar_name.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_osdc_type, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry osdc type");
      } else {
        await db.insert(
          TableName.tbl_sys_osdc_type,
          {
            TableName.sys_osdc_type_id: data.id,
            TableName.sys_osdc_type_en_name: data.en_name.toString(),
            TableName.sys_osdc_type_ar_name: data.ar_name.toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertOSDCReasonArray(List<Sys_OSDCReasonModel> modelList) async {
    var db = await initDataBase();

    for (Sys_OSDCReasonModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sys_osdc_reason_id: data.id,
        TableName.sys_osdc_reason_en_name: data.en_name.toString(),
        TableName.sys_osdc_reason_ar_name: data.ar_name.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_osdc_reason, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry osdc");
      } else {
        await db.insert(
          TableName.tbl_sys_osdc_reason,
          {
            TableName.sys_osdc_reason_id: data.id,
            TableName.sys_osdc_reason_en_name: data.en_name.toString(),
            TableName.sys_osdc_reason_ar_name: data.ar_name.toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertCategoryArray(List<CategoryResModel> modelList) async {
    var db = await initDataBase();

    for (CategoryResModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.cat_id: data.id,
        TableName.cat_client_id: data.clientId,
        TableName.cat_en_name: data.enName,
        TableName.cat_ar_name: data.arName,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_category, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry sys category");
      } else {
        await db.insert(
          TableName.tbl_sys_category,
          {
            TableName.cat_id: data.id,
            TableName.cat_client_id: data.clientId,
            TableName.cat_en_name: data.enName,
            TableName.cat_ar_name: data.arName,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertSubCategoryArray(List<CategoryResModel> modelList) async {
    var db = await initDataBase();

    for (CategoryResModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.cat_id: data.id,
        TableName.cat_client_id: data.clientId,
        TableName.cat_en_name: data.enName,
        TableName.cat_ar_name: data.arName,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_subcategory, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry sys sub category");
      } else {
        await db.insert(
          TableName.tbl_sys_subcategory,
          {
            TableName.cat_id: data.id,
            TableName.cat_client_id: data.clientId,
            TableName.cat_en_name: data.enName,
            TableName.cat_ar_name: data.arName,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertProductArray(List<Sys_ProductModel> modelList) async {
    var db = await initDataBase();
    for (Sys_ProductModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sys_product_id: data.id,
        TableName.sys_product_client_id: data.client_id,
        TableName.sys_product_en_name: data.en_name,
        TableName.sys_product_ar_name: data.ar_name,
        TableName.sys_product_image: data.image,
        TableName.sys_product_principal_id: data.principal_id,
        TableName.sys_product_cluster_id: data.cluster_id,
        TableName.sys_product_cat_id: data.cat_id,
        TableName.sys_product_sub_cat_id: data.sub_cat_id,
        TableName.sys_product_brand_id: data.brand_id,
        TableName.sys_product_rsp: data.rsp,
        TableName.sys_product_sku_weight: data.sku_weight,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_product, fields);

      if (isDuplicate) {
        print("Error: Duplicate entry sys product");
      } else {
        await db.insert(
          TableName.tbl_sys_product,
          {
            TableName.sys_product_id: data.id,
            TableName.sys_product_client_id: data.client_id,
            TableName.sys_product_en_name: data.en_name,
            TableName.sys_product_ar_name: data.ar_name,
            TableName.sys_product_image: data.image,
            TableName.sys_product_principal_id: data.principal_id,
            TableName.sys_product_cluster_id: data.cluster_id,
            TableName.sys_product_cat_id: data.cat_id,
            TableName.sys_product_sub_cat_id: data.sub_cat_id,
            TableName.sys_product_brand_id: data.brand_id,
            TableName.sys_product_rsp: data.rsp,
            TableName.sys_product_sku_weight: data.sku_weight,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertStorePogArray(List<SysStorePogModel> modelList) async {
    var db = await initDataBase();

    for (SysStorePogModel data in modelList) {
      print("PoG Arraya");
      print(jsonEncode(data));
      Map<String, dynamic> fields = {
        TableName.sys_store_pog_storeid: data.storeId,
        TableName.sys_client_id: data.clientId,
        TableName.sys_store_pog_catId: data.catId.toString(),
        TableName.sys_store_pog: data.pog.toString(),
        TableName.sys_store_pog_image: data.pogImage.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_store_pog, fields);

      if (isDuplicate) {
        print("Error: Duplicate store pog");
      } else {
        await db.insert(
          TableName.tbl_sys_store_pog,
          {
            TableName.sys_store_pog_storeid: data.storeId,
            TableName.sys_client_id:data.clientId,
            TableName.sys_store_pog_catId: data.catId.toString(),
            TableName.sys_store_pog: data.pog.toString(),
            TableName.sys_store_pog_image: data.pogImage.toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertProductPlacementArray(List<SysProductPlacementModel> modelList) async {
    var db = await initDataBase();

    for (SysProductPlacementModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sys_product_placement_id:data.skuId,
        TableName.sys_product_placement_storeId: data.storeId,
        TableName.sys_product_placement_cat_id: data.catId.toString(),
        TableName.sys_product_placement_pog: data.pog.toString(),
        TableName.sys_product_placement_h_facing: data.h_facing.toString(),
        TableName.sys_product_placement_v_facing: data.v_facing.toString(),
        TableName.sys_product_placement_d_facing: data.d_facing.toString(),
        TableName.sys_product_placement_total_facing: data.total_facing.toString(),
        TableName.sys_product_placement_bay_no: data.bay_no.toString(),
        TableName.sys_product_placement_shelf_no: data.shelf_no.toString(),
        TableName.sys_product_placement_rank_x: data.rank_x.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_product_placement, fields);

      if (isDuplicate) {
        print("Error: Duplicate store pog");
      } else {
        await db.insert(
          TableName.tbl_sys_product_placement,
          {
            TableName.sys_product_placement_id:data.skuId,
            TableName.sys_product_placement_storeId: data.storeId,
            TableName.sys_product_placement_cat_id: data.catId.toString(),
            TableName.sys_product_placement_pog: data.pog.toString(),
            TableName.sys_product_placement_h_facing: data.h_facing.toString(),
            TableName.sys_product_placement_v_facing: data.v_facing.toString(),
            TableName.sys_product_placement_d_facing: data.d_facing.toString(),
            TableName.sys_product_placement_total_facing: data.total_facing.toString(),
            TableName.sys_product_placement_bay_no: data.bay_no.toString(),
            TableName.sys_product_placement_shelf_no: data.shelf_no.toString(),
            TableName.sys_product_placement_rank_x: data.rank_x.toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<bool> insertBrandFacesArray(List<SysBrandFacesModel> modelList) async {
    var db = await initDataBase();

    print("Brand Share Length");
    print(modelList.length);

    for (SysBrandFacesModel data in modelList) {
      print("Brand Face Array");
      print(jsonEncode(data));
      Map<String, dynamic> fields = {
        TableName.sys_brand_faces_storeId: data.storeId,
        TableName.sys_client_id:  data.clientId,
        TableName.sys_brand_faces_catId: data.catId.toString(),
        TableName.sys_brand_faces_brandId: data.brand_id.toString(),
        TableName.sys_brand_faces_givenFaces: data.given_faces.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tbl_sys_brand_faces, fields);

      if (isDuplicate) {
        print("Error: Duplicate store Shelf Share");
      } else {
        await db.insert(
          TableName.tbl_sys_brand_faces,
          {
            TableName.sys_brand_faces_storeId: data.storeId,
            TableName.sys_client_id:data.clientId,
            TableName.sys_brand_faces_catId: data.catId.toString(),
            TableName.sys_brand_faces_brandId: data.brand_id.toString(),
            TableName.sys_brand_faces_givenFaces: data.given_faces.toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  static Future<void> insertClient(ClientModel model) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_sys_client,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> insertAgencyDashboard(AgencyDashboardModel dashmodel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_sys_agency_dashboard,
      dashmodel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }
  static Future<void> insertDropReason(DropReasonModel model) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_sys_drop_reason,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> insertBeforeFaxing(TransBeforeFaxingModel beforeFaxing) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_before_faxing,
      beforeFaxing.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// ----********* trans table data insert-----************
  static Future<List<AvailabilityShowModel>> getAvlDataList(String workingId, String clientId, String brandId,String categoryId,String subCategoryId) async {
    final db = await initDataBase();

    // Start building the base query
    String query = "SELECT trans_availability.*, sys_category.en_name || ' ' || sys_subcategory.en_name as cat_en_name, sys_category.ar_name || ' ' || sys_subcategory.ar_name as cat_ar_name, sys_subcategory.en_name as subcat_en_name, sys_subcategory.ar_name as subcat_ar_name, "
        "sys_brand.en_name as brand_en_name, sys_brand.ar_name as brand_ar_name, sys_product.image, sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name "
        "FROM trans_availability "
        "JOIN sys_product ON sys_product.id = trans_availability.sku_id "
        "JOIN sys_category ON sys_category.id = sys_product.category_id "
        "JOIN sys_brand ON sys_brand.id = sys_product.brand_id "
        "JOIN sys_subcategory ON sys_subcategory.id = sys_product.subcategory_id "
        "WHERE working_id = '$workingId' ";

    // List to hold conditions
    List<String> conditions = [];

    // Add conditions based on search parameters
    if (clientId != "-1") {
      conditions.add("trans_availability.client_id = '$clientId'");
    }
    if (brandId != "-1") {
      conditions.add("sys_product.brand_id = '$brandId'");
    }
    if (subCategoryId != "-1") {
      conditions.add("sys_product.subcategory_id = '$subCategoryId'");
    }
    if (categoryId != "-1") {
      conditions.add("sys_product.category_id = '$categoryId'");
    }

    // Join conditions with 'AND' in the query
    if (conditions.isNotEmpty) {
      query += " AND " + conditions.join(" AND ");
    }

    query += " ORDER BY sys_subcategory.en_name,sys_brand.en_name ASC";
    print("AVL");
    print(query);
    final List<Map<String, dynamic>> avlMap = await db.rawQuery(query);
  print(avlMap);
    return List.generate(avlMap.length, (index) {
      return AvailabilityShowModel(
        pro_id: avlMap[index]['sku_id'] as int,
        upload_status: avlMap[index]['upload_status'] ?? 0,
        client_id: avlMap[index]['client_id'] as int,
        cat_en_name: avlMap[index]['cat_en_name'] ?? "",
        cat_ar_name: avlMap[index]['cat_ar_name'] ?? "",
        pro_en_name: avlMap[index]['pro_en_name'] ?? "",
        pro_ar_name: avlMap[index]['pro_ar_name'] ?? "",
        image: avlMap[index]['image'] ?? "",
        avl_status: avlMap[index]['avl_status'] ?? -1,
        actual_picklist: avlMap[index]['actual_picklist'] ?? 0,
        activity_status: avlMap[index]['activity_status'] ?? 0,
        requried_picklist: avlMap[index]['req_picklist'] ?? 0,
        brand_en_name: avlMap[index]['brand_en_name'] ?? "",
        brand_ar_name: avlMap[index]['brand_ar_name'] ?? "",
        picklist_reason: 1,
        picklist_ready: avlMap[index]['picklist_ready'] ?? 0,
        picker_name : avlMap[index]['picker_name'] ?? '',
        pick_upload_status: avlMap[index]['pick_upload_status'],
        pick_list_send_time: avlMap[index]['pick_list_send_time'] ?? "",
        pick_list_receive_time: avlMap[index]['pick_list_receive_time'] ?? ""
      );
    });
  }

  static Future<List<AvailabilityShowModel>> getActivityStatusAvlDataList(String workingId) async {
    final db = await initDataBase();

    // Start building the base query
    String query = "SELECT trans_availability.*, sys_category.en_name || ' ' || sys_subcategory.en_name as cat_en_name, sys_category.ar_name || ' ' || sys_subcategory.ar_name as cat_ar_name, sys_subcategory.en_name as subcat_en_name, sys_subcategory.ar_name as subcat_ar_name, "
        "sys_brand.en_name as brand_en_name, sys_brand.ar_name as brand_ar_name, sys_product.image, sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name "
        "FROM trans_availability "
        "JOIN sys_product ON sys_product.id = trans_availability.sku_id "
        "JOIN sys_category ON sys_category.id = sys_product.category_id "
        "JOIN sys_brand ON sys_brand.id = sys_product.brand_id "
        "JOIN sys_subcategory ON sys_subcategory.id = sys_product.subcategory_id "
        "WHERE working_id = '$workingId' AND activity_status=1";

    print("AVL Activity Status");
    print(query);
    final List<Map<String, dynamic>> avlMap = await db.rawQuery(query);

    return List.generate(avlMap.length, (index) {
      return AvailabilityShowModel(
        pro_id: avlMap[index]['sku_id'] as int,
        upload_status: avlMap[index]['upload_status'] ?? 0,
        client_id: avlMap[index]['client_id'] as int,
        cat_en_name: avlMap[index]['cat_en_name'] ?? "",
        cat_ar_name: avlMap[index]['cat_ar_name'] ?? "",
        pro_en_name: avlMap[index]['pro_en_name'] ?? "",
        pro_ar_name: avlMap[index]['pro_ar_name'] ?? "",
        image: avlMap[index]['image'] ?? "",
        avl_status: avlMap[index]['avl_status'] ?? -1,
        actual_picklist: avlMap[index]['actual_picklist'] ?? 0,
        activity_status: avlMap[index]['activity_status'] ?? 0,
        requried_picklist: avlMap[index]['req_picklist'] ?? 0,
        brand_en_name: avlMap[index]['brand_en_name'] ?? "",
        brand_ar_name: avlMap[index]['brand_ar_name'] ?? "",
        picklist_reason: 1,
        picklist_ready: avlMap[index]['picklist_ready'] ?? 0,
        picker_name : avlMap[index]['picker_name'] ?? '',
        pick_upload_status: avlMap[index]['pick_upload_status'],
        pick_list_send_time: avlMap[index]['pick_list_send_time'] ?? "",
        pick_list_receive_time: avlMap[index]['pick_list_receive_time'] ?? ""
      );
    });
  }


  static Future<List<AvlProductPlacementModel>> getAvlProductPlacement(String skuId,String storeId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> placementMap = await db.rawQuery("SELECT *FROM sys_product_placement"
        " WHERE sku_id=$skuId and store_id=$storeId");
    print("___  Product Placement Data List _______");
    print(jsonEncode(placementMap));
    return List.generate(placementMap.length, (index) {
      return AvlProductPlacementModel(
        shelfNo: placementMap[index]['shelf_no'].toString() == "null" ? "0" : placementMap[index]['shelf_no'].toString(),
        buyNo: placementMap[index]['bay_no'].toString() == "null" ? "0" : placementMap[index]['bay_no'].toString(),
        h_facing: placementMap[index]['h_facings'].toString() == "null" ? "0" : placementMap[index]['h_facings'].toString(),
        v_facing: placementMap[index]['v_facings'].toString() == "null" ? "0" : placementMap[index]['v_facings'].toString(),
        d_facing: placementMap[index]['d_facings'].toString() == "null" ? "0" : placementMap[index]['d_facings'].toString(),
        pog: placementMap[index]['pog'].toString() == "null" ? "" : placementMap[index]['pog'].toString(),
      );
    });
  }

  static Future<List<TransPlanoGuideModel>> getPlanoGuideDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = "SELECT trans_planoguide.id as trans_plano_id,trans_planoguide.client_id,sys_category.en_name as cat_en_name,"
        "trans_planoguide.cat_id,trans_planoguide.activity_status,sys_category.ar_name as cat_ar_name,trans_planoguide.pog as pog,trans_planoguide.imageName,trans_planoguide.isAdherence,trans_planoguide.skuImageName,trans_planoguide.upload_status,trans_planoguide.gcs_status "
        " FROM trans_planoguide"
        " join sys_category on sys_category.id=trans_planoguide.cat_id"
        " WHERE working_id=$workingId ORDER BY trans_planoguide.cat_id,pog ASC";

    print("PLANOGUIDE QUERY");
    print(rawQuery);

    final List<Map<String, dynamic>> planoguideMap = await db.rawQuery(rawQuery);

    return List.generate(planoguideMap.length, (index) {
      return TransPlanoGuideModel(
        id: planoguideMap[index]['trans_plano_id'] as int,
        cat_id: planoguideMap[index]['cat_id'] as int,
        cat_en_name: planoguideMap[index]['cat_en_name'] ?? "",
        cat_ar_name: planoguideMap[index]['cat_ar_name'] ?? "",
        pog: planoguideMap[index]['pog'] ?? "",
        imageFile: null,
        skuImageName: planoguideMap[index]['skuImageName'] == null || planoguideMap[index]['skuImageName'] == "null" ? "" : planoguideMap[index]['skuImageName'],
        gcs_status: planoguideMap[index]['gcs_status'],
        upload_status: planoguideMap[index]['upload_status'] ?? 0,
        activity_status: planoguideMap[index]['activity_status'] ?? 0,
        client_id: planoguideMap[index]['client_id'],
        imageName: planoguideMap[index]['imageName'] ?? "",
        isAdherence: planoguideMap[index]['isAdherence'] ?? "-1",

      );
    });
  }

  static Future<List<TransPlanoGuideModel>> getPlanoGuideFilteredDataList(String workingId,int activityStatus,String isAdhere) async {
    final db = await initDataBase();
    String rawQuery = "SELECT trans_planoguide.id as trans_plano_id,trans_planoguide.client_id,sys_category.en_name as cat_en_name,"
        "trans_planoguide.cat_id,trans_planoguide.activity_status,sys_category.ar_name as cat_ar_name,trans_planoguide.pog as pog,trans_planoguide.imageName,trans_planoguide.isAdherence,trans_planoguide.skuImageName,trans_planoguide.upload_status,trans_planoguide.gcs_status "
        " FROM trans_planoguide"
        " join sys_category on sys_category.id=trans_planoguide.cat_id"
        " WHERE working_id=$workingId AND activity_status=$activityStatus AND isAdherence=$isAdhere ORDER BY trans_planoguide.cat_id,pog ASC";

    print("PLANOGUIDE QUERY");
    print(rawQuery);

    final List<Map<String, dynamic>> planoguideMap = await db.rawQuery(rawQuery);

    return List.generate(planoguideMap.length, (index) {
      return TransPlanoGuideModel(
        id: planoguideMap[index]['trans_plano_id'] as int,
        cat_id: planoguideMap[index]['cat_id'] as int,
        cat_en_name: planoguideMap[index]['cat_en_name'] ?? "",
        cat_ar_name: planoguideMap[index]['cat_ar_name'] ?? "",
        pog: planoguideMap[index]['pog'] ?? "",
        imageFile: null,
        skuImageName: planoguideMap[index]['skuImageName'] == null || planoguideMap[index]['skuImageName'] == "null" ? "" : planoguideMap[index]['skuImageName'],
        gcs_status: planoguideMap[index]['gcs_status'],
        upload_status: planoguideMap[index]['upload_status'] ?? 0,
        activity_status: planoguideMap[index]['activity_status'] ?? 0,
        client_id: planoguideMap[index]['client_id'],
        imageName: planoguideMap[index]['imageName'] ?? "",
        isAdherence: planoguideMap[index]['isAdherence'] ?? "-1",

      );
    });
  }

  static Future<List<SavePlanoguideListData>> getActivityStatusPlanoGuideDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = "SELECT id,client_id,cat_id As category_id,pog,isAdherence as is_adh,skuImageName as image_name "
        " FROM trans_planoguide WHERE working_id=$workingId AND activity_status=1 AND upload_status=0";

    print("PLANOGUIDE QUERY");
    print(rawQuery);

    final List<Map<String, dynamic>> planoguideMap = await db.rawQuery(rawQuery);
    print(planoguideMap);
    return List.generate(planoguideMap.length, (index) {
      return SavePlanoguideListData(
        pogId: planoguideMap[index]['id'].toString(),
        catId: planoguideMap[index]['category_id'].toString(),
        pogText: planoguideMap[index]['pog'].toString(),
        pogImageName: planoguideMap[index]['image_name'].toString(),
        clientId: planoguideMap[index]['client_id'].toString(),
        adhStatus: planoguideMap[index]['is_adh'].toString(),

      );
    });
  }

  static Future<List<TransBransShareModel>> getBransSharesDataList(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> brandShareMap = await db.rawQuery("SELECT trans_brand_share.client_id,trans_brand_share.id as trans_brand_shares_id,"
        "trans_brand_share.category_id as cat_id,trans_brand_share.brand_id ,sys_category.en_name as cat_en_name,sys_category.ar_name as cat_ar_name,sys_brand.ar_name as brand_ar_name,sys_brand.en_name as brand_en_name,trans_brand_share.given_faces,trans_brand_share.upload_status,"
        " trans_brand_share.actual_faces,trans_brand_share.activity_status FROM trans_brand_share"
        " join sys_category on sys_category.id=trans_brand_share.category_id"
        " join sys_brand on sys_brand.id=trans_brand_share.brand_id"
        " WHERE working_id=$workingId ORDER BY category_id,brand_en_name ASC");


    return List.generate(brandShareMap.length, (index) {
      return TransBransShareModel(
        id: brandShareMap[index]['trans_brand_shares_id'] as int,
        cat_id: brandShareMap[index]['cat_id'] as int,
        brand_id: brandShareMap[index]['brand_id'] as int,
        cat_en_name: brandShareMap[index]['cat_en_name'] ?? "",
        cat_ar_name: brandShareMap[index]['cat_ar_name'] ?? "",
        brand_en_name: brandShareMap[index]['brand_en_name'] ?? "",
        brand_ar_name: brandShareMap[index]['brand_ar_name'] ?? "",
        given_faces: brandShareMap[index]['given_faces'] ?? "",
        actual_faces: brandShareMap[index]['actual_faces'] ?? "",
        upload_status: brandShareMap[index]['upload_status'] ?? 0,
        activity_status: brandShareMap[index]['activity_status'] ?? 0,
        client_id: brandShareMap[index]['client_id'] ?? -1,
      );
    });
  }

  static Future<List<TransBransShareModel>> getBransSharesFilteredDataList(String workingId,int activityStatus) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> brandShareMap = await db.rawQuery("SELECT trans_brand_share.client_id,trans_brand_share.id as trans_brand_shares_id,"
        "trans_brand_share.category_id as cat_id,trans_brand_share.brand_id ,sys_category.en_name as cat_en_name,sys_category.ar_name as cat_ar_name,sys_brand.ar_name as brand_ar_name,sys_brand.en_name as brand_en_name,trans_brand_share.given_faces,trans_brand_share.upload_status,"
        " trans_brand_share.actual_faces,trans_brand_share.activity_status FROM trans_brand_share"
        " join sys_category on sys_category.id=trans_brand_share.category_id"
        " join sys_brand on sys_brand.id=trans_brand_share.brand_id"
        " WHERE working_id=$workingId AND activity_status=$activityStatus ORDER BY category_id,brand_en_name ASC");


    return List.generate(brandShareMap.length, (index) {
      return TransBransShareModel(
        id: brandShareMap[index]['trans_brand_shares_id'] as int,
        cat_id: brandShareMap[index]['cat_id'] as int,
        brand_id: brandShareMap[index]['brand_id'] as int,
        cat_en_name: brandShareMap[index]['cat_en_name'] ?? "",
        cat_ar_name: brandShareMap[index]['cat_ar_name'] ?? "",
        brand_en_name: brandShareMap[index]['brand_en_name'] ?? "",
        brand_ar_name: brandShareMap[index]['brand_ar_name'] ?? "",
        given_faces: brandShareMap[index]['given_faces'] ?? "",
        actual_faces: brandShareMap[index]['actual_faces'] ?? "",
        upload_status: brandShareMap[index]['upload_status'] ?? 0,
        activity_status: brandShareMap[index]['activity_status'] ?? 0,
        client_id: brandShareMap[index]['client_id'] ?? -1,
      );
    });
  }

  static Future<List<SaveBrandShareListData>> getActivityStatusBrandSharesDataList(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> brandShareMap = await db.rawQuery("SELECT id,client_id,category_id,brand_id,given_faces,actual_faces "
        " FROM trans_brand_share WHERE working_id=$workingId AND activity_status=1 AND upload_status=0");


    return List.generate(brandShareMap.length, (index) {
      return SaveBrandShareListData(
        id: brandShareMap[index]['id'],
        catId: brandShareMap[index]['category_id'] ,
        brandId: brandShareMap[index]['brand_id'],
        givenFaces: brandShareMap[index]['given_faces'],
        actualFaces: brandShareMap[index]['actual_faces'],
        clientId: brandShareMap[index]['client_id'],
      );
    });
  }

  static Future<List<AgencyDashboardModel>> getAgencyDashboard() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> agencyDashboard =
        await db.rawQuery("SELECT *from ${TableName.tbl_sys_agency_dashboard}");
    print(agencyDashboard);
    return List.generate(agencyDashboard.length, (index) {
      return AgencyDashboardModel.fromJson(agencyDashboard[index]);
    });
  }

  static Future<List<GetTransPhotoModel>> getTransPhoto(String workingId) async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transphoto =
    await db.rawQuery(
        "SELECT  trans_photo.id,trans_photo.client_id,trans_photo.cat_id,trans_photo.type_id,trans_photo.upload_status,sys_client.client_name ,sys_category.en_name as cat_en_name ,sys_category.ar_name as cat_ar_name ,trans_photo.gcs_status,sys_photo_type.en_name as type_en_name,sys_photo_type.ar_name as type_ar_name,"
            "trans_photo.image_name FROM trans_photo "
            "JOIN sys_client on sys_client.client_id=trans_photo.client_id "
            "JOIN sys_category on sys_category.id=trans_photo.cat_id "
            " JOIN sys_photo_type on sys_photo_type.id=trans_photo.type_id "
            "WHERE trans_photo.photo_type_id=1 AND trans_photo.working_id=${workingId}");

    return List.generate(transphoto.length, (index) {
      return GetTransPhotoModel(
        trans_photo_type_id: transphoto[index]['id'],
        clientName: transphoto[index][TableName.sys_client_name] as String,
        img_name: transphoto[index][TableName.trans_photo_name] as String,
        imageFile: null,
        cat_id: transphoto[index]['cat_id'] as int,
        client_id: transphoto[index]['client_id'] as int,
        type_id: transphoto[index]['type_id'] as int,
        categoryArName: transphoto[index]["cat_ar_name"] as String,
        categoryEnName: transphoto[index]["cat_en_name"] as String,
        gcs_status: transphoto[index][TableName.trans_photo_gcs_status] as int,
        type_ar_name: transphoto[index]["type_en_name"] as String,
        type_en_name: transphoto[index]["type_ar_name"] as String,
        upload_status: transphoto[index]["upload_status"] as int,
      );
    });
  }

  static Future<List<GetTransOSDCModel>> getTransOSDC(String workingId) async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transOsdc =
    await db.rawQuery(
        "SELECT trans_osdc.id as osdc_id,trans_osdc.gcs_status,trans_osdc.upload_status,trans_osdc.image_name,trans_osdc.quantity,sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,"
        "sys_osdc_reason.en_name as reason_en_name,sys_osdc_reason.ar_name as reason_ar_name,sys_osdc_reason.ar_name as osdc_ar_name,sys_osdc_type.en_name as type_en_name,sys_osdc_type.ar_name as type_ar_name "
       " FROM trans_osdc "
    "JOIN sys_brand on sys_brand.id=trans_osdc.brand_id "
    "JOIN sys_osdc_reason on sys_osdc_reason.id=trans_osdc.reason_id "
    "JOIN sys_osdc_type on sys_osdc_type.id=trans_osdc.type_id WHERE trans_osdc.working_id=$workingId");

    return List.generate(transOsdc.length, (index) {
      print("--------------OSDC SHOW-----------");
      print(jsonEncode(transOsdc));
      print("--------------OSDC SHOW-----------");
      return GetTransOSDCModel(
        id: transOsdc[index]['osdc_id'] as int,
        quantity: transOsdc[index]["quantity"] as int,
        img_name: transOsdc[index][TableName.trans_photo_name] as String,
        imageFile: null,
        gcs_status: transOsdc[index]['gcs_status'] as int,
        upload_status: transOsdc[index]['upload_status'] as int,
        brand_en_name: transOsdc[index]["brand_en_name"] as String,
        brand_ar_name: transOsdc[index]["brand_ar_name"] as String,
        type_ar_name: transOsdc[index]["type_ar_name"] as String,
        type_en_name: transOsdc[index]["type_en_name"] as String,
        reason_ar_name: transOsdc[index]["reason_ar_name"] as String,
        reason_en_name: transOsdc[index]["reason_en_name"] as String,
      );
    });
  }

  static Future<List<DropReasonModel>> getDropReason() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> dropreason =
        await db.rawQuery("SELECT *from ${TableName.tbl_sys_drop_reason}");
    return List.generate(dropreason.length, (index) {
      return DropReasonModel(
        id: dropreason[index][TableName.drop_id] as int,
        en_name: dropreason[index][TableName.drop_en_name] as String,
        ar_name: dropreason[index][TableName.drop_ar_name] as String,
        status: dropreason[index][TableName.drop_status] as int,
      );
    });
  }

  Future<bool> checkDataExists(Database database) async {
    List<Map<String, dynamic>> result = await database
        .rawQuery('SELECT * FROM ${TableName.tbl_sys_drop_reason}');
    return result.isNotEmpty;
  }

  static Future<List<PlanogramReasonModel>> getPlanogramReason() async {
    final db = await initDataBase();
    print("____________REASON LIST_____________");
    final List<Map<String, dynamic>> planogram_reason = await db
        .rawQuery("SELECT * FROM ${TableName.tbl_sys_planogram_reason}");

    print(jsonEncode(planogram_reason));
    return List.generate(planogram_reason.length, (index) {
      return PlanogramReasonModel(
        en_name: planogram_reason[index][TableName.planogram_reason_en_name]
            as String,
        ar_name: planogram_reason[index][TableName.planogram_reason_ar_name]
            as String,
        id: planogram_reason[index][TableName.planogram_reason_id] as int,
        status: planogram_reason[index][TableName.planogram_status] as int,
      );
    });
  }

  static Future<List<ShowPlanogramModel>> getTransPlanogram(String workingId) async {
    print("__________________TransPlanogram__________________");

    final db = await initDataBase();
    final List<Map<String, dynamic>> planogram = await db.rawQuery(
        "SELECT trans_planogram.id,trans_planogram.client_id,trans_planogram.cat_id,trans_planogram.brand_id,trans_planogram.reason_id,trans_planogram.gcs_status,trans_planogram.upload_status,sys_client.client_name,sys_category.en_name as cat_en_name,sys_category.ar_name as cat_ar_name, sys_brand.en_name as brand_en_name, sys_brand.ar_name as brand_ar_name,is_adherence,image_name, "
            "CASE WHEN sys_planogram_reason.id >0 then sys_planogram_reason.en_name  else 0 END as not_adh_reason "
            "FROM trans_planogram "
            "JOIN sys_client on sys_client.client_id=trans_planogram.client_id "
            "JOIN sys_category on sys_category.id=trans_planogram.cat_id "
            "JOIN sys_brand on sys_brand.id=trans_planogram.brand_id "
            "LEFT JOIN sys_planogram_reason on sys_planogram_reason.id=trans_planogram.reason_id "
            "WHERE trans_planogram.working_id=$workingId");
    print(jsonEncode(planogram));

    return List.generate(planogram.length, (index) {
      return ShowPlanogramModel(
        id:planogram[index]['id'] as int,
        client_id: planogram[index]['client_id'] as int,
        cat_id: planogram[index]['cat_id'] as int,
        reason_id: planogram[index]['reason_id'] as int,
        brand_id: planogram[index]['brand_id'] as int,
        client_name: planogram[index][TableName.sys_client_name] as String,
        cat_en_name:planogram[index]['cat_en_name'] as String,
        cat_ar_name:planogram[index]['cat_ar_name'] as String,
        brand_en_name:planogram[index]['brand_en_name'] as String,
        brand_ar_name:planogram[index]['brand_ar_name'] as String,
        is_adherence:planogram[index]['is_adherence'].toString(),
        image_name:planogram[index]['image_name'] as String,
        imageFile: null,
        not_adherence_reason:planogram[index]['not_adh_reason'].toString(),
        gcs_status:planogram[index]['gcs_status'] as int,
        upload_status:planogram[index]['upload_status'] as int,


      );
    });
  }

  static Future<bool> dataExists(int id) async {
    var db = await initDataBase();

    var res = await db.rawQuery('SELECT * FROM trans_availability WHERE sku_id=$id');
    return res.isNotEmpty;
  }

  static Future<List<RTVShowModel>> getRTVDataList(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> rtvMap = await db.rawQuery("SELECT sys_product.id as pro_id,sys_product.en_name as pro_en_name,"
        " sys_product.ar_name as pro_ar_name,sys_category.en_name as cat_en_name,sys_category.ar_name as cat_ar_name, "
        " sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,sys_product.image,sys_product.rsp,"
        " CASE WHEN trans_rtv.sku_id IS NULL then 0 ELSE trans_rtv.sku_id END as rtv_taken"
        " from sys_product"
        " JOIN sys_category on sys_category.id=sys_product.category_id"
        " JOIN sys_brand on sys_brand.id=sys_product.brand_id"
        " left join trans_rtv on trans_rtv.sku_id = sys_product.id"
        " WHERE sys_product.client_id IN(1,2,3) AND sys_product.id NOT IN(1,2,3)"
        " group BY sys_product.id");

    print(jsonEncode(rtvMap.length));
    print("___RTV Data List _______");
    return List.generate(rtvMap.length, (index) {
      return RTVShowModel(
        pro_id: rtvMap[index]['pro_id'] as int,
        cat_en_name: rtvMap[index]['cat_en_name'] ?? "",
        cat_ar_name: rtvMap[index]['cat_ar_name'] ?? "",
        pro_en_name: rtvMap[index]['pro_en_name'] ?? "",
        pro_ar_name: rtvMap[index]['pro_ar_name'] ?? "",
        img_name: rtvMap[index]['image'] ?? "",
        rsp: rtvMap[index]['rsp'] ?? "",
        brand_en_name: rtvMap[index]['brand_en_name'] ?? "",
        brand_ar_name: rtvMap[index]['brand_ar_name'] ?? "",
        rtv_taken: rtvMap[index]['rtv_taken'] ?? "",
        imageFile: null,
        pieces: rtvMap[index]['pieces'] ?? 0
      , act_status: rtvMap[index]['act_status'] ?? "");
    });
  }

  static Future<List<ShowTransRTVShowModel>> getTransRTVDataList(String workingId,String clienId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> rtvMap = await db.rawQuery("SELECT trans_rtv.id as trans_id,sys_product.en_name"
        " as pro_en_name,trans_rtv.date_time,trans_rtv.gcs_status,trans_rtv.upload_status,"
        " sys_product.ar_name as pro_ar_name,trans_rtv.image_name as rtv_image_name,trans_rtv.date_time as dateTime,trans_rtv.expire_date,trans_rtv.pieces,"
        " trans_rtv.sku_id,sys_product.image as pro_image,sys_rtv_reason.en_name as reason_en_name,sys_rtv_reason.ar_name as reason_ar_name"
        " from sys_product"
        " JOIN sys_subcategory on sys_subcategory.id=sys_product.subcategory_id"
        " JOIN sys_brand on sys_brand.id=sys_product.brand_id "
        " JOIN sys_rtv_reason on sys_rtv_reason.id=trans_rtv.reason"
        " left join trans_rtv on trans_rtv.sku_id = sys_product.id"
        " WHERE sys_product.client_id IN($clienId) AND sys_product.id NOT IN(1,2,3)"
        " ORDER BY sys_subcategory.en_name");

    print(jsonEncode(rtvMap.length));
    print("___RTV Data List _______");
    return List.generate(rtvMap.length, (index) {
      return ShowTransRTVShowModel(
        id: rtvMap[index]['trans_id'] as int,
        reason_en_name: rtvMap[index]['reason_en_name'] ?? "",
        reason_ar_name: rtvMap[index]['reason_ar_name'] ?? "",
        pro_en_name: rtvMap[index]['pro_en_name'] ?? "",
        pro_ar_name: rtvMap[index]['pro_ar_name'] ?? "",
        rtv_image: rtvMap[index]['rtv_image_name'] ?? "",
        pro_image: rtvMap[index]['pro_image'] ?? "",
        pieces: rtvMap[index]['pieces'] as int,
        upload_status: rtvMap[index]['upload_status'] as int,
        gcs_status: rtvMap[index]['gcs_status'] as int,
        sku_id: rtvMap[index]['sku_id'] as int,
        exp_date: rtvMap[index]['expire_date'] ?? "",
        dateTime: rtvMap[index]['dateTime'] ?? "",
        imageFile: null,
      );
    });
  }

  static Future<List<ShowTransSOSModel>> getTransSOS(String workingId) async {
    print("__________________TransSOS__________________");

    final db = await initDataBase();
    final List<Map<String, dynamic>> sos = await db.rawQuery(
        "SELECT trans_sos.id,sys_client.client_name,sys_category.en_name as cat_en_name,sys_category.ar_name as cat_ar_name, sys_brand.en_name as brand_en_name, sys_brand.ar_name as brand_ar_name,trans_sos.unit,trans_sos.cat_space as total_space,trans_sos.actual_space "
            " FROM trans_sos "
            "JOIN sys_client on sys_client.client_id=trans_sos.client_id "
            "JOIN sys_category on sys_category.id=trans_sos.cat_id "
            "JOIN sys_brand on sys_brand.id=trans_sos.brand_id "
            "WHERE trans_sos.working_id=$workingId");
    print(jsonEncode(sos));

    return List.generate(sos.length, (index) {
      return ShowTransSOSModel(
        id:sos[index]['id'] as int,
        client_name: sos[index][TableName.sys_client_name] as String,
        cat_en_name:sos[index]['cat_en_name'] as String,
        cat_ar_name:sos[index]['cat_ar_name'] as String,
        brand_en_name:sos[index]['brand_en_name'] as String,
        brand_ar_name:sos[index]['brand_ar_name'] as String,
        total_cat_space:sos[index]['total_space'] as String,
        actual_space:sos[index]['actual_space'] as String,
        unit:sos[index]['unit'].toString(),

      );
    });
  }
  static Future<List<GetTransBeforeFixing>> getTransBeforeFixing(String workingId) async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transbefore =
    await db.rawQuery(
        "SELECT  trans_before_fixing.id ,sys_client.client_name ,sys_category.en_name ,sys_category.ar_name,sys_category.id as cat_id,sys_category.client_id,"
            " trans_before_fixing.gcs_status,trans_before_fixing.upload_status,trans_before_fixing.photo_type_id, trans_before_fixing.image_name FROM trans_before_fixing "
            "JOIN sys_client on sys_client.client_id=trans_before_fixing.client_id "
            "JOIN sys_category on sys_category.id=trans_before_fixing.cat_id "
            "WHERE trans_before_fixing.photo_type_id=1 AND trans_before_fixing.working_id=$workingId");

    return List.generate(transbefore.length, (index) {
      // print(transphoto[index]['id']);
      print(transbefore[index]);
      return GetTransBeforeFixing(
          id: transbefore[index]['id'],
          trans_photo_type_id: transbefore[index]['photo_type_id'],
          clientName: transbefore[index][TableName.sys_client_name] as String,
          img_name: transbefore[index][TableName.trans_photo_name] as String,
          imageFile: null,
          client_id: transbefore[index][TableName.cat_client_id],
          cat_id: transbefore[index]['cat_id'],
          categoryArName: transbefore[index][TableName.cat_ar_name] as String,
          categoryEnName: transbefore[index][TableName.cat_en_name] as String,
          gcs_status: transbefore[index][TableName.trans_photo_gcs_status] as int,
          upload_status: transbefore[index][TableName.trans_upload_status] as int
      );
    });
  }

  // ----********* Update Data-----************
  static Future<List<AvailabilityShowModel>> getUpdateAvlDataList(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> avlMap = await db.rawQuery("SELECT trans_availability.*, sys_category.en_name || ' ' || sys_subcategory.en_name as cat_en_name, sys_category.ar_name || ' ' || sys_subcategory.ar_name as cat_ar_name, sys_subcategory.en_name as subcat_en_name, sys_subcategory.ar_name as subcat_ar_name, "
        "sys_brand.en_name as brand_en_name, sys_brand.ar_name as brand_ar_name, sys_product.image, sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name "
        "FROM trans_availability "
        "JOIN sys_product ON sys_product.id = trans_availability.sku_id "
        "JOIN sys_category ON sys_category.id = sys_product.category_id "
        "JOIN sys_brand ON sys_brand.id = sys_product.brand_id "
        "JOIN sys_subcategory ON sys_subcategory.id = sys_product.subcategory_id "
        "WHERE working_id = '$workingId' AND req_picklist>0");
    print(jsonEncode(avlMap.length));
    print("___Update AVL Data List _______");

    return List.generate(avlMap.length, (index) {
      return AvailabilityShowModel(
        pro_id: avlMap[index]['sku_id'] as int,
        client_id: avlMap[index]['client_id'] as int,
        cat_en_name: avlMap[index]['cat_en_name'] ?? "",
        cat_ar_name: avlMap[index]['cat_ar_name'] ?? "",
        pro_en_name: avlMap[index]['pro_en_name'] ?? "",
        pro_ar_name: avlMap[index]['pro_ar_name'] ?? "",
        image: avlMap[index]['image'] ?? "",
        avl_status: avlMap[index]['avl_status'] ?? -1,
        upload_status: avlMap[index]['upload_status'] ?? 0,
        actual_picklist: avlMap[index]['actual_picklist'] ?? 0,
        activity_status: avlMap[index]['activity_status'] ?? 0,
        requried_picklist: avlMap[index]['req_picklist'] ?? 0,
        brand_en_name: avlMap[index]['brand_en_name'] ?? -1,
        brand_ar_name: avlMap[index]['brand_ar_name'] ?? -1,
        picklist_reason: 1,
        picklist_ready: avlMap[index]['picklist_ready'] ?? 0,
        picker_name : avlMap[index]['picker_name'] ?? '',
        pick_upload_status: avlMap[index]['pick_upload_status'] ?? 1,
        pick_list_send_time: avlMap[index]['pick_list_send_time'] ?? "",
        pick_list_receive_time: avlMap[index]['pick_list_receive_time'] ?? ""
      );
    });
  }
  static Future<int> updateTransAVLAfterUpdate(String workingId,String skuId) async {
    String writeQuery = "UPDATE trans_availability SET upload_status=1 WHERE working_id=$workingId AND sku_id in ($skuId)";

    var db = await initDataBase();
    // final Map<String, dynamic> arguments = transAvlModelItem.toMap();
    // print(jsonEncode(arguments));
    print("_______________UpdATE________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateTransAVLAfterPickListUpdate(String workingId,String skuId,String currentTime) async {
    String writeQuery = "UPDATE trans_availability SET pick_upload_status=1,pick_list_send_time=${wrapIfString(currentTime)} WHERE working_id=$workingId AND sku_id in ($skuId)";

    var db = await initDataBase();
    // final Map<String, dynamic> arguments = transAvlModelItem.toMap();
    // print(jsonEncode(arguments));
    print("_______________UpdATE________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateTransAVLAfterApiPickList(int skuId,String workingId) async {
    String writeQuery = "update trans_availability set pick_upload_status=1 WHERE sku_id=$skuId AND working_id=$workingId";

    var db = await initDataBase();
    // final Map<String, dynamic> arguments = transAvlModelItem.toMap();
    // print(jsonEncode(arguments));
    print("_______________UpdATE________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateTransPlanoGuides(int gcsStatus,int id,String workingId,String skuImageName,String adherenceId) async {

    String writeQuery = "UPDATE trans_planoguide SET isAdherence=?,gcs_status=$gcsStatus, skuImageName=?,upload_status=0,activity_status=1 WHERE id=$id and working_id=$workingId";
    var db = await initDataBase();
    print("_______________UpdATE PlanoGuide________________");
    print(writeQuery);
    return await db.rawUpdate(writeQuery,[adherenceId,skuImageName]);
  }

  static Future<int> updatePlanoguideAfterGcsAfterFinish(int id,String workingId) async {

    String writeQuery = "UPDATE trans_planoguide SET gcs_status=1 WHERE working_id=$workingId And id=$id";

    var db = await initDataBase();

    print("_______________UpdATE Planoguide1122________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }


  static Future<int> updateRtvAfterGcsAfterFinish(int id,String workingId) async {

    String writeQuery = "UPDATE trans_rtv SET gcs_status=1 WHERE working_id=$workingId And id=$id";

    var db = await initDataBase();

    print("_______________UpdATE Rtv GCS STATUS________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updatePlanoguideAfterApi(String workingId,String ids) async {
    String writeQuery = "UPDATE trans_planoguide SET upload_status=1 WHERE working_id=$workingId AND id in ($ids)";

    var db = await initDataBase();
    print("_______________UpdATE Planoguide________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateRtvAfterApi(String workingId,String ids) async {
    String writeQuery = "UPDATE trans_rtv SET upload_status=1 WHERE working_id=$workingId AND sku_id in ($ids)";

    var db = await initDataBase();
    print("_______________UpdATE Planoguide________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updatePriceCheckAfterApi(String workingId,String ids) async {
    String writeQuery = "UPDATE trans_pricing SET upload_status=1 WHERE working_id=$workingId AND sku_id in ($ids)";

    var db = await initDataBase();
    print("_______________UpdATE Planoguide________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateShareShelfAfterApi(String workingId) async {
    // bool dataExist = await dataExists(transAvlModelItem.sku_id);
    // if(dataExist) {

    String writeQuery = "UPDATE trans_brand_share SET upload_status=1 WHERE activity_status=1 AND working_id=$workingId";

    var db = await initDataBase();
    // final Map<String, dynamic> arguments = transAvlModelItem.toMap();
    // print(jsonEncode(arguments));
    print("_______________UpdATE Share Shelf________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateTransBrandShares(int id,String workingId,String actualFaces,String categoryId) async {
    String writeQuery = "UPDATE trans_brand_share SET actual_faces=$actualFaces, upload_status=0, activity_status=1 where brand_id=$id and category_id=$categoryId and working_id=$workingId";
    var db = await initDataBase();
    print("_______________UpdATE Share Shelf________________");
    print(writeQuery);
    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateTableAfterGCSUpload(String workingID,String tblName,int gcsStatus,int uploadStatus,String imgName) async {
    String updateQuery = "UPDATE $tblName SET gcs_status=$gcsStatus, upload_status=$uploadStatus WHERE working_id=? AND image_name=?";

    var db = await initDataBase();
    print("_______________ Update Update All Table________________");
    print(updateQuery);

    return await db.rawUpdate(updateQuery,[workingID,imgName]);

  }
  static Future<int> updatePlanoTableAfterGCSUpload(String workingID,String tblName,int gcsStatus,int uploadStatus,String imgName) async {
    String updateQuery = "UPDATE $tblName SET gcs_status=$gcsStatus, upload_status=$uploadStatus WHERE working_id=? AND skuImageName=?";

    var db = await initDataBase();
    print("_______________ Update Update All Table________________");
    print(updateQuery);

    return await db.rawUpdate(updateQuery,[workingID,imgName]);

  }


  //   ---******insertTrans Data Start-----********
  static Future<void> insertTransPhoto(TransPhotoModel transPhotoModel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_photo,
      transPhotoModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> insertTransPlanogram(TransPlanogramModel transPlanogramModel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_planogram,
      transPlanogramModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int>  updateTransAVL(int avlStatus,String workingId,String skuId) async {

    String writeQuery = "UPDATE trans_availability SET avl_status=$avlStatus, activity_status=1,upload_status=0 WHERE working_id=$workingId AND sku_id=$skuId";

    var db = await initDataBase();
    print("_______________UpdATE________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int>  updateSavePickList(String workingId,String reqPickList,String skuId) async {

    String writeQuery = "UPDATE trans_availability SET pick_upload_status=0,req_picklist=$reqPickList WHERE working_id=$workingId AND sku_id=$skuId";

    var db = await initDataBase();
    print("_______________UpdATE________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }


  static Future<void> insertTransSOS(TransSOSModel transSOSModel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_sos,
      transSOSModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> insertTransPricing(TransPricingModel pricingModel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_pricing,
      pricingModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> insertTransFreshness(TransFreshnessModel transFreshnessModel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_freshness,
      transFreshnessModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> insertTransStock(TransStockModel transStockModel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_stock,
      transStockModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> insertTransOSDC(TransOSDCModel transOSDCModel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_osdc,
      transOSDCModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> insertTransOSDCImage(TransOSDCImagesModel transOSDCImage) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_osdc_images,
      transOSDCImage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> insertTransOnePlusOne(TransOnePlusOneModel transOnePlusOneModel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_one_plus_one,
      transOnePlusOneModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> insertTransPromoPlan(TransPromoPlanModel transPromoPlanModel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_promoplan,
      transPromoPlanModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<int>  insertTransPlanoguide(String workingID) async {
    String insertQuery = "INSERT OR IGNORE INTO trans_planoguide (client_id,store_id, cat_id, pog, isAdherence, imageName, date_time,activity_status, gcs_status, upload_status, working_id) "
        " SELECT client_id,store_id, category_id, pog,-1, pog_image, CURRENT_TIMESTAMP,0,0, 0,$workingID"
        " FROM sys_store_pog";
    var db = await initDataBase();
    print("_______________INSERT TransPlanoGuide________________");
    print(insertQuery);
    return await db.rawInsert(insertQuery);
  }
  static Future<int>  insertTransBrandShares(String workingID) async {
    String insertQuery = "INSERT OR IGNORE INTO trans_brand_share (client_id,store_id, category_id, brand_id, given_faces,actual_faces,date_time,activity_status,upload_status,working_id) "
        " SELECT client_id,store_id, category_id, brand_id, given_faces,'',CURRENT_TIMESTAMP,0,0,$workingID"
        " FROM sys_brand_faces";
    var db = await initDataBase();
    print("_______________INSERT BransShare________________");
    print(insertQuery);
    return await db.rawInsert(insertQuery);
  }
  static Future<int>  insertTransAvailability(String workingID,String clientId,String visitAvlExcludes,String now) async {
    String insertQuery = "INSERT OR IGNORE INTO trans_availability (client_id,sku_id, avl_status, activity_status,req_picklist,actual_picklist,picklist_reason,picklist_ready,working_id,pick_upload_status,upload_status,date_time,picker_name,pick_list_send_time,pick_list_receive_time) "
        "SELECT client_id,id, -1, 0 , 0,0,0,0,$workingID,0,0,00,'','',''"
        " FROM sys_product where client_id IN($clientId) "
        "AND id NOT IN($visitAvlExcludes)";
    var db = await initDataBase();
    print("_______________INSERT AVAILABILITY________________");
    print(insertQuery);
    return await db.rawInsert(insertQuery);
  }


//--------************get drop down data-------**********
  static Future<List<ClientModel>> getVisitClientList(String client_ids) async {
    final db = await initDataBase();

    final List<Map<String, dynamic>> clientMaps = await db.rawQuery(
        "SELECT client_id as client_id, client_name as client_name FROM sys_client WHERE sys_client.client_id IN ($client_ids)");
    print(jsonEncode(clientMaps));
    print("________CLIENT List ________________");
    return List.generate(clientMaps.length, (index) {
      return ClientModel(
        client_id: clientMaps[index][TableName.sys_client_id] as int,
        client_name: clientMaps[index][TableName.sys_client_name] as String,
        // logo: clientMaps[index][TableName.sys_client_logo] as String,
        // classification:
        // clientMaps[index][TableName.sys_client_classification] as int,
        // chain_sku_code:
        // clientMaps[index][TableName.sys_client_chainSku_code] as int,
        // day_freshness:
        // clientMaps[index][TableName.sys_client_is_dayFreshness] as int,
        // is_geo_requried:
        // clientMaps[index][TableName.sys_client_geo_requried] as String,
        // order_avl: clientMaps[index][TableName.sys_client_order_avl] as int,
        // is_survey: clientMaps[index][TableName.sys_client_is_survey] as int,
      );
    });
  }
  static Future<List<CategoryModel>> getCategoryList(int client_ids) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> categoryMaps = await db.rawQuery(
        "SELECT sys_category.id as cat_id,sys_category.en_name as cat_en_name,sys_category.client_id,"
            "sys_category.ar_name as cat_ar_name FROM  sys_category JOIN sys_client "
            "on sys_client.client_id=sys_category.client_id WHERE sys_category.client_id=($client_ids)");


    return List.generate(categoryMaps.length, (index) {
      return CategoryModel(
        id: categoryMaps[index]['cat_id'] as int,
        en_name: categoryMaps[index]['cat_en_name'] as String,
        ar_name: categoryMaps[index]['cat_ar_name'] as String,
        client: categoryMaps[index][TableName.cat_client_id] as int,
      );
    });
  }
  static Future<List<CategoryModel>> getSubCategoryList(int client_ids) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> categoryMaps = await db.rawQuery(
        "SELECT sys_subcategory.id as cat_id,sys_subcategory.en_name as cat_en_name,sys_subcategory.client_id,"
            "sys_subcategory.ar_name as cat_ar_name FROM  sys_subcategory JOIN sys_client "
            "on sys_client.client_id=sys_subcategory.client_id WHERE sys_subcategory.client_id=($client_ids)");
//AND sys_subcategory.category_id=($categoryId)

    return List.generate(categoryMaps.length, (index) {
      return CategoryModel(
        id: categoryMaps[index]['cat_id'] as int,
        en_name: categoryMaps[index]['cat_en_name'] as String,
        ar_name: categoryMaps[index]['cat_ar_name'] as String,
        client: categoryMaps[index][TableName.cat_client_id] as int,
      );
    });
  }
  static Future<List<Sys_PhotoTypeModel>> getPhotoTypeList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> photoTypeMaps = await db.rawQuery(
        "SELECT *from sys_photo_type");
    print(jsonEncode(photoTypeMaps));
    print("________Photo type List ________________");
    return List.generate(photoTypeMaps.length, (index) {
      return Sys_PhotoTypeModel(
        id: photoTypeMaps[index]['id'] as int,
        en_name: photoTypeMaps[index]['en_name'] as String,
        ar_name: photoTypeMaps[index]['ar_name'] as String,
      );
    });
  }
  static Future<List<SYS_BrandModel>> getBrandList(int client_id) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> brandMaps = await db.rawQuery(
        "SELECT sys_brand.id,sys_brand.en_name ,sys_brand.ar_name,sys_brand.client_id "
            "FROM sys_brand JOIN sys_client on sys_client.client_id=sys_brand.client_id "
            "WHERE sys_brand.client_id = ${client_id}");

    print(jsonEncode(brandMaps));
    print("________BRAND List ________________");
    return List.generate(brandMaps.length, (index) {
      return SYS_BrandModel(
        id: brandMaps[index][TableName.sys_brand_id] as int,
        en_name: brandMaps[index][TableName.sys_brand_en_name] as String,
        ar_name: brandMaps[index][TableName.sys_brand_ar_name] as String,
        client: brandMaps[index][TableName.sys_brand_client_id] as int,
      );
    });
  }
  static Future<List<SYS_BrandModel>> getBrandListOSDC() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> brandMaps = await db.rawQuery(
        "SELECT sys_brand.id,sys_brand.en_name ,sys_brand.ar_name,sys_brand.client_id "
            "FROM sys_brand JOIN sys_client on sys_client.client_id=sys_brand.client_id");

    print(jsonEncode(brandMaps));
    print("________BRAND List ________________");
    return List.generate(brandMaps.length, (index) {
      return SYS_BrandModel(
        id: brandMaps[index][TableName.sys_brand_id] as int,
        en_name: brandMaps[index][TableName.sys_brand_en_name] as String,
        ar_name: brandMaps[index][TableName.sys_brand_ar_name] as String,
        client: brandMaps[index][TableName.sys_brand_client_id] as int,
      );
    });
  }
//------*******Show  praph data********--------
  static Future<AdherenceModel> getAdherenceData() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> adhereMaps = (await db.rawQuery(
        "SELECT SUM(CASE WHEN is_adherence = 1 THEN 1 ELSE 0 END) AS total_adhere,"
            " SUM(CASE WHEN is_adherence = 0 THEN 1 ELSE 0 END) AS total_not_adhere FROM trans_planogram")) ;
    print(jsonEncode(adhereMaps));
    print("____________Adhere Cont_______________");
    return  AdherenceModel(
      adhereCount: int.parse(adhereMaps[0]['total_adhere'].toString() == "null" ? "0" : adhereMaps[0]['total_adhere'].toString()),
      notAdhereCount: int.parse(adhereMaps[0]['total_not_adhere'].toString() == "null" ? "0" : adhereMaps[0]['total_not_adhere'].toString()),
    );
  }
  static Future<AvailableCountModel> getAvailableCountData(String workingId) async {
    print(workingId);
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery("SELECT COUNT(*) AS total_products, SUM(CASE WHEN avl_status = 1 THEN 1"
        " ELSE 0 END) AS total_avl, SUM(CASE WHEN avl_status = 0 THEN 1 ELSE 0 END) AS total_not_avl  "
        "FROM trans_availability WHERE working_id=$workingId"));
    print(jsonEncode(result));
    print("____________Adhere Cont_______________");
    return  AvailableCountModel(
      totalProducts: int.parse(result[0]['total_products'].toString()),
      totalAvl: int.parse(result[0]['total_avl'].toString()),
      totalNotAvl: int.parse(result[0]['total_not_avl'].toString()),
    );
  }
  static Future<List<Sys_OSDCReasonModel>> getOsdcReasonList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcReasonMaps = await db.rawQuery(
        "SELECT *from sys_osdc_reason");
    print(jsonEncode(osdcReasonMaps));
    print("________OSDC Reason List ________________");
    return List.generate(osdcReasonMaps.length, (index) {
      return Sys_OSDCReasonModel(
        id: osdcReasonMaps[index][TableName.sys_osdc_reason_id] as int,
        en_name: osdcReasonMaps[index][TableName.sys_osdc_reason_en_name] as String,
        ar_name: osdcReasonMaps[index][TableName.sys_osdc_reason_ar_name] as String,
      );
    });
  }
  static Future<List<Sys_OSDCTypeModel>> getSosUnitList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcTypeMaps = await db.rawQuery(
        "SELECT *from sys_sos_unit");
    print(jsonEncode(osdcTypeMaps));
    print("________ SOS Unit List ________________");
    return List.generate(osdcTypeMaps.length, (index) {
      return Sys_OSDCTypeModel(
        id: osdcTypeMaps[index][TableName.sys_osdc_type_id] as int,
        en_name: osdcTypeMaps[index][TableName.sys_osdc_type_en_name] as String,
        ar_name: osdcTypeMaps[index][TableName.sys_osdc_type_ar_name] as String,
      );
    });
  }
  static Future<List<Sys_OSDCTypeModel>> getAppSettingList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcTypeMaps = await db.rawQuery(
        "SELECT *from sys_app_setting");
    print(jsonEncode(osdcTypeMaps));
    print("________ App Setting List ________________");
    return List.generate(osdcTypeMaps.length, (index) {
      return Sys_OSDCTypeModel(
        id: osdcTypeMaps[index][TableName.sys_osdc_type_id] as int,
        en_name: osdcTypeMaps[index][TableName.sys_osdc_type_en_name] as String,
        ar_name: osdcTypeMaps[index][TableName.sys_osdc_type_ar_name] as String,
      );
    });
  }
  static Future<List<Sys_OSDCTypeModel>> getDailyCheckList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcTypeMaps = await db.rawQuery(
        "SELECT *from sys_daily_checklist");
    print(jsonEncode(osdcTypeMaps));
    print("________ SOS Unit List ________________");
    return List.generate(osdcTypeMaps.length, (index) {
      return Sys_OSDCTypeModel(
        id: osdcTypeMaps[index][TableName.sys_osdc_type_id] as int,
        en_name: osdcTypeMaps[index][TableName.sys_osdc_type_en_name] as String,
        ar_name: osdcTypeMaps[index][TableName.sys_osdc_type_ar_name] as String,
      );
    });
  }
  static Future<List<Sys_OSDCTypeModel>> getOsdcTypeList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcTypeMaps = await db.rawQuery(
        "SELECT *from sys_osdc_type");
    print(jsonEncode(osdcTypeMaps));
    print("________OSDC Type List ________________");
    return List.generate(osdcTypeMaps.length, (index) {
      return Sys_OSDCTypeModel(
        id: osdcTypeMaps[index][TableName.sys_osdc_type_id] as int,
        en_name: osdcTypeMaps[index][TableName.sys_osdc_type_en_name] as String,
        ar_name: osdcTypeMaps[index][TableName.sys_osdc_type_ar_name] as String,
      );
    });
  }
//----******** delete tabale********------------
  static Future<void> delete_table(String tbl_name) async {
    var db = await initDataBase();
    await db.rawDelete('DELETE FROM ${tbl_name}');
  }
  static Future<void> deleteOneRecord(String tblName, int id) async {
    var db = await initDataBase();
    await db.delete(tblName, where: 'id = ?', whereArgs: [id]);
  }


  /// Get PickList From Query Sql

  static Future<List<PickListModel>> getPickListData() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> picklist =
    await db.rawQuery("SELECT *FROM picklist");
    return List.generate(picklist.length, (index) {
      // print(transphoto[index]['id']);
      print(picklist[index]);
      return PickListModel(
        picklist_id: picklist[index]['picklist_id'].toString(),
        store_id: picklist[index]['store_id'].toString(),
        category_id: picklist[index]['category_id'].toString(),
        tmr_id: picklist[index]['tmr_id'].toString(),
        tmr_name: picklist[index]['tmr_name'].toString(),
        stocker_id: picklist[index]['stocker_id'].toString(),
        stocker_name: picklist[index]['stocker_name'].toString(),
        shift_time: picklist[index]['shift_time'].toString(),
        en_cat_name: picklist[index]['en_cat_name'].toString(),
        ar_cat_name: picklist[index]['ar_cat_name'].toString(),
        sku_picture: picklist[index]['sku_picture'].toString(),
        en_sku_name: picklist[index]['en_sku_name'].toString(),
        ar_sku_name: picklist[index]['ar_sku_name'].toString(),
        req_pickList: picklist[index]['req_picklist'].toString(),
        act_pickList: picklist[index]['act_picklist'].toString(),
        pickList_ready: picklist[index]['picklist_ready'].toString(),
        upload_status: picklist[index]['upload_status'] ?? 0,
        pick_list_send_time: picklist[index]['pick_list_send_time'] ?? "",
        pick_list_receive_time: picklist[index]['pick_list_receive_time'] ?? "",
        isReasonShow: true,
        reasonValue: []
      );
    });
  }

  //int pickListId,int storeId,int catId,int tmrId,String tmrName,int stockerId,String stockerName,String shiftTime,String enCatName,String arCatName,String skuPicture,String enSkuName,String arSkuName,int reqPickList, int actPickList, int pickListReady

  static Future<int> insertPickListByQuery (String queryBulkInsertion) async {
  String insertQuery = "INSERT OR IGNORE INTO picklist (picklist_id,store_id, category_id, tmr_id,tmr_name,stocker_id,stocker_name,shift_time,en_cat_name,ar_cat_name,sku_picture,en_sku_name,ar_sku_name,req_picklist,act_picklist,picklist_ready,upload_status,pick_list_send_time,pick_list_receive_time)"
                        "VALUES $queryBulkInsertion";
                        // "VALUES($pickListId,$storeId,$catId,$tmrId,$tmrName,$stockerId, $stockerName,$shiftTime,$enCatName,$arCatName,$skuPicture,$enSkuName,$arSkuName,$reqPickList,$actPickList,$pickListReady)";
  var db = await initDataBase();
  print("_______________INSERT PICKLIST________________");
  print(insertQuery);

  return await db.rawInsert(insertQuery);
}

  // static Future<void> insertPicklistArray(List<PickListModel> modelList) async {
  //   var db = await initDataBase();
  //   for (PickListModel data in modelList) {
  //     Map<String, dynamic> fields = {
  //       TableName.picklist_id: data.picklist_id.toString(),
  //       TableName.picklist_store_id: data.store_id.toString(),
  //       TableName.picklist_category_id: data.category_id.toString(),
  //       TableName.picklist_tmr_id: data.tmr_id.toString(),
  //       TableName.picklist_tmr_name: data.tmr_name.toString(),
  //       TableName.picklist_stocker_id: data.stocker_id.toString(),
  //       TableName.picklist_stocker_name: data.stocker_name.toString(),
  //       TableName.picklist_shift_time: data.shift_time.toString(),
  //       TableName.picklist_en_cat_name: data.en_cat_name.toString(),
  //       TableName.picklist_ar_cat_name: data.ar_cat_name.toString(),
  //       TableName.picklist_sku_picture: data.sku_picture.toString(),
  //       TableName.picklist_en_sku_name: data.en_sku_name.toString(),
  //       TableName.picklist_ar_sku_name: data.ar_sku_name.toString(),
  //       TableName.picklist_req_picklist: data.req_pickList.toString(),
  //       TableName.picklist_act_picklist: data.act_pickList.toString(),
  //       TableName.picklist_picklist_ready: data.pickList_ready.toString(),
  //     };
  //     bool isDuplicate = await hasDuplicateEntry(
  //         db, TableName.tbl_picklist, fields);
  //     if (isDuplicate) {
  //       print("Error: Duplicate entry picklist reason");
  //     } else {
  //       await db.insert(
  //         TableName.tbl_picklist,
  //         {
  //           TableName.picklist_id: data.picklist_id.toString(),
  //           TableName.picklist_store_id: data.store_id.toString(),
  //           TableName.picklist_category_id: data.category_id.toString(),
  //           TableName.picklist_tmr_id: data.tmr_id.toString(),
  //           TableName.picklist_tmr_name: data.tmr_name.toString(),
  //           TableName.picklist_stocker_id: data.stocker_id.toString(),
  //           TableName.picklist_stocker_name: data.stocker_name.toString(),
  //           TableName.picklist_shift_time: data.shift_time.toString(),
  //           TableName.picklist_en_cat_name: data.en_cat_name.toString(),
  //           TableName.picklist_ar_cat_name: data.ar_cat_name.toString(),
  //           TableName.picklist_sku_picture: data.sku_picture.toString(),
  //           TableName.picklist_en_sku_name: data.en_sku_name.toString(),
  //           TableName.picklist_ar_sku_name: data.ar_sku_name.toString(),
  //           TableName.picklist_req_picklist: data.req_pickList.toString(),
  //           TableName.picklist_act_picklist: data.act_pickList.toString(),
  //           TableName.picklist_picklist_ready: data.pickList_ready.toString(),
  //         },
  //         conflictAlgorithm: ConflictAlgorithm.replace,
  //       );
  //       print("check picklist insertion");
  //
  //     }
  //   }
  // }

  ///Availability update Sql from PickList
  static Future<int> updateTransAVLAPicklist(int skuId,int actualPicklist,int actStatus,int workingId,String pickerName,String pickListReadyTime) async {
    String writeQuery = "";
    if(actualPicklist > 0) {
      writeQuery = "update trans_availability set picker_name='$pickerName',pick_list_receive_time=${wrapIfString(pickListReadyTime)},avl_status=1,actual_picklist=$actualPicklist,picklist_ready=$actStatus where sku_id=$skuId AND working_id=$workingId";
    } else {
      writeQuery = "update trans_availability set picker_name='$pickerName',pick_list_receive_time=${wrapIfString(pickListReadyTime)},actual_picklist=$actualPicklist,picklist_ready=$actStatus where sku_id=$skuId AND working_id=$workingId";
    }
    var db = await initDataBase();
    print("_______________UpdATE________________");
    print(writeQuery);
    return await db.rawUpdate(writeQuery);
  }

  ///Trans Pick list update Sql
  static Future<int> updateTransPicklist(String picklistId,String actPicklist,String picklistReady) async {
    String writeQuery = "update picklist set act_picklist=?,picklist_ready=? where picklist_id=?";
    var db = await initDataBase();
    print("_______________UpdATE________________");
    print(writeQuery);
    return await db.rawUpdate(writeQuery,[actPicklist,picklistReady,picklistId]);
  }

  ///Trans Pick list update Sql after APi
  static Future<int> updateTransPicklistAfterApi(String picklistId,String actPicklist,String picklistReady) async {
    String writeQuery = "update picklist set upload_status=1 where picklist_ready=1";
    var db = await initDataBase();
    print("_______________UpdATE________________");
    print(writeQuery);
    return await db.rawUpdate(writeQuery,[actPicklist,picklistReady,picklistId]);
  }

  ///Get AVL COUNT RECORDS FOR API UPLOAD
  static Future<AvailabilityCountModel> getAvailabilityCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery("SELECT count(sku_id) AS total_sku, "
        "sum(CASE WHEN avl_status = 1 THEN 1 ELSE 0 END) As total_avl, "
        "sum(CASE WHEN avl_status = 0 THEN 1 ELSE 0 END) As total_not_avl, "
        "sum(CASE WHEN avl_status = -1 THEN 1 ELSE 0 END) As total_not_marked, "
        "sum(CASE WHEN activity_status = 1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, "
        "sum(CASE WHEN activity_status = 1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded FROM trans_availability "
        "WHERE working_id=$workingId"));
    print(jsonEncode(result));
    print("____________Available Count_______________");
    return  AvailabilityCountModel(
      totalSku: result[0]['total_sku'] ?? 0,
      totalAvl: result[0]['total_avl'] ?? 0,
      totalNotAvl: result[0]['total_not_avl'] ?? 0,
      totalNotUploaded: result[0]['total_not_uploaded'] ?? 0,
      totalUploaded: result[0]['total_uploaded'] ?? 0,
      totalNotMarked : result[0]['total_not_marked'] ?? 0,
    );
  }

  ///Get TMR PICK List COUNT RECORDS FOR API UPLOAD
  static Future<TmrPickListCountModel> getTmrPickListCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery("SELECT count(sku_id) AS total_sku, "
        "sum(CASE WHEN pick_upload_status = 1 THEN 1 ELSE 0 END) As total_pick_uploaded, "
        "sum(CASE WHEN picklist_ready = 1 THEN 1 ELSE 0 END) As total_pick_ready, "
        "sum(CASE WHEN picklist_ready = 0 THEN 1 ELSE 0 END) As total_pick_not_ready, "
        "sum(CASE WHEN pick_upload_status = 0 THEN 1 ELSE 0 END) As total_pick_not_uploaded FROM trans_availability "
        "WHERE working_id=$workingId AND req_picklist>0"));
    print(jsonEncode(result));
    print("____________Available Count_______________");
    return  TmrPickListCountModel(
        totalPickListItems: result[0]['total_sku'] ?? 0,
        totalPickNotUpload: result[0]['total_pick_not_uploaded'] ?? 0,
        totalPickUpload: result[0]['total_pick_uploaded'] ?? 0,
        totalPickReady: result[0]['total_pick_ready'] ?? 0,
        totalPickNotReady: result[0]['total_pick_not_ready'] ?? 0
    );
  }

  ///Get Planoguide COUNT RECORDS FOR API UPLOAD
  static Future<PlanoguideCountModel> getPlanoguideCountData(String workingId) async {
    print(workingId);
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery("SELECT count(id) AS total_plano, "
        "sum(CASE WHEN isAdherence = 1 THEN 1 ELSE 0 END) As total_adhere, "
        "sum(CASE WHEN isAdherence = 0 THEN 1 ELSE 0 END) As total_not_adhere, "
        "sum(CASE WHEN activity_status = 0 THEN 1 ELSE 0 END) As total_not_marked, "
        "sum(CASE WHEN activity_status = 1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, "
        "sum(CASE WHEN activity_status = 1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded, "
        "sum(CASE WHEN gcs_status = 0 AND activity_status=1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_images_not_uploaded, "
        "sum(CASE WHEN gcs_status = 1 AND activity_status=1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_images_uploaded "
        "FROM trans_planoguide WHERE working_id=$workingId"));
    print(jsonEncode(result));
    print("____________Planoguide Cont_______________");
    return  PlanoguideCountModel(
        totalPlano: result[0]['total_plano'] ?? 0,
        totalAdhere: result[0]['total_adhere'] ?? 0,
        totalNotAdhere: result[0]['total_not_adhere'] ?? 0,
        totalNotUploaded: result[0]['total_not_uploaded'] ?? 0,
        totalUploaded: result[0]['total_uploaded'] ?? 0,
        totalImagesUploaded: result[0]['total_images_uploaded'] ?? 0,
        totalImagesNotUploaded: result[0]['total_images_not_uploaded'] ?? 0,
        totalNotMarkedPlano: result[0]['total_not_marked'] ?? 0,
    );
  }

  ///Get BrandShare COUNT RECORDS FOR API UPLOAD
  static Future<BrandShareCountModel> getBrandShareCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery("SELECT count(id) AS total_brand_share, "
        "sum(CASE WHEN activity_status = 1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, "
        "sum(CASE WHEN activity_status = 1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded, "
        "sum(CASE WHEN activity_status = 1 THEN 1 ELSE 0 END) As total_ready_brand, "
        "sum(CASE WHEN activity_status = 0 THEN 1 ELSE 0 END) As total_not_ready_brand "
        "FROM trans_brand_share WHERE working_id=$workingId"));
    print(jsonEncode(result));
    print("____________Brand Share Cont_______________");
    return  BrandShareCountModel(
        totalBrandShare: result[0]['total_brand_share'] ?? 0,
        totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
        totalUpload: result[0]['total_uploaded'] ?? 0,
        totalReadyBrands: result[0]['total_ready_brand'] ?? 0,
        totalNotReadyBrands: result[0]['total_not_ready_brand'] ?? 0,
    );
  }

  ///Get Rtv COUNT RECORDS FOR API UPLOAD
  static Future<RtvCountModel> getRtvCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery("SELECT count(id) AS total_rtv, "
        "sum(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, "
        "sum(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded "
        "FROM trans_rtv WHERE working_id=$workingId"));
    print(jsonEncode(result));
    print("____________RTV Cont_______________");
    return  RtvCountModel(
      totalRtv: result[0]['total_rtv'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
    );
  }

  ///Get Avl APi Data Query
  static Future<List<SaveAvailabilityData>> getAvlDataListForApi(String workingId) async {
    final db = await initDataBase();

    // Start building the base query
    String query = "SELECT sku_id,client_id,avl_status From trans_availability "
        " WHERE working_id=$workingId AND upload_status=0 And activity_status =1";

    print("getAvlDataListForApi");
    print(query);
    final List<Map<String, dynamic>> avlMap = await db.rawQuery(query);
    print(avlMap);
    return List.generate(avlMap.length, (index) {
      return SaveAvailabilityData(
          skuId: avlMap[index]['sku_id'],
          clientId: avlMap[index]['client_id'],
          avlStatus: avlMap[index]['avl_status'],
      );
    });
  }

  ///Get Avl Pciklist APi Data Query
  static Future<List<SavePickListData>> getAvlPickListDataListForApi(String workingId) async {
    final db = await initDataBase();

    // Start building the base query
    String query = "SELECT sku_id,client_id,req_picklist From trans_availability "
        " WHERE working_id=$workingId AND req_picklist > 0 AND pick_upload_status=0";

    print("getAvlPickListDataListForApi");
    print(query);
    final List<Map<String, dynamic>> avlMap = await db.rawQuery(query);
    print(avlMap);
    return List.generate(avlMap.length, (index) {
      return SavePickListData(
        skuId: avlMap[index]['sku_id'],
        clientId: avlMap[index]['client_id'],
        reqPicklist: avlMap[index]['req_picklist'],
      );
    });
  }

  ///Update Shelf Share after APi call
  static Future<int> updateShelfShareAfterApi(String workingId,String ids) async {

    String writeQuery = "UPDATE trans_brand_share SET upload_status=1 WHERE working_id=$workingId AND id in ($ids)";
    var db = await initDataBase();
    print("_______________UpdATE Share Shelf________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  ///get planoguide Images For GCS upload
  static Future<List<TransPlanoGuideGcsImagesListModel>> getPlanoGuideGcsImagesList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = "SELECT id,skuImageName as image_name "
        " FROM trans_planoguide WHERE working_id=$workingId AND activity_status=1 AND gcs_status=0";

    print("PLANOGUIDE QUERY");
    print(rawQuery);

    final List<Map<String, dynamic>> planoguideMap = await db.rawQuery(rawQuery);

    return List.generate(planoguideMap.length, (index) {
      return TransPlanoGuideGcsImagesListModel(
        id: planoguideMap[index]['id'],
        imageName: planoguideMap[index]['image_name'],
        imageFile: null
      );
    });
  }

  ///Get Rtv Data List For API
  static Future<List<SaveRtvDataListData>> getActivityStatusRtvDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = "SELECT sku_id,pieces,image_name,expire_date,reason "
        " FROM trans_rtv WHERE working_id=$workingId AND upload_status=0 AND gcs_status=1";

    print("RTV QUERY");
    print(rawQuery);

    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(rawQuery);
    print(rtvMap);
    return List.generate(rtvMap.length, (index) {
      return SaveRtvDataListData(
        skuId: rtvMap[index]['sku_id'],
        clientId: 1,
        pieces: rtvMap[index]['pieces'],
        rtvImageName: rtvMap[index]['image_name'].toString(),
        expireDate: rtvMap[index]['expire_date'].toString(),
        rtvReasonId: rtvMap[index]['reason'].toString(),

      );
    });
  }

  ///get RTV Images For GCS upload
  static Future<List<TransPlanoGuideGcsImagesListModel>> getRtvGcsImagesList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = "SELECT id, image_name"
        " FROM trans_rtv WHERE working_id=$workingId AND gcs_status=0";

    print("RTV QUERY");
    print(rawQuery);

    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(rawQuery);
    print(rtvMap);
    print("RTV Images List");
    return List.generate(rtvMap.length, (index) {
      return TransPlanoGuideGcsImagesListModel(
          id: rtvMap[index]['id'],
          imageName: rtvMap[index]['image_name'],
          imageFile: null
      );
    });
  }

  ///picklist count from query
  static Future<PickListCountModel> getPicklistCountData(String stockerId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery("SELECT count(picklist_id) AS total_picklist_items, "
        " sum(CASE WHEN picklist_ready = 1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, "
        " sum(CASE WHEN picklist_ready = 1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded, "
        "sum(CASE WHEN picklist_ready = 1 THEN 1 ELSE 0 END) As total_pick_ready, "
        "sum(CASE WHEN picklist_ready = 0 THEN 1 ELSE 0 END) As total_pick_not_ready "
        " FROM picklist WHERE stocker_id=$stockerId"));
    print(jsonEncode(result));
    print("____________Pick List Cont_______________");
    return  PickListCountModel(
        totalPickListItems: result[0]['total_picklist_items'] ?? 0,
        totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
        totalUpload: result[0]['total_uploaded'] ?? 0,
        totalPickNotReady: result[0]['total_pick_not_ready'] ?? 0,
        totalPickReady: result[0]['total_pick_ready'] ?? 0,
    );
  }

  ///picklist data list for API
  static Future<List<ReadyPickListData>> getPickListDataForApi(String stockerId) async {
    final db = await initDataBase();
    String rawQuery = "SELECT picklist_id,act_picklist FROM picklist "
        "WHERE picklist_ready = 1 AND upload_status=0 And stocker_id=$stockerId";

    print("Pick List QUERY");
    print(rawQuery);

    final List<Map<String, dynamic>> pickListMap = await db.rawQuery(rawQuery);
    print(pickListMap);

    return List.generate(pickListMap.length, (index) {
      return ReadyPickListData(
        pickListId: pickListMap[index]['picklist_id'],
          actualPicklist: pickListMap[index]['act_picklist'],
        picklistReason: "",
      );
    });
  }

  ///pick data update After API
  static Future<int> updatePickListAfterApi(String ids,String currentTime) async {

    String writeQuery = "UPDATE picklist SET upload_status=1,pick_list_send_time=${wrapIfString(currentTime)} WHERE picklist_id in ($ids)";
    var db = await initDataBase();
    print("_______________UpdATE PickList________________");
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  ///Required Modules data list for API
  static Future<List<RequiredModuleModel>> getRequiredModuleListDataForApi() async {
    final db = await initDataBase();
    String rawQuery = "SELECT module_id,visit_activty_type_id FROM sys_visit_required_modules";

    print("Require Module List QUERY");
    print(rawQuery);

    final List<Map<String, dynamic>> reqModListMap = await db.rawQuery(rawQuery);
    print(reqModListMap);

    return List.generate(reqModListMap.length, (index) {
      return RequiredModuleModel(
        moduleId: reqModListMap[index]['module_id'],
        visitActivityTypeId: reqModListMap[index]['visit_activty_type_id'],
      );
    });
  }

  /// Drop Whole DB
  static Future<bool> dropDb() async {

    const databaseName = "cstore_pro.db";
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);

    final dbFile = File(path);

    await closeDb();

    if (await dbFile.exists()) {
      try {
        await dbFile.delete();
        print('Database $path dropped successfully.');
        return true;
      } catch (e) {
        print('Error deleting database file: $e');
        return false;
      }
    } else {
      print('Database file does not exist at path: $path');
      return false;
    }
  }

  /// Close Connection with DB
  static Future<void> closeDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "cstore_pro.db");
    Database db = await openDatabase(path);
    await db.close();
  }

  ///Pricing Database Functions

  static Future<List<PricingShowModel>> getDataListPriceCheck(String workingId, String clientId, String brandId,String categoryId,String subCategoryId) async {
    final db = await initDataBase();
    String query = "SELECT sys_product.id as pro_id,"
        " sys_product.en_name as pro_en_name,"
        " trans_pricing.promo_price,trans_pricing.act_status,trans_pricing.upload_status, trans_pricing.regular_price, sys_product.ar_name as pro_ar_name,sys_category.en_name  ||  '  ' ||  sys_subcategory.en_name as cat_en_name,"
        " sys_category.ar_name as cat_ar_name,"
        " sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,sys_product.image,"
        " sys_product.rsp,"
        " CASE WHEN trans_pricing.sku_id IS NULL then 0 ELSE trans_pricing.sku_id END as pricing_taken"
        " from sys_product"
        " JOIN sys_category on sys_category.id=sys_product.category_id"
        "  JOIN sys_subcategory on sys_subcategory.id=sys_product.subcategory_id"
        "  JOIN sys_brand on sys_brand.id=sys_product.brand_id"
        " left join trans_pricing on trans_pricing.sku_id = sys_product.id"
        " WHERE sys_category.id=sys_product.category_id ";
    List<String> conditions = [];
    if (clientId != "-1") {
      conditions.add("sys_product.client_id = '$clientId'");
    }
    if (brandId != "-1") {
      conditions.add("sys_product.brand_id = '$brandId'");
    }
    if (subCategoryId != "-1") {
      conditions.add("sys_product.subcategory_id = '$subCategoryId'");
    }
    if (categoryId != "-1") {
      conditions.add("sys_product.category_id = '$categoryId'");
    }
    if (conditions.isNotEmpty) {
      query += " AND " + conditions.join(" AND ");
    }
    query += " ORDER BY sys_subcategory.en_name,sys_brand.en_name ASC";
    final List<Map<String, dynamic>> pricingMap = await db.rawQuery(query);
    return List.generate(pricingMap.length, (index) {
      return PricingShowModel(
        pro_id: pricingMap[index]['pro_id'] as int,
        cat_en_name: pricingMap[index]['cat_en_name'] ?? "",
        cat_ar_name: pricingMap[index]['cat_ar_name'] ?? "",
        pro_en_name: pricingMap[index]['pro_en_name'] ?? "",
        pro_ar_name: pricingMap[index]['pro_ar_name'] ?? "",
        img_name: pricingMap[index]['image'] ?? "",
        rsp: pricingMap[index]['rsp'] ?? "",
        brand_en_name: pricingMap[index]['brand_en_name'] ?? "",
        brand_ar_name: pricingMap[index]['brand_ar_name'] ?? "",
        pricing_taken: pricingMap[index]['pricing_taken'] ?? 0,
        regular_price: pricingMap[index]['regular_price'] ?? "",
        promo_price: pricingMap[index]['promo_price'] ?? "",
        upload_status: pricingMap[index]['upload_status'] ?? 0,
        act_status: pricingMap[index]['act_status'] ?? 0,
      );
    });
  }

  ///Get Price Check COUNT RECORDS FOR API UPLOAD
  static Future<PriceCheckCountModel> getPriceCheckCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery("SELECT count(sku_id) AS total_price_check, "
        "sum(CASE WHEN act_status=1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, "
        "sum(CASE WHEN act_status=1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded "
        "FROM trans_pricing WHERE working_id=$workingId"));
    print(jsonEncode(result));
    print("____________Price Check Cont_______________");
    return  PriceCheckCountModel(
      totalPriceCheck: result[0]['total_price_check'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
    );
  }

  ///Get Price Check Data List For API
  static Future<List<SavePricingDataListData>> getActivityStatusPriceCheckDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = "SELECT sku_id,regular_price,promo_price "
        " FROM trans_pricing WHERE working_id=$workingId AND upload_status=0";

    print("RTV QUERY");
    print(rawQuery);

    final List<Map<String, dynamic>> priceCheckMap = await db.rawQuery(rawQuery);
    print(priceCheckMap);
    return List.generate(priceCheckMap.length, (index) {
      return SavePricingDataListData(
        skuId: priceCheckMap[index]['sku_id'],
        clientId: 1,
        regularPrice: priceCheckMap[index]['regular_price'].toString(),
        promoPrice: priceCheckMap[index]['promo_price'].toString(),

      );
    });
  }

  static Future<int> insertTransPromoPrice(int skuId, String regular, String promo, String workingID) async {
    String insertQuery = '''
    INSERT INTO trans_pricing (sku_id, regular_price, promo_price, date_time, upload_status,act_status, working_id)
    VALUES ($skuId, ${wrapIfString(regular)}, ${wrapIfString(promo)},CURRENT_TIMESTAMP,0,1,$workingID)
  ''';

    var db = await initDataBase();
    print("_______________INSERT TransPromoPrice________________");
    print(insertQuery);
    return await db.rawInsert(insertQuery);
  }

  static Future<int> updateTransPromoPricing(int skuId, String regular, String promo, String workingID) async {
    String writeQuery = "update trans_pricing set regular_price=${wrapIfString(regular)},promo_price=${wrapIfString(promo)},upload_status=0 Where sku_id=$skuId AND working_id=$workingID";
    var db = await initDataBase();
    print("_______________UpdATE________________");
    print(writeQuery);
    return await db.rawUpdate(writeQuery);
  }



  ///RTV Database Functions

  static Future<void> insertTransRtvData(TransRtvModel transRtvModel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tbl_trans_rtv,
      transRtvModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  static Future<List<Sys_RTVReasonModel>> getRtvReasonList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> brandMaps = await db.rawQuery(
        "SELECT *from sys_rtv_reason");

    print(jsonEncode(brandMaps));
    print("________ RTV Reason List ________________");
    return List.generate(brandMaps.length, (index) {
      return Sys_RTVReasonModel(
        id: brandMaps[index][TableName.sys_rtv_reason_id] as int,
        en_name: brandMaps[index][TableName.sys_rtv_reason_en_name] as String,
        ar_name: brandMaps[index][TableName.sys_rtv_reason_ar_name] as String,
        calendar: brandMaps[index][TableName.sys_rtv_reason_calendar].toString(),
        status: brandMaps[index][TableName.sys_rtv_reason_status] as int,
      );
    });
  }

  static Future<List<RTVShowModel>> getDataListRTV(String workingId, String clientId, String brandId,String categoryId,String subCategoryId) async {
    final db = await initDataBase();
    String query = "SELECT sys_product.id as pro_id,"
        " sys_product.en_name as pro_en_name,"
        " trans_rtv.act_status, trans_rtv.pieces, sys_product.ar_name as pro_ar_name,sys_category.en_name  ||  '  ' ||  sys_subcategory.en_name as cat_en_name,"
        " sys_category.ar_name as cat_ar_name, "
        " sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,sys_product.image,"
        "sys_product.rsp,"
        " CASE WHEN trans_rtv.sku_id IS NULL then 0 ELSE trans_rtv.sku_id END as rtv_taken"
        " from sys_product"
        " JOIN sys_category on sys_category.id=sys_product.category_id"
        " JOIN sys_subcategory on sys_subcategory.id=sys_product.subcategory_id"
        " JOIN sys_brand on sys_brand.id=sys_product.brand_id "
        " left join trans_rtv on trans_rtv.sku_id = sys_product.id"
        " WHERE 1=1";
    List<String> conditions = [];
    if (clientId != "-1") {
      conditions.add("sys_product.client_id = '$clientId'");
    }
    if (brandId != "-1") {
      conditions.add("sys_product.brand_id = '$brandId'");
    }
    if (subCategoryId != "-1") {
      conditions.add("sys_product.subcategory_id = '$subCategoryId'");
    }
    if (categoryId != "-1") {
      conditions.add("sys_product.category_id = '$categoryId'");
    }
    if (conditions.isNotEmpty) {
      query += " AND " + conditions.join(" AND ");
    }
    query += " GROUP BY sys_product.id ORDER BY sys_subcategory.en_name,sys_brand.en_name ASC";
    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(query);
    print(rtvMap);
    return List.generate(rtvMap.length, (index) {
      return RTVShowModel(
        pro_id: rtvMap[index]['pro_id'] as int,
        cat_en_name: rtvMap[index]['cat_en_name'] ?? "",
        cat_ar_name: rtvMap[index]['cat_ar_name'] ?? "",
        pro_en_name: rtvMap[index]['pro_en_name'] ?? "",
        pro_ar_name: rtvMap[index]['pro_ar_name'] ?? "",
        img_name: rtvMap[index]['image'] ?? "",
        rsp: rtvMap[index]['rsp'] ?? "",
        brand_en_name: rtvMap[index]['brand_en_name'] ?? "",
        brand_ar_name: rtvMap[index]['brand_ar_name'] ?? "",
        rtv_taken: rtvMap[index]['rtv_taken'] ?? 0,
        pieces: rtvMap[index]['pieces'] ?? 0,
        act_status: rtvMap[index]['act_status'] ?? 0,
        imageFile: null,
      );
    });
  }
  static Future<RTVCountModel>  getRTVCountData(String workingId, String clientId, String brandId,String categoryId,String subCategoryId) async {
    final db = await initDataBase();
    String query = "SELECT COUNT(DISTINCT sku_id) as total_rtv_pro, sum(pieces ) as total_volume, SUM(total_value) as total_value FROM "
        " (SELECT sku_id, trans_rtv.pieces as pieces ,SUM(trans_rtv.pieces * sys_product.rsp) as total_value"
        " from trans_rtv"
        " join sys_product on sys_product.id=trans_rtv.sku_id"
        " WHERE working_id=$workingId ";
    List<String> conditions = [];
    if (clientId != "-1") {
      conditions.add("sys_product.client_id = '$clientId'");
    }
    if (brandId != "-1") {
      conditions.add("sys_product.brand_id = '$brandId'");
    }
    if (subCategoryId != "-1") {
      conditions.add("sys_product.subcategory_id = '$subCategoryId'");
    }
    if (categoryId != "-1") {
      conditions.add("sys_product.category_id = '$categoryId'");
    }
    if (conditions.isNotEmpty) {
      query += " AND " + conditions.join(" AND ");
    }
    query += "  GROUP by trans_rtv.id  ) A";
    final List<Map<String, dynamic>> result = await db.rawQuery(query);
    print("rtv count data....");
    print(result);
    return RTVCountModel(
      total_rtv_pro: result[0]['total_rtv_pro'] ?? 0,
      total_value: result[0]['total_value'] ?? 0,
      total_volume: result[0]['total_volume']?? 0,
    );
  }

  static Future<PricingCountModel> getPricingCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery("SELECT sum(trans_pricing.act_status) as total_pricing FROM trans_pricing WHERE trans_pricing.working_id=$workingId"));
    print(jsonEncode(result));
    print("____________Pricing Cont_______________");
    return  PricingCountModel(
      total_pricing: result[0]['total_pricing'] ?? 0,
    );
  }


  ///Delete Data from tabkle with workingId
  static Future<void> deleteTransTableByWorkingId(String tblName, String workingId) async {
    var db = await initDataBase();
    await db.delete(tblName, where: 'working_id = ?', whereArgs: [workingId]);
    print("Table data delet $tblName,  $workingId");
  }
}

String wrapIfString(dynamic value) {
  if (value is String) {
    return "'$value'";
  } else {
    return value.toString();
  }
}
