import 'package:flutter/material.dart';
class TableName {
  /// Database name
  static const String dbName = "cstore_pro.db";

  // ------******* system table -----********
  static const String tblSysDropReason = "sys_drop_reason";
  static const String tblSysAgencyDashboard = "sys_agency_dashboard";
  static const String tblSysClient = "sys_client";
  static const String tblSysCategory = "sys_category";
  static const String tblSysSubcategory = "sys_subcategory";
  static const String tblSysBrand= "sys_brand";
  static const String tblSysPlanogramReason="sys_planogram_reason";
  static const String tblSysRtvReason="sys_rtv_reason";
  static const String tblSysPhototype="sys_photo_type";
  static const String tblSysOsdcType="sys_osdc_type";
  static const String tblSysOsdcReason="sys_osdc_reason";
  static const String tblSysProduct="sys_product";
  static const String tblSysStorePog="sys_store_pog";
  static const String tblSysProductPlacement="sys_product_placement";
  static const String tblSysBrandFaces="sys_brand_faces ";
  static const String tblSysAppSetting ="sys_app_setting";
  static const String tblSysDailyChecklist  ="sys_daily_checklist";
  static const String tblSysSosUnits="sys_sos_units";
  static const String tblSysVisitReqModules="sys_visit_required_modules";
  static const String tblSysModuleId = 'module_id';
  static const String tblSysVisitActivityType = 'visit_activty_type_id';
  static const String tblSysKnowledgeShare = 'sys_knowledge_share';

  static const String tblSysSosUnit = 'sys_sos_units';
  static const String tblSysPromoPlaneReason = 'sys_promo_plan_reasons';
  static const String tblSysStores = 'sys_stores';

  static const String tblPicklist="picklist";
  static const String tblSysJourneyPlan = "sys_journey_plan";
  static const String tblSysDashboard = "sys_dashboard";
  static const String tblSysPromoPlan = "sys_promoplan";
  static const String tbTransPromoPlan = "trans_promoplan";

  //-----******* Transcition tables ------*******
  static const String tblTransPhoto = "trans_photo";
  static const String tblTransPlanogram= "trans_planogram";
  static const String tblTransSos= "trans_sos";
  static const String tblTransRtv= "trans_rtv";
  static const String tblTransAvailability= "trans_availability";
  static const String tblTransPricing= "trans_pricing";
  static const String tblTransFreshness= "trans_freshness";
  static const String tblTransStock= "trans_stock";
  static const String tblTransOsdc= "trans_osdc";
  static const String tblTransOsdcImages= "trans_osdc_images";
  static const String tblTransOnePlusOne= "trans_one_plus_one";
  static const String tblTransPromoplan= "trans_promoplan";
  static const String tblTransBeforeFaxing= "trans_before_fixing";
  static const String tblTransPlanoguide= "trans_planoguide";
  static const String tblTransBrandShare= "trans_brand_share";
  static const String tblTransPOS= "trans_proof_of_sale";
  static const String tblTransMarketIssue= "trans_market_issue";


  //----*******Transtion table column-----******
  static const String transPhotoTypeId = "photo_type_id";
  static const String transPlanogramIsAdherence="is_adherence";
  static const String transPlanogramReasonId="reason_id";

  static const String trans_sos_cat_space="cat_space";
  static const String trans_sos_actual_space="actual_space";
  static const String trans_sos_unit="unit";

  static const String trans_rtv_reason="reason";
  static const String trans_rtv_activity_status="act_status";
  static const String transActivityStatus="activity_status";
  static const String trans_rtv_expire_date="expire_date";

  static const String trans_avl_status="avl_status";
  static const String trans_avl_req_picklist="req_picklist";
  static const String trans_avl_actual_picklist="actual_picklist";
  static const String trans_avl_picklist_reason="picklist_reason";
  static const String trans_avl_picklist_ready="picklist_ready";
  static const String trans_pick_upload_status= "pick_upload_status";

