import 'package:flutter/material.dart';

class TableName {

  final GlobalKey<ScaffoldState> drawerKey = new GlobalKey<ScaffoldState>();

  /// Database name
  static const String dbName = "cstore_pro.db";

  // ------******* system table -----********
  static const String tbl_sys_drop_reason = "sys_drop_reason";
  static const String tbl_sys_agency_dashboard = "sys_agency_dashboard";
  static const String tbl_sys_client = "sys_client";
  static const String tbl_sys_category = "sys_category";
  static const String tbl_sys_subcategory = "sys_subcategory";
  static const String tbl_sys_brand= "sys_brand";
  static const String tbl_sys_planogram_reason="sys_planogram_reason";
  static const String tbl_sys_rtv_reason="sys_rtv_reason";
  static const String tbl_sys_photo_type="sys_photo_type";
  static const String tbl_sys_osdc_type="sys_osdc_type";
  static const String tbl_sys_osdc_reason="sys_osdc_reason";
  static const String tbl_sys_product="sys_product";

  static const String tbl_sys_store_pog="sys_store_pog";
  static const String tbl_sys_product_placement="sys_product_placement";
  static const String tbl_sys_brand_faces="sys_brand_faces ";

  static const String tbl_sys_app_setting ="sys_app_setting";
  static const String tbl_sys_daily_checklist  ="sys_daily_checklist";
  static const String tbl_sys_sos_units="sys_sos_units";

  static const String tblSysVisitReqModules="sys_visit_required_modules";
  static const String tblSysModuleId = 'module_id';
  static const String tblSysVisitActivityType = 'visit_activty_type_id';

  //-----******* Transcition tables ------*******
  static const String tbl_trans_photo = "trans_photo";
  static const String tbl_trans_planogram= "trans_planogram";
  static const String tbl_trans_sos= "trans_sos";
  static const String tbl_trans_rtv= "trans_rtv";
  static const String tbl_trans_availability= "trans_availability";

  static const String tbl_trans_pricing= "trans_pricing";
  static const String tbl_trans_freshness= "trans_freshness";
  static const String tbl_trans_stock= "trans_stock";
  static const String tbl_trans_osdc= "trans_osdc";
  static const String tbl_trans_osdc_images= "trans_osdc_images";
  static const String tbl_trans_one_plus_one= "trans_one_plus_one";
  static const String tbl_trans_promoplan= "trans_promoplan";

  static const String tbl_trans_before_faxing= "trans_before_fixing";
  static const String tbl_trans_planoguide= "trans_planoguide";
  static const String tbl_trans_BrandShare= "trans_brand_share";


  //----*******Transtion table column-----******
  static const String trans_photo_id = "id";
  static const String trans_photo_client_id = "client_id";
  static const String trans_photo_type_id = "photo_type_id";
  static const String trans_photo_cat_id = "cat_id";
  static const String trans_other_photo_type_id = "type_id";
  static const String trans_photo_name = "image_name";
  static const String trans_photo_gcs_status = "gcs_status";
  static const String trans_photo_working_id = "working_id";

  static const String trans_planogram_id="id";
  static const String trans_planogram_client_id="client_id";
  static const String trans_planogram_cat_id="cat_id";
  static const String trans_planogram_brand_id="brand_id";
  static const String trans_planogram_image_name="image_name";
  static const String trans_planogram_is_adherence="is_adherence";
  static const String trans_planogram_reason_id="reason_id";
  static const String trans_planogram_gcs_status="gcs_status";
  static const String trans_planogram_working_id="working_id";

  static const String trans_sos_id="id";
  static const String trans_sos_client_id="client_id";
  static const String trans_sos_cat_id="cat_id";
  static const String trans_sos_brand_id="brand_id";
  static const String trans_sos_cat_space="cat_space";
  static const String trans_sos_actual_space="actual_space";
  static const String trans_sos_unit="unit";
  static const String trans_sos_working_id="working_id";

  static const String trans_rtv_id="id";
  static const String trans_rtv_sku_id="sku_id";
  static const String trans_rtv_type_id="type_id";
  static const String trans_rtv_reason="reason";
  static const String trans_rtv_activity_status="act_status";
  static const String trans_rtv_pieces="pieces";
  static const String trans_rtv_expire_date="expire_date";
  static const String trans_rtv_image_name="image_name";
  static const String trans_rtv_gcs_status="gcs_status";
  static const String trans_rtv_working_id="working_id";

  static const String trans_avl_id="id";
  static const String trans_avl_sku_id="sku_id";
  static const String trans_avl_status="avl_status";
  static const String trans_avl_req_picklist="req_picklist";
  static const String trans_avl_actual_picklist="actual_picklist";
  static const String trans_avl_picklist_reason="picklist_reason";
  static const String trans_avl_picklist_ready="picklist_ready";
  static const String trans_avl_working_id="working_id";
  static const String trans_avl_activity_status="activity_status";
  static const String trans_avl_client_id = "client_id";
  static const String trans_pick_upload_status= "pick_upload_status";


