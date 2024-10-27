import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cstore/Model/database_model/picklist_model.dart';
import 'package:cstore/Model/database_model/pomo_plan_model.dart';
import 'package:cstore/Model/database_model/sys_osdc_reason_model.dart';
import 'package:cstore/Model/database_model/sys_osdc_type_model.dart';
import 'package:cstore/Model/database_model/sys_rtv_reason_model.dart';
import 'package:cstore/Model/database_model/trans_freshness_model.dart';
import 'package:cstore/Model/database_model/trans_one_plus_one_mode.dart';
import 'package:cstore/Model/database_model/trans_sos_model.dart';
import 'package:cstore/Model/database_model/trans_stock_model.dart';
import 'package:cstore/Model/request_model.dart/save_one_plus_one_request.dart';
import 'package:cstore/database/table_name.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/database_model/app_setting_model.dart';
import '../Model/database_model/availability_show_model.dart';
import '../Model/database_model/avl_product_placement_model.dart';
import '../Model/database_model/freshness_graph_count.dart';
import '../Model/database_model/knowledgeShare_model.dart';
import '../Model/database_model/planoguide_gcs_images_list_model.dart';
import '../Model/database_model/pricing_show_model.dart';
import '../Model/database_model/promo_plan_graph_api_count_model.dart';
import '../Model/database_model/required_module_model.dart';
import '../Model/database_model/rtv_show_model.dart';
import '../Model/database_model/show_before_fixing.dart';
import '../Model/database_model/show_freshness_list_model.dart';
import '../Model/database_model/show_market_issue_model.dart';
import '../Model/database_model/show_planogram_model.dart';
import '../Model/database_model/show_proof_of_sale_model.dart';
import '../Model/database_model/show_trans_osdc_model.dart';
import '../Model/database_model/show_trans_rtv_model.dart';
import '../Model/database_model/show_trans_sos.dart';
import '../Model/database_model/sys_brand_faces_model.dart';
import '../Model/database_model/sys_brand_model.dart';
import '../Model/database_model/sys_market_issue_model.dart';
import '../Model/database_model/sys_photo_type.dart';
import '../Model/database_model/sys_product_model.dart';
import '../Model/database_model/sys_product_placement_model.dart';
import '../Model/database_model/sys_store_model.dart';
import '../Model/database_model/sys_store_pog_model.dart';
import '../Model/database_model/total_count_response_model.dart';
import '../Model/database_model/trans_add_proof_of_sale_model.dart';
import '../Model/database_model/trans_before_faxing.dart';
import '../Model/database_model/trans_brand_shares_model.dart';
import '../Model/database_model/trans_market_issue_model.dart';
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
import '../Model/database_model/trans_promo_plan_list_model.dart';
import '../Model/database_model/trans_rtv_model.dart';
import '../Model/database_model/trans_rtv_one_plus_one.dart';
import '../Model/request_model.dart/availability_api_request_model.dart';
import '../Model/request_model.dart/brand_share_request.dart';
import '../Model/request_model.dart/other_images_end_Api_request.dart';
import '../Model/request_model.dart/planogram_end_api_request_model.dart';
import '../Model/request_model.dart/planoguide_request_model.dart';
import '../Model/request_model.dart/ready_pick_list_request.dart';
import '../Model/request_model.dart/save_api_pricing_data_request.dart';
import '../Model/request_model.dart/save_api_rtv_data_request.dart';
import '../Model/request_model.dart/save_freshness_request_model.dart';
import '../Model/request_model.dart/save_market_issue_request.dart';
import '../Model/request_model.dart/save_osd_request.dart';
import '../Model/request_model.dart/save_pos_request.dart';
import '../Model/request_model.dart/save_promo_plan_request_model.dart';
import '../Model/request_model.dart/save_replenishment_request.dart';
import '../Model/request_model.dart/save_stock_request_model.dart';
import '../Model/request_model.dart/sos_end_api_request_model.dart';
import '../Model/response_model.dart/adherence_response_model.dart';
import '../Model/response_model.dart/jp_response_model.dart';
import '../Model/response_model.dart/repelish_response_model.dart';
import '../Model/response_model.dart/syncronise_response_model.dart';
import '../Model/response_model.dart/user_dashboard_model.dart';
import '../Network/app_exceptions.dart';
import '../screens/important_service/genral_checks_status.dart';
import '../screens/utils/services/general_checks_controller_call_function.dart';

class DatabaseHelper {
  static var instance;