  static const String trans_pricing_regular="regular_price";
  static const String trans_pricing_promo="promo_price";

  static const String trans_stock_cases="cases";
  static const String trans_stock_outer="outer";

  static const String trans_osdc_reason_id="reason_id";
  static const String trans_osdc_quantity="quantity";

  static const String trans_osdc_main_id="osd_main_id";

  static const String trans_one_plus_one_quantity="quantity";
  static const String trans_one_plus_one_doc_no="doc_no";
  static const String trans_one_plus_one_comment="comment";
  static const String trans_one_plus_one_type="type";
  static const String trans_one_plus_one_image="image";
  static const String trans_one_plus_one_doc_image="doc_image";

  static const String trans_promo_db_id="db_id";
  static const String trans_promo_plan_id="promo_plan_id";
  static const String trans_promo_reason="reason";

  static const String trans_lang_en="lang_en";
  static const String trans_lang_ar="lang_ar";
  static const String trans_avl_picker_name="picker_name";
  static const String trans_avl_send_time="pick_list_send_time";
  static const String trans_avl_receive_time="pick_list_receive_time";

  static const String trans_planoguide_pog="pog";
  static const String trans_planoguide_isAdherence="isAdherence";
  static const String trans_planoguide_skuImageName="skuImageName";

  static const String trans_brand_shares_storeId="store_id";
  static const String trans_brand_shares_givenFaces="given_faces";
  static const String trans_brand_shares_actualFaces="actual_faces";

  //----******* system table column -----*********

  static const String agency_dash_icon = "icon_svg";
  static const String agency_dash_start_date = "start_date";
  static const String agency_dash_end_date = "end_date";
  static const String agency_dash_accessTo = "access_to";

  static const String sys_client_name = "client_name";
  static const String sys_client_logo = "logo";
  static const String sys_client_classification = "is_classification";
  static const String sys_client_chainSku_code = "is_chain_sku_codes";
  static const String sys_client_is_dayFreshness = "is_day_freshness";
  static const String sys_client_geo_requried = "is_geo_required";
  static const String sys_client_order_avl = "is_suggeted_order_avl";
  static const String sys_client_is_survey = "is_survey";

  static const String sys_rtv_reason_calendar="calendar";

  static const String sys_product_image="image";
  static const String sys_product_principal_id="principal_id";
  static const String sys_product_cluster_id="cluster_id";
  static const String sys_product_sub_cat_id="subcategory_id";
  static const String sys_product_rsp="rsp";
  static const String sys_product_sku_weight="sku_weight";

  static const String sys_store_pog="pog";
  static const String sys_store_pog_image="pog_image";

  static const String sys_product_placement_pog="pog";
  static const String sys_product_placement_h_facing="h_facings";
  static const String sys_product_placement_v_facing="v_facings";
  static const String sys_product_placement_d_facing="d_facings";
  static const String sys_product_placement_total_facing="total_facings";
  static const String sys_product_placement_bay_no="bay_no";
  static const String sys_product_placement_shelf_no="shelf_no";
  static const String sys_product_placement_rank_x="rank_x";

  static const String sys_brand_faces_givenFaces="given_faces";
  static const String sys_app_settingBgServices="bg_service";
  static const String sys_app_settingBgServiceMinute="bg_service_minutes";
  static const String sys_app_settingPicklisService="is_picklist_service";
  static const String sys_app_settingPicklisTime="picklist_time";
  static const String sys_app_auto_time = "is_autotime_enabled";
  static const String sys_app_location = "is_location_enabled";
  static const String sys_app_fake_location_check = "is_fake_gps_check_enabled";
  static const String sys_app_vpn_check = "is_vpn_checked";