  static const String trans_pricing_id="id";
  static const String trans_pricing_sku_id="sku_id";
  static const String trans_pricing_regular="regular_price";
  static const String trans_pricing_promo="promo_price";
  static const String trans_pricing_working_id="working_id";

  static const String trans_stock_id="id";
  static const String trans_stock_sku_id="sku_id";
  static const String trans_stock_cases="cases";
  static const String trans_stock_outer="outer";
  static const String trans_stock_pieces="pieces";
  static const String trans_stock_working_id="working_id";

  static const String trans_osdc_id="id";
  static const String trans_osdc_brand_id="brand_id";
  static const String trans_osdc_type_id="type_id";
  static const String trans_osdc_client_id="client_id";
  static const String trans_osdc_reason_id="reason_id";
  static const String trans_osdc_quantity="quantity";
  static const String trans_osdc_gcs_status="gcs_status";
  static const String trans_osdc_working_id="working_id";


  static const String trans_osdc_images_id="id";
  static const String trans_osdc_main_id="osd_main_id";
  static const String trans_osdc_imagesName="images_name";


  static const String trans_one_plus_one_id="id";
  static const String trans_one_plus_one_sku_id="sku_id";
  static const String trans_one_plus_one_quantity="quantity";
  static const String trans_one_plus_one_doc_no="doc_no";
  static const String trans_one_plus_one_comment="comment";
  static const String trans_one_plus_one_type="type";
  static const String trans_one_plus_one_image="image";
  static const String trans_one_plus_one_doc_image="doc_image";
  static const String trans_one_plus_one_working_id="working_id";

  static const String trans_promo_id="id";
  static const String trans_promo_db_id="db_id";
  static const String trans_promo_plan_id="promo_plan_id";
  static const String trans_promo_status="status";
  static const String trans_promo_reason="reason";
  static const String trans_promo_image_name="image_name";
  static const String trans_promo_working_id="working_id";

  static const String trans_date_time="date_time";
  static const String trans_lang_en="lang_en";
  static const String trans_lang_ar="lang_ar";
  static const String trans_upload_status="upload_status";
  static const String trans_avl_picker_name="picker_name";
  static const String trans_avl_send_time="pick_list_send_time";
  static const String trans_avl_receive_time="pick_list_receive_time";


  static const String trans_planoguide_id="id";
  static const String trans_planoguide_catId="cat_id";
  static const String trans_planoguide_storeId="store_id";
  static const String trans_planoguide_pog="pog";
  static const String trans_planoguide_isAdherence="isAdherence";
  static const String trans_planoguide_imageName="imageName";
  static const String trans_planoguide_skuImageName="skuImageName";
  static const String trans_planoguide_dateTime="date_time";
  static const String trans_planoguide_gcs_status="gcs_status";
  static const String trans_planoguide_upload_status="upload_status";
  static const String trans_planoguide_activity_status="activity_status";
  static const String trans_planoguide_working_id="working_id";


  static const String trans_brand_shares_id="id";
  static const String trans_brand_shares_storeId="store_id";
  static const String trans_brand_shares_catId="category_id";
  static const String trans_brand_shares_brandId="brand_id";
  static const String trans_brand_shares_givenFaces="given_faces";
  static const String trans_brand_shares_actualFaces="actual_faces";
  static const String trans_brand_shares_dateTime="date_time";
  static const String trans_brand_shares_uploadStauts="upload_status";
  static const String trans_brand_shares_workingId="working_id";

  //----******* system table column -----*********
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
  static const String agency_dash_accessTo = "access_to";

  static const String sys_client_id = "client_id";
  static const String sys_client_name = "client_name";
  static const String sys_client_logo = "logo";
  static const String sys_client_classification = "is_classification";
  static const String sys_client_chainSku_code = "is_chain_sku_codes";
  static const String sys_client_is_dayFreshness = "is_day_freshness";
  static const String sys_client_geo_requried = "is_geo_required";
  static const String sys_client_order_avl = "is_suggeted_order_avl";
  static const String sys_client_is_survey = "is_survey";

  static const String cat_id = "id";
  static const String cat_en_name = "en_name";
  static const String cat_ar_name = "ar_name";
  static const String cat_client_id = "client_id";

  static const String sys_brand_id = "id";
  static const String sys_brand_en_name = "en_name";
  static const String sys_brand_ar_name="ar_name";
  static const String sys_brand_client_id = "client_id";

  static const String planogram_reason_id = "id";
  static const String planogram_reason_en_name = "en_name";
  static const String planogram_reason_ar_name="ar_name";
  static const String planogram_status="status";

  static const String sys_rtv_reason_id="id";
  static const String sys_rtv_reason_en_name="en_name";
  static const String sys_rtv_reason_ar_name="ar_name";
  static const String sys_rtv_reason_calendar="calendar";
  static const String sys_rtv_reason_status="status";

  static const String sys_photo_type_id="id";
  static const String sys_photo_type_en_name="en_name";
  static const String sys_photo_type_ar_name="ar_name";