  static Future<Database?> get database async {
    // Get a location using getDatabasesPath()
    const databaseName = 'cstore_pro.db';
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Create your tables here
      await db.execute('CREATE TABLE ' +
          TableName.tblSysDropReason +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT, ' +
          TableName.status +
          ' INTEGER' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblSysAgencyDashboard +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT, ' +
          TableName.agency_dash_icon +
          ' TEXT, ' +
          TableName.agency_dash_start_date +
          ' TEXT, ' +
          TableName.agency_dash_end_date +
          ' TEXT, ' +
          TableName.agency_dash_accessTo +
          ' TEXT, ' +
          TableName.orderBy +
          ' INTEGER,' +
          TableName.status +
          ' INTEGER' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblSysCategory +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT, ' +
          TableName.clientIds +
          ' INTEGER' +
          ')');
      await db.execute('CREATE TABLE ' +
          TableName.tblSysSubcategory +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT, ' +
          TableName.clientIds +
          ' INTEGER' +
          ')');
      await db.execute('CREATE TABLE ' +
          TableName.tblSysClient +
          '(' +
          TableName.clientIds +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.sys_client_name +
          ' TEXT, ' +
          TableName.sys_client_logo +
          ' BLOB, ' +
          TableName.sys_client_classification +
          ' INTEGER, ' +
          TableName.sys_client_chainSku_code +
          ' INTEGER, ' +
          TableName.sys_client_is_dayFreshness +
          ' INTEGER, ' +
          TableName.sys_client_geo_requried +
          ' INTEGER, ' +
          TableName.sys_client_order_avl +
          ' INTEGER, ' +
          TableName.sys_client_is_survey +
          ' INTEGER' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblSysPlanogramReason +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' INTEGER, ' +
          TableName.status +
          ' INTEGER' +
          ')');
      await db.execute('CREATE TABLE ' +
          TableName.tblSysBrand +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT, ' +
          TableName.clientIds +
          ' INTEGER' +
          ')');

      ///Rtv Reason Table

      await db.execute('CREATE TABLE ' +
          TableName.tblSysRtvReason+
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT, ' +
          TableName.sys_rtv_reason_calendar +
          ' INTEGER, ' +
          TableName.status +
          ' INTEGER' +
          ')');


      await db.execute('CREATE TABLE '+
          TableName.tblSysPhototype+
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblSysOsdcType+
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblSysOsdcReason+
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblSysProduct+
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.clientIds +
          ' INTEGER, ' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT, ' +
          TableName.sys_product_image +
          ' TEXT, ' +
          TableName.sys_product_principal_id +
          ' INTEGER, ' +
          TableName.sys_product_cluster_id +
          ' INTEGER, ' +
          TableName.sysCategoryId +
          ' INTEGER, ' +
          TableName.sys_product_sub_cat_id +
          ' INTEGER, ' +
          TableName.brandId +
          ' INTEGER, ' +
          TableName.sys_product_rsp +
          ' TEXT, ' +
          TableName.sys_product_sku_weight +
          ' TEXT' +
          ')');

      await db.execute(
          'CREATE TABLE ' +
              TableName.tblSysStorePog +
              ' (' +
              TableName.clientIds + ' INTEGER, ' +
              TableName.storeId + ' INTEGER, ' +
              TableName.sysCategoryId + ' INTEGER, ' +
              TableName.sys_store_pog + ' TEXT, ' +
              TableName.sys_store_pog_image + ' TEXT, ' +
              'CONSTRAINT unique_key UNIQUE (' +
              TableName.storeId + ', ' +
              TableName.sysCategoryId + ', ' +
              TableName.sys_store_pog +
              ')' +
              ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblSysProductPlacement +
          '(' +
          TableName.skuId +
          ' INTEGER, ' +
          TableName.storeId +
          ' INTEGER, ' +
          TableName.sysCategoryId +
          ' INTEGER, ' +
          TableName.sys_product_placement_pog +
          ' TEXT, ' +
          TableName.sys_product_placement_h_facing +
          ' INTEGER, ' +
          TableName.sys_product_placement_v_facing +
          ' INTEGER, ' +
          TableName.sys_product_placement_d_facing +
          ' INTEGER, ' +
          TableName.sys_product_placement_total_facing +
          ' INTEGER, ' +
          TableName.sys_product_placement_bay_no +
          ' TEXT, ' +
          TableName.sys_product_placement_shelf_no +
          ' TEXT, ' +
          TableName.sys_product_placement_rank_x +
          ' TEXT, ' +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.storeId + ', ' +
          TableName.skuId +
          ')' +
          ')');

      await db.execute(
          'CREATE TABLE ' +
              TableName.tblSysBrandFaces +
              ' (' +
              TableName.storeId + ' INTEGER, ' +
              TableName.clientIds + ' INTEGER, ' +
              TableName.sysCategoryId + ' INTEGER, ' +
              TableName.brandId + ' INTEGER, ' +
              TableName.sys_brand_faces_givenFaces + ' INTEGER, ' +
              'CONSTRAINT unique_key UNIQUE (' +
              TableName.storeId + ', ' +
              TableName.sysCategoryId + ', ' +
              TableName.brandId +
              ')' +
              ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblSysSosUnits+
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT' +
          ')');
      await db.execute('CREATE TABLE ' +
          TableName.tblSysDailyChecklist+
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT' +
          ')');
      await db.execute('CREATE TABLE ' +
          TableName.tblSysAppSetting+
          '(' +
          TableName.storeId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.sys_app_settingBgServices +
          ' TEXT, ' +
          TableName.sys_app_settingBgServiceMinute +
          ' TEXT, ' +
          TableName.sys_app_settingPicklisService +
          ' TEXT, ' +
          TableName.sys_app_auto_time +
          ' TEXT, ' +
          TableName.sys_app_location +
          ' TEXT, ' +
          TableName.sys_app_geo_location +
          ' TEXT, ' +
          TableName.sys_app_fake_location_check +
          ' TEXT, ' +
          TableName.sys_app_vpn_check +
          ' TEXT, ' +
          TableName.sys_app_settingPicklisTime +
          ' TEXT' +
          ')');

      ///Promo plan System Table
      await db.execute('CREATE TABLE ' +
          TableName.tblSysPromoPlan+
          '(' +
          TableName.skuId +
          ' INTEGER, ' +
          TableName.storeId +
          ' INTEGER, ' +
          TableName.from +
          ' TEXT, ' +
          TableName.to +
          ' TEXT, ' +
          TableName.weekTitle +
          ' TEXT, ' +
          TableName.promoScope +
          ' TEXT, ' +
          TableName.promoScopeOther +
          ' TEXT, ' +
          TableName.promoPrice +
          ' TEXT, ' +
          TableName.osdType +
          ' TEXT, ' +
          TableName.leftOverAction +
          ' TEXT, ' +
          TableName.modalImage +
          ' TEXT, ' +
          TableName.companyId +
          ' TEXT, ' +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.skuId + ', ' +
          TableName.storeId +
          ')' +
          ')');

      //---------***********create trans table here*************---------
      await db.execute('CREATE TABLE ' +
          TableName.tblTransBeforeFaxing +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY AUTOINCREMENT,' +
          TableName.clientIds +
          ' INTEGER, ' +
          TableName.transPhotoTypeId +
          ' INTEGER, ' +
          TableName.sysCategoryId +
          ' INTEGER, ' +
          TableName.imageName +
          ' TEXT, ' +
          TableName.gcsStatus +
          ' INTEGER, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus+
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER' +
          ')');
      await db.execute('CREATE TABLE ' +
          TableName.tblTransPhoto +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY AUTOINCREMENT,' +
          TableName.clientIds +
          ' INTEGER, ' +
          TableName.transPhotoTypeId +
          ' INTEGER, ' +
          TableName.sysCategoryId +
          ' INTEGER, ' +
          TableName.type_id +
          ' INTEGER, ' +
          TableName.imageName +
          ' TEXT, ' +
          TableName.gcsStatus +
          ' INTEGER, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus+
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblTransPlanogram +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY AUTOINCREMENT,' +
          TableName.clientIds +
          ' INTEGER, ' +
          TableName.sysCategoryId +
          ' INTEGER, ' +
          TableName.brandId +
          ' INTEGER, ' +
          TableName.imageName +
          ' TEXT, ' +
          TableName.transPlanogramIsAdherence +
          ' INTEGER, ' +
          TableName.gcsStatus +
          ' INTEGER, ' +
          TableName.transPlanogramReasonId +
          ' INTEGER,' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus+
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblTransSos +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY AUTOINCREMENT,' +
          TableName.clientIds +
          ' INTEGER, ' +
          TableName.sysCategoryId +
          ' INTEGER, ' +
          TableName.brandId +
          ' INTEGER, ' +
          TableName.trans_sos_cat_space +
          ' TEXT, ' +
          TableName.trans_sos_actual_space +
          ' TEXT, ' +
          TableName.trans_sos_unit +
          ' TEXT, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus+
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER' +
          ')');
      await db.execute('CREATE TABLE ' +
          TableName.tblTransAvailability +
          '(' +
          TableName.skuId +
          ' INTEGER , ' +
          TableName.trans_avl_status +
          ' INTEGER, ' +
          TableName.transActivityStatus +
          ' INTEGER, ' +
          TableName.trans_avl_req_picklist +
          ' INTEGER, ' +
          TableName.trans_avl_actual_picklist +
          ' INTEGER, ' +
          TableName.trans_avl_picklist_reason +
          ' INTEGER, ' +
          TableName.trans_avl_picklist_ready +
          ' INTEGER, ' +
          TableName.trans_pick_upload_status +
          ' INTEGER, ' +
          TableName.clientIds +
          ' INTEGER, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.trans_avl_picker_name +
          ' TEXT, ' +
          TableName.uploadStatus +
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER, ' +
          TableName.trans_avl_send_time +
          ' TEXT, ' +
          TableName.trans_avl_receive_time +
          ' TEXT, ' +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.skuId + ', ' +
          TableName.workingId +
          ')'+')');

      await db.execute('CREATE TABLE ' +
          TableName.tblTransRtv +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE, ' +
          TableName.skuId +
          ' INTEGER ' +
          TableName.type_id +
          ' INTEGER, ' +
          TableName.trans_rtv_reason +
          ' INTEGER, ' +
          TableName.pieces +
          ' INTEGER, ' +
          TableName.trans_rtv_expire_date+
          ' TEXT, ' +
          TableName.imageName +
          ' TEXT, ' +
          TableName.trans_rtv_activity_status +
          ' INTEGER, ' +
          TableName.gcsStatus +
          ' INTEGER, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus+
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblTransPricing +
          '(' +
          TableName.skuId +
          ' INTEGER , ' +
          TableName.trans_pricing_regular +
          ' TEXT, ' +
          TableName.trans_pricing_promo +
          ' TEXT, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus +
          ' INTEGER, ' +
          TableName.trans_rtv_activity_status +
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER, ' +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.skuId + ', ' +
          TableName.workingId +
          ')' +
          ')');


      await db.execute('CREATE TABLE ' +
          TableName.transReplenishmentTable +
          '(' +
          TableName.skuId +
          ' INTEGER , ' +
          TableName.transRequiredPieces +
          ' TEXT, ' +
          TableName.transPickedPieces +
          ' TEXT, ' +
          TableName.transPickListReason +
          ' TEXT, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus +
          ' INTEGER, ' +
          TableName.trans_rtv_activity_status +
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER, ' +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.skuId + ', ' +
          TableName.workingId +
          ')' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tbTransPromoPlan +
          '(' +
          TableName.skuId +
          ' INTEGER, ' +
          TableName.imageName +
          ' TEXT, ' +
          TableName.modalImage +
          ' TEXT, ' +
          TableName.promoReason +
          ' TEXT, ' +
          TableName.promoStatus +
          ' TEXT, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.activityStatus +
          ' INTEGER, ' +
          TableName.gcsStatus +
          ' INTEGER, ' +
          TableName.uploadStatus +
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER, ' +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.workingId +
          ', ' +
          TableName.skuId +
          ')' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblTransFreshness +
          '(' +
          TableName.skuId +
          ' INTEGER , ' +
          TableName.clientIds +
          ' INTEGER , ' +
          TableName.trans_freshness_year +
          ' INTEGER, ' +
          TableName.trans_freshness_jan +
          ' INTEGER, ' +
          TableName.trans_freshness_feb +
          ' INTEGER, ' +
          TableName.trans_freshness_mar +
          ' INTEGER, ' +
          TableName.trans_freshness_apr +
          ' INTEGER, ' +
          TableName.trans_freshness_may +
          ' INTEGER, ' +
          TableName.trans_freshness_jun +
          ' INTEGER, ' +
          TableName.trans_freshness_jul +
          ' INTEGER, ' +
          TableName.trans_freshness_aug +
          ' INTEGER, ' +
          TableName.trans_freshness_sep +
          ' INTEGER, ' +
          TableName.trans_freshness_oct +
          ' INTEGER, ' +
          TableName.trans_freshness_nov +
          ' INTEGER, ' +
          TableName.trans_freshness_dec +
          ' INTEGER, ' +
          TableName.trans_freshness_specific_date +
          ' INTEGER, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus +
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER, ' +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.dateTime +
          ', ' +
          TableName.workingId +
          ')' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblTransStock +
          '(' +
          TableName.skuId +
          ' INTEGER, ' +
          TableName.trans_stock_cases +
          ' INTEGER, ' +
          TableName.clientIds +
          ' INTEGER, ' +
          TableName.trans_stock_outer +
          ' INTEGER, ' +
          TableName.pieces +
          ' INTEGER, ' +
          TableName.uploadStatus +
          ' INTEGER, ' +
          TableName.trans_rtv_activity_status +
          ' INTEGER, ' +
          TableName.dateTime +
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER, ' +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.dateTime +
          ', ' +
          TableName.workingId +
          ')' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblTransOsdc +
          '(' +
          TableName.sysId+
          ' INTEGER PRIMARY KEY AUTOINCREMENT,' +
          TableName.brandId +
          ' INTEGER, ' +
          TableName.trans_osdc_reason_id+
          ' INTEGER, ' +
          TableName.trans_osdc_quantity+
          ' INTEGER, ' +
          TableName.gcsStatus+
          ' INTEGER, ' +
          TableName.type_id+
          ' INTEGER, ' +
          TableName.clientIds+
          ' INTEGER, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus+
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblTransOsdcImages +
          '(' +
          TableName.sysId+
          ' INTEGER PRIMARY KEY AUTOINCREMENT,' +
          TableName.trans_osdc_main_id +
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER, ' +
          TableName.imageName+
          ' INTEGER' +
          ')');
      await db.execute('CREATE TABLE ' +
          TableName.tblTransPlanoguide +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY AUTOINCREMENT, ' +
          TableName.sysCategoryId +
          ' INTEGER, ' +
          TableName.clientIds +
          ' INTEGER, ' +
          TableName.storeId +
          ' INTEGER, ' +
          TableName.trans_planoguide_pog +
          ' TEXT, ' +
          TableName.trans_planoguide_isAdherence +
          ' TEXT, ' +
          TableName.imageName +
          ' TEXT, ' +
          TableName.trans_planoguide_skuImageName +
          ' TEXT, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus +
          ' INTEGER, ' +
          TableName.transActivityStatus +
          ' INTEGER, ' +
          TableName.gcsStatus +
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER, ' +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.storeId + ', ' +
          TableName.sysCategoryId + ', ' +
          TableName.trans_planoguide_pog + ', ' +
          TableName.workingId +
          ')' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblTransBrandShare +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY AUTOINCREMENT, ' +
          TableName.sysCategoryId +
          ' INTEGER, ' +
          TableName.clientIds +
          ' INTEGER, ' +
          TableName.trans_brand_shares_storeId +
          ' INTEGER, ' +
          TableName.brandId +
          ' INTEGER, ' +
          TableName.trans_brand_shares_givenFaces +
          ' TEXT, ' +
          TableName.trans_brand_shares_actualFaces +
          ' TEXT, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus +
          ' INTEGER, ' +
          TableName.transActivityStatus +
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER, ' +
          'CONSTRAINT unique_key UNIQUE (' +
          TableName.trans_brand_shares_storeId + ', ' +
          TableName.brandId + ', ' +
          TableName.sysCategoryId + ', ' +
          TableName.workingId +
          ')' +
          ')');


      ///PickList Addition

      await db.execute('CREATE TABLE ' +
          TableName.tblPicklist +
          '(' +
          TableName.picklist_id +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.storeId +
          ' INTEGER,'+
          TableName.sysCategoryId +
          ' INTEGER,'+
          TableName.picklist_tmr_id +
          ' INTEGER,'+
          TableName.picklist_tmr_name +
          ' TEXT,'+
          TableName.picklist_stocker_id +
          ' INTEGER,' +
          TableName.picklist_stocker_name +
          ' TEXT,' +
          TableName.picklist_shift_time  +
          ' TEXT,' +
          TableName.enName +
          ' TEXT,' +
          TableName.arName  +
          ' TEXT,' +
          TableName.picklist_sku_picture  +
          ' TEXT,' +
          TableName.picklist_en_sku_name   +
          ' TEXT,' +
          TableName.picklist_ar_sku_name    +
          ' TEXT,' +
          TableName.picklist_act_picklist    +
          ' INTEGER,'+
          TableName.picklist_req_picklist    +
          ' INTEGER,'+
          TableName.uploadStatus +
          ' INTEGER, ' +
          TableName.picklist_picklist_ready  +
          ' INTEGER, '+
          TableName.trans_avl_send_time +
          ' TEXT, ' +
          TableName.picklist_reason   +
          ' TEXT,' +
          TableName.workingId +
          ' INTEGER, ' +
          TableName.trans_avl_receive_time +
          ' TEXT ' +')');

      ///Required Modules List Addition
      await db.execute('CREATE TABLE ' +
          TableName.tblSysVisitReqModules +
          '(' +
          TableName.tblSysModuleId +
          ' INTEGER,' +
          TableName.tblSysVisitActivityType +
          ' INTEGER,'+
          ' CONSTRAINT unique_key UNIQUE (' +
          TableName.tblSysModuleId + ', ' +
          TableName.tblSysVisitActivityType + ')' + ')'
      );

      ///JourneyPlanListAddition
      await db.execute('CREATE TABLE ' +
          TableName.tblSysJourneyPlan+
          '(' +
          TableName.workingId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.workingDate +
          ' TEXT, ' +
          TableName.storeId +
          ' INTEGER, ' +
          TableName.enStoreName +
          ' TEXT, ' +
          TableName.arStoreName +
          ' TEXT,' +
          TableName.storeGCode +
          ' TEXT,' +
          TableName.clientIds +
          ' TEXT,' +
          TableName.userId +
          ' INTEGER,' +
          TableName.checkInTime +
          ' TEXT,' +
          TableName.checkOutTime +
          ' TEXT,' +
          TableName.startVisitPhoto +
          ' TEXT,' +
          TableName.checkInGps +
          ' TEXT,' +
          TableName.checkOutGps +
          ' TEXT,' +
          TableName.visitStatus +
          ' INTEGER,' +
          TableName.visitType +
          ' TEXT,' +
          TableName.isDrop +
          ' INTEGER,' +
          TableName.visitActivityType +
          ' INTEGER,' +
          TableName.avlExclude +
          ' TEXT,' +
          TableName.otherExclude +
          ' TEXT' +
          ')');


      ///Dashboard Data Addition
      await db.execute('CREATE TABLE ' +
          TableName.tblSysDashboard+
          '(' +
          TableName.userId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.jpPlanned +
          ' INTEGER, ' +
          TableName.jpVisited +
          ' INTEGER, ' +
          TableName.outOfPlanned +
          ' INTEGER, ' +
          TableName.outOfPlannedVisited +
          ' INTEGER,' +
          TableName.jpc +
          ' INTEGER,' +
          TableName.pro +
          ' INTEGER,' +
          TableName.workingHrs +
          ' INTEGER,' +
          TableName.eff +
          ' INTEGER,' +
          TableName.monthlyAttend +
          ' INTEGER,' +
          TableName.monthlyPro +
          ' INTEGER,' +
          TableName.monthlyEff +
          ' INTEGER,' +
          TableName.monthlyIncentives +
          ' INTEGER,' +
          TableName.monthlyDeduction +
          ' INTEGER' +
          ')');

      await db.execute('CREATE TABLE ' +
    TableName.tblSysKnowledgeShare +
    '(' +
    TableName.sysId +
    ' INTEGER PRIMARY KEY UNIQUE,' +
    TableName.sys_knowledge_title +
    ' TEXT, ' +
    TableName.sys_knowledge_des +
    ' TEXT, ' +
    TableName.clientIds +
    ' INTEGER, ' +
    TableName.chain_id +
    ' INTEGER, ' +
    TableName.sysKnowledgeAddedBy +
    ' TEXT, ' +
    TableName.sysKnowledgeFileName +
    ' TEXT, ' +
    TableName.sysKnowledgeType +
    ' TEXT, ' +
    TableName.sysKnowledgeActive +
    ' TEXT, ' +
    TableName.sysIssueUpdateAt +
    ' TEXT' +
    ')');

      await db.execute(
          'CREATE TABLE ' +
              TableName.tblTransPOS +
              ' (' +
              TableName.sysId +
              ' INTEGER PRIMARY KEY AUTOINCREMENT,' +
              TableName.skuId + ' INTEGER, ' +
              TableName.clientIds + ' INTEGER, ' +
              TableName.sysCategoryId + ' INTEGER, ' +
              TableName.trans_pos_name + ' TEXT, ' +
              TableName.trans_pos_email + ' TEXT, ' +
              TableName.trans_pos_phone + ' TEXT, ' +
              TableName.trans_pos_amount + ' TEXT, ' +
              TableName.quantity + ' INTEGER, ' +
              TableName.imageName + ' TEXT, ' +
              TableName.uploadStatus + ' INTEGER, ' +
              TableName.gcsStatus + ' INTEGER, ' +
              TableName.workingId + ' INTEGER, ' +
              TableName.dateTime + ' INTEGER ' +
              ')');

      await db.execute(
          'CREATE TABLE ' +
              TableName.tblTransOnePlusOne +
              ' (' +
              TableName.sysId +
              ' INTEGER PRIMARY KEY AUTOINCREMENT,' +
              TableName.skuId +
              ' INTEGER, ' +
              TableName.clientIds +
              ' INTEGER, ' +
              TableName.pieces +
              ' INTEGER, ' +
              TableName.trans_one_plus_one_doc_no +
              ' TEXT, ' +
              TableName.trans_one_plus_one_comment +
              ' TEXT, ' +
              TableName.trans_one_plus_one_type +
              ' TEXT, ' +
              TableName.imageName +
              ' TEXT, ' +
              TableName.trans_one_plus_one_doc_image +
              ' TEXT, ' +
              TableName.dateTime +
              ' TEXT, ' +
              TableName.uploadStatus +
              ' INTEGER, ' +
              TableName.gcsStatus +
              ' INTEGER, ' +
              TableName.activityStatus +
              ' INTEGER, ' +
              TableName.workingId +
              ' INTEGER, ' +
              'CONSTRAINT unique_key UNIQUE (' +
              TableName.workingId + ', ' +
              TableName.trans_one_plus_one_doc_no + ', ' +
              TableName.skuId +
              ')' +
              ')');


      await db.execute('CREATE TABLE ' +
          TableName.tblSysMarketIssue +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.trans_pos_name +
          ' TEXT, ' +
          TableName.status +
          ' INTEGER, ' +
          TableName.sysIssueUpdateAt +
          ' TEXT' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblTransMarketIssue +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY AUTOINCREMENT,' +
          TableName.sys_issue_id +
          ' INTEGER, ' +
          TableName.clientIds +
          ' INTEGER, ' +
          TableName.trans_one_plus_one_comment +
          ' TEXT, ' +
          TableName.imageName +
          ' TEXT, ' +
          TableName.dateTime +
          ' TEXT, ' +
          TableName.uploadStatus +
          ' INTEGER, ' +
          TableName.gcsStatus +
          ' INTEGER, ' +
          TableName.workingId +
          ' INTEGER' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblSysStores +
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT, ' +
          TableName.sysStoreGcode +
          ' TEXT, ' +
          TableName.sysStoreRegionId +
          ' INTEGER, ' +
          TableName.sysStoreRegionName +
          ' TEXT, ' +
          TableName.sysStoreCityId +
          ' INTEGER, ' +
          TableName.sysStoreCityName +
          ' TEXT, ' +
          TableName.chain_id +
          ' INTEGER, ' +
          TableName.sysStoreChainName +
          ' TEXT, ' +
          TableName.sysStoreChannelId +
          ' INTEGER, ' +
          TableName.sysStoreChannelId6 +
          ' INTEGER, ' +
          TableName.sysStoreChannelId7 +
          ' INTEGER, ' +
          TableName.type_id +
          ' INTEGER ' +
          ')');

      await db.execute('CREATE TABLE ' +
          TableName.tblSysPromoPlaneReason+
          '(' +
          TableName.sysId +
          ' INTEGER PRIMARY KEY UNIQUE,' +
          TableName.enName +
          ' TEXT, ' +
          TableName.arName +
          ' TEXT' +
          ')');

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
        TableName.sys_app_auto_time: data.isAutoTimeEnabled.toString(),
        TableName.sys_app_location: data.isLocationEnabled.toString(),
        TableName.sys_app_geo_location: data.isGeoLocationEnabled.toString(),
        TableName.sys_app_fake_location_check: data.isFakeLocationEnabled.toString(),
        TableName.sys_app_vpn_check: data.isVpnEnabled.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysAppSetting, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry App Setting type');
      } else {
        print('App Sitting insertion');
        await db.insert(
          TableName.tblSysAppSetting,
          {
            TableName.sys_app_settingBgServices: data.isBgServices.toString(),
            TableName.sys_app_settingBgServiceMinute: data.isBgMinute.toString(),
            TableName.sys_app_settingPicklisService: data.isPicklistService.toString(),
            TableName.sys_app_settingPicklisTime: data.isPicklistTime.toString(),
            TableName.sys_app_auto_time: data.isAutoTimeEnabled.toString(),
            TableName.sys_app_location: data.isLocationEnabled.toString(),
            TableName.sys_app_geo_location: data.isGeoLocationEnabled.toString(),
            TableName.sys_app_fake_location_check: data.isFakeLocationEnabled.toString(),
            TableName.sys_app_vpn_check: data.isVpnEnabled.toString(),
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

      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysVisitReqModules, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry sys Required Modules reason');
      } else {
        print('Required MOdules insertion');
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

  ///Insert Promo Plan to system table
  static Future<bool> insertSysPromoPlanArray(List<PromoPlanModel> modelList) async {
    var db = await initDataBase();
    print('Promo plan insertion');
    print(modelList.length);
    for (PromoPlanModel data in modelList) {
      Map<String, dynamic> fields = {

        TableName.skuId: data.skuId,
        TableName.modalImage:data.modalImage,
        TableName.from: data.from,
        TableName.to: data.to,
        TableName.promoScope: data.promoScope,
        TableName.promoScopeOther: data.promoScopeOther,
        TableName.weekTitle: data.weekTitle,
        TableName.storeId: data.storeId,
        TableName.companyId: data.companyId,
        TableName.osdType:data.osdType,
        TableName.leftOverAction:data.leftOverAction,
        TableName.promoPrice: data.promoPrice
      };

      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysPromoPlan, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry sys Promo PLan');
      } else {

        await db.insert(
          TableName.tblSysPromoPlan,
          {
            TableName.skuId: data.skuId,
            TableName.modalImage:data.modalImage,
            TableName.from: data.from,
            TableName.to: data.to,
            TableName.promoScope: data.promoScope,
            TableName.promoScopeOther: data.promoScopeOther,
            TableName.weekTitle: data.weekTitle,
            TableName.storeId: data.storeId,
            TableName.companyId: data.companyId,
            TableName.osdType:data.osdType,
            TableName.leftOverAction:data.leftOverAction,
            TableName.promoPrice: data.promoPrice
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

      }
    }
    return false;
  }

  ///Insert Journey Plan to system table
  static Future<bool> insertSysJourneyPlanArray(List<JourneyPlanDetail> modelList) async {
    var db = await initDataBase();

    for (JourneyPlanDetail data in modelList) {
      Map<String, dynamic> fields = {
        TableName.workingId: data.workingId,
        TableName.workingDate: data.workingDate,
        TableName.storeId: data.storeId,
        TableName.enStoreName: data.enStoreName,
        TableName.arStoreName: data.arStoreName,
        TableName.storeGCode: data.gcode,
        TableName.clientIds: data.clientIds,
        TableName.userId: data.userId,
        TableName.checkInTime: data.checkIn,
        TableName.checkOutTime: data.checkOut,
        TableName.startVisitPhoto: data.startVisitPhoto,
        TableName.checkInGps: data.checkinGps,
        TableName.checkOutGps: data.checkoutGps,
        TableName.visitStatus: data.visitStatus,
        TableName.visitType: data.visitType,
        TableName.isDrop: data.isDrop,
        TableName.visitActivityType: data.visitActivity,
        TableName.avlExclude: data.avlExclude,
        TableName.otherExclude: data.otherExclude,
      };

      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysJourneyPlan, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry sys Journey PLan');
      } else {
        print('JP Insertion');
        await db.insert(
          TableName.tblSysJourneyPlan,
          {
            TableName.workingId: data.workingId,
            TableName.workingDate: data.workingDate,
            TableName.storeId: data.storeId,
            TableName.enStoreName: data.enStoreName,
            TableName.arStoreName: data.arStoreName,
            TableName.storeGCode: data.gcode,
            TableName.clientIds: data.clientIds,
            TableName.userId: data.userId,
            TableName.checkInTime: data.checkIn,
            TableName.checkOutTime: data.checkOut,
            TableName.startVisitPhoto: data.startVisitPhoto,
            TableName.checkInGps: data.checkinGps,
            TableName.checkOutGps: data.checkoutGps,
            TableName.visitStatus: data.visitStatus,
            TableName.visitType: data.visitType,
            TableName.isDrop: data.isDrop,
            TableName.visitActivityType: data.visitActivity,
            TableName.avlExclude: data.avlExclude,
            TableName.otherExclude: data.otherExclude,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }
  ///Insert Dashboard to system table
  static Future<bool> insertSysDashboardArray(List<UserDashboardModel> modelList) async {
    var db = await initDataBase();

    for (UserDashboardModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.userId: data.user_id,
        TableName.jpPlanned: data.jp_planned,
        TableName.jpVisited: data.jp_visited,
        TableName.outOfPlanned: data.out_of_planned,
        TableName.outOfPlannedVisited: data.out_of_planned_visited,
        TableName.jpc: data.jpc,
        TableName.pro: data.pro,
        TableName.workingHrs: data.working_hrs,
        TableName.eff: data.eff,
        TableName.monthlyAttend: data.monthly_attend,
        TableName.monthlyPro: data.monthly_pro,
        TableName.monthlyEff: data.monthly_eff,
        TableName.monthlyIncentives: data.monthly_incentives,
        TableName.monthlyDeduction: data.monthly_deduction,
      };

      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysDashboard, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry sys Dashboard');
      } else {
        print('Dashboard Insertion');
        await db.insert(
          TableName.tblSysDashboard,
          {
            TableName.userId: data.user_id,
            TableName.jpPlanned: data.jp_planned,
            TableName.jpVisited: data.jp_visited,
            TableName.outOfPlanned: data.out_of_planned,
            TableName.outOfPlannedVisited: data.out_of_planned_visited,
            TableName.jpc: data.jpc,
            TableName.pro: data.pro,
            TableName.workingHrs: data.working_hrs,
            TableName.eff: data.eff,
            TableName.monthlyAttend: data.monthly_attend,
            TableName.monthlyPro: data.monthly_pro,
            TableName.monthlyEff: data.monthly_eff,
            TableName.monthlyIncentives: data.monthly_incentives,
            TableName.monthlyDeduction: data.monthly_deduction,
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
        TableName.sysId: data.id,
        TableName.enName: data.en_name.toString(),
        TableName.arName: data.ar_name.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysDailyChecklist, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry DailyCheckList type');
      } else {
        print('Daily CHeck list Insertion');
        await db.insert(
          TableName.tblSysDailyChecklist,
          {
            TableName.sysId: data.id,
            TableName.enName: data.en_name.toString(),
            TableName.arName: data.ar_name.toString(),
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
        TableName.sysId: data.id,
        TableName.enName: data.en_name.toString(),
        TableName.arName: data.ar_name.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysSosUnits, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry sos unit type');
      } else {
        print('SOS Insertion');
        await db.insert(
          TableName.tblSysSosUnits,
          {
            TableName.sysId: data.id,
            TableName.enName: data.en_name.toString(),
            TableName.arName: data.ar_name.toString(),
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
      print('Client Array insertion');
      await db.insert(
        TableName.tblSysClient,
        {
          TableName.clientIds: data.clientId,
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
        TableName.sysId: data.id,
        TableName.enName: data.enName,
        TableName.arName: data.arName,
        TableName.agency_dash_start_date: data.startDate,
        TableName.agency_dash_end_date: data.endDate,
        TableName.agency_dash_icon: data.iconSvg,
        TableName.status: data.status,
        TableName.agency_dash_accessTo: data.accessTo,
        TableName.orderBy: data.orderBy,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysAgencyDashboard, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry drop reason');
      } else {
        print('agency Dashboard insertion');
        await db.insert(
          TableName.tblSysAgencyDashboard,
          {
            TableName.sysId: data.id,
            TableName.enName: data.enName,
            TableName.arName: data.arName,
            TableName.agency_dash_start_date: data.startDate,
            TableName.agency_dash_end_date: data.endDate,
            TableName.agency_dash_icon: data.iconSvg,
            TableName.status: data.status,
            TableName.agency_dash_accessTo: data.accessTo,
            TableName.orderBy: data.orderBy,
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
        TableName.sysId: data.id,
        TableName.enName: data.enName,
        TableName.arName: data.arName,
        TableName.status: data.status,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysDropReason, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry drop reason');
      } else {


        print('Drop Reason insertion');
        await db.insert(
          TableName.tblSysDropReason,
          {
            TableName.sysId: data.id,
            TableName.enName: data.enName,
            TableName.arName: data.arName,
            TableName.status: data.status,
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
        TableName.sysId: data.id,
        TableName.enName: data.enName,
        TableName.arName: data.arName,
        TableName.clientIds: data.clientId,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysBrand, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry sys brand');
      } else {

        print('Brand Array insertion');

        await db.insert(
          TableName.tblSysBrand,
          {
            TableName.sysId: data.id,
            TableName.enName: data.enName,
            TableName.arName: data.arName,
            TableName.clientIds: data.clientId,
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
        TableName.sysId: data.id,
        TableName.enName: data.en_name,
        TableName.arName: data.ar_name,
        TableName.status: data.status,

      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysPlanogramReason, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry sys plano reason');
      } else {

        print('System Plano reason insertion');

        await db.insert(
          TableName.tblSysPlanogramReason,
          {
            TableName.sysId: data.id,
            TableName.enName: data.en_name,
            TableName.arName: data.ar_name,
            TableName.status: data.status,
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
        TableName.sysId: data.id,
        TableName.enName: data.en_name,
        TableName.arName: data.ar_name,
        TableName.sys_rtv_reason_calendar: data.calendar,
        TableName.status: data.status,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysRtvReason, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry RTV reason');
      } else {

        print('RTV Reason insertion');

        await db.insert(
          TableName.tblSysRtvReason,
          {
            TableName.sysId: data.id,
            TableName.enName: data.en_name,
            TableName.arName: data.ar_name,
            TableName.sys_rtv_reason_calendar: data.calendar,
            TableName.status: data.status,
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
        TableName.sysId: data.id,
        TableName.enName: data.en_name,
        TableName.arName: data.ar_name,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysPhototype, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry photo type');
      } else {


        print('Photo Type array insertion');

        await db.insert(
          TableName.tblSysPhototype,
          {
            TableName.sysId: data.id,
            TableName.enName: data.en_name,
            TableName.arName: data.ar_name,
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
        TableName.sysId: data.id,
        TableName.enName: data.en_name,
        TableName.arName: data.ar_name,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysOsdcType, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry osdc type');
      } else {

        print('OSDC TYPE ARRAY insertion');

        await db.insert(
          TableName.tblSysOsdcType,
          {
            TableName.sysId: data.id,
            TableName.enName: data.en_name.toString(),
            TableName.arName: data.ar_name.toString(),
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
        TableName.sysId: data.id,
        TableName.enName: data.en_name.toString(),
        TableName.arName: data.ar_name.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysOsdcReason, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry osdc');
      } else {
        print('OSDC REASON insertion');

        await db.insert(
          TableName.tblSysOsdcReason,
          {
            TableName.sysId: data.id,
            TableName.enName: data.en_name.toString(),
            TableName.arName: data.ar_name.toString(),
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
        TableName.sysId: data.id,
        TableName.clientIds: data.clientId,
        TableName.enName: data.enName,
        TableName.arName: data.arName,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysCategory, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry sys category');
      } else {

        print('Category insertion');

        await db.insert(
          TableName.tblSysCategory,
          {
            TableName.sysId: data.id,
            TableName.clientIds: data.clientId,
            TableName.enName: data.enName,
            TableName.arName: data.arName,
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
        TableName.sysId: data.id,
        TableName.clientIds: data.clientId,
        TableName.enName: data.enName,
        TableName.arName: data.arName,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysSubcategory, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry sys sub category');
      } else {
        print('Sub Category insertion');
        await db.insert(
          TableName.tblSysSubcategory,
          {
            TableName.sysId: data.id,
            TableName.clientIds: data.clientId,
            TableName.enName: data.enName,
            TableName.arName: data.arName,
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
        TableName.sysId: data.id,
        TableName.clientIds: data.client_id,
        TableName.enName: data.en_name,
        TableName.arName: data.ar_name,
        TableName.sys_product_image: data.image,
        TableName.sys_product_principal_id: data.principal_id,
        TableName.sys_product_cluster_id: data.cluster_id,
        TableName.sysCategoryId: data.cat_id,
        TableName.sys_product_sub_cat_id: data.sub_cat_id,
        TableName.brandId: data.brand_id,
        TableName.sys_product_rsp: data.rsp,
        TableName.sys_product_sku_weight: data.sku_weight,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysProduct, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry sys product');
      } else {
        print('Products Array insertion');
        await db.insert(
          TableName.tblSysProduct,
          {
            TableName.sysId: data.id,
            TableName.clientIds: data.client_id,
            TableName.enName: data.en_name,
            TableName.arName: data.ar_name,
            TableName.sys_product_image: data.image,
            TableName.sys_product_principal_id: data.principal_id,
            TableName.sys_product_cluster_id: data.cluster_id,
            TableName.sysCategoryId: data.cat_id,
            TableName.sys_product_sub_cat_id: data.sub_cat_id,
            TableName.brandId: data.brand_id,
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
      print('PoG Arraya');
      print(jsonEncode(data));
      Map<String, dynamic> fields = {
        TableName.storeId: data.storeId,
        TableName.clientIds: data.clientId,
        TableName.sysCategoryId: data.catId.toString(),
        TableName.sys_store_pog: data.pog.toString(),
        TableName.sys_store_pog_image: data.pogImage.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysStorePog, fields);

      if (isDuplicate) {
        print('Error: Duplicate store pog');
      } else {
        await db.insert(
          TableName.tblSysStorePog,
          {
            TableName.storeId: data.storeId,
            TableName.clientIds: data.clientId,
            TableName.sysCategoryId: data.catId.toString(),
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
        TableName.skuId:data.skuId,
        TableName.storeId: data.storeId,
        TableName.sysCategoryId: data.catId.toString(),
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
          db, TableName.tblSysProductPlacement, fields);

      if (isDuplicate) {
        print('Error: Duplicate store pog');
      } else {

        print('Product Placement insertion');
        print(modelList.length);
        await db.insert(
          TableName.tblSysProductPlacement,
          {
            TableName.skuId:data.skuId,
            TableName.storeId: data.storeId,
            TableName.sysCategoryId: data.catId.toString(),
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

    for (SysBrandFacesModel data in modelList) {
      print('Brand Face Array');
      print(jsonEncode(data));
      Map<String, dynamic> fields = {
        TableName.storeId: data.storeId,
        TableName.clientIds:  data.clientId,
        TableName.sysCategoryId: data.catId.toString(),
        TableName.brandId: data.brand_id.toString(),
        TableName.sys_brand_faces_givenFaces: data.given_faces.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysBrandFaces, fields);

      if (isDuplicate) {
        print('Error: Duplicate store Shelf Share');
      } else {
        await db.insert(
          TableName.tblSysBrandFaces,
          {
            TableName.storeId: data.storeId,
            TableName.clientIds:  data.clientId,
            TableName.sysCategoryId: data.catId.toString(),
            TableName.brandId: data.brand_id.toString(),
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
    print('Client insertion');
    await db.insert(
      TableName.tblSysClient,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> insertAgencyDashboard(AgencyDashboardModel dashmodel) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tblSysAgencyDashboard,
      dashmodel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }
  static Future<void> insertDropReason(DropReasonModel model) async {
    var db = await initDataBase();
    await db.insert(
      TableName.tblSysDropReason,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///Insert Trans Before Fixing
  static Future<void> insertBeforeFaxing(TransBeforeFaxingModel beforeFaxing) async {
    var db = await initDataBase();

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //   Get.delete<GeneralChecksStatusController>();
      await db.insert(
        TableName.tblTransBeforeFaxing,
        beforeFaxing.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }
  /// GET Clients List
  static Future<List<ClientModel>> getAllClients() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transSysAppSetting =
    await db.rawQuery('SELECT * FROM sys_client');

    print(jsonEncode(transSysAppSetting));
    print('--------------SYS CLIENTS -----------');

    return List.generate(transSysAppSetting.length, (index) {
      return ClientModel(
        client_id: transSysAppSetting[index][TableName.clientIds] as int,
        client_name: transSysAppSetting[index][TableName.sys_client_name] as String,
      );
    });
  }


  ///Get System Setting Details
  static Future<SysAppSettingModel> getTransSysAppSetting() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transSysAppSetting =
    await db.rawQuery('SELECT * FROM sys_app_setting');

    print(jsonEncode(transSysAppSetting));
    print('--------------SYS APP SETTING -----------');

      return SysAppSettingModel(
          isGeoLocationEnabled: transSysAppSetting[0]['is_geo_location_enabled'] ?? '',
           isBgServices : transSysAppSetting[0]['bg_service'] ?? '',
           isBgMinute : transSysAppSetting[0]['bg_service_minutes'] ?? '',
           isPicklistService: transSysAppSetting[0]['is_picklist_service'] ?? '',
           isPicklistTime: transSysAppSetting[0]['picklist_time'] ?? '',
           isAutoTimeEnabled: transSysAppSetting[0]['is_autotime_enabled'] ?? '',
           isLocationEnabled: transSysAppSetting[0]['is_location_enabled'] ?? '',
           isFakeLocationEnabled: transSysAppSetting[0]['is_fake_gps_check_enabled'] ?? '',
           isVpnEnabled: transSysAppSetting[0]['is_vpn_checked'] ?? '',
      );
  }


// ----********* trans table data insert-----************
  static Future<List<AvailabilityShowModel>> getAvlDataList(String workingId, String clientId, String brandId,String categoryId,String subCategoryId) async {
    final db = await initDataBase();

    // Start building the base query
    String query = 'SELECT trans_availability.*, sys_category.en_name || " " || sys_subcategory.en_name as cat_en_name, sys_category.ar_name || " " || sys_subcategory.ar_name as cat_ar_name, sys_subcategory.en_name as subcat_en_name, sys_subcategory.ar_name as subcat_ar_name, '
        'sys_brand.en_name as brand_en_name, sys_brand.ar_name as brand_ar_name, sys_product.image, sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name '
        'FROM trans_availability '
        'JOIN sys_product ON sys_product.id = trans_availability.sku_id '
        'JOIN sys_category ON sys_category.id = sys_product.category_id '
        'JOIN sys_brand ON sys_brand.id = sys_product.brand_id '
        'JOIN sys_subcategory ON sys_subcategory.id = sys_product.subcategory_id '
        'WHERE working_id = "$workingId" ';

    // List to hold conditions
    List<String> conditions = [];

    // Add conditions based on search parameters
    if (clientId != '-1') {
      conditions.add('trans_availability.client_id = "$clientId"');
    }
    if (brandId != '-1') {
      conditions.add('sys_product.brand_id = "$brandId"');
    }
    if (subCategoryId != '-1') {
      conditions.add('sys_product.subcategory_id = "$subCategoryId"');
    }
    if (categoryId != '-1') {
      conditions.add('sys_product.category_id = "$categoryId"');
    }

    // Join conditions with 'AND' in the query
    if (conditions.isNotEmpty) {
      query += ' AND ' + conditions.join(' AND ');
    }

    query += ' ORDER BY sys_subcategory.en_name,sys_brand.en_name ASC';
    print('AVL');
    print(query);
    final List<Map<String, dynamic>> avlMap = await db.rawQuery(query);
  print(avlMap);
    return List.generate(avlMap.length, (index) {
      return AvailabilityShowModel(
        pro_id: avlMap[index]['sku_id'] as int,
        upload_status: avlMap[index]['upload_status'] ?? 0,
        client_id: avlMap[index]['client_id'] as int,
        cat_en_name: avlMap[index]['cat_en_name'] ?? '',
        cat_ar_name: avlMap[index]['cat_ar_name'] ?? '',
        pro_en_name: avlMap[index]['pro_en_name'] ?? '',
        pro_ar_name: avlMap[index]['pro_ar_name'] ?? '',
        image: avlMap[index]['image'] ?? '',
        avl_status: avlMap[index]['avl_status'] ?? -1,
        actual_picklist: avlMap[index]['actual_picklist'] ?? 0,
        activity_status: avlMap[index]['activity_status'] ?? 0,
        requried_picklist: avlMap[index]['req_picklist'] ?? 0,
        brand_en_name: avlMap[index]['brand_en_name'] ?? '',
        brand_ar_name: avlMap[index]['brand_ar_name'] ?? '',
        picklist_reason: 1,
        picklist_ready: avlMap[index]['picklist_ready'] ?? 0,
        picker_name : avlMap[index]['picker_name'] ?? '',
        pick_upload_status: avlMap[index]['pick_upload_status'],
        pick_list_send_time: avlMap[index]['pick_list_send_time'] ?? '',
        pick_list_receive_time: avlMap[index]['pick_list_receive_time'] ?? ''
      );
    });
  }

  // ----********* trans table data insert-----************
  static Future<List<AvailabilityShowModel>> getSidcoAvlDataList(String workingId, String clientId, String brandId,String categoryId,String subCategoryId) async {
    final db = await initDataBase();

    // Start building the base query
    String query = ' SELECT A.*,CASE WHEN B.required_pieces IS NUll THEN 0 ELSE B.required_pieces END AS req_pick_pieces '
        ' From ( SELECT trans_availability.*, sys_category.en_name || " " || sys_subcategory.en_name as cat_en_name, '
        ' sys_category.ar_name || " " || sys_subcategory.ar_name as cat_ar_name, '
        ' sys_subcategory.en_name as subcat_en_name, sys_subcategory.ar_name as subcat_ar_name, '
        ' sys_brand.en_name as brand_en_name, sys_brand.ar_name as brand_ar_name, sys_product.image, sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name '
        ' FROM trans_availability JOIN sys_product ON sys_product.id = trans_availability.sku_id '
        ' JOIN sys_category ON sys_category.id = sys_product.category_id '
        ' JOIN sys_brand ON sys_brand.id = sys_product.brand_id '
        ' JOIN sys_subcategory ON sys_subcategory.id = sys_product.subcategory_id '
        ' WHERE trans_availability.working_id = "$workingId") A '
        ' LEFT JOIN ( SELECT sku_id,required_pieces '
        ' FROM trans_picklist WHERE working_id = "$workingId") B ON A.sku_id = B.sku_id ';

    // List to hold conditions
    List<String> conditions = [];

    // Add conditions based on search parameters
    if (clientId != '-1') {
      conditions.add('trans_availability.client_id = "$clientId"');
    }
    if (brandId != '-1') {
      conditions.add('sys_product.brand_id = "$brandId"');
    }
    if (subCategoryId != '-1') {
      conditions.add('sys_product.subcategory_id = "$subCategoryId"');
    }
    if (categoryId != '-1') {
      conditions.add('sys_product.category_id = "$categoryId"');
    }

    // Join conditions with 'AND' in the query
    if (conditions.isNotEmpty) {
      query += ' AND ' + conditions.join(' AND ');
    }

    query += ' ORDER BY A.subcat_en_name,A.brand_en_name ASC';
    print('AVL');
    print(query);
    final List<Map<String, dynamic>> avlMap = await db.rawQuery(query);
    print(avlMap);
    return List.generate(avlMap.length, (index) {
      return AvailabilityShowModel(
          pro_id: avlMap[index]['sku_id'] as int,
          upload_status: avlMap[index]['upload_status'] ?? 0,
          client_id: avlMap[index]['client_id'] as int,
          cat_en_name: avlMap[index]['cat_en_name'] ?? '',
          cat_ar_name: avlMap[index]['cat_ar_name'] ?? '',
          pro_en_name: avlMap[index]['pro_en_name'] ?? '',
          pro_ar_name: avlMap[index]['pro_ar_name'] ?? '',
          image: avlMap[index]['image'] ?? '',
          avl_status: avlMap[index]['avl_status'] ?? -1,
          actual_picklist: avlMap[index]['actual_picklist'] ?? 0,
          activity_status: avlMap[index]['activity_status'] ?? 0,
          requried_picklist: int.parse(avlMap[index]['req_pick_pieces'].toString()),
          brand_en_name: avlMap[index]['brand_en_name'] ?? '',
          brand_ar_name: avlMap[index]['brand_ar_name'] ?? '',
          picklist_reason: 1,
          picklist_ready: avlMap[index]['picklist_ready'] ?? 0,
          picker_name : avlMap[index]['picker_name'] ?? '',
          pick_upload_status: avlMap[index]['pick_upload_status'],
          pick_list_send_time: avlMap[index]['pick_list_send_time'] ?? '',
          pick_list_receive_time: avlMap[index]['pick_list_receive_time'] ?? ''
      );
    });
  }


  static Future<List<AvailabilityShowModel>> getActivityStatusAvlDataList(String workingId) async {
    final db = await initDataBase();

    // Start building the base query
    String query = 'SELECT trans_availability.*, sys_category.en_name || " " || sys_subcategory.en_name as cat_en_name, sys_category.ar_name || ' ' || sys_subcategory.ar_name as cat_ar_name, sys_subcategory.en_name as subcat_en_name, sys_subcategory.ar_name as subcat_ar_name, '
        'sys_brand.en_name as brand_en_name, sys_brand.ar_name as brand_ar_name, sys_product.image, sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name '
        'FROM trans_availability '
        'JOIN sys_product ON sys_product.id = trans_availability.sku_id '
        'JOIN sys_category ON sys_category.id = sys_product.category_id '
        'JOIN sys_brand ON sys_brand.id = sys_product.brand_id '
        'JOIN sys_subcategory ON sys_subcategory.id = sys_product.subcategory_id '
        'WHERE working_id = "$workingId" AND activity_status=1';

    print('AVL Activity Status');
    print(query);
    final List<Map<String, dynamic>> avlMap = await db.rawQuery(query);

    return List.generate(avlMap.length, (index) {
      return AvailabilityShowModel(
        pro_id: avlMap[index]['sku_id'] as int,
        upload_status: avlMap[index]['upload_status'] ?? 0,
        client_id: avlMap[index]['client_id'] as int,
        cat_en_name: avlMap[index]['cat_en_name'] ?? '',
        cat_ar_name: avlMap[index]['cat_ar_name'] ?? '',
        pro_en_name: avlMap[index]['pro_en_name'] ?? '',
        pro_ar_name: avlMap[index]['pro_ar_name'] ?? '',
        image: avlMap[index]['image'] ?? '',
        avl_status: avlMap[index]['avl_status'] ?? -1,
        actual_picklist: avlMap[index]['actual_picklist'] ?? 0,
        activity_status: avlMap[index]['activity_status'] ?? 0,
        requried_picklist: avlMap[index]['req_picklist'] ?? 0,
        brand_en_name: avlMap[index]['brand_en_name'] ?? '',
        brand_ar_name: avlMap[index]['brand_ar_name'] ?? '',
        picklist_reason: 1,
        picklist_ready: avlMap[index]['picklist_ready'] ?? 0,
        picker_name : avlMap[index]['picker_name'] ?? '',
        pick_upload_status: avlMap[index]['pick_upload_status'],
        pick_list_send_time: avlMap[index]['pick_list_send_time'] ?? '',
        pick_list_receive_time: avlMap[index]['pick_list_receive_time'] ?? ''
      );
    });
  }


  static Future<List<AvlProductPlacementModel>> getAvlProductPlacement(String skuId,String storeId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> placementMap = await db.rawQuery('SELECT *FROM sys_product_placement'
        ' WHERE sku_id=$skuId and store_id=$storeId');
    print('___  Product Placement Data List _______');
    print(jsonEncode(placementMap));
    return List.generate(placementMap.length, (index) {
      return AvlProductPlacementModel(
        shelfNo: placementMap[index]['shelf_no'].toString() == 'null' ? '0' : placementMap[index]['shelf_no'].toString(),
        buyNo: placementMap[index]['bay_no'].toString() == 'null' ? '0' : placementMap[index]['bay_no'].toString(),
        h_facing: placementMap[index]['h_facings'].toString() == 'null' ? '0' : placementMap[index]['h_facings'].toString(),
        v_facing: placementMap[index]['v_facings'].toString() == 'null' ? '0' : placementMap[index]['v_facings'].toString(),
        d_facing: placementMap[index]['d_facings'].toString() == 'null' ? '0' : placementMap[index]['d_facings'].toString(),
        pog: placementMap[index]['pog'].toString() == 'null' ? '' : placementMap[index]['pog'].toString(),
      );
    });
  }

  static Future<List<TransPlanoGuideModel>> getPlanoGuideDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT trans_planoguide.id as trans_plano_id,trans_planoguide.client_id,sys_category.en_name as cat_en_name,'
        ' trans_planoguide.category_id,trans_planoguide.activity_status,sys_category.ar_name as cat_ar_name,trans_planoguide.pog as pog,trans_planoguide.image_name,trans_planoguide.isAdherence,trans_planoguide.skuImageName,trans_planoguide.upload_status,trans_planoguide.gcs_status '
        ' FROM trans_planoguide'
        ' join sys_category on sys_category.id=trans_planoguide.category_id'
        ' WHERE working_id=$workingId ORDER BY trans_planoguide.category_id,pog ASC';


    final List<Map<String, dynamic>> planoguideMap = await db.rawQuery(rawQuery);
    print('PLANOGUIDE QUERY');
    print(jsonEncode(planoguideMap));

    return List.generate(planoguideMap.length, (index) {
      return TransPlanoGuideModel(
        id: planoguideMap[index]['trans_plano_id'] as int,
        cat_id: planoguideMap[index]['category_id'] as int,
        cat_en_name: planoguideMap[index]['cat_en_name'] ?? '',
        cat_ar_name: planoguideMap[index]['cat_ar_name'] ?? '',
        pog: planoguideMap[index]['pog'] ?? '',
        imageFile: null,
        skuImageName: planoguideMap[index]['skuImageName'] == null || planoguideMap[index]['skuImageName'] == 'null' ? '' : planoguideMap[index]['skuImageName'],
        gcs_status: planoguideMap[index]['gcs_status'],
        upload_status: planoguideMap[index]['upload_status'] ?? 0,
        activity_status: planoguideMap[index]['activity_status'] ?? 0,
        client_id: planoguideMap[index]['client_id'],
        imageName: planoguideMap[index]['image_name'] ?? '',
        isAdherence: planoguideMap[index]['isAdherence'] ?? '-1',

      );
    });
  }

  static Future<List<TransPlanoGuideModel>> getPlanoGuideFilteredDataList(String workingId,int activityStatus,String isAdhere) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT trans_planoguide.id as trans_plano_id,trans_planoguide.client_id,sys_category.en_name as cat_en_name,'
        'trans_planoguide.category_id,trans_planoguide.activity_status,sys_category.ar_name as cat_ar_name,trans_planoguide.pog as pog,trans_planoguide.image_name,trans_planoguide.isAdherence,trans_planoguide.skuImageName,trans_planoguide.upload_status,trans_planoguide.gcs_status '
        ' FROM trans_planoguide'
        ' join sys_category on sys_category.id=trans_planoguide.category_id'
        ' WHERE working_id=$workingId AND activity_status=$activityStatus AND isAdherence=$isAdhere ORDER BY trans_planoguide.category_id,pog ASC';

    print('PLANOGUIDE QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> planoguideMap = await db.rawQuery(rawQuery);

    return List.generate(planoguideMap.length, (index) {
      return TransPlanoGuideModel(
        id: planoguideMap[index]['trans_plano_id'] as int,
        cat_id: planoguideMap[index]['category_id'] as int,
        cat_en_name: planoguideMap[index]['cat_en_name'] ?? '',
        cat_ar_name: planoguideMap[index]['cat_ar_name'] ?? '',
        pog: planoguideMap[index]['pog'] ?? '',
        imageFile: null,
        skuImageName: planoguideMap[index]['skuImageName'] == null || planoguideMap[index]['skuImageName'] == 'null' ? '' : planoguideMap[index]['skuImageName'],
        gcs_status: planoguideMap[index]['gcs_status'],
        upload_status: planoguideMap[index]['upload_status'] ?? 0,
        activity_status: planoguideMap[index]['activity_status'] ?? 0,
        client_id: planoguideMap[index]['client_id'],
        imageName: planoguideMap[index]['image_name'] ?? '',
        isAdherence: planoguideMap[index]['isAdherence'] ?? '-1',

      );
    });
  }

  static Future<List<SavePlanoguideListData>> getActivityStatusPlanoGuideDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT id,client_id,category_id As category_id,pog,isAdherence as is_adh,image_name as image_name '
        ' FROM trans_planoguide WHERE working_id=$workingId AND gcs_status=1 AND activity_status=1 AND upload_status=0';

    print('PLANOGUIDE QUERY');
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

  static Future<List<TransBransShareModel>> getBransSharesDataList(String workingId,String categoryId,String brandId) async {
    final db = await initDataBase();

    String searchWhere = '';

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_brand.id = "$brandId"';
    }

    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_category.id = "$categoryId"';
    }

    final List<Map<String, dynamic>> brandShareMap = await db.rawQuery('SELECT trans_brand_share.client_id,trans_brand_share.id as trans_brand_shares_id,'
        ' trans_brand_share.category_id as cat_id,trans_brand_share.brand_id ,sys_category.en_name as cat_en_name,sys_category.ar_name as cat_ar_name,sys_brand.ar_name as brand_ar_name,sys_brand.en_name as brand_en_name,trans_brand_share.given_faces,trans_brand_share.upload_status,'
        ' trans_brand_share.actual_faces,trans_brand_share.activity_status FROM trans_brand_share'
        ' join sys_category on sys_category.id=trans_brand_share.category_id'
        ' join sys_brand on sys_brand.id=trans_brand_share.brand_id'
        ' WHERE working_id=$workingId $searchWhere ORDER BY category_id,brand_en_name ASC');


    return List.generate(brandShareMap.length, (index) {
      return TransBransShareModel(
        id: brandShareMap[index]['trans_brand_shares_id'] as int,
        cat_id: brandShareMap[index]['cat_id'] as int,
        brand_id: brandShareMap[index]['brand_id'] as int,
        cat_en_name: brandShareMap[index]['cat_en_name'] ?? '',
        cat_ar_name: brandShareMap[index]['cat_ar_name'] ?? '',
        brand_en_name: brandShareMap[index]['brand_en_name'] ?? '',
        brand_ar_name: brandShareMap[index]['brand_ar_name'] ?? '',
        given_faces: brandShareMap[index]['given_faces'] ?? '',
        actual_faces: brandShareMap[index]['actual_faces'] ?? '',
        upload_status: brandShareMap[index]['upload_status'] ?? 0,
        activity_status: brandShareMap[index]['activity_status'] ?? 0,
        client_id: brandShareMap[index]['client_id'] ?? -1,
      );
    });
  }

  static Future<List<TransBransShareModel>> getBransSharesFilteredDataList(String workingId,int activityStatus,String categoryId,String brandId) async {
    final db = await initDataBase();

    String searchWhere = '';

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_brand.id = "$brandId"';
    }

    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_category.id = "$categoryId"';
    }

    final List<Map<String, dynamic>> brandShareMap = await db.rawQuery('SELECT trans_brand_share.client_id,trans_brand_share.id as trans_brand_shares_id,'
        'trans_brand_share.category_id as cat_id,trans_brand_share.brand_id ,sys_category.en_name as cat_en_name,sys_category.ar_name as cat_ar_name,sys_brand.ar_name as brand_ar_name,sys_brand.en_name as brand_en_name,trans_brand_share.given_faces,trans_brand_share.upload_status,'
        ' trans_brand_share.actual_faces,trans_brand_share.activity_status FROM trans_brand_share'
        ' join sys_category on sys_category.id=trans_brand_share.category_id'
        ' join sys_brand on sys_brand.id=trans_brand_share.brand_id'
        ' WHERE working_id=$workingId AND activity_status=$activityStatus $searchWhere ORDER BY category_id,brand_en_name ASC');


    return List.generate(brandShareMap.length, (index) {
      return TransBransShareModel(
        id: brandShareMap[index]['trans_brand_shares_id'] as int,
        cat_id: brandShareMap[index]['cat_id'] as int,
        brand_id: brandShareMap[index]['brand_id'] as int,
        cat_en_name: brandShareMap[index]['cat_en_name'] ?? '',
        cat_ar_name: brandShareMap[index]['cat_ar_name'] ?? '',
        brand_en_name: brandShareMap[index]['brand_en_name'] ?? '',
        brand_ar_name: brandShareMap[index]['brand_ar_name'] ?? '',
        given_faces: brandShareMap[index]['given_faces'] ?? '',
        actual_faces: brandShareMap[index]['actual_faces'] ?? '',
        upload_status: brandShareMap[index]['upload_status'] ?? 0,
        activity_status: brandShareMap[index]['activity_status'] ?? 0,
        client_id: brandShareMap[index]['client_id'] ?? -1,
      );
    });
  }

  static Future<List<SaveBrandShareListData>> getActivityStatusBrandSharesDataList(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> brandShareMap = await db.rawQuery('SELECT id,client_id,category_id,brand_id,given_faces,actual_faces '
        ' FROM trans_brand_share WHERE working_id=$workingId AND activity_status=1 AND upload_status=0');


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
        await db.rawQuery('SELECT *from ${TableName.tblSysAgencyDashboard} ORDER BY order_by ASC');
    print(agencyDashboard);
    return List.generate(agencyDashboard.length, (index) {
      return AgencyDashboardModel.fromJson(agencyDashboard[index]);
    });
  }

  static Future<List<GetTransPhotoModel>> getTransPhoto(String workingId) async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transphoto =
    await db.rawQuery(
        'SELECT  trans_photo.*,sys_client.client_name ,sys_category.en_name as cat_en_name ,sys_category.ar_name as cat_ar_name ,sys_photo_type.en_name as type_en_name,sys_photo_type.ar_name as type_ar_name '
            ' FROM trans_photo '
            ' JOIN sys_client on sys_client.client_id=trans_photo.client_id '
            ' JOIN sys_category on sys_category.id=trans_photo.category_id '
            ' JOIN sys_photo_type on sys_photo_type.id=trans_photo.type_id '
            'WHERE trans_photo.photo_type_id=1 AND working_id=$workingId ORDER BY sys_category.en_name,sys_photo_type.en_name ASC');

    print(jsonEncode(transphoto));
    print('Trans Photo List');
    return List.generate(transphoto.length, (index) {
      return GetTransPhotoModel(
        trans_photo_type_id: transphoto[index]['id'],
        dateTime: transphoto[index]['date_time']??'',
        clientName: transphoto[index][TableName.sys_client_name] as String,
        img_name: transphoto[index][TableName.imageName] as String,
        imageFile: null,
        cat_id: transphoto[index]['category_id'] as int,
        client_id: transphoto[index]['client_id'] as int,
        type_id: transphoto[index]['type_id'] as int,
        categoryArName: transphoto[index]['cat_ar_name'] as String,
        categoryEnName: transphoto[index]['cat_en_name'] as String,
        gcs_status: transphoto[index][TableName.gcsStatus] as int,
        type_ar_name: transphoto[index]['type_ar_name'] as String,
        type_en_name: transphoto[index]['type_en_name'] as String,
        upload_status: transphoto[index]['upload_status'] as int,
      );
    });
  }

  ///Other Photo count for API
  static Future<OtherPhotoCountModel> getOtherPhotoCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT count(id) AS total_photo_items, '
        'COUNT(DISTINCT category_id) as total_categories, '
        'sum(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        'sum(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        'FROM trans_photo WHERE working_id=$workingId'));
    print(jsonEncode(result));
    print('____________Other Photo Cont_______________');
    return  OtherPhotoCountModel(
      totalOtherPhotos: result[0]['total_photo_items'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
      totalCategories: result[0]['total_categories'] ?? 0,
    );
  }

  ///Other Photo List For GCS Upload
  static Future<List<TransPlanoGuideGcsImagesListModel>> getOtherPhotoGcsImagesList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT id, image_name'
        ' FROM trans_photo WHERE working_id=$workingId AND gcs_status=0';

    print('Other Photo QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> otherPhotoMap = await db.rawQuery(rawQuery);
    print(otherPhotoMap);
    print('Other Photo Images List');
    return List.generate(otherPhotoMap.length, (index) {
      return TransPlanoGuideGcsImagesListModel(
          id: otherPhotoMap[index]['id'],
          imageName: otherPhotoMap[index]['image_name'],
          imageFile: null
      );
    });
  }

  static Future<int> updateOtherPhotoAfterGcsImageUpload(String workingId,String promoId) async {
    String writeQuery = 'UPDATE trans_photo SET gcs_status=1 WHERE working_id=$workingId AND id = $promoId';

    var db = await initDataBase();
    print('_______________UpdATE GCS Other Photo________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<List<SaveOtherPhotoData>> getOtherPhotoApiUploadDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT id,client_id,category_id,type_id, image_name '
        ' FROM trans_photo WHERE working_id=$workingId AND upload_status=0';

    print('Other Photo QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> beforeFixingMap = await db.rawQuery(rawQuery);
    print(beforeFixingMap);
    return List.generate(beforeFixingMap.length, (index) {
      return SaveOtherPhotoData(
          transPhotoId: beforeFixingMap[index]['id'],
          typeId: beforeFixingMap[index]['type_id'],
          categoryId: beforeFixingMap[index]['category_id'],
          clientId: beforeFixingMap[index]['client_id'],
          imageName: beforeFixingMap[index]['image_name']
      );
    });
  }

  static Future<int> updateOtherPhotoAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_photo SET upload_status=1 WHERE working_id=$workingId AND id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE Before Fixing________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }


  static Future<List<GetTransOSDCModel>> getTransOSDC(String workingId) async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transOsdc =
    await db.rawQuery(
        'SELECT trans_osdc.id as osdc_id,trans_osdc.working_id as working_id,trans_osdc.gcs_status,trans_osdc.upload_status,trans_osdc.quantity,sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,'
        'sys_osdc_reason.en_name as reason_en_name,sys_osdc_reason.ar_name as reason_ar_name,sys_osdc_reason.ar_name as osdc_ar_name,sys_osdc_type.en_name as type_en_name,sys_osdc_type.ar_name as type_ar_name '
       ' FROM trans_osdc '
    'JOIN sys_brand on sys_brand.id=trans_osdc.brand_id '
    'JOIN sys_osdc_reason on sys_osdc_reason.id=trans_osdc.reason_id '
    'JOIN sys_osdc_type on sys_osdc_type.id=trans_osdc.type_id WHERE trans_osdc.working_id=$workingId');

    print(jsonEncode(transOsdc));
    print('--------------OSDC SHOW-----------');

    return List.generate(transOsdc.length, (index) {

      return GetTransOSDCModel(
        id: transOsdc[index]['osdc_id'] as int,
        quantity: transOsdc[index]['quantity'] as int,
        img_name: '',
        imageFile: [],
        gcs_status: transOsdc[index]['gcs_status'] as int,
        upload_status: transOsdc[index]['upload_status'] as int,
        brand_en_name: transOsdc[index]['brand_en_name'] as String,
        brand_ar_name: transOsdc[index]['brand_ar_name'] as String,
        type_ar_name: transOsdc[index]['type_ar_name'] as String,
        type_en_name: transOsdc[index]['type_en_name'] as String,
        reason_ar_name: transOsdc[index]['reason_ar_name'] as String,
        reason_en_name: transOsdc[index]['reason_en_name'] as String,
      );
    });
  }

  static Future<List<GetTransImagesOSDCModel>> getTransOSDCImages(String workingId) async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transImageOsdc =
    await db.rawQuery('SELECT * FROM trans_osdc_images WHERE working_id=$workingId');

    print(jsonEncode(transImageOsdc));
    print('--------------OSDC IMAGE SHOW-----------');

    return List.generate(transImageOsdc.length, (index) {
      return GetTransImagesOSDCModel(
        id: transImageOsdc[index][TableName.trans_osdc_main_id],
        imgName: transImageOsdc[index][TableName.imageName],
      );
    });
  }

  ///Get OSD COUNT RECORDS FOR API UPLOAD
  static Future<OsdAndMarketIssueCountModel> getOsdCountDataServices(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT COUNT(id) as total_osd_pro, '
        ' SUM(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        ' SUM(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        ' FROM trans_osdc '
        ' WHERE working_id=$workingId '));

    print(jsonEncode(result));
    print('____________OSD Count_______________');
    return  OsdAndMarketIssueCountModel(
      totalItems: result[0]['total_osd_pro'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
    );
  }

  static Future<List<TransPlanoGuideGcsImagesListModel>> getOsdcGcsImagesList(String workingId) async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transImageOsdc =
    await db.rawQuery('SELECT * FROM trans_osdc_images '
        ' JOIN trans_osdc ON trans_osdc.id = trans_osdc_images.osd_main_id '
        ' WHERE trans_osdc.working_id=$workingId AND gcs_status=0');

    print(jsonEncode(transImageOsdc));
    print('--------------OSDC IMAGE List-----------');

    return List.generate(transImageOsdc.length, (index) {
      return TransPlanoGuideGcsImagesListModel(
        id: transImageOsdc[index][TableName.trans_osdc_main_id],
        imageName: transImageOsdc[index][TableName.imageName],
        imageFile: null
      );
    });
  }

  static Future<List<SaveOsdListData>> getOsdDataListForApi(String workingId) async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transImageOsdc =
    await db.rawQuery('SELECT trans_osdc.*, sys_brand.client_id as brand_client_id FROM trans_osdc '
        ' JOIN sys_brand on sys_brand.id = trans_osdc.brand_id'
        ' WHERE working_id=$workingId AND upload_status=0');

    print(jsonEncode(transImageOsdc));
    print('--------------OSDC Data List-----------');

    return List.generate(transImageOsdc.length, (index)  {
      return SaveOsdListData(
          id: transImageOsdc[index][TableName.sysId],
          clientId: transImageOsdc[index]['brand_client_id'].toString(),
          brandId: transImageOsdc[index][TableName.brandId],
          typeId: transImageOsdc[index][TableName.type_id],
          reasonId: transImageOsdc[index][TableName.trans_osdc_reason_id],
          quantity: transImageOsdc[index][TableName.trans_osdc_quantity],
          osdImagesList: [],
      );
    });
  }

  static Future<List<SaveOsdImageNameListData>> getOsdDataImagesListForApi(String workingId,int osdMainId) async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transImageOsdc =
    await db.rawQuery('SELECT * FROM trans_osdc_images '
        ' WHERE working_id=$workingId AND osd_main_id = $osdMainId ');

    print(jsonEncode(transImageOsdc));
    print('--------------OSDC Images Data List-----------');

    return List.generate(transImageOsdc.length, (index) {
      return SaveOsdImageNameListData(
        id: transImageOsdc[index][TableName.trans_osdc_main_id],
        imageName: transImageOsdc[index][TableName.imageName],
      );
    });
  }

  ///Update OSD GCS status after images upload
  static Future<int> updateOsdAfterGcsImageUpload(String workingId,String promoId) async {
    String writeQuery = 'UPDATE trans_osdc SET gcs_status=1 WHERE working_id=$workingId AND id = $promoId';

    var db = await initDataBase();
    print('_______________UpdATE GCS OSDC________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  /// Update OSD After API
  static Future<int> updateOsdAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_osdc SET upload_status=1 WHERE working_id=$workingId AND id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE OSDC________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<List<DropReasonModel>> getDropReason() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> dropreason =
        await db.rawQuery('SELECT *from ${TableName.tblSysDropReason}');
    return List.generate(dropreason.length, (index) {
      return DropReasonModel(
        id: dropreason[index][TableName.sysId] as int,
        en_name: dropreason[index][TableName.enName] as String,
        ar_name: dropreason[index][TableName.arName] as String,
        status: dropreason[index][TableName.status] as int,
      );
    });
  }

  Future<bool> checkDataExists(Database database) async {
    List<Map<String, dynamic>> result = await database
        .rawQuery('SELECT * FROM ${TableName.tblSysDropReason}');
    return result.isNotEmpty;
  }

  static Future<List<PlanogramReasonModel>> getPlanogramReason() async {
    final db = await initDataBase();
    print('____________REASON LIST_____________');
    final List<Map<String, dynamic>> planogram_reason = await db
        .rawQuery('SELECT * FROM ${TableName.tblSysPlanogramReason}');

    print(jsonEncode(planogram_reason));
    return List.generate(planogram_reason.length, (index) {
      return PlanogramReasonModel(
        en_name: planogram_reason[index][TableName.enName]
            as String,
        ar_name: planogram_reason[index][TableName.arName]
            as String,
        id: planogram_reason[index][TableName.sysId] as int,
        status: planogram_reason[index][TableName.status] as int,
      );
    });
  }

  static Future<List<ShowPlanogramModel>> getTransPlanogram(String workingId) async {
    print('__________________TransPlanogram__________________');

    final db = await initDataBase();
    final List<Map<String, dynamic>> planogram = await db.rawQuery(
        'SELECT trans_planogram.id,trans_planogram.client_id,trans_planogram.date_time,trans_planogram.category_id,trans_planogram.brand_id,trans_planogram.reason_id,trans_planogram.gcs_status,trans_planogram.upload_status,sys_client.client_name,sys_category.en_name as cat_en_name,sys_category.ar_name as cat_ar_name, sys_brand.en_name as brand_en_name, sys_brand.ar_name as brand_ar_name,is_adherence,image_name, '
            'CASE WHEN sys_planogram_reason.id >0 then sys_planogram_reason.en_name  else 0 END as not_adh_en_reason, '
            'CASE WHEN sys_planogram_reason.id >0 then sys_planogram_reason.ar_name  else 0 END as not_adh_ar_reason '
            'FROM trans_planogram '
            'JOIN sys_client on sys_client.client_id=trans_planogram.client_id '
            'JOIN sys_category on sys_category.id=trans_planogram.category_id '
            'LEFT JOIN sys_brand on sys_brand.id=trans_planogram.brand_id '
            'LEFT JOIN sys_planogram_reason on sys_planogram_reason.id=trans_planogram.reason_id '
            'WHERE trans_planogram.working_id=$workingId ORDER BY sys_category.en_name,sys_brand.en_name ASC');
    print(jsonEncode(planogram));

    return List.generate(planogram.length, (index) {
      return ShowPlanogramModel(
        id:planogram[index]['id'] as int,
        dateTime:planogram[index]['date_time'] ?? '',
        client_id: planogram[index]['client_id'] as int,
        cat_id: planogram[index]['category_id'] as int,
        reason_id: planogram[index]['reason_id'] as int,
        brand_id: planogram[index]['brand_id'] as int,
        client_name: planogram[index][TableName.sys_client_name] as String,
        cat_en_name:planogram[index]['cat_en_name'] as String,
        cat_ar_name:planogram[index]['cat_ar_name'] as String,
        brand_en_name:planogram[index]['brand_en_name'] ?? '',
        brand_ar_name:planogram[index]['brand_ar_name'] ?? '',
        is_adherence:planogram[index]['is_adherence'].toString(),
        image_name:planogram[index]['image_name'] as String,
        imageFile: null,
        not_en_adherence_reason:planogram[index]['not_adh_en_reason'].toString(),
        not_ar_adherence_reason:planogram[index]['not_adh_ar_reason'].toString(),
        gcs_status:planogram[index]['gcs_status'] as int,
        upload_status:planogram[index]['upload_status'] as int,


      );
    });
  }

  ///Trans Planogram count for API
  static Future<PlanogramCountModel> getTransPlanogramCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT count(id) AS total_palnogram_items, '
        'COUNT(DISTINCT category_id) as total_categories, '
        'SUM(CASE WHEN is_adherence = 1 THEN 1 ELSE 0 END) AS total_adhere, '
        'SUM(CASE WHEN is_adherence = 0 THEN 1 ELSE 0 END) AS total_not_adhere, '
        'sum(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        'sum(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        'FROM trans_planogram WHERE working_id=$workingId'));
    print(jsonEncode(result));
    print('____________Planogram Count_______________');
    return  PlanogramCountModel(
      totalPlanogramItems: result[0]['total_palnogram_items'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
      totalAdhere: result[0]['total_adhere'] ?? 0,
      totalNotAdhere: result[0]['total_not_adhere'] ?? 0,
    );
  }

  ///Trans Planogram Image List For GCS Upload
  static Future<List<TransPlanoGuideGcsImagesListModel>> getTransPlanogramGcsImagesList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT id, image_name'
        ' FROM trans_planogram WHERE working_id=$workingId AND gcs_status=0';

    print('Planogram QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(rawQuery);
    print(rtvMap);
    print('Trans planogram Images List');
    return List.generate(rtvMap.length, (index) {
      return TransPlanoGuideGcsImagesListModel(
          id: rtvMap[index]['id'],
          imageName: rtvMap[index]['image_name'],
          imageFile: null
      );
    });
  }

  static Future<int> updateTransPlanogramAfterGcsImageUpload(String workingId,String promoId) async {
    String writeQuery = 'UPDATE trans_planogram SET gcs_status=1 WHERE working_id=$workingId AND id = $promoId';

    var db = await initDataBase();
    print('_______________UpdATE GCS Trans Planogram________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<List<SavePlanogramPhotoData>> getTransPlanogramApiUploadDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT id,is_adherence,reason_id,brand_id,category_id As category_id, image_name,client_id '
        ' FROM trans_planogram WHERE working_id=$workingId AND upload_status=0';

    print('Trans Planogram QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> planogramMap = await db.rawQuery(rawQuery);
    print(planogramMap);
    return List.generate(planogramMap.length, (index) {
      return SavePlanogramPhotoData(
          id: planogramMap[index]['id'],
          isAdherence: planogramMap[index]['is_adherence'].toString(),
          reasonId: planogramMap[index]['reason_id'],
          brandId: planogramMap[index]['brand_id'],
          categoryId: planogramMap[index]['category_id'],
          clientId: planogramMap[index]['client_id'],
          imageName: planogramMap[index]['image_name']
      );
    });
  }

  static Future<int> updateTransPlanogramAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_planogram SET upload_status=1 WHERE working_id=$workingId AND id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE Trans Planogram________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }


  static Future<bool> dataExists(int id) async {
    var db = await initDataBase();

    var res = await db.rawQuery('SELECT * FROM trans_availability WHERE sku_id=$id');
    return res.isNotEmpty;
  }

  static Future<List<RTVShowModel>> getRTVDataList(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> rtvMap = await db.rawQuery('SELECT sys_product.id as pro_id,sys_product.en_name as pro_en_name,'
        ' sys_product.ar_name as pro_ar_name,sys_category.en_name as cat_en_name,sys_category.ar_name as cat_ar_name, '
        ' sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,sys_product.image,sys_product.rsp,'
        ' CASE WHEN trans_rtv.sku_id IS NULL then 0 ELSE trans_rtv.sku_id END as rtv_taken'
        ' from sys_product'
        ' JOIN sys_category on sys_category.id=sys_product.category_id'
        ' JOIN sys_brand on sys_brand.id=sys_product.brand_id'
        ' left join trans_rtv on trans_rtv.sku_id = sys_product.id'
        ' WHERE sys_product.client_id IN(1,2,3) AND sys_product.id NOT IN(1,2,3)'
        ' group BY sys_product.id');

    print(jsonEncode(rtvMap.length));
    print('___RTV Data List _______');
    return List.generate(rtvMap.length, (index) {
      return RTVShowModel(
        pro_id: rtvMap[index]['pro_id'] as int,
        cat_en_name: rtvMap[index]['cat_en_name'] ?? '',
        cat_ar_name: rtvMap[index]['cat_ar_name'] ?? '',
        pro_en_name: rtvMap[index]['pro_en_name'] ?? '',
        pro_ar_name: rtvMap[index]['pro_ar_name'] ?? '',
        img_name: rtvMap[index]['image'] ?? '',
        rsp: rtvMap[index]['rsp'] ?? '',
        brand_en_name: rtvMap[index]['brand_en_name'] ?? '',
        brand_ar_name: rtvMap[index]['brand_ar_name'] ?? '',
        rtv_taken: rtvMap[index]['rtv_taken'] ?? '',
        imageFile: null,
        pieces: rtvMap[index]['pieces'] ?? 0
      , act_status: rtvMap[index]['act_status'] ?? '');
    });
  }

  static Future<List<ShowTransRTVShowModel>> getTransRTVDataList(String workingId,String clienId) async {
    final db = await initDataBase();

    String query = 'SELECT trans_rtv.id as trans_id,sys_product.en_name as pro_en_name,trans_rtv.date_time,trans_rtv.gcs_status,trans_rtv.upload_status, sys_product.ar_name as pro_ar_name,trans_rtv.image_name as rtv_image_name,trans_rtv.date_time as dateTime,trans_rtv.expire_date,trans_rtv.pieces, trans_rtv.sku_id,sys_product.image as pro_image,sys_rtv_reason.en_name as reason_en_name,sys_rtv_reason.ar_name as reason_ar_name '
        'from trans_rtv '
        'JOIN sys_rtv_reason on sys_rtv_reason.id= trans_rtv.reason '
        'Join sys_product on sys_product.id  = trans_rtv.sku_id '
        'WHERE working_id=$workingId ORDER BY date_time DESC ';

    print(query);

    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(query);


    print(jsonEncode(rtvMap.length));
    print('___RTV Data List _______');
    return List.generate(rtvMap.length, (index) {
      return ShowTransRTVShowModel(
        id: rtvMap[index]['trans_id'] as int,
        reason_en_name: rtvMap[index]['reason_en_name'] ?? '',
        reason_ar_name: rtvMap[index]['reason_ar_name'] ?? '',
        pro_en_name: rtvMap[index]['pro_en_name'] ?? '',
        pro_ar_name: rtvMap[index]['pro_ar_name'] ?? '',
        rtv_image: rtvMap[index]['rtv_image_name'] ?? '',
        pro_image: rtvMap[index]['pro_image'] ?? '',
        pieces: rtvMap[index]['pieces'] as int,
        upload_status: rtvMap[index]['upload_status'] as int,
        gcs_status: rtvMap[index]['gcs_status'] as int,
        sku_id: rtvMap[index]['sku_id'] as int,
        exp_date: rtvMap[index]['expire_date'] ?? '',
        dateTime: rtvMap[index]['dateTime'] ?? '',
        imageFile: null,
      );
    });
  }

  static Future<List<ShowTransSOSModel>> getTransSOS(String workingId) async {
    print('__________________TransSOS__________________');

    final db = await initDataBase();
    final List<Map<String, dynamic>> sos = await db.rawQuery(
        'SELECT trans_sos.id,sys_client.client_name,sys_category.en_name as cat_en_name,sys_category.ar_name as cat_ar_name, sys_brand.en_name as brand_en_name, sys_brand.ar_name as brand_ar_name,trans_sos.unit,trans_sos.cat_space as total_space,trans_sos.actual_space,sys_sos_units.en_name as unit_en_name,sys_sos_units.ar_name as unit_ar_name,upload_status '
            ' FROM trans_sos '
            'JOIN sys_client on sys_client.client_id=trans_sos.client_id '
            'JOIN sys_category on sys_category.id=trans_sos.category_id '
            'JOIN sys_sos_units on sys_sos_units.id=trans_sos.unit '
            'LEFT JOIN sys_brand on sys_brand.id=trans_sos.brand_id '
            'WHERE trans_sos.working_id=$workingId ORDER BY sys_category.en_name,sys_brand.en_name ASC');
    print(jsonEncode(sos));

    return List.generate(sos.length, (index) {
      return ShowTransSOSModel(
        id:sos[index]['id'] as int,
        client_name: sos[index][TableName.sys_client_name] as String,
        cat_en_name:sos[index]['cat_en_name'] as String,
        cat_ar_name:sos[index]['cat_ar_name'] as String,
        brand_en_name:sos[index]['brand_en_name'] ?? '---',
        brand_ar_name:sos[index]['brand_ar_name'] ?? '---',
        total_cat_space:sos[index]['total_space'] as String,
        actual_space:sos[index]['actual_space'] as String,
        unitEnName:sos[index]['unit_en_name'].toString(),
        unitArName:sos[index]['unit_ar_name'].toString(),
        uploadStatus: sos[index]['upload_status'],
      );
    });
  }

  ///Trans Share of Shelf count for API
  static Future<SosCountModel> getSosCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT count(id) AS total_sos_items, '
        'COUNT(DISTINCT category_id) as total_categories, '
        'sum(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        'sum(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        'FROM trans_sos WHERE working_id=$workingId'));
    print(jsonEncode(result));
    print('____________SoS Cont_______________');
    return  SosCountModel(
      totalSosItems: result[0]['total_sos_items'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
      totalCategories: result[0]['total_categories'] ?? 0,
    );
  }

  static Future<List<SaveSosData>> getSosApiUploadDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT id, client_id, category_id As category_id, brand_id ,unit,cat_space ,actual_space '
        ' FROM trans_sos WHERE working_id=$workingId AND upload_status=0';

    print('SOS QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> beforeFixingMap = await db.rawQuery(rawQuery);
    print(beforeFixingMap);
    return List.generate(beforeFixingMap.length, (index) {
      return SaveSosData(
          id: beforeFixingMap[index]['id'],
          categoryId: beforeFixingMap[index]['category_id'],
          clientId: beforeFixingMap[index]['client_id'],
          brandId: beforeFixingMap[index]['brand_id'],
          catSpace: beforeFixingMap[index]['cat_space'].toString(),
          actualSpace: beforeFixingMap[index]['actual_space'].toString(),
          unit: beforeFixingMap[index]['unit'].toString(),
      );
    });
  }

  static Future<int> updateSosAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_sos SET upload_status=1 WHERE working_id=$workingId AND id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE SOS ________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<List<GetTransBeforeFixing>> getTransBeforeFixing(String workingId) async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> transbefore =
    await db.rawQuery(
        'SELECT  trans_before_fixing.id ,sys_client.client_name ,sys_category.en_name ,sys_category.ar_name,sys_category.id as cat_id,sys_category.client_id,'
            ' trans_before_fixing.gcs_status,trans_before_fixing.upload_status,trans_before_fixing.photo_type_id,trans_before_fixing.date_time ,trans_before_fixing.image_name FROM trans_before_fixing '
            'JOIN sys_client on sys_client.client_id=trans_before_fixing.client_id '
            'JOIN sys_category on sys_category.id=trans_before_fixing.category_id '
            'WHERE trans_before_fixing.photo_type_id=1 AND trans_before_fixing.working_id=$workingId ORDER BY sys_category.en_name ASC');

    return List.generate(transbefore.length, (index) {
      // print(transphoto[index]['id']);
      print(transbefore[index]);
      return GetTransBeforeFixing(
          id: transbefore[index]['id'],
          dateTime: transbefore[index]['date_time'] ?? '',
          trans_photo_type_id: transbefore[index]['photo_type_id'],
          clientName: transbefore[index][TableName.sys_client_name] as String,
          img_name: transbefore[index][TableName.imageName] as String,
          imageFile: null,
          client_id: transbefore[index][TableName.clientIds],
          cat_id: transbefore[index]['cat_id'],
          categoryArName: transbefore[index][TableName.arName] as String,
          categoryEnName: transbefore[index][TableName.enName] as String,
          gcs_status: transbefore[index][TableName.gcsStatus] as int,
          upload_status: transbefore[index][TableName.uploadStatus] as int
      );
    });
  }

///Before Fixing count for API
  static Future<BeforeFixingCountModel> getBeforeFixingCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT count(id) AS total_before_fixing, '
        'COUNT(DISTINCT category_id) as total_categories, '
        'sum(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        'sum(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        'FROM trans_before_fixing WHERE working_id=$workingId'));
    print(jsonEncode(result));
    print('____________Before Share Count_______________');
    return  BeforeFixingCountModel(
      totalBeforeFixing: result[0]['total_before_fixing'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
      totalCategories: result[0]['total_categories'] ?? 0,
    );
  }

  ///Before Fixing Image List For GCS Upload
  static Future<List<TransPlanoGuideGcsImagesListModel>> geBeforeFixingGcsImagesList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT id, image_name'
        ' FROM trans_before_fixing WHERE working_id=$workingId AND gcs_status=0';

    print('Before Fixing QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(rawQuery);
    print(rtvMap);
    print('Promo Plan Images List');
    return List.generate(rtvMap.length, (index) {
      return TransPlanoGuideGcsImagesListModel(
          id: rtvMap[index]['id'],
          imageName: rtvMap[index]['image_name'],
          imageFile: null
      );
    });
  }

  static Future<int> updateBeforeFixingAfterGcsImageUpload(String workingId,String promoId) async {
    String writeQuery = 'UPDATE trans_before_fixing SET gcs_status=1 WHERE working_id=$workingId AND id = $promoId';

    var db = await initDataBase();
    print('_______________UpdATE GCS Before Fixing________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<List<SaveOtherPhotoData>> getBeforeFixingApiUploadDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT id,client_id,category_id As category_id,photo_type_id, image_name '
        ' FROM trans_before_fixing WHERE working_id=$workingId AND upload_status=0';

    print('Before Fixing QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> beforeFixingMap = await db.rawQuery(rawQuery);
    print(beforeFixingMap);
    return List.generate(beforeFixingMap.length, (index) {
      return SaveOtherPhotoData(
        transPhotoId: beforeFixingMap[index]['id'],
        typeId: beforeFixingMap[index]['photo_type_id'],
        categoryId: beforeFixingMap[index]['category_id'],
        clientId: beforeFixingMap[index]['client_id'],
          imageName: beforeFixingMap[index]['image_name']
      );
    });
  }

  static Future<int> updateBeforeFixingAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_before_fixing SET upload_status=1 WHERE working_id=$workingId AND id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE Before Fixing________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  // ----********* Update Data-----************
  static Future<List<AvailabilityShowModel>> getUpdateAvlDataList(String workingId) async {
    final db = await initDataBase();

    String query = 'SELECT trans_availability.*, sys_category.en_name || " " || sys_subcategory.en_name as cat_en_name, sys_category.ar_name || " " || sys_subcategory.ar_name as cat_ar_name, sys_subcategory.en_name as subcat_en_name, sys_subcategory.ar_name as subcat_ar_name, '
        'sys_brand.en_name as brand_en_name, sys_brand.ar_name as brand_ar_name, sys_product.image, sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name '
        'FROM trans_availability '
        'JOIN sys_product ON sys_product.id = trans_availability.sku_id '
        'JOIN sys_category ON sys_category.id = sys_product.category_id '
        'JOIN sys_brand ON sys_brand.id = sys_product.brand_id '
        'JOIN sys_subcategory ON sys_subcategory.id = sys_product.subcategory_id '
        'WHERE working_id = "$workingId" AND req_picklist>0';
    final List<Map<String, dynamic>> avlMap = await db.rawQuery(query);
    print(jsonEncode(avlMap.length));
    print(query);
    print('___Update AVL Data List _______');

    return List.generate(avlMap.length, (index) {
      return AvailabilityShowModel(
        pro_id: avlMap[index]['sku_id'] as int,
        client_id: avlMap[index]['client_id'] as int,
        cat_en_name: avlMap[index]['cat_en_name'] ?? '',
        cat_ar_name: avlMap[index]['cat_ar_name'] ?? '',
        pro_en_name: avlMap[index]['pro_en_name'] ?? '',
        pro_ar_name: avlMap[index]['pro_ar_name'] ?? '',
        image: avlMap[index]['image'] ?? '',
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
        pick_list_send_time: avlMap[index]['pick_list_send_time'] ?? '',
        pick_list_receive_time: avlMap[index]['pick_list_receive_time'] ?? ''
      );
    });
  }
  static Future<int> updateTransAVLAfterUpdate(String workingId,String skuId) async {
    String writeQuery = 'UPDATE trans_availability SET upload_status=1 WHERE working_id=$workingId AND sku_id in ($skuId)';

    var db = await initDataBase();
    // final Map<String, dynamic> arguments = transAvlModelItem.toMap();
    // print(jsonEncode(arguments));
    print('_______________UpdATE________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateTransAVLAfterPickListUpdate(String workingId,String skuId,String currentTime) async {
    String writeQuery = 'UPDATE trans_availability SET pick_upload_status=1,pick_list_send_time=${wrapIfString(currentTime)} WHERE working_id=$workingId AND sku_id in ($skuId)';

    var db = await initDataBase();
    // final Map<String, dynamic> arguments = transAvlModelItem.toMap();
    // print(jsonEncode(arguments));
    print('_______________UpdATE________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateTransAVLAfterApiPickList(int skuId,String workingId) async {
    String writeQuery = 'update trans_availability set pick_upload_status=1 WHERE sku_id=$skuId AND working_id=$workingId';

    var db = await initDataBase();
    // final Map<String, dynamic> arguments = transAvlModelItem.toMap();
    // print(jsonEncode(arguments));
    print('_______________UpdATE________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateTransPlanoGuides(int gcsStatus,int id,String workingId,String skuImageName,String adherenceId) async {

    String writeQuery = 'UPDATE trans_planoguide SET isAdherence=?,gcs_status=$gcsStatus, image_name=?,upload_status=0,activity_status=1 WHERE id=$id and working_id=$workingId';
    var db = await initDataBase();
    print('_______________UpdATE PlanoGuide________________');
    print(writeQuery);
    return await db.rawUpdate(writeQuery,[adherenceId,skuImageName]);
  }

  static Future<int> updatePlanoguideAfterGcsAfterFinish(int id,String workingId) async {

    String writeQuery = 'UPDATE trans_planoguide SET gcs_status=1 WHERE working_id=$workingId And id=$id';

    var db = await initDataBase();

    print('_______________UpdATE Planoguide1122________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }


  static Future<int> updateRtvAfterGcsAfterFinish(int id,String workingId) async {

    String writeQuery = 'UPDATE trans_rtv SET gcs_status=1 WHERE working_id=$workingId And id=$id';

    var db = await initDataBase();

    print('_______________UpdATE Rtv GCS STATUS________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updatePlanoguideAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_planoguide SET upload_status=1 WHERE working_id=$workingId AND id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE Planoguide________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateRtvAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_rtv SET upload_status=1 WHERE working_id=$workingId AND sku_id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE Planoguide________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updatePriceCheckAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_pricing SET upload_status=1 WHERE working_id=$workingId AND sku_id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE Planoguide________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateShareShelfAfterApi(String workingId) async {
    // bool dataExist = await dataExists(transAvlModelItem.sku_id);
    // if(dataExist) {

    String writeQuery = 'UPDATE trans_brand_share SET upload_status=1 WHERE activity_status=1 AND working_id=$workingId';

    var db = await initDataBase();
    // final Map<String, dynamic> arguments = transAvlModelItem.toMap();
    // print(jsonEncode(arguments));
    print('_______________UpdATE Share Shelf________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateTransBrandShares(int id,String workingId,String actualFaces,String categoryId) async {
    String writeQuery = 'UPDATE trans_brand_share SET actual_faces=$actualFaces, upload_status=0, activity_status=1 where brand_id=$id and category_id=$categoryId and working_id=$workingId';
    var db = await initDataBase();
    print('_______________UpdATE Share Shelf________________');
    print(writeQuery);
    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateTableAfterGCSUpload(String workingID,String tblName,int gcsStatus,int uploadStatus,String imgName) async {
    String updateQuery = 'UPDATE $tblName SET gcs_status=$gcsStatus, upload_status=$uploadStatus WHERE working_id=? AND image_name=?';

    var db = await initDataBase();
    print('_______________ Update Update All Table________________');
    print(updateQuery);

    return await db.rawUpdate(updateQuery,[workingID,imgName]);

  }
  static Future<int> updatePlanoTableAfterGCSUpload(String workingID,String tblName,int gcsStatus,int uploadStatus,String imgName) async {
    String updateQuery = 'UPDATE $tblName SET gcs_status=$gcsStatus, upload_status=$uploadStatus WHERE working_id=? AND skuImageName=?';

    var db = await initDataBase();
    print('_______________ Update Update All Table________________');
    print(updateQuery);

    return await db.rawUpdate(updateQuery,[workingID,imgName]);

  }


  //   ---******insertTrans Data Start-----********


  static Future<void> insertTransMarketIssue(
      TransMarketIssueModel marketIssueModel) async {
    var db = await initDataBase();

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //   Get.delete<GeneralChecksStatusController>();

      await db.insert(
        TableName.tblTransMarketIssue,
        marketIssueModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }

  static Future<void> insertTransPhoto(TransPhotoModel transPhotoModel) async {
    var db = await initDataBase();

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      await db.insert(
        TableName.tblTransPhoto,
        transPhotoModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }

  static Future<void> insertTransPlanogram(TransPlanogramModel transPlanogramModel) async {
    var db = await initDataBase();
    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      await db.insert(
        TableName.tblTransPlanogram,
        transPlanogramModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }

  static Future<int>  updateTransAVL(int avlStatus,String workingId,String skuId) async {

    String writeQuery = 'UPDATE trans_availability SET avl_status=$avlStatus, activity_status=1,upload_status=0 WHERE working_id=$workingId AND sku_id=$skuId';

    var db = await initDataBase();
    print('_______________UpdATE________________');
    print(writeQuery);

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // }  else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawUpdate(writeQuery);
    // }
  }

  static Future<int>  updateSavePickList(String workingId,String reqPickList,String skuId) async {

    String writeQuery = 'UPDATE trans_availability SET pick_upload_status=0,req_picklist=$reqPickList WHERE working_id=$workingId AND sku_id=$skuId';

    var db = await initDataBase();
    print('_______________UpdATE________________');
    print(writeQuery);

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawUpdate(writeQuery);
    // }
  }


  static Future<int>  updateSidcoSavePickList(String workingId,String reqPickList,String skuId) async {

    String writeQuery = 'UPDATE trans_availability SET req_picklist=$reqPickList WHERE working_id=$workingId AND sku_id=$skuId';

    var db = await initDataBase();
    print('_______________UpdATE________________');
    print(writeQuery);

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

    return await db.rawUpdate(writeQuery);
    // }
  }


  static Future<void> insertTransSOS(TransSOSModel transSOSModel) async {
    var db = await initDataBase();

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      await db.insert(
        TableName.tblTransSos,
        transSOSModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }

  static Future<void> insertTransPricing(TransPricingModel pricingModel) async {
    var db = await initDataBase();

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // }  else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      await db.insert(
        TableName.tblTransPricing,
        pricingModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }

  static Future<void> insertTransStock(TransStockModel transStockModel) async {
    var db = await initDataBase();

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      await db.insert(
        TableName.tblTransStock,
        transStockModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }

  static Future<int> insertTransOSDC(TransOSDCModel transOSDCModel) async {
    var db = await initDataBase();

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      final osdcId = await db.insert(
        TableName.tblTransOsdc,
        transOSDCModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return osdcId;
    // }
  }

  static Future<void> insertTransOSDCImage(TransOSDCImagesModel transOSDCImage) async {
    var db = await initDataBase();

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      await db.insert(
        TableName.tblTransOsdcImages,
        transOSDCImage.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }

  static Future<void> insertTransOnePlusOne(TransOnePlusOneModel transOnePlusOneModel) async {
    var db = await initDataBase();

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      await db.insert(
        TableName.tblTransOnePlusOne,
        transOnePlusOneModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }
  // static Future<void> insertTransPromoPlan(TransPromoPlanModel transPromoPlanModel) async {
  //   var db = await initDataBase();
  //   await db.insert(
  //     TableName.tbl_trans_promoplan,
  //     transPromoPlanModel.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }
  static Future<int>  insertTransPlanoguide(String workingID) async {
    String insertQuery = 'INSERT OR IGNORE INTO trans_planoguide (client_id,store_id, category_id, pog, isAdherence, image_name, date_time,activity_status, gcs_status, upload_status, working_id) '
        ' SELECT client_id,store_id, category_id, pog,-1, pog_image, CURRENT_TIMESTAMP,0,0, 0,$workingID'
        ' FROM sys_store_pog';
    var db = await initDataBase();
    print('_______________INSERT TransPlanoGuide________________');
    print(insertQuery);

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawInsert(insertQuery);
    // }
  }

  static Future<int>  insertTransBrandShares(String workingID) async {
    String insertQuery = 'INSERT OR IGNORE INTO trans_brand_share (client_id,store_id, category_id, brand_id, given_faces,actual_faces,date_time,activity_status,upload_status,working_id) '
        ' SELECT client_id,store_id, category_id, brand_id, given_faces,"",CURRENT_TIMESTAMP,0,0,$workingID'
        ' FROM sys_brand_faces';
    var db = await initDataBase();
    print('_______________INSERT BransShare________________');
    print(insertQuery);
    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawInsert(insertQuery);
    // }
  }

  static Future<int>  insertTransAvailability(String workingID,String clientId,String now) async {

    String searchWhere = '';
    String avlExclSearchParam = await getAvlExcludesString(workingID);
    print(avlExclSearchParam);

    if(avlExclSearchParam.isNotEmpty) {
      searchWhere = ' AND id NOT IN($avlExclSearchParam)';
    }


    String insertQuery = 'INSERT OR IGNORE INTO trans_availability (client_id,sku_id, avl_status, activity_status,req_picklist,actual_picklist,picklist_reason,picklist_ready,working_id,pick_upload_status,upload_status,date_time,picker_name,pick_list_send_time,pick_list_receive_time) '
        'SELECT client_id,id, -1, 0 , 0,0,0,0,$workingID,0,0,00,"","",""'
        ' FROM sys_product where client_id IN($clientId) $searchWhere';
    var db = await initDataBase();
    print('_______________INSERT AVAILABILITY________________');
    print(insertQuery);

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawInsert(insertQuery);
    // }
  }

//--------************get drop down data-------**********
  static Future<List<ClientModel>> getVisitClientList(String client_ids) async {
    final db = await initDataBase();

    final List<Map<String, dynamic>> clientMaps = await db.rawQuery(
        'SELECT client_id as client_id, client_name as client_name FROM sys_client WHERE sys_client.client_id IN ($client_ids)');
    print(jsonEncode(clientMaps));
    print('________CLIENT List ________________');
    return List.generate(clientMaps.length, (index) {
      return ClientModel(
        client_id: clientMaps[index][TableName.clientIds] as int,
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
        'SELECT sys_category.id as cat_id,sys_category.en_name as cat_en_name,sys_category.client_id,'
            'sys_category.ar_name as cat_ar_name FROM  sys_category JOIN sys_client '
            'on sys_client.client_id=sys_category.client_id WHERE sys_category.client_id=($client_ids) ORDER BY sys_category.en_name ASC');


    return List.generate(categoryMaps.length, (index) {
      return CategoryModel(
        id: categoryMaps[index]['cat_id'] as int,
        en_name: categoryMaps[index]['cat_en_name'] as String,
        ar_name: categoryMaps[index]['cat_ar_name'] as String,
        client: categoryMaps[index][TableName.clientIds] as int,
      );
    });
  }

  static Future<List<CategoryModel>> getSubCategoryList(int client_ids,String categoryId) async {
    final db = await initDataBase();

    String searchWhere = '';

    if(categoryId.isNotEmpty && categoryId != '-1') {
      searchWhere = ' AND sys_product.category_id = $categoryId ';
    }

    final List<Map<String, dynamic>> categoryMaps = await db.rawQuery(
        'SELECT sys_subcategory.id as cat_id,sys_subcategory.en_name as cat_en_name,sys_subcategory.client_id,'
            ' sys_subcategory.ar_name as cat_ar_name '
            ' FROM sys_product JOIN sys_client on sys_client.client_id=sys_subcategory.client_id '
            ' JOIN sys_subcategory on sys_subcategory.id=sys_product.subcategory_id '
            ' WHERE sys_subcategory.client_id=($client_ids) $searchWhere GROUP BY subcategory_id ORDER BY sys_subcategory.en_name ASC');
//AND sys_subcategory.category_id=($categoryId)
    print(categoryId);
    print(client_ids);
    print('________Sub Category List ________________');
    return List.generate(categoryMaps.length, (index) {
      return CategoryModel(
        id: categoryMaps[index]['cat_id'] as int,
        en_name: categoryMaps[index]['cat_en_name'] as String,
        ar_name: categoryMaps[index]['cat_ar_name'] as String,
        client: categoryMaps[index][TableName.clientIds] as int,
      );
    });
  }

  static Future<List<Sys_PhotoTypeModel>> getPhotoTypeList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> photoTypeMaps = await db.rawQuery(
        'SELECT *from sys_photo_type');
    print(jsonEncode(photoTypeMaps));
    print('________Photo type List ________________');
    return List.generate(photoTypeMaps.length, (index) {
      return Sys_PhotoTypeModel(
        id: photoTypeMaps[index]['id'] as int,
        en_name: photoTypeMaps[index]['en_name'] as String,
        ar_name: photoTypeMaps[index]['ar_name'] as String,
      );
    });
  }

  static Future<List<SYS_BrandModel>> getBrandList(int clientId, String categoryId,String subCategoryId) async {
    final db = await initDataBase();

    String searchWhere = '';

    if(categoryId.isNotEmpty && categoryId != '-1') {
      searchWhere = ' AND sys_product.category_id = $categoryId ';
    }

    if(subCategoryId != '-1') {
      searchWhere = ' AND sys_product.subcategory_id = $subCategoryId ';
    }

    final List<Map<String, dynamic>> brandMaps = await db.rawQuery(
        'SELECT sys_brand.id,sys_brand.en_name ,sys_brand.ar_name,sys_brand.client_id '
            'FROM sys_product JOIN sys_client on sys_client.client_id=sys_brand.client_id '
            ' JOIN sys_brand on sys_brand.id=sys_product.brand_id '
            'WHERE sys_brand.client_id = $clientId $searchWhere GROUP BY brand_id ORDER BY sys_brand.en_name ASC');

    print(jsonEncode(brandMaps));
    print(categoryId);
    print(clientId);
    print('________BRAND List ________________');
    return List.generate(brandMaps.length, (index) {
      return SYS_BrandModel(
        id: brandMaps[index][TableName.sysId] as int,
        en_name: brandMaps[index][TableName.enName] as String,
        ar_name: brandMaps[index][TableName.arName] as String,
        client: brandMaps[index][TableName.clientIds] as int,
      );
    });
  }

  static Future<List<SYS_BrandModel>> getBrandListOSDC(String clientId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> brandMaps = await db.rawQuery(
        'SELECT sys_brand.id,sys_brand.en_name ,sys_brand.ar_name,sys_brand.client_id '
            'FROM sys_brand JOIN sys_client on sys_client.client_id=sys_brand.client_id '
            'WHERE sys_client.client_id IN($clientId)');

    print(jsonEncode(brandMaps));
    print('________BRAND List ________________');
    return List.generate(brandMaps.length, (index) {
      return SYS_BrandModel(
        id: brandMaps[index][TableName.sysId] as int,
        en_name: brandMaps[index][TableName.enName] as String,
        ar_name: brandMaps[index][TableName.arName] as String,
        client: brandMaps[index][TableName.clientIds] as int,
      );
    });
  }
//------*******Show  praph data********--------
  static Future<AdherenceModel> getAdherenceData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> adhereMaps = (await db.rawQuery(
        'SELECT SUM(CASE WHEN is_adherence = 1 THEN 1 ELSE 0 END) AS total_adhere,'
            ' SUM(CASE WHEN is_adherence = 0 THEN 1 ELSE 0 END) AS total_not_adhere FROM trans_planogram WHERE working_id=$workingId')) ;
    print(jsonEncode(adhereMaps));
    print('____________Adhere Cont_______________');
    return  AdherenceModel(
      adhereCount: int.parse(adhereMaps[0]['total_adhere'].toString() == 'null' ? '0' : adhereMaps[0]['total_adhere'].toString()),
      notAdhereCount: int.parse(adhereMaps[0]['total_not_adhere'].toString() == 'null' ? '0' : adhereMaps[0]['total_not_adhere'].toString()),
    );
  }

  static Future<AvailableCountModel> getAvailableCountData(String workingId) async {
    print(workingId);
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT COUNT(*) AS total_products, SUM(CASE WHEN avl_status = 1 THEN 1'
        ' ELSE 0 END) AS total_avl, SUM(CASE WHEN avl_status = 0 THEN 1 ELSE 0 END) AS total_not_avl  '
        'FROM trans_availability WHERE working_id=$workingId'));
    print(jsonEncode(result));
    print('____________Adhere Cont_______________');
    return  AvailableCountModel(
      totalProducts: int.parse(result[0]['total_products'].toString()),
      totalAvl: int.parse(result[0]['total_avl'].toString()),
      totalNotAvl: int.parse(result[0]['total_not_avl'].toString()),
    );
  }

  static Future<List<Sys_OSDCReasonModel>> getOsdcReasonList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcReasonMaps = await db.rawQuery(
        'SELECT *from sys_osdc_reason');
    print(jsonEncode(osdcReasonMaps));
    print('________OSDC Reason List ________________');
    return List.generate(osdcReasonMaps.length, (index) {
      return Sys_OSDCReasonModel(
        id: osdcReasonMaps[index][TableName.sysId] as int,
        en_name: osdcReasonMaps[index][TableName.enName] as String,
        ar_name: osdcReasonMaps[index][TableName.arName] as String,
      );
    });
  }

  static Future<List<Sys_OSDCTypeModel>> getAppSettingList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcTypeMaps = await db.rawQuery(
        'SELECT *from sys_app_setting');
    print(jsonEncode(osdcTypeMaps));
    print('________ App Setting List ________________');
    return List.generate(osdcTypeMaps.length, (index) {
      return Sys_OSDCTypeModel(
        id: osdcTypeMaps[index][TableName.sysId] as int,
        en_name: osdcTypeMaps[index][TableName.enName] as String,
        ar_name: osdcTypeMaps[index][TableName.arName] as String,
      );
    });
  }

  static Future<List<Sys_OSDCTypeModel>> getDailyCheckList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcTypeMaps = await db.rawQuery(
        'SELECT *from sys_daily_checklist');
    print(jsonEncode(osdcTypeMaps));
    print('________ SOS Unit List ________________');
    return List.generate(osdcTypeMaps.length, (index) {
      return Sys_OSDCTypeModel(
        id: osdcTypeMaps[index][TableName.sysId] as int,
        en_name: osdcTypeMaps[index][TableName.enName] as String,
        ar_name: osdcTypeMaps[index][TableName.arName] as String,
      );
    });
  }

  static Future<List<Sys_OSDCTypeModel>> getOsdcTypeList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcTypeMaps = await db.rawQuery(
        'SELECT *from sys_osdc_type');
    print(jsonEncode(osdcTypeMaps));
    print('________OSDC Type List ________________');
    return List.generate(osdcTypeMaps.length, (index) {
      return Sys_OSDCTypeModel(
        id: osdcTypeMaps[index][TableName.sysId] as int,
        en_name: osdcTypeMaps[index][TableName.enName] as String,
        ar_name: osdcTypeMaps[index][TableName.arName] as String,
      );
    });
  }
//----******** delete tabale********------------
  static Future<void> delete_table(String tbl_name) async {
    var db = await initDataBase();
    await db.rawDelete('DELETE FROM ${tbl_name}');
  }

  static Future<void> deleteOneRecord(String tblName, int id) async {
    print(tblName);
    print(id);
    print('Delete Record');
    var db = await initDataBase();
    await db.delete(tblName, where: 'id = ?', whereArgs: [id]);
  }

  /// Get PickList From Query Sql

  static Future<List<PickListModel>> getPickListData() async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> picklist =
    await db.rawQuery('SELECT *FROM picklist');
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
        en_cat_name: picklist[index]['en_name'].toString(),
        ar_cat_name: picklist[index]['ar_name'].toString(),
        sku_picture: picklist[index]['sku_picture'].toString(),
        en_sku_name: picklist[index]['en_sku_name'].toString(),
        ar_sku_name: picklist[index]['ar_sku_name'].toString(),
        req_pickList: picklist[index]['req_picklist'].toString(),
        act_pickList: picklist[index]['act_picklist'].toString(),
        pickList_ready: picklist[index]['picklist_ready'].toString(),
        upload_status: picklist[index]['upload_status'] ?? 0,
        pick_list_send_time: picklist[index]['pick_list_send_time'] ?? '',
        pick_list_receive_time: picklist[index]['pick_list_receive_time'] ?? '',
        isReasonShow: true,
        reasonValue: [],
        pick_list_reason: picklist[index]['picklist_reason'] ?? '',
      );
    });
  }

  static Future<int> insertPickListByQuery (String queryBulkInsertion) async {
     String insertQuery = 'INSERT OR IGNORE INTO picklist (working_id,picklist_id,store_id, category_id, tmr_id,tmr_name,stocker_id,stocker_name,shift_time,en_name,ar_name,sku_picture,en_sku_name,ar_sku_name,req_picklist,act_picklist,picklist_ready,upload_status,pick_list_send_time,pick_list_receive_time,picklist_reason)'
                        'VALUES $queryBulkInsertion';
                        // 'VALUES($pickListId,$storeId,$catId,$tmrId,$tmrName,$stockerId, $stockerName,$shiftTime,$enCatName,$arCatName,$skuPicture,$enSkuName,$arSkuName,$reqPickList,$actPickList,$pickListReady)';
  var db = await initDataBase();
  print('_______________INSERT PICKLIST________________');
  log(insertQuery);

  //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

  // if(generalStatusController.isVpnStatus.value) {
  //   throw FetchDataException('Please Disable Your VPN'.tr);
  // } else if(generalStatusController.isMockLocation.value) {
  //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
  // } else if(!generalStatusController.isLocationStatus.value) {
  //   throw FetchDataException('Please Enable Your Location'.tr);
  // } else {
  //
  //   Get.delete<GeneralChecksStatusController>();

      return await db.rawInsert(insertQuery);
    // }
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
  //         db, TableName.tblPicklist, fields);
  //     if (isDuplicate) {
  //       print('Error: Duplicate entry picklist reason');
  //     } else {
  //       await db.insert(
  //         TableName.tblPicklist,
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
  //       print('check picklist insertion');
  //
  //     }
  //   }
  // }

  ///Availability update Sql from PickList
  static Future<int> updateTransAVLAPicklist(int skuId,int actualPicklist,int actStatus,int workingId,String pickerName,String pickListReadyTime) async {
    String writeQuery = '';
    if(actualPicklist > 0) {
      writeQuery = 'update trans_availability set picker_name="$pickerName" ,pick_list_receive_time=${wrapIfString(pickListReadyTime)},avl_status=1,actual_picklist=$actualPicklist,picklist_ready=$actStatus where sku_id=$skuId AND working_id=$workingId';
    } else {
      writeQuery = 'update trans_availability set picker_name="$pickerName",pick_list_receive_time=${wrapIfString(pickListReadyTime)},actual_picklist=$actualPicklist,picklist_ready=$actStatus where sku_id=$skuId AND working_id=$workingId';
    }
    var db = await initDataBase();
    print('_______________UpdATE________________');
    print(writeQuery);

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawUpdate(writeQuery);
    // }
  }

  ///Trans Pick list update Sql
  static Future<int> updateTransPicklist(String picklistId,String actPicklist,String picklistReady,String reason) async {
    String writeQuery = 'update picklist set act_picklist=?,upload_status=0,picklist_ready=?,picklist_reason=${wrapIfString(reason)} where picklist_id=?';
    var db = await initDataBase();
    print('_______________UpdATE________________');
    print(writeQuery);

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db
          .rawUpdate(writeQuery, [actPicklist, picklistReady, picklistId]);
    // }
  }

  ///Trans Pick list update Sql after APi
  static Future<int> updateTransPicklistAfterApi(String picklistId,String actPicklist,String picklistReady) async {
    String writeQuery = 'update picklist set upload_status=1 where picklist_ready=1';
    var db = await initDataBase();
    print('_______________UpdATE________________');
    print(writeQuery);
    return await db.rawUpdate(writeQuery,[actPicklist,picklistReady,picklistId]);
  }

  ///Get AVL COUNT RECORDS FOR API UPLOAD
  static Future<AvailabilityCountModel> getAvailabilityCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT count(sku_id) AS total_sku, '
        'sum(CASE WHEN avl_status = 1 THEN 1 ELSE 0 END) As total_avl, '
        'sum(CASE WHEN avl_status = 0 THEN 1 ELSE 0 END) As total_not_avl, '
        'sum(CASE WHEN avl_status = -1 THEN 1 ELSE 0 END) As total_not_marked, '
        'sum(CASE WHEN activity_status = 1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        'sum(CASE WHEN activity_status = 1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded FROM trans_availability '
        'WHERE working_id=$workingId'));
    print(jsonEncode(result));
    print('____________Available Count_______________');
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
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT count(sku_id) AS total_sku, '
        'sum(CASE WHEN pick_upload_status = 1 THEN 1 ELSE 0 END) As total_pick_uploaded, '
        'sum(CASE WHEN picklist_ready = 1 THEN 1 ELSE 0 END) As total_pick_ready, '
        'sum(CASE WHEN picklist_ready = 0 THEN 1 ELSE 0 END) As total_pick_not_ready, '
        'sum(CASE WHEN pick_upload_status = 0 THEN 1 ELSE 0 END) As total_pick_not_uploaded FROM trans_availability '
        'WHERE working_id=$workingId AND req_picklist>0'));
    print(jsonEncode(result));
    print('____________Available Count_______________');
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
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT count(id) AS total_plano, '
        'sum(CASE WHEN isAdherence = 1 THEN 1 ELSE 0 END) As total_adhere, '
        'sum(CASE WHEN isAdherence = 0 THEN 1 ELSE 0 END) As total_not_adhere, '
        'sum(CASE WHEN activity_status = 0 THEN 1 ELSE 0 END) As total_not_marked, '
        'sum(CASE WHEN activity_status = 1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        'sum(CASE WHEN activity_status = 1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded, '
        'sum(CASE WHEN gcs_status = 0 AND activity_status=1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_images_not_uploaded, '
        'sum(CASE WHEN gcs_status = 1 AND activity_status=1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_images_uploaded '
        'FROM trans_planoguide WHERE working_id=$workingId'));
    print(jsonEncode(result));
    print('____________Planoguide Cont_______________');
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
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT count(id) AS total_brand_share, '
        'sum(CASE WHEN activity_status = 1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        'sum(CASE WHEN activity_status = 1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded, '
        'sum(CASE WHEN activity_status = 1 THEN 1 ELSE 0 END) As total_ready_brand, '
        'sum(CASE WHEN activity_status = 0 THEN 1 ELSE 0 END) As total_not_ready_brand '
        'FROM trans_brand_share WHERE working_id=$workingId'));
    print(jsonEncode(result));
    print('____________Brand Share Cont_______________');
    return  BrandShareCountModel(
        totalBrandShare: result[0]['total_brand_share'] ?? 0,
        totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
        totalUpload: result[0]['total_uploaded'] ?? 0,
        totalReadyBrands: result[0]['total_ready_brand'] ?? 0,
        totalNotReadyBrands: result[0]['total_not_ready_brand'] ?? 0,
    );
  }

  ///Get Rtv COUNT RECORDS FOR API UPLOAD
  static Future<RtvCountModel> getRtvCountDataServices(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT COUNT(DISTINCT sku_id) as total_rtv_pro,'
        ' sum(pieces) as total_volume, SUM(total_value) as total_value, sum(total_not_uploaded) as total_not_uploaded, sum(total_uploaded) as total_uploaded FROM '
        ' (SELECT sku_id, trans_rtv.pieces as pieces ,SUM(trans_rtv.pieces * sys_product.rsp) as total_value, '
        ' sum(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        ' sum(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        ' from trans_rtv'
        ' join sys_product on sys_product.id=trans_rtv.sku_id'
        ' WHERE working_id=$workingId GROUP by trans_rtv.id  ) A'));

    print(jsonEncode(result));
    print('____________RTV Cont_______________');
    return  RtvCountModel(
      totalRtv: result[0]['total_rtv_pro'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
      totalValue: result[0]['total_value'] == null ? 0 : result[0]['total_value'].round(),
      totalVolume: result[0]['total_volume'] == null ? 0 : result[0]['total_volume'].round(),
    );
  }

  ///Get Avl APi Data Query
  static Future<List<SaveAvailabilityData>> getAvlDataListForApi(String workingId) async {
    final db = await initDataBase();

    // Start building the base query
    String query = 'SELECT sku_id,client_id,avl_status From trans_availability '
        ' WHERE working_id=$workingId AND upload_status=0 And activity_status =1';

    print('getAvlDataListForApi');
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
    String query = 'SELECT sku_id,client_id,req_picklist From trans_availability '
        ' WHERE working_id=$workingId AND req_picklist > 0 AND pick_upload_status=0';

    print('getAvlPickListDataListForApi');
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

    String writeQuery = 'UPDATE trans_brand_share SET upload_status=1 WHERE working_id=$workingId AND id in ($ids)';
    var db = await initDataBase();
    print('_______________UpdATE Share Shelf________________');
    print(writeQuery);
    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // }  else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawUpdate(writeQuery);
    // }
  }

  ///get planoguide Images For GCS upload
  static Future<List<TransPlanoGuideGcsImagesListModel>> getPlanoGuideGcsImagesList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT id, image_name '
        ' FROM trans_planoguide WHERE working_id=$workingId AND activity_status=1 AND gcs_status=0';

    print('PLANOGUIDE QUERY');
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
    String rawQuery = 'SELECT sys_product.client_id as client_sku_id, sku_id,pieces,image_name,expire_date,reason '
        ' FROM trans_rtv '
        ' join sys_product on sys_product.id=trans_rtv.sku_id '
        'WHERE working_id=$workingId AND upload_status=0 AND gcs_status=1';

    print('RTV QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(rawQuery);
    print(rtvMap);
    return List.generate(rtvMap.length, (index) {
      return SaveRtvDataListData(
        skuId: rtvMap[index]['sku_id'],
        clientId: rtvMap[index]['client_sku_id'],
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
    String rawQuery = 'SELECT id, image_name'
        ' FROM trans_rtv WHERE working_id=$workingId AND gcs_status=0';

    print('RTV QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(rawQuery);
    print(rtvMap);
    print('RTV Images List');
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
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT count(picklist_id) AS total_picklist_items, '
        ' sum(CASE WHEN picklist_ready = 1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        ' sum(CASE WHEN picklist_ready = 1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded, '
        'sum(CASE WHEN picklist_ready = 1 THEN 1 ELSE 0 END) As total_pick_ready, '
        'sum(CASE WHEN picklist_ready = 0 THEN 1 ELSE 0 END) As total_pick_not_ready '
        ' FROM picklist WHERE stocker_id=$stockerId'));
    print(jsonEncode(result));
    print('____________Pick List Cont_______________');
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
    String rawQuery = 'SELECT picklist_id,act_picklist FROM picklist '
        'WHERE picklist_ready = 1 AND upload_status=0 And stocker_id=$stockerId';

    print('Pick List QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> pickListMap = await db.rawQuery(rawQuery);
    print(pickListMap);

    return List.generate(pickListMap.length, (index) {
      return ReadyPickListData(
        pickListId: pickListMap[index]['picklist_id'],
          actualPicklist: pickListMap[index]['act_picklist'],
        picklistReason: '',
      );
    });
  }

  ///pick data update After API
  static Future<int> updatePickListAfterApi(String ids,String currentTime) async {

    String writeQuery = 'UPDATE picklist SET upload_status=1,pick_list_send_time=${wrapIfString(currentTime)} WHERE picklist_id in ($ids)';
    var db = await initDataBase();
    print('_______________UpdATE PickList________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  ///Required Modules data list for API
  static Future<List<RequiredModuleModel>> getRequiredModuleListDataForApi() async {
    final db = await initDataBase();
    String rawQuery = 'SELECT module_id,visit_activty_type_id FROM sys_visit_required_modules';

    print('Require Module List QUERY');
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

    // final PermissionStatus permissionStatus = await _getPermission();

    // if (permissionStatus == PermissionStatus.granted) {
      const databaseName = 'cstore_pro.db';
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, databaseName);

      final dbFile = File(path);

      await closeDb(path);

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
    // } else {
    //   print('Permission Not Allowed');
    //   return false;
    // }
  }

  /// Close Connection with DB
  static Future<void> closeDb(String dbPath) async {

    Database db = await openDatabase(dbPath);
    if(db.isOpen) {
      await db.close();
      print('Compiler is HERE ${db.isOpen}');
    }
  }

  ///Replenishment Database Functions
  static Future<List<ReplenishShowModel>> getDataListReplenishment(String workingId, String clientId,String jpSessionClientIds, String brandId,String categoryId,String subCategoryId,String currentSelectedItem) async {

    String searchOtherExclude = '';
    String otherExclSearchParam = await getOtherExcludesString(workingId);
    print(otherExclSearchParam);

    if(otherExclSearchParam.isNotEmpty) {
      searchOtherExclude = 'And sys_product.id not in ($otherExclSearchParam)';
    }


    String searchWhere = '';
    String transWhere = '';

    String clientIds = '';

    if (clientId != '-1') {
      clientIds = clientId;
    } else {
      clientIds  = jpSessionClientIds;
    }

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_product.brand_id = "$brandId"';
    }
    if (subCategoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.subcategory_id = "$subCategoryId"';
    }
    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.category_id = "$categoryId"';
    }
    print('Sub Category FIlter');
    print(searchWhere);


    if(currentSelectedItem == 'Required') {
      transWhere = '$transWhere HAVING TransTable.required_pieces > 0 ';
    }

    if(currentSelectedItem == 'Picked') {
      transWhere = '$transWhere HAVING TransTable.picked_pieces >= 0 ';
    }

    final db = await initDataBase();
    String query = 'SELECT SystemTable.*,TransTable.act_status,TransTable.upload_status,TransTable.required_pieces,TransTable.picked_pieces,TransTable.not_picked_reason From (SELECT sys_product.id as pro_id, '
        'sys_product.en_name as pro_en_name, '
        'sys_product.ar_name as pro_ar_name,sys_category.en_name  ||  "  " ||  sys_subcategory.en_name as cat_en_name, '
        'sys_category.ar_name as cat_ar_name, '
        'sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,sys_product.image, '
        'sys_product.rsp, sys_subcategory.en_name as sub_category,sys_brand.en_name as brand '
        'from sys_product '
        'JOIN sys_category on sys_category.id=sys_product.category_id '
        'JOIN sys_subcategory on sys_subcategory.id=sys_product.subcategory_id '
        'JOIN sys_brand on sys_brand.id=sys_product.brand_id '
        'WHERE 1=1 And sys_product.client_id in ($clientIds) $searchOtherExclude $searchWhere) SystemTable '
        'LEFT JOIN ( SELECT sku_id,upload_status,act_status,required_pieces,picked_pieces,not_picked_reason FROM trans_picklist WHERE working_id=$workingId) TransTable '
        'on SystemTable.pro_id = TransTable.sku_id '
        'GROUP BY SystemTable.pro_id $transWhere ORDER BY sub_category,brand ASC ';

    print('++++++++++++++++++++');
    log(query);
    print('+++++++++++++++++++++');

    final List<Map<String, dynamic>> pricingMap = await db.rawQuery(query);
    return List.generate(pricingMap.length, (index) {

      return ReplenishShowModel(
        pro_id: pricingMap[index]['pro_id'] as int,
        cat_en_name: pricingMap[index]['cat_en_name'] ?? '',
        cat_ar_name: pricingMap[index]['cat_ar_name'] ?? '',
        pro_en_name: pricingMap[index]['pro_en_name'] ?? '',
        pro_ar_name: pricingMap[index]['pro_ar_name'] ?? '',
        img_name: pricingMap[index]['image'] ?? '',
        reason: pricingMap[index]['not_picked_reason'] ?? '',
        brand_en_name: pricingMap[index]['brand_en_name'] ?? '',
        brand_ar_name: pricingMap[index]['brand_ar_name'] ?? '',
        pricing_taken: pricingMap[index]['picked_pieces'] == null || pricingMap[index]['picked_pieces'] == '' ? 0 : int.parse(pricingMap[index]['picked_pieces'].toString()),
        regular_price: pricingMap[index]['required_pieces'] ?? '',
        promo_price: pricingMap[index]['picked_pieces'] ?? '',
        upload_status: pricingMap[index]['upload_status'] ?? 0,
        act_status: pricingMap[index]['act_status'] ?? 0,
        reasonValue: [],
      );
    });
  }
  ///insert Replenishment data from module
  static Future<int> insertTransReplenishment(int skuId, String regular, String promo,String reason ,String workingID) async {
    String insertQuery = '''
     INSERT OR REPLACE INTO trans_picklist (sku_id, required_pieces, picked_pieces,not_picked_reason, date_time, upload_status,act_status, working_id)
    VALUES ($skuId, ${wrapIfString(regular)}, ${wrapIfString(promo)},${wrapIfString(reason)},CURRENT_TIMESTAMP,0,1,$workingID)
  ''';

    var db = await initDataBase();
    print('_______________INSERT REPLENISHMENT________________');
    print(insertQuery);
    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawInsert(insertQuery);
    // }
  }

  static Future<int>  updateSavePickListForReplenishment(String workingId,String reqPickList,String skuId) async {

    String writeQuery = '''
    INSERT OR REPLACE INTO trans_picklist (working_id, sku_id, required_pieces, act_status,upload_status)
    VALUES ($workingId, $skuId, $reqPickList, 1, 0);
  ''';
    var db = await initDataBase();
    print('_______________UpdATE Replenishment ________________');
    print(writeQuery);

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

    return await db.rawInsert(writeQuery);
    // }
  }


  ///update Replenishment data from module
  static Future<int> updateTransReplenishment(int skuId, String regular, String promo,String reason, String workingID) async {
    String writeQuery = 'update trans_picklist set required_pieces=${wrapIfString(regular)},picked_pieces=${wrapIfString(promo)},not_picked_reason=${wrapIfString(reason)},upload_status=0 Where sku_id=$skuId AND working_id=$workingID';
    var db = await initDataBase();
    print('_______________UPDATE REPLENISHMENT________________');
    print(writeQuery);
    return await db.rawUpdate(writeQuery);
  }

  static Future<int> deleteTransReplenishment(int skuId,String workingID) async {
    String writeQuery = 'DELETE FROM trans_picklist WHERE sku_id=$skuId AND working_id=$workingID';
    var db = await initDataBase();
    print('_______________DELETE PROMO PRICE________________');
    print(writeQuery);
    return await db.rawUpdate(writeQuery);
  }

  ///Get Replenishment COUNT RECORDS FOR API UPLOAD
  static Future<PricingCountModel> getReplenishmentCountData(String workingId) async {
    final db = await initDataBase();

    String query  = ' SELECT COUNT(DISTINCT a.id) as all_sku, '
        ' sum(case when B.picked_pieces != "" Then 1 else 0 end) as total_picked_products, '
        ' sum(case when B.required_pieces != "" Then 1 else 0 end) as total_required_products '
        ' FROM (SELECT id from sys_product WHERE 1=1) A '
        ' LEFT JOIN(SELECT sku_id,required_pieces,picked_pieces from trans_picklist where 1=1 AND  working_id=$workingId) B '
        ' ON A.id=B.sku_id ';


    final List<Map<String, dynamic>> result = (await db.rawQuery(query));
    print(jsonEncode(result));
    print('____________Price Check Cont_______________');
    return  PricingCountModel(
      total_pricing_products: result[0]['all_sku'] ?? 0,
      total_promo_pricing: result[0]['total_picked_products'] ?? 0,
      total_regular_pricing: result[0]['total_required_products'] ?? 0,
    );
  }

  ///Get Replenish Data List For API
  static Future<List<SaveReplenishListData>> getActivityStatusReplenishDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT sys_product.client_id as client_product_id,sku_id,required_pieces,picked_pieces,not_picked_reason '
        ' FROM trans_picklist '
        ' join sys_product on sys_product.id=trans_picklist.sku_id '
        'WHERE working_id=$workingId AND upload_status=0';

    print('Price Check QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> priceCheckMap = await db.rawQuery(rawQuery);
    print(priceCheckMap);
    return List.generate(priceCheckMap.length, (index) {
      return SaveReplenishListData(
        skuId: priceCheckMap[index]['sku_id'],
        clientId: priceCheckMap[index]['client_product_id'].toString(),
        reqPicklist: priceCheckMap[index]['required_pieces'].toString(),
        actPicklist: priceCheckMap[index]['picked_pieces'].toString(),
        picklistReason: priceCheckMap[index]['not_picked_reason'].toString()
      );
    });
  }


  ///Update Replenish After API Upload
  static Future<int> updateReplenishmentAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_picklist SET upload_status=1 WHERE working_id=$workingId AND sku_id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE Planoguide________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }


  ///Get Price Check COUNT RECORDS FOR API UPLOAD
  static Future<PriceCheckCountModel> getReplenishmentCountDataForSummary(String workingId) async {

    String query = ' SELECT SUM(required_pieces) as total_required, '
        ' SUM(CASE WHEN act_status=1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        ' SUM(CASE WHEN act_status=1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded, '
        ' SUM(picked_pieces) as total_picked, '
        ' ROUND((SUM(picked_pieces) / SUM(required_pieces)) * 100,0) as rate '
        ' FROM trans_picklist WHERE working_id=$workingId';

    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery(query));
    print(jsonEncode(result));
    print('____________Replenishment Count_______________');
    return  PriceCheckCountModel(
      totalPriceCheck:result[0]['total_required'] == 0 || result[0]['total_required'] == null ? 0 : ((result[0]['total_picked']==null ? 0 : result[0]['total_picked'].round()/result[0]['total_required'].round()) * 100).round(),
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
      totalPromoSku: result[0]['total_picked'] == null ? 0 : result[0]['total_picked'].round(),
      totalRegularSku: result[0]['total_required'] ?? 0,
    );
  }

  ///Pricing Database Functions

  static Future<List<PricingShowModel>> getDataListPriceCheck(String workingId, String clientId,String jpSessionClientIds, String brandId,String categoryId,String subCategoryId) async {

    String searchOtherExclude = '';
    String otherExclSearchParam = await getOtherExcludesString(workingId);
    print(otherExclSearchParam);

    if(otherExclSearchParam.isNotEmpty) {
      searchOtherExclude = 'And sys_product.id not in ($otherExclSearchParam)';
    }


    String searchWhere = '';

    String clientIds = '';

    if (clientId != '-1') {
      clientIds = clientId;
    } else {
      clientIds  = jpSessionClientIds;
    }

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_product.brand_id = "$brandId"';
    }
    if (subCategoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.subcategory_id = "$subCategoryId"';
    }
    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.category_id = "$categoryId"';
    }
    print('Sub Category FIlter');
    print(searchWhere);

    final db = await initDataBase();
    String query = 'SELECT SystemTable.*,TransTable.act_status,TransTable.regular_price,TransTable.promo_price From (SELECT sys_product.id as pro_id, '
        'sys_product.en_name as pro_en_name, '
        'sys_product.ar_name as pro_ar_name,sys_category.en_name  ||  "  " ||  sys_subcategory.en_name as cat_en_name, '
        'sys_category.ar_name as cat_ar_name, '
        'sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,sys_product.image, '
        'sys_product.rsp, sys_subcategory.en_name as sub_category,sys_brand.en_name as brand '
        'from sys_product '
        'JOIN sys_category on sys_category.id=sys_product.category_id '
        'JOIN sys_subcategory on sys_subcategory.id=sys_product.subcategory_id '
        'JOIN sys_brand on sys_brand.id=sys_product.brand_id '
        'WHERE 1=1 And sys_product.client_id in ($clientIds) $searchOtherExclude $searchWhere) SystemTable '
        'LEFT JOIN ( SELECT sku_id,act_status,regular_price,promo_price FROM trans_pricing WHERE working_id=$workingId ) TransTable '
        'on SystemTable.pro_id = TransTable.sku_id '
        'GROUP BY SystemTable.pro_id ORDER BY sub_category,brand ASC';

    print('++++++++++++++++++++');
    print(query);
    print('+++++++++++++++++++++');

    final List<Map<String, dynamic>> pricingMap = await db.rawQuery(query);
    return List.generate(pricingMap.length, (index) {
      return PricingShowModel(
        pro_id: pricingMap[index]['pro_id'] as int,
        cat_en_name: pricingMap[index]['cat_en_name'] ?? '',
        cat_ar_name: pricingMap[index]['cat_ar_name'] ?? '',
        pro_en_name: pricingMap[index]['pro_en_name'] ?? '',
        pro_ar_name: pricingMap[index]['pro_ar_name'] ?? '',
        img_name: pricingMap[index]['image'] ?? '',
        rsp: pricingMap[index]['rsp'] ?? '',
        brand_en_name: pricingMap[index]['brand_en_name'] ?? '',
        brand_ar_name: pricingMap[index]['brand_ar_name'] ?? '',
        pricing_taken: pricingMap[index]['pricing_taken'] ?? 0,
        regular_price: pricingMap[index]['regular_price'] ?? '',
        promo_price: pricingMap[index]['promo_price'] ?? '',
        upload_status: pricingMap[index]['upload_status'] ?? 0,
        act_status: pricingMap[index]['act_status'] ?? 0,
      );
    });
  }

  ///Get Price Check COUNT RECORDS FOR API UPLOAD
  static Future<PriceCheckCountModel> getPriceCheckCountData(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT count(Distinct sku_id) AS total_price_check, '
        'sum(CASE WHEN act_status=1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        'sum(case when regular_price != "" Then 1 else 0 end) as total_regular_products, '
        'sum(case when promo_price != "" Then 1 else 0 end) as total_promo_products, '
        'sum(CASE WHEN act_status=1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        'FROM trans_pricing WHERE working_id=$workingId'));
    print(jsonEncode(result));
    print('____________Price Check Cont_______________');
    return  PriceCheckCountModel(
      totalPriceCheck: result[0]['total_price_check'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
      totalPromoSku: result[0]['total_promo_products'] ?? 0,
      totalRegularSku: result[0]['total_regular_products'] ?? 0,
    );
  }

  ///Get Price Check Data List For API
  static Future<List<SavePricingDataListData>> getActivityStatusPriceCheckDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT sys_product.client_id as client_product_id,sku_id,regular_price,promo_price '
        ' FROM trans_pricing '
        ' join sys_product on sys_product.id=trans_pricing.sku_id '
        'WHERE working_id=$workingId AND upload_status=0';

    print('Price Check QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> priceCheckMap = await db.rawQuery(rawQuery);
    print(priceCheckMap);
    return List.generate(priceCheckMap.length, (index) {
      return SavePricingDataListData(
        skuId: priceCheckMap[index]['sku_id'],
        clientId: priceCheckMap[index]['client_product_id'],
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
    print('_______________INSERT TransPromoPrice________________');
    print(insertQuery);
    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawInsert(insertQuery);
    // }
  }

  static Future<int> updateTransPromoPricing(int skuId, String regular, String promo, String workingID) async {
    String writeQuery = 'update trans_pricing set regular_price=${wrapIfString(regular)},promo_price=${wrapIfString(promo)},upload_status=0 Where sku_id=$skuId AND working_id=$workingID';
    var db = await initDataBase();
    print('_______________UpdATE________________');
    print(writeQuery);
    return await db.rawUpdate(writeQuery);
  }

  static Future<int> deleteTransPromoPricing(int skuId,String workingID) async {
    String writeQuery = 'DELETE FROM trans_pricing WHERE sku_id=$skuId AND working_id=$workingID';
    var db = await initDataBase();
    print('_______________DELETE PROMO PRICE________________');
    print(writeQuery);
    return await db.rawUpdate(writeQuery);
  }

  ///RTV Database Functions

  static Future<void> insertTransRtvData(TransRtvModel transRtvModel) async {
    var db = await initDataBase();
    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      await db.insert(
        TableName.tblTransRtv,
        transRtvModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }

  static Future<List<Sys_RTVReasonModel>> getRtvReasonList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> brandMaps = await db.rawQuery(
        'SELECT *from sys_rtv_reason');

    print(jsonEncode(brandMaps));
    print('________ RTV Reason List ________________');
    return List.generate(brandMaps.length, (index) {
      return Sys_RTVReasonModel(
        id: brandMaps[index][TableName.sysId] as int,
        en_name: brandMaps[index][TableName.enName] as String,
        ar_name: brandMaps[index][TableName.arName] as String,
        calendar: brandMaps[index][TableName.sys_rtv_reason_calendar].toString(),
        status: brandMaps[index][TableName.status] as int,
      );
    });
  }

  static Future<List<RTVShowModel>> getDataListRTV(String workingId, String clientId,String jpSessionClientIds,String brandId,String categoryId,String subCategoryId) async {

    String searchOtherExclude = '';
    String otherExclSearchParam = await getOtherExcludesString(workingId);
    print(otherExclSearchParam);

    if(otherExclSearchParam.isNotEmpty) {
      searchOtherExclude = 'And sys_product.id not in ($otherExclSearchParam)';
    }

    String searchWhere = '';

    String clientIds = '';

    if (clientId != '-1') {
      clientIds = clientId;
    } else {
      clientIds  = jpSessionClientIds;
    }

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_product.brand_id = "$brandId"';
    }
    if (subCategoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.subcategory_id = "$subCategoryId"';
    }
    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.category_id = "$categoryId"';
    }


    final db = await initDataBase();
    String query = 'SELECT SystemTable.*,TransTable.act_status From (SELECT sys_product.id as pro_id, '
        'sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name, '
        'sys_category.en_name  ||  "  " ||  sys_subcategory.en_name as cat_en_name, sys_category.ar_name as cat_ar_name, '
        'sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,sys_product.image, sys_product.rsp, sys_subcategory.en_name as sub_category,sys_brand.en_name as brand '
        'from sys_product '
        'JOIN sys_category on sys_category.id=sys_product.category_id '
        'JOIN sys_subcategory on sys_subcategory.id=sys_product.subcategory_id '
        'JOIN sys_brand on sys_brand.id=sys_product.brand_id '
        'WHERE 1=1 And sys_product.client_id in ($clientIds) $searchOtherExclude $searchWhere ) SystemTable '
        'LEFT JOIN ( SELECT sku_id,act_status FROM trans_rtv WHERE working_id=$workingId ) TransTable '
        'on SystemTable.pro_id = TransTable.sku_id GROUP BY SystemTable.pro_id ORDER BY SystemTable.sub_category,SystemTable.brand ASC';
    print(query);
    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(query);
    print(rtvMap);
    return List.generate(rtvMap.length, (index) {
      return RTVShowModel(
        pro_id: rtvMap[index]['pro_id'] as int,
        cat_en_name: rtvMap[index]['cat_en_name'] ?? '',
        cat_ar_name: rtvMap[index]['cat_ar_name'] ?? '',
        pro_en_name: rtvMap[index]['pro_en_name'] ?? '',
        pro_ar_name: rtvMap[index]['pro_ar_name'] ?? '',
        img_name: rtvMap[index]['image'] ?? '',
        rsp: rtvMap[index]['rsp'] ?? '',
        brand_en_name: rtvMap[index]['brand_en_name'] ?? '',
        brand_ar_name: rtvMap[index]['brand_ar_name'] ?? '',
        rtv_taken: rtvMap[index]['rtv_taken'] ?? 0,
        pieces: rtvMap[index]['pieces'] ?? 0,
        act_status: rtvMap[index]['act_status'] ?? 0,
        imageFile: null,
      );
    });
  }

  static Future<RTVCountModel>  getRTVCountData(String workingId, String clientId, String brandId,String categoryId,String subCategoryId) async {

    String searchWhere = '';

    if (clientId != '-1') {
      searchWhere = '$searchWhere And sys_product.client_id = "$clientId"';
    }

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_product.brand_id = "$brandId"';
    }
    if (subCategoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.subcategory_id = "$subCategoryId"';
    }
    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.category_id = "$categoryId"';
    }

    final db = await initDataBase();
    String query = 'SELECT COUNT(DISTINCT sku_id) as total_rtv_pro, sum(pieces ) as total_volume, SUM(total_value) as total_value FROM '
        ' (SELECT sku_id, trans_rtv.pieces as pieces ,SUM(trans_rtv.pieces * sys_product.rsp) as total_value'
        ' from trans_rtv'
        ' join sys_product on sys_product.id=trans_rtv.sku_id'
        ' WHERE working_id=$workingId $searchWhere GROUP by trans_rtv.id ) A';
    final List<Map<String, dynamic>> result = await db.rawQuery(query);
    print('rtv count data....');
    print(result);
    return RTVCountModel(
      total_rtv_pro: result[0]['total_rtv_pro'] ?? 0,
      total_value: result[0]['total_value'] != null ? result[0]['total_value'].round() : 0,
      total_volume: result[0]['total_volume'] != null ? result[0]['total_volume'].round() : 0,
    );
  }

  static Future<PricingCountModel> getPricingCountData(String workingId, String clientId, String brandId,String categoryId,String subCategoryId) async {

    String searchWhere = '';

    if (clientId != '-1') {
      searchWhere = '$searchWhere And sys_product.client_id = "$clientId"';
    }

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_product.brand_id = "$brandId"';
    }
    if (subCategoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.subcategory_id = "$subCategoryId"';
    }
    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.category_id = "$categoryId"';
    }


    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT count(sku_id) as total_pricing_products, '
        'sum(case when regular_price != "" Then 1 else 0 end) as total_regular_products, '
        'sum(case when promo_price != "" Then 1 else 0 end) as total_promo_products '
        'From trans_pricing '
        'join sys_product on sys_product.id=trans_pricing.sku_id '
        'WHERE working_id=$workingId $searchWhere ' ));
    print(jsonEncode(result));
    print('____________Pricing Cont_______________');
    return  PricingCountModel(
      total_pricing_products : result[0]['total_pricing_products'] ?? 0,
      total_regular_pricing :  result[0]['total_regular_products'] ?? 0,
      total_promo_pricing :  result[0]['total_promo_products'] ?? 0,
    );
  }

  ///Freshness Queries

  static Future<List<FreshnessListShowModel>> getDataListFreshness(String workingId, String clientId, String jpSessionClientIds, String brandId, String categoryId, String subCategoryId) async {

    String searchOtherExclude = '';
    String otherExclSearchParam = await getOtherExcludesString(workingId);
    print(otherExclSearchParam);

    if(otherExclSearchParam.isNotEmpty) {
      searchOtherExclude = 'And sys_product.id not in ($otherExclSearchParam)';
    }


    String searchWhere = '';

    String clientIds = '';

    if (clientId != '-1') {
      clientIds = clientId;
    } else {
      clientIds  = jpSessionClientIds;
    }

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_product.brand_id = "$brandId"';
    }
    if (subCategoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.subcategory_id = "$subCategoryId"';
    }
    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.category_id = "$categoryId"';
    }

    final db = await initDataBase();
    String query = 'SELECT SystemTable.*,CASE WHEN TransTable.sku_id is NOT NULL THEN 1 ELSE 0 End as act_status From (SELECT sys_product.id as pro_id,'
        ' sys_product.en_name as pro_en_name,'
        ' sys_product.ar_name as pro_ar_name,sys_category.en_name  ||  "  " ||  sys_subcategory.en_name as cat_en_name,'
        ' sys_category.ar_name as cat_ar_name,'
        ' sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,sys_product.image,'
        ' sys_product.rsp, sys_subcategory.en_name as sub_category,sys_brand.en_name as brand'
        ' from sys_product'
        ' JOIN sys_category on sys_category.id=sys_product.category_id'
        ' JOIN sys_subcategory on sys_subcategory.id=sys_product.subcategory_id'
        ' JOIN sys_brand on sys_brand.id=sys_product.brand_id'
        ' WHERE 1=1 And sys_product.client_id in ($clientIds) $searchOtherExclude $searchWhere ) SystemTable'
        ' LEFT JOIN ( SELECT sku_id FROM trans_freshness WHERE working_id=$workingId ) TransTable'
        ' on SystemTable.pro_id = TransTable.sku_id'
        ' GROUP BY SystemTable.pro_id'
        ' ORDER BY SystemTable.sub_category,SystemTable.brand ASC';

    print(query);

    final List<Map<String, dynamic>> pricingMap = await db.rawQuery(query);
    return List.generate(pricingMap.length, (index) {
      return FreshnessListShowModel(
        pro_id: pricingMap[index]['pro_id'] as int,
        cat_en_name: pricingMap[index]['cat_en_name'] ?? '',
        cat_ar_name: pricingMap[index]['cat_ar_name'] ?? '',
        pro_en_name: pricingMap[index]['pro_en_name'] ?? '',
        pro_ar_name: pricingMap[index]['pro_ar_name'] ?? '',
        img_name: pricingMap[index]['image'] ?? '',
        rsp: pricingMap[index]['rsp'] ?? '',
        brand_en_name: pricingMap[index]['brand_en_name'] ?? '',
        brand_ar_name: pricingMap[index]['brand_ar_name'] ?? '',
        upload_status: pricingMap[index]['upload_status'] ?? 0,
        activity_status: pricingMap[index]['act_status'] ?? 0,
        freshness_taken: pricingMap[index]['freshness_taken'] ?? 0,
      );
    });
  }

  static Future<int> insertTransFreshness(String month, String clientId,String currentTime, int year, int skuId, String workingID, int pieces) async {

    String monthSubString = month.replaceAll(' ', '').substring(0,3).toLowerCase();

    String insertQuery = ' INSERT INTO trans_freshness (sku_id, client_id,date_time, year,$monthSubString, upload_status, working_id) '
        'VALUES ($skuId,${wrapIfString(clientId)},${wrapIfString(currentTime)},$year,$pieces,0,${wrapIfString(workingID)})';

    var db = await initDataBase();
    print('_______________INSERT Trans Freshness________________');
    print(insertQuery);
    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // }  else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawInsert(insertQuery);
    // }
  }

  static Future<List<TransFreshnessModel>> getTransFreshnessDataList(String workingId, String clientId, String brandId, String categoryId, String subCategoryId) async {

    String searchOtherExclude = '';
    String otherExclSearchParam = await getOtherExcludesString(workingId);
    print(otherExclSearchParam);

    if(otherExclSearchParam.isNotEmpty) {
      searchOtherExclude = 'And sys_product.id not in ($otherExclSearchParam)';
    }


    String searchWhere = '';

    if (clientId != '-1') {
      searchWhere = '$searchWhere And sys_product.client_id = "$clientId"';
    }

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_product.brand_id = "$brandId"';
    }
    if (subCategoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.subcategory_id = "$subCategoryId"';
    }
    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.category_id = "$categoryId"';
    }

    final db = await initDataBase();
    String query =  ' SELECT sys_product.image as img_name, sys_product.en_name as sku_en_name, sys_product.ar_name as sku_ar_name, sys_product.client_id, '
        ' trans_freshness.sku_id, trans_freshness.year,trans_freshness.specific_date,trans_freshness.upload_status, '
        ' IFNULL(sum(trans_freshness.jan),0) as jan,'
        ' IFNULL(sum(trans_freshness.feb),0) as feb,'
        ' IFNULL(sum(trans_freshness.mar),0) as mar,'
        ' IFNULL(sum(trans_freshness.apr),0) as apr,'
        ' IFNULL(sum(trans_freshness.may),0) as may,'
        ' IFNULL(sum(trans_freshness.jun),0) as jun,'
        ' IFNULL(sum(trans_freshness.jul),0) as jul,'
        ' IFNULL(sum(trans_freshness.aug),0) as aug,'
        ' IFNULL(sum(trans_freshness.sep),0) as sep,'
        ' IFNULL(sum(trans_freshness.oct),0) as oct,'
        ' IFNULL(sum(trans_freshness.nov),0) as nov,'
        ' IFNULL(sum(trans_freshness.dec),0) as dec '
        ' FROM trans_freshness'
        ' JOIN sys_product'
        ' ON trans_freshness.sku_id = sys_product.id'
        ' WHERE trans_freshness.working_id = $workingId $searchWhere'
        ' GROUP BY trans_freshness.year, trans_freshness.sku_id ORDER BY sys_product.subcategory_id,sys_product.brand_id';

    final List<Map<String, dynamic>> freshnessMap = await db.rawQuery(query);

    print(query);
    print('___ Freshness Data List _______');
    return List.generate(freshnessMap.length, (index) {
      print(jsonEncode(freshnessMap[index]));
      return TransFreshnessModel(
          sku_id:freshnessMap[index]['sku_id'],
          year:freshnessMap[index]['year'] ?? 0,
          jan:freshnessMap[index]['jan'] ?? 0,
          feb:freshnessMap[index]['feb'] ?? 0,
          mar:freshnessMap[index]['mar'] ?? 0,
          apr:freshnessMap[index]['apr'] ?? 0,
          may:freshnessMap[index]['may'] ?? 0,
          jun:freshnessMap[index]['jun'] ?? 0,
          jul:freshnessMap[index]['jul'] ?? 0,
          aug:freshnessMap[index]['aug'] ?? 0,
          sep:freshnessMap[index]['sep'] ?? 0,
          oct:freshnessMap[index]['oct'] ?? 0,
          nov:freshnessMap[index]['nov'] ?? 0,
          dec:freshnessMap[index]['dec'] ?? 0,
          specific_date:freshnessMap[index]['specific_date'] ?? '',
          client_id:freshnessMap[index]['client_id'].toString(),
          sku_en_name:freshnessMap[index]['sku_en_name'].toString(),
          sku_ar_name:freshnessMap[index]['sku_ar_name'].toString(),
          upload_status:freshnessMap[index]['upload_status'],
          imgName: freshnessMap[index]['img_name']);
    });
  }

  static Future<FreshnessGraphCountShowModel> getFreshnessGraphCount(String workingId, String clientId, String jpSessionClientIds, String brandId, String categoryId, String subCategoryId) async {

    String searchWhere = '';

    if (clientId != '-1') {
      searchWhere = '$searchWhere And sys_product.client_id = "$clientId"';
    } else {
      // searchWhere  = '$searchWhere And sys_product.client_id = '$clientId'';
    }

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_product.brand_id = "$brandId"';
    }
    if (subCategoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.subcategory_id = "$subCategoryId"';
    }
    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.category_id = "$categoryId"';
    }

    final db = await initDataBase();
    String query = 'SELECT count(DISTINCT sku_id) as total_freshness_taken, '
        ' (ifnull(Sum(jan),0) + ifnull(Sum(feb),0) + ifnull(Sum(mar),0) + ifnull(Sum(apr),0) + '
        ' ifnull(Sum(may),0) + ifnull(Sum(jun),0) + ifnull(Sum(jul),0) + ifnull(Sum(aug),0) + '
        ' ifnull(Sum(sep),0) + ifnull(Sum(oct),0) + ifnull(Sum(nov),0) + ifnull(Sum(dec),0 )) as total_volume, '
        'sum(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        'sum(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        ' FROM trans_freshness '
        ' join sys_product on sys_product.id=trans_freshness.sku_id '
        ' WHERE working_id=$workingId $searchWhere';

    print(query);

    final List<Map<String, dynamic>> freshnessGraphCount = await db.rawQuery(query);
    print(jsonEncode(freshnessGraphCount));
      return FreshnessGraphCountShowModel(
        totalFreshnessTaken: freshnessGraphCount[0]['total_freshness_taken'] ?? 0,
        totalVolume: freshnessGraphCount[0]['total_volume'] ?? 0,
        totalUploadCount: freshnessGraphCount[0]['total_uploaded'] ?? 0,
        totalNotUploadCount: freshnessGraphCount[0]['total_not_uploaded'] ?? 0
      );
  }

  static Future<List<SaveFreshnessListData>> getFreshnessDataListFromApi(String workingId) async {

    final db = await initDataBase();

    String rawQuery = 'SELECT sys_product.client_id as api_client_id,trans_freshness.*'
        ' FROM trans_freshness '
        ' join sys_product on sys_product.id=trans_freshness.sku_id '
        ' WHERE working_id=$workingId AND upload_status=0 ';

    print('Freshness QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> freshnessMap = await db.rawQuery(rawQuery);
    print(freshnessMap);
    return List.generate(freshnessMap.length, (index) {
      return SaveFreshnessListData(
        skuId: freshnessMap[index]['sku_id'],
        clientId: freshnessMap[index]['api_client_id'],
        year: int.parse(freshnessMap[index]['year'].toString()),
        dateTime: freshnessMap[index]['date_time'] ?? '',
        jan: freshnessMap[index]['jan'] ?? 0,
        feb: freshnessMap[index]['feb'] ?? 0,
        mar: freshnessMap[index]['mar'] ?? 0,
        apr: freshnessMap[index]['apr'] ?? 0,
        may: freshnessMap[index]['may'] ?? 0,
        jun: freshnessMap[index]['jun'] ?? 0,
        jul: freshnessMap[index]['jul'] ?? 0,
        aug: freshnessMap[index]['aug'] ?? 0,
        sep: freshnessMap[index]['sep'] ?? 0,
        oct: freshnessMap[index]['oct'] ?? 0,
        nov: freshnessMap[index]['nov'] ?? 0,
        dec: freshnessMap[index]['dec'] ?? 0
      );
    });
  }

  static Future<int> updateFresshnessAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_freshness SET upload_status=1 WHERE working_id=$workingId AND date_time in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE Freshness________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateFreshnessAfterResetLocalData(String workingId,int skuId,String month,String year) async {

    String writeQuery = 'UPDATE trans_freshness SET $month = 0 WHERE working_id=$workingId AND sku_id = $skuId AND year = $year';

    var db = await initDataBase();
    print('_______________UpdATE Freshness After Local Reset________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  ///Promo Plan Database Queries
  static Future<int>  insertTransPromoPlan(String workingID,String clientId,int storeId) async {
    String insertQuery = 'INSERT OR IGNORE INTO trans_promoplan (sku_id,modal_image, image_name, promo_reason, promo_status,date_time,act_status,gcs_status,upload_status, working_id) '
        ' SELECT sku_id,modal_image,"","","", CURRENT_TIMESTAMP,0,0, 0,$workingID'
        ' FROM sys_promoplan WHERE  company_id in($clientId) AND store_id=$storeId GROUP BY sys_promoplan.store_id,sys_promoplan.sku_id';
    var db = await initDataBase();
    print('_______________INSERT TransPromoPlan________________');
    print(insertQuery);
    return await db.rawInsert(insertQuery);
  }

  static Future<List<TransPromoPlanListModel>> getTransPromoPlanList(String workingId,String promoReason) async {
    final db = await initDataBase();

    print(promoReason);

    String searchWhere = '';

    if (promoReason != '' && promoReason != 'Pending') {
      searchWhere = '$searchWhere And promo_status = "$promoReason"';
    }

    if (promoReason == 'Pending') {
      searchWhere = '$searchWhere And act_status = 0';
    }

    String query = 'Select sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name, '
        ' sys_category.en_name as cat_en_name, sys_category.ar_name as cat_ar_name, sys_promoplan.promo_to, sys_promoplan.promo_from, sys_promoplan.promo_Scope, sys_promoplan.promo_price, sys_promoplan.osd_type,sys_promoplan.left_over_action, '
        ' sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name, sys_product.image as pro_image_name, '
        ' trans_promoplan.promo_reason, '
        ' trans_promoplan.* '
        ' From trans_promoplan '
        ' JOIN sys_product on sys_product.id = trans_promoplan.sku_id '
        ' JOIN sys_category on sys_category.id = sys_product.category_id '
        ' JOIN sys_brand on sys_brand.id = sys_product.brand_id '
        ' JOIN sys_promoplan on sys_promoplan.sku_id = trans_promoplan.sku_id '
        ' WHERE working_id=$workingId $searchWhere GROUP BY trans_promoplan.sku_id';

    final List<Map<String, dynamic>> transPromoPlanMap = await db.rawQuery(query);

    print(query);
    print(jsonEncode(transPromoPlanMap));
    print('___ Trans Promo Plan Data List _______');
    return List.generate(transPromoPlanMap.length, (index) {

      return TransPromoPlanListModel(
          promoId : transPromoPlanMap[index]['sku_id'],
          skuEnName : transPromoPlanMap[index]['pro_en_name'] ?? '',
          skuArName : transPromoPlanMap[index]['pro_ar_name'] ?? '',
          skuImageName : transPromoPlanMap[index]['pro_image_name'] ?? '',
          catEnName : transPromoPlanMap[index]['cat_en_name'] ?? '',
          catArName : transPromoPlanMap[index]['car_ar_name'] ?? '',
          brandEnName : transPromoPlanMap[index]['brand_en_name'] ?? '',
          brandArName : transPromoPlanMap[index]['brand_ar_name'] ?? '',
          osdType: transPromoPlanMap[index]['osd_type'] ?? '',
          skuId : transPromoPlanMap[index]['sku_id'] ?? 0,
          promoFrom : transPromoPlanMap[index]['promo_from'] ?? '',
          promoTo : transPromoPlanMap[index]['promo_to'] ?? '',
          weekTitle : transPromoPlanMap[index]['week_title'] ?? '',
          promoPrice : transPromoPlanMap[index]['promo_price'] ?? '0',
          promoScope : transPromoPlanMap[index]['promo_Scope'] ?? '',
          imageName : transPromoPlanMap[index]['image_name'] ?? '',
          modalImage: transPromoPlanMap[index]['modal_image'] ?? '',
          leftOverAction : transPromoPlanMap[index]['left_over_action'] ?? '',
          initialOsdcItem: Sys_OSDCReasonModel(id: -1, en_name: '', ar_name: ''),
          promoReasonId : transPromoPlanMap[index]['promo_reason'].toString().isEmpty ? -1 : int.parse(transPromoPlanMap[index]['promo_reason'].toString()),
          promoStatus : transPromoPlanMap[index]['promo_status'] ?? '',
          actStatus : transPromoPlanMap[index]['act_status'] ?? 0,
          uploadStatus : transPromoPlanMap[index]['upload_status'] ?? 0,
          gcsStatus : transPromoPlanMap[index]['gcs_status'] ?? 0,
          imageFile: null,
      );
    });
  }

  static Future<int> updateTransPromoPlan(int gcsStatus,int promoId,String workingId,String imageName,String promoStatus,String promoReason) async {

    String writeQuery = 'UPDATE trans_promoplan SET act_status=1,gcs_status=$gcsStatus, image_name=${wrapIfString(imageName)},promo_reason=${wrapIfString(promoReason)},promo_status=${wrapIfString(promoStatus)},upload_status=0 WHERE sku_id=$promoId and working_id=$workingId';
    var db = await initDataBase();
    print('_______________UpdATE Promo Plan________________');
    print(writeQuery);

    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawUpdate(writeQuery);
    // }
  }

  static Future<PromoPlanGraphAndApiCountShowModel> getPromoGraphAndApiCount(String workingId,) async {

    final db = await initDataBase();
    String query = 'SELECT count(DISTINCT sku_id) as total_promo, '
        'sum(CASE WHEN act_status = 1 AND promo_status="Yes" THEN 1 ELSE 0 END) As total_deployed, '
        'sum(CASE WHEN act_status = 1 AND promo_status="No" THEN 1 ELSE 0 END) As total_not_deployed, '
        'sum(CASE WHEN act_status = 0 THEN 1 ELSE 0 END) As total_pending, '
        'sum(CASE WHEN act_status = 1 AND upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        'sum(CASE WHEN act_status=1 AND upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        ' FROM trans_promoplan '
        ' WHERE working_id=$workingId ';

    print(query);

    final List<Map<String, dynamic>> promoGraphAndApiCount = await db.rawQuery(query);
    print(jsonEncode(promoGraphAndApiCount));
    return PromoPlanGraphAndApiCountShowModel(
        totalPromoPLan: promoGraphAndApiCount[0]['total_promo'] ?? 0,
        totalDeployed: promoGraphAndApiCount[0]['total_deployed'] ?? 0,
        totalNotDeployed: promoGraphAndApiCount[0]['total_not_deployed'] ?? 0,
        totalPending: promoGraphAndApiCount[0]['total_pending'] ?? 0,
        totalUploadCount: promoGraphAndApiCount[0]['total_uploaded'] ?? 0,
        totalNotUploadCount: promoGraphAndApiCount[0]['total_not_uploaded'] ?? 0
    );
  }

  static Future<List<SavePromoPlanDataListData>> getPromoPlansListDataForAPi(String workingId) async {
    final db = await initDataBase();

    String rawQuery = 'SELECT sys_product.client_id as api_client_id,trans_promoplan.*'
        ' FROM trans_promoplan '
        ' join sys_product on sys_product.id=trans_promoplan.sku_id '
        ' WHERE working_id=$workingId AND upload_status=0 AND gcs_status=1 ';

    print('Freshness QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> freshnessMap = await db.rawQuery(rawQuery);
    print(freshnessMap);
    return List.generate(freshnessMap.length, (index) {
      return SavePromoPlanDataListData(
          skuId: freshnessMap[index]['sku_id'],
          clientId: freshnessMap[index]['api_client_id'],
          promoId: freshnessMap[index]['sku_id'],
          deployed: freshnessMap[index]['promo_status'],
          reason: freshnessMap[index]['promo_reason'] == '-1' ? '' : freshnessMap[index]['promo_reason'],
          imageName: freshnessMap[index]['image_name'],

      );
    });
  }

  static Future<int> updatePromoPlanAfterGcsImageUpload(String workingId,String promoId) async {
    String writeQuery = 'UPDATE trans_promoplan SET gcs_status=1 WHERE working_id=$workingId AND sku_id = $promoId';

    var db = await initDataBase();
    print('_______________UpdATE GCS Promoplan________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  //trans stock list
  static Future<List<TransStockModel>> getDataListStock(String workingId, String clientId, String jpSessionClientIds, String brandId, String categoryId, String subCategoryId) async {

    String searchOtherExclude = '';
    String otherExclSearchParam = await getOtherExcludesString(workingId);
    print(otherExclSearchParam);

    if(otherExclSearchParam.isNotEmpty) {
      searchOtherExclude = 'And sys_product.id not in ($otherExclSearchParam)';
    }


    String searchWhere = '';
    String clientIds = '';
    if (clientId != '-1') {
      clientIds = clientId;
    } else {
      clientIds = jpSessionClientIds;
    }
    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_product.brand_id = "$brandId"';
    }
    if (subCategoryId != '-1') {
      searchWhere =
      '$searchWhere And sys_product.subcategory_id = "$subCategoryId"';
    }
    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.category_id = "$categoryId"';
    }
    print('Sub Category FIlter');
    print(searchWhere);
    final db = await initDataBase();
    String query = 'SELECT IFNULL(SUM(outer),0) as total_outer,IFNULL(SUM(cases),0) as total_cases,IFNULL(SUM(pieces),0) as total_pieces, SystemTable.*,TransTable.act_status From (SELECT sys_product.id as pro_id,'
        ' sys_product.en_name as pro_en_name,sys_product.client_id,'
        ' sys_product.ar_name as pro_ar_name,sys_category.en_name  ||  "  " ||  sys_subcategory.en_name as cat_en_name,'
        ' sys_category.ar_name as cat_ar_name,'
        ' sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,sys_product.image,'
        ' sys_product.rsp, sys_subcategory.en_name as sub_category,sys_brand.en_name as brand'
        ' from sys_product'
        ' JOIN sys_category on sys_category.id=sys_product.category_id'
        ' JOIN sys_subcategory on sys_subcategory.id=sys_product.subcategory_id'
        ' JOIN sys_brand on sys_brand.id=sys_product.brand_id'
        ' WHERE 1=1 And sys_product.client_id in ($clientIds) $searchOtherExclude $searchWhere) SystemTable'
        ' LEFT JOIN (SELECT sku_id,act_status,cases,outer,pieces FROM trans_stock WHERE working_id=$workingId) TransTable '
        ' on SystemTable.pro_id = TransTable.sku_id'
        ' GROUP BY SystemTable.pro_id ORDER BY sub_category,brand ASC';

    print(query);
    print('-------------------- Stock --------------------');

    final List<Map<String, dynamic>> pricingMap = await db.rawQuery(query);
    return List.generate(pricingMap.length, (index) {
      return TransStockModel(
          pro_id: pricingMap[index]['pro_id'] as int,
          cat_en_name: pricingMap[index]['cat_en_name'] ?? '',
          cat_ar_name: pricingMap[index]['cat_ar_name'] ?? '',
          pro_en_name: pricingMap[index]['pro_en_name'] ?? '',
          pro_ar_name: pricingMap[index]['pro_ar_name'] ?? '',
          img_name: pricingMap[index]['image'] ?? '',
          rsp: pricingMap[index]['rsp'] ?? '',
          brand_en_name: pricingMap[index]['brand_en_name'] ?? '',
          brand_ar_name: pricingMap[index]['brand_ar_name'] ?? '',
          upload_status: pricingMap[index]['upload_status'] ?? 0,
          act_status: pricingMap[index]['act_status'] ?? 0,
          cases: pricingMap[index]['total_cases'] ?? 0,
          outer: pricingMap[index]['total_outer'] ?? 0,
          pieces: int.parse(pricingMap[index]['total_pieces'].toString()),
          client_id: pricingMap[index]['client_id'] ?? '');
    });
  }

  static Future<int> updateTransStockAfterDeleteOneSkuRecord(String workingId,String promoId) async {
    String writeQuery = 'UPDATE trans_stock SET act_status=0, cases=0,outer=0,pieces=0 WHERE working_id=$workingId AND sku_id = $promoId';

    var db = await initDataBase();
    print('_______________UpdATE Stock Sku After Delete on record________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<TotalStockCountData> getStockCount(String workingId, String clientId, String brandId, String categoryId, String subCategoryId) async {

    String searchWhere = '';

    if (clientId != '-1') {
      searchWhere = '$searchWhere And sys_product.client_id = "$clientId"';
    } else {
    }

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_product.brand_id = "$brandId"';
    }
    if (subCategoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.subcategory_id = "$subCategoryId"';
    }
    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.category_id = "$categoryId"';
    }

    final db = await initDataBase();
    String query = 'SELECT count(DISTINCT sku_id) as total_stock_taken,'
        ' sum(cases) As total_cases,'
        ' sum(outer) As total_outer,'
        ' sum(pieces) As total_pieces,'
        ' sum(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded,'
        ' sum(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded'
        ' FROM trans_stock'
        ' join sys_product on sys_product.id=trans_stock.sku_id'
        ' WHERE working_id=$workingId $searchWhere';
    print(query);
    final List<Map<String, dynamic>> stockGraphCount = await db.rawQuery(query);
    print(jsonEncode(stockGraphCount));
    return TotalStockCountData(
        total_stock_taken: stockGraphCount[0]['total_stock_taken'] ?? 0,
        total_cases: stockGraphCount[0]['total_cases'] ?? 0,
        total_outers: stockGraphCount[0]['total_outer'] ?? 0,
        total_pieces: stockGraphCount[0]['total_pieces'] ?? 0,
        total_not_upload: stockGraphCount[0]['total_not_uploaded'] ?? 0,
        total_uploaded: stockGraphCount[0]['total_uploaded'] ?? 0);
  }

  static Future<int> insertTransStockeCheck(int skuId, int cases, int outer,int pieces, String workingID,String dateTime,String clientId) async {
    String insertQuery = '''
  INSERT INTO trans_stock (sku_id, cases,client_id, outer,pieces,upload_status,act_status, date_time, working_id)
  VALUES ($skuId, $cases, 0,$outer, $pieces,0,1,${wrapIfString(dateTime)},$workingID)
''';

    var db = await initDataBase();
    print('_______________INSERT Trans stock________________');
    print(insertQuery);
    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      return await db.rawInsert(insertQuery);
    // }
  }

  static Future<List<SaveStockListData>> getStockDataListFromApi(String workingId) async {

    final db = await initDataBase();

    String rawQuery = 'SELECT sys_product.client_id as api_client_id,trans_stock.*'
        ' FROM trans_stock '
        ' join sys_product on sys_product.id=trans_stock.sku_id '
        ' WHERE working_id=$workingId AND upload_status=0 ';

    print('Stock QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> freshnessMap = await db.rawQuery(rawQuery);
    print(freshnessMap);
    return List.generate(freshnessMap.length, (index) {
      return SaveStockListData(
          skuId: freshnessMap[index]['sku_id'],
          clientId: freshnessMap[index]['api_client_id'],
          dateTime: freshnessMap[index]['date_time'] ?? '',
          cases: freshnessMap[index]['cases'],
          outer: freshnessMap[index]['outer'],
          pieces: freshnessMap[index]['pieces']
      );
    });
  }

  static Future<int> updateStockAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_stock SET upload_status=1 WHERE working_id=$workingId AND date_time in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE Stock________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updatePromoPlanAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_promoplan SET upload_status = 1 WHERE working_id=$workingId AND sku_id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE API Planoguide________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<List<TransPlanoGuideGcsImagesListModel>> getPromoPlanGcsImagesList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT sku_id, image_name '
        ' FROM trans_promoplan WHERE working_id=$workingId AND gcs_status=0 AND image_name!= ""';

    print('Promo Plan QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(rawQuery);
    print(rtvMap);
    print('Promo Plan Images List');
    return List.generate(rtvMap.length, (index) {
      return TransPlanoGuideGcsImagesListModel(
          id: rtvMap[index]['sku_id'],
          imageName: rtvMap[index]['image_name'],
          imageFile: null
      );
    });
  }


  ///Dashboard Data List

  static Future<UserDashboardModel> getMainDashboardData(String userId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> dashboardMap = await db.rawQuery(
        'SELECT * FROM sys_dashboard WHERE user_id=$userId');

    print(jsonEncode(dashboardMap));
    print('________ Dashboard Data Getting ________________');
      return UserDashboardModel(
        user_id: dashboardMap[0]['user_id'] ?? 0,
        jp_planned: dashboardMap[0]['jp_planned'] ?? 0,
        jp_visited: dashboardMap[0]['jp_visited'] ?? 0,
        out_of_planned: dashboardMap[0]['out_of_planned'] ?? 0,
        out_of_planned_visited: dashboardMap[0]['out_of_planned_visited'] ?? 0,
        jpc: dashboardMap[0]['jpc'] ?? 0,
        pro: dashboardMap[0]['pro'] ?? 0,
        working_hrs: dashboardMap[0]['working_hrs'] ?? 0,
        eff: dashboardMap[0]['eff'] ?? 0,
        monthly_attend: dashboardMap[0]['monthly_attend'] ?? 0,
        monthly_pro: dashboardMap[0]['monthly_pro'] ?? 0,
        monthly_eff: dashboardMap[0]['monthly_eff'] ?? 0,
        monthly_incentives: dashboardMap[0]['monthly_incentives'] ?? 0,
        monthly_deduction: dashboardMap[0]['monthly_deduction'] ?? 0,
      );
  }

  ///Journey Plan Data List

  static Future<List<JourneyPlanDetail>> getJourneyPlanData(String userId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> journeyPlanMap = await db.rawQuery(
        'SELECT * FROM sys_journey_plan WHERE user_id=$userId');

    print(jsonEncode(journeyPlanMap));
    print('________ Journey Plan Data Getting ________________');

    return List.generate(journeyPlanMap.length, (index) {
      return JourneyPlanDetail(
          workingId: journeyPlanMap[index]['working_id'] ?? 0,
          workingDate: journeyPlanMap[index]['working_date'].toString(),
          storeId: journeyPlanMap[index]['store_id'] ?? 0,
          enStoreName: journeyPlanMap[index]['en_store_name'].toString(),
          arStoreName: journeyPlanMap[index]['ar_store_name'].toString(),
          gcode: journeyPlanMap[index]['gcode'].toString(),
          clientIds: journeyPlanMap[index]['client_id'].toString(),
          userId: journeyPlanMap[index]['user_id'] ?? 0,
          checkIn: journeyPlanMap[index]['check_in'] ?? '',
          checkOut: journeyPlanMap[index]['check_out'] ?? '',
          startVisitPhoto: journeyPlanMap[index]['start_visit_photo'].toString() == 'null' ? '' :journeyPlanMap[index]['start_visit_photo'].toString() ,
          checkinGps: journeyPlanMap[index]['checkin_gps'].toString(),
          checkoutGps: journeyPlanMap[index]['checkout_gps'].toString(),
          visitStatus: journeyPlanMap[index]['visit_status'].toString(),
          visitType: journeyPlanMap[index]['visit_type'].toString(),
          avlExclude: journeyPlanMap[index]['avl_exclude'].toString(),
          otherExclude: journeyPlanMap[index]['other_exculde'].toString(),
          isDrop: journeyPlanMap[index]['is_drop'] ?? 0,
          visitActivity: journeyPlanMap[index]['visit_activity_type'] ?? 0
      );
    });
  }

  ///Universe Data List

  static Future<List<SysStoreModel>> getUniverseStoreData(String searchItem) async {
    final db = await initDataBase();

    String searchStart = "";
    String searchWhere = "";
    String searchWordStart = "$searchItem%";

    String searchWordMiddle = "%$searchItem%";

    if(searchItem.isNotEmpty) {
      searchStart = ' WHERE en_name LIKE ${wrapIfString(searchWordStart)} ';

      searchWhere = ' WHERE en_name LIKE ${wrapIfString(searchWordMiddle)} AND en_name NOT LIKE ${wrapIfString(searchWordStart)}';

    }

    String query = ' SELECT * FROM sys_stores $searchStart UNION SELECT * FROM sys_stores $searchWhere ORDER BY en_name';

    final List<Map<String, dynamic>> universeMap = await db.rawQuery(query);

    print("-----------------------------------------------");
    print(query);
    print('________ Universe Data Getting ________________');

    return List.generate(universeMap.length, (index) {
      return SysStoreModel(
        id: universeMap[index][TableName.sysId],
        en_name: universeMap[index][TableName.enName],
        ar_name: universeMap[index][TableName.arName],
        gcode: universeMap[index][TableName.sysStoreGcode],
        region_id: universeMap[index][TableName.sysStoreRegionId],
        region_name: universeMap[index][TableName.sysStoreRegionName],
        city_id: universeMap[index][TableName.sysStoreCityId],
        city_name: universeMap[index][TableName.sysStoreCityName],
        chain_id: universeMap[index][TableName.chain_id],
        chain_name: universeMap[index][TableName.sysStoreChainName],
        channel_id: universeMap[index][TableName.sysStoreChannelId],
        channel_id6: universeMap[index][TableName.sysStoreChannelId6],
        channel_id7: universeMap[index][TableName.sysStoreChannelId7],
        type_id: universeMap[index][TableName.type_id],
      );
    });
  }

  ///Delete Data from tabkle with workingId
  static Future<void> deleteTransTableByWorkingId(String tblName, String workingId) async {
    var db = await initDataBase();
    await db.delete(tblName, where: 'working_id = ?', whereArgs: [workingId]);
    print('Table data delet $tblName,  $workingId');
  }

  static Future<void> insertTransPOS(TransAddProfOfSale transAddProfOfSale) async {
    var db = await initDataBase();
    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      await db.insert(
        TableName.tblTransPOS,
        transAddProfOfSale.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }

  static Future<List<ShowProofOfSaleModel>> getTransPOS(String workingId) async {

    final db = await initDataBase();
    final List<Map<String, dynamic>> posData = await db.rawQuery(
        'Select  trans_proof_of_sale.*,sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name,'
            ' sys_category.en_name as cat_en_name, sys_category.ar_name as cat_ar_name'
            ' From trans_proof_of_sale'
            ' JOIN sys_product on sys_product.id = trans_proof_of_sale.sku_id'
            ' JOIN sys_category on sys_category.id = sys_product.category_id'
            ' WHERE working_id=$workingId');
    print('__________________TransPos__________________');
    print(jsonEncode(posData));

    return List.generate(posData.length, (index) {
      return ShowProofOfSaleModel(
          id: posData[index][TableName.sysId] ?? 0,
          sku_id: posData[index][TableName.skuId] ?? 0,
          client_id: posData[index][TableName.clientIds] ?? 0,
          dateTime: posData[index][TableName.dateTime] ?? '',
          qty: posData[index][TableName.quantity] ?? 0,
          gcs_status: posData[index][TableName.gcsStatus] ?? 0,
          upload_status: posData[index][TableName.uploadStatus] ?? 0,
          cat_en_name: posData[index]['cat_en_name'] ?? '',
          cat_ar_name: posData[index]['cat_ar_name'] ?? '',
          pro_en_name: posData[index]['pro_en_name'] ?? '',
          pro_ar_name: posData[index]['pro_en_name'] ?? '',
          image_name: posData[index][TableName.imageName] ?? '',
          name: posData[index][TableName.trans_pos_name] ?? '',
          email: posData[index][TableName.trans_pos_email] ?? '',
          amount: posData[index][TableName.trans_pos_amount] ?? '',
          phone: posData[index][TableName.trans_pos_phone] ?? '');
    });
  }

  ///Get POS COUNT RECORDS FOR API UPLOAD
  static Future<PosCountModel> getPosCountDataServices(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT COUNT(DISTINCT sku_id) as total_pos_pro, '
        ' SUM(qty) as total_quantity, SUM(amount) as total_amount, '
        ' SUM(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        ' SUM(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        ' FROM trans_proof_of_sale'
        ' JOIN sys_product on sys_product.id = trans_proof_of_sale.sku_id'
        ' WHERE working_id=$workingId '));

    print(jsonEncode(result));
    print('____________POS Count_______________');
    return  PosCountModel(
      totalPosItems: result[0]['total_pos_pro'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
      quantity: result[0]['total_quantity'] == null ? 0 : result[0]['total_quantity'].round(),
      amount: result[0]['total_amount'] == null ? 0 : result[0]['total_amount'].round(),
    );
  }

  ///Pos Image List For GCS Upload
  static Future<List<TransPlanoGuideGcsImagesListModel>> getPosGcsImagesList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT sku_id, image_name'
        ' FROM trans_proof_of_sale WHERE working_id=$workingId AND gcs_status=0';

    print('POS GCS IMAGES LIST QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(rawQuery);
    print(rtvMap);
    print('POS Images List');
    return List.generate(rtvMap.length, (index) {
      return TransPlanoGuideGcsImagesListModel(
          id: rtvMap[index]['sku_id'],
          imageName: rtvMap[index]['image_name'],
          imageFile: null
      );
    });
  }

  static Future<List<SavePosListData>> getTransPosApiUploadDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = ' SELECT trans_proof_of_sale.*,sys_product.client_id '
        ' From trans_proof_of_sale'
        ' JOIN sys_product on sys_product.id = trans_proof_of_sale.sku_id'
        ' WHERE working_id=$workingId AND upload_status=0';

    print('Trans POS QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> posMap = await db.rawQuery(rawQuery);
    print(jsonEncode(posMap));
    print('POS DATA LIST FOR API');
    return List.generate(posMap.length, (index) {
      return SavePosListData(
          skuId: posMap[index][TableName.skuId],
          name: posMap[index][TableName.trans_pos_name].toString(),
          email: posMap[index][TableName.trans_pos_email],
          phoneNo: posMap[index][TableName.trans_pos_phone],
          clientId: posMap[index][TableName.clientIds],
          imageName: posMap[index][TableName.imageName],
          amount: int.parse(posMap[index][TableName.trans_pos_amount]),
          quantity: posMap[index][TableName.quantity],
      );
    });
  }

  ///Update GCS status after images upload
  static Future<int> updatePosAfterGcsImageUpload(String workingId,String promoId) async {
    String writeQuery = 'UPDATE trans_proof_of_sale SET gcs_status=1 WHERE working_id=$workingId AND sku_id = $promoId';

    var db = await initDataBase();
    print('_______________UpdATE GCS POS________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  ///Delete POS
  static Future<dynamic> deletePos(String workingId,int promoId) async {
    String writeQuery = 'DELETE FROM trans_proof_of_sale WHERE working_id=$workingId AND sku_id = $promoId';

    var db = await initDataBase();
    print('_______________UpdATE GCS POS________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  /// Update POS After API
  static Future<int> updatePosAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_proof_of_sale SET upload_status=1 WHERE working_id=$workingId AND sku_id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE POS________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<List<Sys_PhotoTypeModel>> getSkusList(int catId,String workingId) async {

    String searchOtherExclude = '';
    String otherExclSearchParam = await getOtherExcludesString(workingId);
    print(otherExclSearchParam);

    if(otherExclSearchParam.isNotEmpty) {
      searchOtherExclude = 'And sys_product.id not in ($otherExclSearchParam)';
    }

    final db = await initDataBase();
    final List<Map<String, dynamic>> photoTypeMaps = await db.rawQuery(
        'SELECT sys_product.id,sys_product.en_name,sys_product.ar_name from sys_product where sys_product.category_id=$catId $searchOtherExclude ORDER BY category_id,brand_id ASC');
    print(jsonEncode(photoTypeMaps));
    print('________Photo type List ________________');
    return List.generate(photoTypeMaps.length, (index) {
      return Sys_PhotoTypeModel(
        id: photoTypeMaps[index]['id'] as int,
        en_name: photoTypeMaps[index]['en_name'] as String,
        ar_name: photoTypeMaps[index]['ar_name'] as String,
      );
    });
  }

  static Future<void> insertTransRtvOnePlusOne(TransRtvOnePlusOneModel transRtvModel) async {
    var db = await initDataBase();
    //GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

    // if(generalStatusController.isVpnStatus.value) {
    //   throw FetchDataException('Please Disable Your VPN'.tr);
    // } else if(generalStatusController.isMockLocation.value) {
    //   throw FetchDataException('Please Disable Your Fake Locator'.tr);
    // } else if(!generalStatusController.isAutoTimeStatus.value) {
    //   throw FetchDataException('Please Enable Your Auto time Option From Setting'.tr);
    // } else if(!generalStatusController.isLocationStatus.value) {
    //   throw FetchDataException('Please Enable Your Location'.tr);
    // } else {
    //
    //   Get.delete<GeneralChecksStatusController>();

      await db.insert(
        TableName.tblTransOnePlusOne,
        transRtvModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    // }
  }

  static Future<List<RTVShowModel>> getDataListRTVOnePlusOne(String workingId, String clientId, String jpSessionClientIds, String brandId, String categoryId, String subCategoryId) async {
    String searchWhere = '';
    String clientIds = '';
    if (clientId != '-1') {
      clientIds = clientId;
    } else {
      clientIds = jpSessionClientIds;
    }

    if (brandId != '-1') {
      searchWhere = '$searchWhere And sys_product.brand_id = "$brandId"';
    }
    if (subCategoryId != '-1') {
      searchWhere =
      '$searchWhere And sys_product.subcategory_id = "$subCategoryId"';
    }
    if (categoryId != '-1') {
      searchWhere = '$searchWhere And sys_product.category_id = "$categoryId"';
    }

    final db = await initDataBase();
    String query =
        'SELECT SystemTable.*,TransTable.act_status From (SELECT sys_product.id as pro_id, '
        'sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name, '
        'sys_category.en_name  ||  "  " ||  sys_subcategory.en_name as cat_en_name, sys_category.ar_name as cat_ar_name, '
        'sys_brand.en_name as brand_en_name,sys_brand.ar_name as brand_ar_name,sys_product.image, sys_product.rsp, sys_subcategory.en_name as sub_category,sys_brand.en_name as brand '
        'from sys_product '
        'JOIN sys_category on sys_category.id=sys_product.category_id '
        'JOIN sys_subcategory on sys_subcategory.id=sys_product.subcategory_id '
        'JOIN sys_brand on sys_brand.id=sys_product.brand_id '
        'WHERE 1=1 And sys_product.client_id in ($clientIds) And sys_product.id '
        'not in (11000,11001,11002) $searchWhere ) SystemTable '
        'LEFT JOIN ( SELECT sku_id,act_status FROM trans_one_plus_one WHERE working_id=$workingId ) TransTable '
        'on SystemTable.pro_id = TransTable.sku_id GROUP BY SystemTable.pro_id ORDER BY SystemTable.sub_category,SystemTable.brand ASC';
    print('show rtv_query');
    print(query);
    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(query);
    print(rtvMap);
    return List.generate(rtvMap.length, (index) {
      return RTVShowModel(
        pro_id: rtvMap[index]['pro_id'] as int,
        cat_en_name: rtvMap[index]['cat_en_name'] ?? '',
        cat_ar_name: rtvMap[index]['cat_ar_name'] ?? '',
        pro_en_name: rtvMap[index]['pro_en_name'] ?? '',
        pro_ar_name: rtvMap[index]['pro_ar_name'] ?? '',
        img_name: rtvMap[index]['image'] ?? '',
        rsp: rtvMap[index]['rsp'] ?? '',
        brand_en_name: rtvMap[index]['brand_en_name'] ?? '',
        brand_ar_name: rtvMap[index]['brand_ar_name'] ?? '',
        rtv_taken: rtvMap[index]['rtv_taken'] ?? 0,
        pieces: rtvMap[index]['pieces'] ?? 0,
        act_status: rtvMap[index]['act_status'] ?? 0,
        imageFile: null,
      );
    });
  }

  static Future<List<TransOnePlusOneModel>> getTransRTVOnePluOneDataList(String workingId) async {
    final db = await initDataBase();
    String query =
        ' SELECT trans_one_plus_one.id as trans_id,sys_product.en_name as pro_en_name, sys_product.ar_name as pro_ar_name,trans_one_plus_one.date_time,'
        ' trans_one_plus_one.gcs_status,trans_one_plus_one.upload_status,trans_one_plus_one.image_name,trans_one_plus_one.doc_image,'
        ' trans_one_plus_one.pieces,trans_one_plus_one.doc_no,trans_one_plus_one.comment,trans_one_plus_one.type'
        ' from trans_one_plus_one'
        ' Join sys_product on sys_product.id  = trans_one_plus_one.sku_id'
        ' WHERE working_id=$workingId ORDER BY date_time DESC';
    print(query);
    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(query);
    print(jsonEncode(rtvMap));
    print('___One Plus One Data List _______');
    return List.generate(rtvMap.length, (index) {
      return TransOnePlusOneModel(
          id: rtvMap[index]['trans_id'] ?? 0,
          pieces: rtvMap[index]['pieces'] ?? 0,
          pro_en_name: rtvMap[index]['pro_en_name'] ?? '',
          pro_ar_name: rtvMap[index]['pro_ar_name'] ?? '',
          doc_no: rtvMap[index]['doc_no'] ?? '',
          comment: rtvMap[index]['comment'] ?? '',
          type: rtvMap[index]['type'] ?? '',
          date_time: rtvMap[index]['date_time'] ?? '',
          doc_image: rtvMap[index]['doc_image'] ?? '',
          image_name: rtvMap[index]['image_name'] ?? '',
          working_id: rtvMap[index]['working_id'] ?? 0,
          upload_status: rtvMap[index]['upload_status'] ?? 0,
          gcs_status: rtvMap[index]['gcs_status'] ?? 0,
          act_status: rtvMap[index]['act_status'] ?? 0,
          imageFile: null,
          imageFileDoc: null);
    });
  }

  ///Get One Plus One COUNT RECORDS FOR API UPLOAD
  static Future<RtvCountModel> getOnePLusOneCountDataServices(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT COUNT(DISTINCT sku_id) as total_one_plus_one_pro,'
        ' sum(pieces) as total_volume, SUM(total_value) as total_value, sum(total_not_uploaded) as total_not_uploaded, sum(total_uploaded) as total_uploaded FROM '
        ' (SELECT sku_id, trans_one_plus_one.pieces as pieces ,SUM(trans_one_plus_one.pieces * sys_product.rsp) as total_value, '
        ' sum(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        ' sum(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        ' from trans_one_plus_one'
        ' join sys_product on sys_product.id=trans_one_plus_one.sku_id'
        ' WHERE working_id=$workingId GROUP by trans_one_plus_one.id  ) A'));

    print(jsonEncode(result));
    print('____________One Plus One Count_______________');
    return  RtvCountModel(
      totalRtv: result[0]['total_one_plus_one_pro'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
      totalValue: result[0]['total_value'] == null ? 0 : result[0]['total_value'].round(),
      totalVolume: result[0]['total_volume'] == null ? 0 : result[0]['total_volume'].round(),
    );
  }

  ///One Plus One Image List For GCS Upload
  static Future<List<TransOnePlusOneGcsImagesListModel>> getOnePlusOneGcsImagesList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT id, image_name,doc_image'
        ' FROM trans_one_plus_one WHERE working_id=$workingId AND gcs_status=0';

    print('One Plus One GCS IMAGES LIST QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(rawQuery);
    print(rtvMap);
    print('One Plus One Images List');
    return List.generate(rtvMap.length, (index) {
      return TransOnePlusOneGcsImagesListModel(
          id: rtvMap[index]['id'],
          imageName: rtvMap[index]['image_name'],
          docImageName: rtvMap[index]['doc_image'],
          imageFile: null,
          docImageFile: null,
      );
    });
  }

  static Future<List<SaveOnePlusOneListData>> getTransOnePlusPneApiUploadDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT * '
        ' FROM trans_one_plus_one WHERE working_id=$workingId AND upload_status=0';

    print('Trans One Plus One QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> posMap = await db.rawQuery(rawQuery);
    print(jsonEncode(posMap));
    print('One Plus One DATA LIST FOR API');
    return List.generate(posMap.length, (index) {
      return SaveOnePlusOneListData(
        id: posMap[index][TableName.sysId],
        skuId: posMap[index][TableName.skuId],
        pieces: posMap[index][TableName.pieces],
        type: posMap[index][TableName.trans_one_plus_one_type].toString(),
        imageName: posMap[index][TableName.imageName],
        docImage: posMap[index][TableName.trans_one_plus_one_doc_image],
        docNumber: posMap[index][TableName.trans_one_plus_one_doc_no].toString(),

      );
    });
  }

  ///Update One PLus One GCS status after images upload
  static Future<int> updateOnePlusOneAfterGcsImageUpload(String workingId,String promoId) async {
    String writeQuery = 'UPDATE trans_one_plus_one SET gcs_status=1 WHERE working_id=$workingId AND id = $promoId';

    var db = await initDataBase();
    print('_______________UpdATE GCS OnePlusOne________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  /// Update One Plus One After API
  static Future<int> updateOnePlusOneAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_one_plus_one SET upload_status=1 WHERE working_id=$workingId AND id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE OnePlusOne________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<List<KnowledgeShareModel>> getKnowledgeShareList(String clientId) async {
    var db = await initDataBase();
    final List<Map<String, dynamic>> knowledgeList = await db.rawQuery(
        'Select * FROM sys_knowledge_share WHERE client_id in($clientId)');
    return List.generate(knowledgeList.length, (index) {
      return KnowledgeShareModel(
          id:knowledgeList[index][TableName.sysId] ?? 0,
          client_id: knowledgeList[index][TableName.clientIds] ?? 0,
          chain_id: knowledgeList[index][TableName.chain_id] ?? 0,
          title: knowledgeList[index][TableName.sys_knowledge_title] ?? '',
          description: knowledgeList[index][TableName.sys_knowledge_des] ?? '',
          added_by: knowledgeList[index][TableName.sysKnowledgeAddedBy] ?? '',
          file_name: knowledgeList[index][TableName.sysKnowledgeFileName] ?? '',
          type: knowledgeList[index][TableName.sysKnowledgeType] ?? '',
          active: knowledgeList[index][TableName.sysKnowledgeActive] ?? '',
          updated_at: knowledgeList[index][TableName.sysIssueUpdateAt] ?? '');
    });
  }

  /// Insert Knowledge Share
  static Future<bool> insertSysKnowledgeShareArray(List<KnowledgeShareModel> modelList) async {
    var db = await initDataBase();

    for (KnowledgeShareModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sysId: data.id,
        TableName.sys_knowledge_title: data.title,
        TableName.sys_knowledge_des: data.description,
        TableName.clientIds: data.client_id,
        TableName.chain_id: data.chain_id,
        TableName.sysKnowledgeAddedBy: data.added_by,
        TableName.sysKnowledgeFileName: data.file_name,
        TableName.sysKnowledgeType: data.type,
        TableName.sysKnowledgeActive: data.active,
        TableName.sysIssueUpdateAt: data.updated_at,
      };

      bool isDuplicate =
      await hasDuplicateEntry(db, TableName.tblSysKnowledgeShare, fields);
      if (isDuplicate) {
        print('Error: Duplicate entry knowledgeshare');
      } else {
        await db.insert(
          TableName.tblSysKnowledgeShare,
          {
            TableName.sysId: data.id,
            TableName.sys_knowledge_title: data.title,
            TableName.sys_knowledge_des: data.description,
            TableName.clientIds: data.client_id,
            TableName.chain_id: data.chain_id,
            TableName.sysKnowledgeAddedBy: data.added_by,
            TableName.sysKnowledgeFileName: data.file_name,
            TableName.sysKnowledgeType: data.type,
            TableName.sysKnowledgeActive: data.active,
            TableName.sysIssueUpdateAt: data.updated_at,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        print('Sys Promo Plan Item');
        print(jsonEncode(data));
      }
    }
    return false;
  }

  static Future<List<ShowMarketIssueModel>> getTransMarketIssue(String workingId) async {
    print('__________________TransMarketIssue__________________');
    final db = await initDataBase();
    final List<Map<String, dynamic>> issueData = await db.rawQuery(
        'Select trans_market_issue.*,sys_market_issues.name,sys_market_issues.updated_at'
            '  From trans_market_issue'
            ' JOIN sys_market_issues on sys_market_issues.id = trans_market_issue.issue_id'
            ' WHERE working_id=$workingId');
    print(jsonEncode(issueData));
    return List.generate(issueData.length, (index) {
      return ShowMarketIssueModel(
          id: issueData[index][TableName.sysId] ?? 0,
          image: issueData[index][TableName.imageName] ?? '',
          Issuetype: issueData[index][TableName.trans_pos_name] ?? '',
          gcs_status: issueData[index][TableName.gcsStatus] ?? 0,
          upload_status: issueData[index][TableName.uploadStatus] ?? 0,
          comment: issueData[index][TableName.trans_one_plus_one_comment] ?? '',
          update_at: issueData[index][TableName.sysIssueUpdateAt] ?? '');
    });
  }

  static Future<List<sysMarketIssueModel>> getMarketIssueDropDownList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> issueModel =
    await db.rawQuery('SELECT *FROM sys_market_issues WHERE status=1');
    print(jsonEncode(issueModel));
    return List.generate(issueModel.length, (index) {
      return sysMarketIssueModel(
          id: issueModel[index]['id'] ?? 0,
          name: issueModel[index]['name'] ?? '',
          status: issueModel[index]['status'] ?? 0,
          updated_at: issueModel[index]['updated_at'] ?? '');
    });
  }

  static Future<bool> insertMarketIssueArray(List<sysMarketIssueModel> modelList) async {
    var db = await initDataBase();
    for (sysMarketIssueModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sysId: data.id,
        TableName.trans_pos_name: data.name,
        TableName.status: data.status,
        TableName.sysIssueUpdateAt: data.updated_at,
      };
      bool isDuplicate =
      await hasDuplicateEntry(db, TableName.tblSysMarketIssue, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry market issue');
      } else {
        print('Market Issue Insertion');
        await db.insert(
          TableName.tblSysMarketIssue,
          {
            TableName.sysId: data.id,
            TableName.trans_pos_name: data.name,
            TableName.status: data.status,
            TableName.sysIssueUpdateAt: data.updated_at,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }

  ///Get Market Issue COUNT RECORDS FOR API UPLOAD
  static Future<OsdAndMarketIssueCountModel> getMarketIssueCountDataServices(String workingId) async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> result = (await db.rawQuery('SELECT COUNT(id) as total_market_issue_pro, '
        ' SUM(CASE WHEN upload_status = 0 THEN 1 ELSE 0 END) As total_not_uploaded, '
        ' SUM(CASE WHEN upload_status = 1 THEN 1 ELSE 0 END) As total_uploaded '
        ' FROM trans_market_issue '
        ' WHERE working_id=$workingId '));

    print(jsonEncode(result));
    print('____________Market Issue Count_______________');
    return  OsdAndMarketIssueCountModel(
      totalItems: result[0]['total_market_issue_pro'] ?? 0,
      totalNotUpload: result[0]['total_not_uploaded'] ?? 0,
      totalUpload: result[0]['total_uploaded'] ?? 0,
    );
  }

  ///Market Issue Image List For GCS Upload
  static Future<List<TransPlanoGuideGcsImagesListModel>> getMarketIssueGcsImagesList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT id, image_name'
        ' FROM trans_market_issue WHERE working_id=$workingId AND gcs_status=0';

    print('Market ISSue QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> rtvMap = await db.rawQuery(rawQuery);
    print(rtvMap);
    print('Market Issue Images List');
    return List.generate(rtvMap.length, (index) {
      return TransPlanoGuideGcsImagesListModel(
          id: rtvMap[index]['id'],
          imageName: rtvMap[index]['image_name'],
          imageFile: null
      );
    });
  }

  static Future<List<SaveMarketIssueListData>> getTransMarketIssueApiUploadDataList(String workingId) async {
    final db = await initDataBase();
    String rawQuery = 'SELECT * '
        ' FROM trans_market_issue WHERE working_id=$workingId AND upload_status=0';

    print('Trans Market Value QUERY');
    print(rawQuery);

    final List<Map<String, dynamic>> posMap = await db.rawQuery(rawQuery);
    print(jsonEncode(posMap));
    print('Market Value DATA LIST FOR API');
    return List.generate(posMap.length, (index) {
      return SaveMarketIssueListData(
        id: posMap[index][TableName.sysId],
        issueId: posMap[index][TableName.sys_issue_id],
        comment: posMap[index][TableName.trans_one_plus_one_comment],
        clientId: posMap[index][TableName.clientIds].toString(),
        imageName: posMap[index][TableName.imageName],
      );
    });
  }

  static Future<int> updateMarketIssueAfterGcsImageUpload(String workingId,String promoId) async {
    String writeQuery = 'UPDATE trans_market_issue SET gcs_status=1 WHERE working_id=$workingId AND id = $promoId';

    var db = await initDataBase();
    print('_______________UpdATE GCS Market Issue________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<int> updateMarketIssueAfterApi(String workingId,String ids) async {
    String writeQuery = 'UPDATE trans_market_issue SET upload_status=1 WHERE working_id=$workingId AND id in ($ids)';

    var db = await initDataBase();
    print('_______________UpdATE Market Issue________________');
    print(writeQuery);

    return await db.rawUpdate(writeQuery);
  }

  static Future<bool> insertSysStoreArray(List<SysStoreModel> modelList) async {
    var db = await initDataBase();

    for (SysStoreModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sysId: data.id,
        TableName.enName: data.en_name,
        TableName.arName: data.ar_name,
        TableName.sysStoreGcode: data.gcode,
        TableName.sysStoreRegionId: data.region_name,
        TableName.sysStoreRegionName: data.region_name,
        TableName.sysStoreCityId: data.city_id,
        TableName.sysStoreCityName: data.city_name,
        TableName.chain_id: data.chain_id,
        TableName.sysStoreChainName: data.chain_name,
        TableName.sysStoreChannelId: data.channel_id,
        TableName.sysStoreChannelId6: data.channel_id6,
        TableName.sysStoreChannelId7: data.channel_id7,
        TableName.type_id: data.type_id,
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysStores, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry storess');
      } else {
        await db.insert(
          TableName.tblSysStores,
          {
            TableName.sysId: data.id,
            TableName.enName: data.en_name,
            TableName.arName: data.ar_name,
            TableName.sysStoreGcode: data.gcode,
            TableName.sysStoreRegionId: data.region_id,
            TableName.sysStoreRegionName: data.region_name,
            TableName.sysStoreCityId: data.city_id,
            TableName.sysStoreCityName: data.city_name,
            TableName.chain_id: data.chain_id,
            TableName.sysStoreChainName: data.chain_name,
            TableName.sysStoreChannelId: data.channel_id,
            TableName.sysStoreChannelId6: data.channel_id6,
            TableName.sysStoreChannelId7: data.channel_id7,
            TableName.type_id: data.type_id,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }

  static Future<bool> insertSosUnitArray(List<Sys_OSDCReasonModel> modelList) async {
    var db = await initDataBase();

    for (Sys_OSDCReasonModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sysId: data.id,
        TableName.enName: data.en_name.toString(),
        TableName.arName: data.ar_name.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysSosUnit, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry osdc');
      } else {
        await db.insert(
          TableName.tblSysSosUnit,
          {
            TableName.sysId: data.id,
            TableName.enName: data.en_name.toString(),
            TableName.arName: data.ar_name.toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }

  static Future<bool> insertPromoPlaneReasonArray(List<Sys_OSDCReasonModel> modelList) async {
    var db = await initDataBase();

    for (Sys_OSDCReasonModel data in modelList) {
      Map<String, dynamic> fields = {
        TableName.sysId: data.id,
        TableName.enName: data.en_name.toString(),
        TableName.arName: data.ar_name.toString(),
      };
      bool isDuplicate = await hasDuplicateEntry(
          db, TableName.tblSysPromoPlaneReason, fields);

      if (isDuplicate) {
        print('Error: Duplicate entry promo plan Reason');
      } else {
        print('Promo plan reason list');
        await db.insert(
          TableName.tblSysPromoPlaneReason,
          {
            TableName.sysId: data.id,
            TableName.enName: data.en_name.toString(),
            TableName.arName: data.ar_name.toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    return false;
  }

  static Future<List<Sys_OSDCReasonModel>> getPromoPlaneReasonList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcTypeMaps = await db.rawQuery(
        'SELECT *from sys_promo_plan_reasons');
    print(jsonEncode(osdcTypeMaps));
    print('________ promo reason Unit List ________________');
    return List.generate(osdcTypeMaps.length, (index) {
      return Sys_OSDCReasonModel(
        id: osdcTypeMaps[index][TableName.sysId] as int,
        en_name: osdcTypeMaps[index][TableName.enName] as String,
        ar_name: osdcTypeMaps[index][TableName.arName] as String,
      );
    });
  }

  static Future<List<Sys_OSDCTypeModel>> getSysDailyCheckList() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcTypeMaps = await db.rawQuery(
        'SELECT *from sys_daily_checklist');
    print(jsonEncode(osdcTypeMaps));
    print('________ sys_daily_checklist ________________');
    return List.generate(osdcTypeMaps.length, (index) {
      return Sys_OSDCTypeModel(
        id: osdcTypeMaps[index][TableName.sysId] as int,
        en_name: osdcTypeMaps[index][TableName.enName] as String,
        ar_name: osdcTypeMaps[index][TableName.arName] as String,
      );
    });
  }

  static Future<List<Sys_OSDCReasonModel>> getSosUnitListData() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> osdcTypeMaps = await db.rawQuery(
        'SELECT *from sys_sos_units');
    print(jsonEncode(osdcTypeMaps));
    print('________ SOS Unit List ________________');
    return List.generate(osdcTypeMaps.length, (index) {
      return Sys_OSDCReasonModel(
        id: osdcTypeMaps[index][TableName.sysId] as int,
        en_name: osdcTypeMaps[index][TableName.enName] as String,
        ar_name: osdcTypeMaps[index][TableName.arName] as String,
      );
    });
  }

}

// Future <GeneralChecksStatusController> generalControllerInitialization () async {
//   GeneralChecksStatusController generalStatusController;
//   generalStatusController = Get.put(GeneralChecksStatusController());
//
//   await generalStatusController.getAppSetting();
//
//   return generalStatusController;
// }

///Getting AVL Excludes From Queries
Future<String> getAvlExcludesString(String workingId) async {
  final db = await DatabaseHelper.initDataBase();
  final List<Map<String, dynamic>> journeyPlanMap = await db.rawQuery(
      'SELECT avl_exclude FROM sys_journey_plan WHERE working_id=$workingId');

  print(jsonEncode(journeyPlanMap));
  print('-------------------- AVL Excludes ------------------------');
  return journeyPlanMap[0]['avl_exclude'] ?? '';
}

///Getting AVL Excludes From Queries
Future<String> getOtherExcludesString(String workingId) async {
  final db = await DatabaseHelper.initDataBase();
  final List<Map<String, dynamic>> journeyPlanMap = await db.rawQuery(
      'SELECT other_exculde FROM sys_journey_plan WHERE working_id=$workingId');

  print(jsonEncode(journeyPlanMap));
  print('-------------------- AVL Excludes ------------------------');
  return journeyPlanMap[0]['other_exculde'] ?? '';
}

String wrapIfString(dynamic value) {
  if (value is String) {
    return '"$value"';
  } else {
    return value.toString();
  }
}