  static const String picklist_id = "picklist_id";
  static const String picklist_tmr_id = "tmr_id";
  static const String picklist_tmr_name = "tmr_name";
  static const String picklist_stocker_id = "stocker_id";
  static const String picklist_stocker_name = "stocker_name";
  static const String picklist_shift_time = "shift_time";
  static const String picklist_sku_picture = "sku_picture";
  static const String picklist_en_sku_name = "en_sku_name";
  static const String picklist_ar_sku_name = "ar_sku_name";
  static const String picklist_req_picklist = "req_picklist";
  static const String picklist_act_picklist = "act_picklist";
  static const String picklist_picklist_ready = "picklist_ready";
  static const String picklist_reason = "picklist_reason";

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

  ///Column Names Here
  static const String sysId = "id";
  static const String enName = "en_name";
  static const String arName = "ar_name";
  static const String promoId = "promo_id";
  static const String brandId = "brand_id";
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
  static const String status="status";
  static const String workingId = "working_id";
  static const String activityStatus = "act_status";
  static const String uploadStatus = "upload_status";
  static const String gcsStatus = "gcs_status";
  static const String imageName = "image_name";
  static const String promoReason = "promo_reason";
  static const String promoStatus = "promo_status";
  static const String modalImage = "modal_image";
  static const String workingDate = "working_date";
  static const String enStoreName = "en_store_name";
  static const String arStoreName = "ar_store_name";
  static const String storeGCode = "gcode";
  static const String clientIds = "client_id";
  static const String userId = "user_id";
  static const String checkInTime = "check_in";
  static const String checkOutTime = "check_out";
  static const String startVisitPhoto = "start_visit_photo";
  static const String checkInGps = "checkin_gps";
  static const String checkOutGps = "checkout_gps";
  static const String visitStatus = "visit_status";
  static const String visitType = "visit_type";
  static const String isDrop = "is_drop";
  static const String visitActivityType = "visit_activity_type";
  static const String avlExclude = "avl_exclude";
  static const String otherExclude = "other_exculde";
  static const String jpPlanned = "jp_planned";
  static const String jpVisited = "jp_visited";
  static const String outOfPlanned = "out_of_planned";
  static const String outOfPlannedVisited = "out_of_plan_visited";
  static const String jpc = "jpc";
  static const String pro = "pro";
  static const String workingHrs = "working_hrs";
  static const String eff = "eff";
  static const String monthlyAttend = "monthly_attend";
  static const String monthlyPro = "monthly_pro";
  static const String monthlyEff = "monthly_eff";
  static const String monthlyIncentives = "monthly_incentives";
  static const String monthlyDeduction = "monthly_deduction";

  static const String trans_pos_name = "name";
  static const String trans_pos_email = "email";
  static const String trans_pos_phone = "phone";
  static const String trans_pos_amount = "amount";
  static const String sys_issue_id = "issue_id";
  static const String tblSysMarketIssue = 'sys_market_issues';
  static const String sysCategoryId = "category_id";
  static const String type_id="type_id";
  static const String reason_id="reason_id";
  static const String col_quantity="quantity";
  static const String pieces="pieces";
  static const String chain_id="chain_id";
  static const String orderBy = "order_by";

  static const String sys_knowledge_title = "title";
  static const String sys_knowledge_des = "description";
  static const String sysKnowledgeAddedBy = "added_by";
  static const String sysKnowledgeFileName = "file_name";
  static const String sysKnowledgeType = "type";
  static const String sysKnowledgeActive = "active";
  static const String sysIssueUpdateAt = "updated_at";

  static const String sysStoreGcode = "gcode";
  static const String sysStoreRegionId = "region_id";
  static const String sysStoreRegionName = "region_name";
  static const String sysStoreCityId= "city_id";
  static const String sysStoreCityName = "city_name";
  static const String sysStoreChainName = "chain_name";
  static const String sysStoreChannelId = "channel_id";
  static const String sysStoreChannelId6 = "channel_id6";
  static const String sysStoreChannelId7 = "channel_id7";
}