  static const String sys_osdc_type_id="id";
  static const String sys_osdc_type_en_name="en_name";
  static const String sys_osdc_type_ar_name="ar_name";

  static const String sys_osdc_reason_id="id";
  static const String sys_osdc_reason_en_name="en_name";
  static const String sys_osdc_reason_ar_name="ar_name";

  static const String sys_product_id="id";
  static const String sys_product_client_id="client_id";
  static const String sys_product_en_name="en_name";
  static const String sys_product_ar_name="ar_name";
  static const String sys_product_image="image";
  static const String sys_product_principal_id="principal_id";
  static const String sys_product_cluster_id="cluster_id";
  static const String sys_product_cat_id="category_id";
  static const String sys_product_sub_cat_id="subcategory_id";
  static const String sys_product_brand_id="brand_id";
  static const String sys_product_rsp="rsp";
  static const String sys_product_sku_weight="sku_weight";

  static const String sys_store_pog_storeid="store_id";
  static const String sys_store_pog_catId="category_id";
  static const String sys_store_pog="pog";
  static const String sys_store_pog_image="pog_image";

  static const String sys_product_placement_id="sku_id";
  static const String sys_product_placement_storeId="store_id";
  static const String sys_product_placement_cat_id="category_id";
  static const String sys_product_placement_pog="pog";
  static const String sys_product_placement_h_facing="h_facings";
  static const String sys_product_placement_v_facing="v_facings";
  static const String sys_product_placement_d_facing="d_facings";
  static const String sys_product_placement_total_facing="total_facings";
  static const String sys_product_placement_bay_no="bay_no";
  static const String sys_product_placement_shelf_no="shelf_no";
  static const String sys_product_placement_rank_x="rank_x";

  static const String sys_brand_faces_storeId="store_id";
  static const String sys_brand_faces_catId="category_id";
  static const String sys_brand_faces_brandId="brand_id";
  static const String sys_brand_faces_givenFaces="given_faces";

  static const String sys_app_settingId="store_id";
  static const String sys_app_settingBgServices="bg_service";
  static const String sys_app_settingBgServiceMinute="bg_service_minutes";
  static const String sys_app_settingPicklisService="is_picklist_service";
  static const String sys_app_settingPicklisTime="picklist_time";

  static const String picklist_id = "picklist_id";
  static const String picklist_store_id = "store_id";
  static const String picklist_category_id = "category_id";
  static const String picklist_tmr_id = "tmr_id";
  static const String picklist_tmr_name = "tmr_name";
  static const String picklist_stocker_id = "stocker_id";
  static const String picklist_stocker_name = "stocker_name";
  static const String picklist_shift_time = "shift_time";
  static const String picklist_en_cat_name = "en_cat_name";
  static const String picklist_ar_cat_name = "ar_cat_name";
  static const String picklist_sku_picture = "sku_picture";
  static const String picklist_en_sku_name = "en_sku_name";
  static const String picklist_ar_sku_name = "ar_sku_name";
  static const String picklist_req_picklist = "req_picklist";
  static const String picklist_act_picklist = "act_picklist";
  static const String picklist_picklist_ready = "picklist_ready";
  static const String picklist_reason = "picklist_reason";
  static const String tbl_picklist="picklist";


  static const String trans_freshness_id="id";
  static const String trans_freshness_sku_id="sku_id";
  static const String trans_freshness_year="year";
  static const String trans_freshness_jan="jan";
  static const String trans_freshness_feb="feb";
  static const String trans_freshness_mar="mar";
  static const String trans_freshness_apr="apr";
  static const String trans_freshness_may="may";
  static const String trans_freshness_jun="jun";
  static const String trans_freshness_jul="jul";
  static const String trans_freshness_aug="aug";
  static const String trans_freshness_sep="sep";
  static const String trans_freshness_oct="oct";
  static const String trans_freshness_nov="nov";
  static const String trans_freshness_dec="dec";
  static const String trans_freshness_specific_date="specific_date";
  static const String trans_freshness_date_time="date_time";
  static const String trans_freshness_working_id="working_id";

  static const String tblSysPromoPlan = "sys_promoplan";
  static const String tbTransPromoPlan = "trans_promoplan";
  static const String promoId = "promo_id";
  static const String storeId = "store_id";
  static const String skuId = "sku_id";
  static const String from = "promo_from";
  static const String to = "promo_to";
  static const String osdType = "osd_type";
  static const String quantity = "qty";
  static const String promoScope = "promo_Scope";
  static const String promoPrice = "promo_price";
  static const String leftOverAction = "left_over_action";
  static const String dateTime = "date_time";
  static const String workingId = "working_id";
  static const String activityStatus = "act_status";
  static const String uploadStatus = "upload_status";
  static const String gcsStatus = "gcs_status";
  static const String imageName = "image_name";
  static const String promoReason = "promo_reason";
  static const String promoStatus = "promo_status";
  static const String modalImage = "modal_image";


}
