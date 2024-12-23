import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cstore/Model/request_model.dart/save_db_file_request.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/availability_show_model.dart';
import '../../Model/database_model/dashboard_model.dart';
import '../../Model/database_model/freshness_graph_count.dart';
import '../../Model/database_model/planoguide_gcs_images_list_model.dart';
import '../../Model/database_model/promo_plan_graph_api_count_model.dart';
import '../../Model/database_model/required_module_model.dart';
import '../../Model/database_model/show_trans_rtv_model.dart';
import '../../Model/database_model/total_count_response_model.dart';
import '../../Model/database_model/trans_brand_shares_model.dart';
import '../../Model/database_model/trans_planoguide_model.dart';
import '../../Model/database_model/trans_stock_model.dart';
import '../../Model/request_model.dart/availability_api_request_model.dart';
import '../../Model/request_model.dart/brand_share_request.dart';
import '../../Model/request_model.dart/finish_visit_request_model.dart';
import '../../Model/request_model.dart/other_images_end_Api_request.dart';
import '../../Model/request_model.dart/planogram_end_api_request_model.dart';
import '../../Model/request_model.dart/planoguide_request_model.dart';
import '../../Model/request_model.dart/ready_pick_list_request.dart';
import '../../Model/request_model.dart/save_api_pricing_data_request.dart';
import '../../Model/request_model.dart/save_api_rtv_data_request.dart';
import '../../Model/request_model.dart/save_freshness_request_model.dart';
import '../../Model/request_model.dart/save_market_issue_request.dart';
import '../../Model/request_model.dart/save_one_plus_one_request.dart';
import '../../Model/request_model.dart/save_osd_request.dart';
import '../../Model/request_model.dart/save_pos_request.dart';
import '../../Model/request_model.dart/save_promo_plan_request_model.dart';
import '../../Model/request_model.dart/save_replenishment_request.dart';
import '../../Model/request_model.dart/save_stock_request_model.dart';
import '../../Model/request_model.dart/sos_end_api_request_model.dart';
import '../../Model/request_model.dart/survey_end_api_request.dart';
import '../../Network/jp_http.dart';
import '../../Network/sql_data_http_manager.dart';
import '../Language/localization_controller.dart';
import '../important_service/genral_checks_status.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/services/general_checks_controller_call_function.dart';
import '../utils/services/getting_gps.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import 'widgets/VisitUploadScreencard.dart';

class VisitUploadScreen extends StatefulWidget {
  static const routeName = "/visit_upload_screen";

  const VisitUploadScreen({super.key});

  @override
  State<VisitUploadScreen> createState() => _VisitUploadScreenState();
}

class _VisitUploadScreenState extends State<VisitUploadScreen> {
  String storeEnName = "";
  String storeArName = "";
  String userName = "";
  String userId = "";
  String storeId = "";
  String token = "";
  String baseUrl = "";
  String bucketName = "";
  String userRole = "";
  String workingId = "";
  String clientId = "";
  String gcode = "";
  String checkInTime = "";
  List<File> _imageFiles = [];
  String workingDate="";
  String location = "";
  String visitActivity = "";

  final languageController = Get.put(LocalizationController());

  int count = 0;

  bool isDataUploading = false;
  List<AvailabilityShowModel> availableData = <AvailabilityShowModel>[];
  List<SaveAvailabilityData> availabilityDataList = [];
  List<SavePickListData> availabilityPickList = [];
  AvailabilityCountModel availabilityCountModel = AvailabilityCountModel(totalSku: 0,totalAvl: 0,totalNotAvl: 0,totalUploaded: 0,totalNotUploaded: 0,totalNotMarked: 0);
  TmrPickListCountModel tmrPickListCountModel = TmrPickListCountModel(totalPickListItems: 0,totalPickNotUpload: 0,totalPickUpload: 0,totalPickReady: 0,totalPickNotReady: 0);

  List<SavePlanoguideListData> planoguideImageList = [];
  List<TransPlanoGuideGcsImagesListModel> planoguideGcsImagesList=[];
  PlanoguideCountModel planoguideCountModel = PlanoguideCountModel(totalPlano: 0,totalAdhere: 0,totalNotAdhere: 0,totalUploaded: 0,totalNotUploaded: 0,totalImagesUploaded: 0,totalImagesNotUploaded: 0,totalNotMarkedPlano: 0);

  List<TransBransShareModel> brandShareData = <TransBransShareModel>[];
  List<SaveBrandShareListData> brandShareImageList = [];
  BrandShareCountModel brandShareCountModel = BrandShareCountModel(totalBrandShare: 0,totalUpload: 0,totalNotUpload: 0,totalNotReadyBrands: 0,totalReadyBrands: 0);

  PickListCountModel pickListCountModel = PickListCountModel(totalNotUpload: 0,totalUpload: 0,totalPickListItems: 0,totalPickNotReady: 0,totalPickReady: 0);

  List<ShowTransRTVShowModel> rtvData = [];
  List<SaveRtvDataListData> rtvImageList = [];
  List<TransPlanoGuideGcsImagesListModel> rtvGcsImagesList=[];
  RtvCountModel rtvCountModel = RtvCountModel(totalRtv: 0, totalNotUpload: 0, totalUpload: 0,totalVolume: 0,totalValue: 0);

  List<TransBransShareModel> priceCheckData = <TransBransShareModel>[];
  List<SavePricingDataListData> priceCheckImageList = [];
  PriceCheckCountModel priceCheckCountModel = PriceCheckCountModel(totalPriceCheck: 0, totalNotUpload: 0, totalUpload: 0,totalRegularSku: 0,totalPromoSku: 0);


  List<SaveReplenishListData> replenishImageList = [];
  PriceCheckCountModel replenishmentCountModel = PriceCheckCountModel(totalPriceCheck: 0, totalNotUpload: 0, totalUpload: 0,totalRegularSku: 0,totalPromoSku: 0);

  List<ReadyPickListData> pickListDataForApi = [];

  FreshnessGraphCountShowModel freshnessGraphCountShowModel = FreshnessGraphCountShowModel(totalFreshnessTaken: 0,totalVolume: 0,totalNotUploadCount: 0,totalUploadCount: 0);
  List<SaveFreshnessListData> saveFreshnessList = [];

  List<TransPlanoGuideGcsImagesListModel> promoPlanGcsImagesList=[];
  List<SavePromoPlanDataListData> savePromoPlanList = [];
  PromoPlanGraphAndApiCountShowModel promoPlanGraphAndApiCountShowModel = PromoPlanGraphAndApiCountShowModel(totalPromoPLan: 0, totalDeployed: 0, totalNotDeployed: 0, totalPending: 0, totalUploadCount: 0, totalNotUploadCount: 0);

  List<SaveStockListData> saveStockList = [];
  TotalStockCountData totalStockCountData = TotalStockCountData(total_uploaded: 0,total_not_upload: 0,total_stock_taken: 0,total_pieces: 0,total_outers: 0,total_cases: 0);

  List<SaveOtherPhotoData> beforeFixingImageList = [];
  List<TransPlanoGuideGcsImagesListModel> beforeFixingGcsImagesList=[];
  BeforeFixingCountModel beforeFixingCountModel = BeforeFixingCountModel(totalBeforeFixing: 0,totalUpload: 0,totalNotUpload: 0,totalCategories: 0);


  List<SaveSurveyData> surveyImageList = [];
  List<TransPlanoGuideGcsImagesListModel> surveyImagesDataList = [];
  List<TransPlanoGuideGcsImagesListModel> surveyGcsImagesList=[];
  SurveyCountModel surveyCountModel = SurveyCountModel(totalQuestions: 0,totalUpload: 0,totalNotUpload: 0,totalImages: 0);

  List<SaveOtherPhotoData> otherPhotoImageList = [];
  List<TransPlanoGuideGcsImagesListModel> otherPhotoGcsImagesList=[];
  OtherPhotoCountModel otherPhotoCountModel = OtherPhotoCountModel(totalOtherPhotos: 0,totalUpload: 0,totalNotUpload: 0,totalCategories: 0);

  List<SavePlanogramPhotoData> planogramImageList = [];
  List<TransPlanoGuideGcsImagesListModel> planogramGcsImagesList=[];
  PlanogramCountModel planogramCountModel = PlanogramCountModel(totalPlanogramItems: 0,totalUpload: 0,totalNotUpload: 0,totalAdhere: 0,totalNotAdhere: 0);

  SosCountModel sosCountModel = SosCountModel(totalNotUpload: 0,totalUpload: 0,totalSosItems: 0,totalCategories: 0);
  List<SaveSosData> sosDataForApi = [];

  List<SavePosListData> posImageList = [];
  List<TransPlanoGuideGcsImagesListModel> posGcsImagesList=[];
  PosCountModel posCountModel = PosCountModel(totalPosItems: 0, totalNotUpload: 0, amount: 0, quantity: 0, totalUpload: 0);

  List<SaveOsdListData> osdImageList = [];
  List<SaveOsdImageNameListData> osdDataImagesList = [];
  List<TransPlanoGuideGcsImagesListModel> osdGcsImagesList=[];
  OsdAndMarketIssueCountModel osdCountModel = OsdAndMarketIssueCountModel(totalItems: 0, totalNotUpload: 0, totalUpload: 0);

  List<SaveMarketIssueListData> marketIssueImageList = [];
  List<TransPlanoGuideGcsImagesListModel> marketIssueGcsImagesList=[];
  OsdAndMarketIssueCountModel marketIssueCountModel = OsdAndMarketIssueCountModel(totalItems: 0, totalNotUpload: 0, totalUpload: 0);

  List<SaveOnePlusOneListData> onePlusOneImageList = [];
  List<TransOnePlusOneGcsImagesListModel> onePlusOneGcsImageList = [];
  RtvCountModel onePlusOneCountModel = RtvCountModel(totalRtv: 0, totalNotUpload: 0, totalUpload: 0,totalVolume: 0,totalValue: 0);

  List<AgencyDashboardModel> allAgencyData = [];
  List<AgencyDashboardModel> agencyData = [];

  List<String> moduleIdList = [];

  bool isFinishButton = true;
  bool isAvlFinishLoading = false;
  bool isPickListFinishLoading = false;
  bool isPlanoguideFinishLoading = false;
  bool isShelfShareFinishLoading = false;
  bool isRtvFinishLoading = false;
  bool isReplenishmentFinishLoading = false;
  bool isPriceCheckFinishLoading = false;
  bool isFreshnessFinishLoading = false;
  bool isPromoPlanFinishLoading = false;
  bool isStockFinishLoading = false;
  bool isBeforeFixingFinishLoading = false;
  bool isOtherPhotoFinishLoading = false;
  bool isSosFinishLoading = false;
  bool isOnePlusOneFinishLoading = false;
  bool isOsdFinishLoading = false;
  bool isMarketIssueFinishLoading = false;
  bool isPosFinishLoading = false;
  bool isPlanogramFinishLoading = false;
  bool isSurveyFinishLoading = false;

  @override
  void initState() {
    super.initState();
    getStoreDetails();
    setState(() {

    });
  }

  getStoreDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    token = sharedPreferences.getString(AppConstants.tokenId)!;
    baseUrl = sharedPreferences.getString(AppConstants.baseUrl)!;
    bucketName = sharedPreferences.getString(AppConstants.bucketName)!;
    storeEnName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;
    storeId = sharedPreferences.getString(AppConstants.storeId)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    clientId  = sharedPreferences.getString(AppConstants.clientId)!;
    workingDate = sharedPreferences.getString(AppConstants.workingDate)!;
    userRole = sharedPreferences.getString(AppConstants.userRole)!;
    visitActivity = sharedPreferences.getString(AppConstants.visitActivity)!;
    gcode = sharedPreferences.getString(AppConstants.gcode)!;

    print("USER ROLE");
    print(bucketName);
    print(clientId);

    allAgencyData = await DatabaseHelper.getAgencyDashboard();

    agencyData = allAgencyData.where((element) => element.accessTo.contains(userRole)).toList();

    List<RequiredModuleModel> allReqModuleData = await DatabaseHelper.getRequiredModuleListDataForApi();

    for(int i=0;i<allReqModuleData.length;i++) {
      if(allReqModuleData[i].visitActivityTypeId.toString() == visitActivity) {
        moduleIdList.add(allReqModuleData[i].moduleId.toString().trim());
      }
    }
    print("REQUIRED MODULES");
    print(moduleIdList);

    getAllCountData();

    checkInTime = sharedPreferences.getString(AppConstants.visitCheckIn)!;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FD),
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName, (){
        Navigator.of(context).pop();
      }, true, false, false, (int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: Column(
        children: [
          Container(
            margin:const  EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Expanded(
                //   child: Text(
                //     languageController.isEnglish.value ? storeEnName : storeArName,
                //     overflow: TextOverflow.ellipsis,
                //     maxLines: 2,
                //     style: const TextStyle(
                //         fontSize: 12,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.black),
                //   ),
                // ),
                Expanded(
                  child: Row(
                    children: [
                       Text(
                        "${"CheckIn".tr} : ",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color:MyColors.darkGreyColor),
                      ),

                      Text(
                        checkInTime,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 15,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:MyColors.darkGreyColor),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PopupMenuButton<int>(
                      onSelected: (value) {
                        print(value);
                        if(value == 1) {
                          uploadDbFile();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 1,
                          // row has two child icon and text
                          child: Text("support request"),
                        ),
                      ],
                      elevation: 2,
                    ),
                  ],
                )
              ],

            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Card(
                  elevation:5,
                  color: MyColors.dropBorderColor,
                  margin: const EdgeInsets.all(6),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        if (availabilityCountModel.totalSku > 0 )
                          VisitAvlUploadScreenCard(
                            onUploadTap: (){
                              availabilityUploadToAPI();
                            },
                            isUploaded: availabilityCountModel.totalNotUploaded == 0,
                            isUploadData: isAvlFinishLoading,
                            storeName:languageController.isEnglish.value ? storeEnName : storeArName,
                            moduleName: "Sku's".tr,
                            screenName: "Availability".tr,
                            checkinTime:checkInTime,
                            avlSkus:availabilityCountModel.totalAvl,
                            notAvlSkus: availabilityCountModel.totalNotAvl,
                            notMarkedSkus: availabilityCountModel.totalNotMarked,
                            totalSkus: availabilityCountModel.totalSku,),

                        if(beforeFixingCountModel.totalBeforeFixing  >0)
                          VisitBeforeFixingUploadScreenCard(
                              screenName: "Before Fixing".tr,
                              moduleName: "Category".tr,
                              onUploadTap: () {

                                uploadImagesToGcs(AppConstants.beforeFixing);

                              },
                              totalBeforeFixing: beforeFixingCountModel.totalBeforeFixing,
                              uploadedData: beforeFixingCountModel.totalCategories,
                              isUploadData: isBeforeFixingFinishLoading,
                              isUploaded: beforeFixingCountModel.totalNotUpload == 0),

                        if(otherPhotoCountModel.totalOtherPhotos  > 0)
                          VisitBeforeFixingUploadScreenCard(
                              screenName: "Other Photo".tr,
                              moduleName: "Category".tr,
                              onUploadTap: ()  {
                                 uploadImagesToGcs(AppConstants.otherPhoto);
                              },
                              totalBeforeFixing: otherPhotoCountModel.totalOtherPhotos,
                              uploadedData: otherPhotoCountModel.totalCategories,
                              isUploadData: isOtherPhotoFinishLoading,
                              isUploaded: otherPhotoCountModel.totalNotUpload == 0),

                        if(sosCountModel.totalSosItems  > 0)
                          VisitSosUploadScreenCard(
                              screenName: "Share Of Shelf".tr,
                              moduleName: "Records".tr,
                              onUploadTap: ()  {
                                sosUploadApi();
                              },
                              totalBeforeFixing: sosCountModel.totalSosItems,
                              uploadedData: sosCountModel.totalCategories,
                              isUploadData: isSosFinishLoading,
                              isUploaded: sosCountModel.totalNotUpload == 0),

                        if(planogramCountModel.totalPlanogramItems > 0)
                          VisitPlanogramUploadScreenCard(
                              screenName: "Planogram".tr,
                              moduleName: "Category".tr,
                              onUploadTap: ()  {
                                 uploadImagesToGcs(AppConstants.planogram);
                              },
                              totalPlanogram: planogramCountModel.totalPlanogramItems,
                              totalAdhere: planogramCountModel.totalAdhere,
                              totalNotAdhere: planogramCountModel.totalNotAdhere,
                              isUploadData: isPlanogramFinishLoading,
                              isUploaded: planogramCountModel.totalNotUpload == 0),

                        if (tmrPickListCountModel.totalPickListItems > 0 )
                          VisitPickListUploadScreenCard(
                            onUploadTap: (){
                              tmrUploadPickList();
                            },
                            isUploadData: isPickListFinishLoading,
                            isUploaded: tmrPickListCountModel.totalPickNotUpload == 0,
                            moduleName: "Requests".tr,
                            screenName: "Picklist".tr,
                            readyPickList:tmrPickListCountModel.totalPickReady,
                            notReadyPickList: tmrPickListCountModel.totalPickNotReady,
                            totalPickList: tmrPickListCountModel.totalPickListItems,),

                        if (planoguideCountModel.totalPlano > 0 )
                          VisitPlanoguideUploadScreenCard(
                            onUploadTap: ()  {
                               uploadImagesToGcs(AppConstants.planoguide);
                            },
                            isUploaded: planoguideCountModel.totalNotUploaded == 0,
                            isUploadData: isPlanoguideFinishLoading,
                            moduleName: "Pog".tr,
                            screenName: "Planoguide".tr,
                            totalAdhere:planoguideCountModel.totalAdhere,
                            totalNotAdhere: planoguideCountModel.totalNotAdhere,
                            notMarkedPlanoguide: planoguideCountModel.totalNotMarkedPlano,
                            totalPlanoguide: planoguideCountModel.totalPlano,),

                        if (brandShareCountModel.totalBrandShare > 0 )
                          VisitBrandShareUploadScreenCard(
                            onUploadTap: (){
                              shareShelfUploadToApi();
                            },
                            isUploaded: brandShareCountModel.totalNotUpload == 0,
                            isUploadData: isShelfShareFinishLoading,
                            moduleName: "Brands".tr,
                            screenName: "Shelf Share".tr,
                            readyBrandList:brandShareCountModel.totalReadyBrands,
                            notReadyBrandList: brandShareCountModel.totalNotReadyBrands,
                            totalBrands: brandShareCountModel.totalBrandShare,),

                        if (pickListCountModel.totalPickListItems > 0 )
                          VisitPickListUploadScreenCard(
                            onUploadTap: (){
                              pickListUploadAPi();
                            },
                            isUploaded: pickListCountModel.totalNotUpload == 0,
                            isUploadData: isPickListFinishLoading,
                            moduleName: "Requests".tr,
                            screenName: "Picklist".tr,
                            readyPickList:pickListCountModel.totalPickReady,
                            notReadyPickList: pickListCountModel.totalPickNotReady,
                            totalPickList: pickListCountModel.totalPickListItems,),

                        if (rtvCountModel.totalRtv > 0 )
                          VisitRtvUploadScreenCard(
                            onUploadTap: ()  {
                               uploadImagesToGcs(AppConstants.rtv);
                            },
                            isUploaded: rtvCountModel.totalNotUpload == 0,
                            isUploadData: isRtvFinishLoading,
                            moduleName: "Sku's".tr,
                            screenName: "RTV".tr,
                            uploadedData:rtvCountModel.totalVolume.toInt(),
                            notUploadedData: rtvCountModel.totalValue.toInt(),
                            totalRtv: rtvCountModel.totalRtv,),

                        if(priceCheckCountModel.totalPriceCheck > 0)
                          VisitPriceCheckUploadScreenCard(
                            onUploadTap: () {
                              priceCheckUploadApi();
                            },
                            isUploaded: priceCheckCountModel.totalNotUpload == 0,
                            isUploadData: isPriceCheckFinishLoading,
                            moduleName: "Sku's".tr,
                            screenName: "Price Check".tr,
                            uploadedData:priceCheckCountModel.totalRegularSku,
                            notUploadedData: priceCheckCountModel.totalPromoSku,
                            totalPriceCheck: priceCheckCountModel.totalPriceCheck,),

                        if(replenishmentCountModel.totalRegularSku > 0)
                          VisitReplenishmentUploadScreenCard(
                            onUploadTap: () {
                               replenishUploadAPi();
                            },
                            isUploaded: replenishmentCountModel.totalNotUpload == 0,
                            isUploadData: isReplenishmentFinishLoading,
                            moduleName: "Required".tr,
                            screenName: "Replenish".tr,
                            uploadedData:replenishmentCountModel.totalPromoSku,
                            notUploadedData: replenishmentCountModel.totalPriceCheck,
                            totalPriceCheck: replenishmentCountModel.totalRegularSku,),

                        if (freshnessGraphCountShowModel.totalFreshnessTaken > 0 )
                          VisitFreshnessUploadScreenCard(
                            onUploadTap: ()  {
                              freshnessUploadApi();
                            },
                            isUploaded: freshnessGraphCountShowModel.totalNotUploadCount == 0,
                            isUploadData: isFreshnessFinishLoading,
                            moduleName: "Sku's".tr,
                            screenName: "Freshness".tr,
                            uploadedData:freshnessGraphCountShowModel.totalVolume,
                            totalRtv: freshnessGraphCountShowModel.totalFreshnessTaken,),

                        if (promoPlanGraphAndApiCountShowModel.totalPromoPLan > 0 )
                          VisitPlanoguideUploadScreenCard(
                            onUploadTap: () {
                              uploadImagesToGcs(AppConstants.promoPlan);
                            },
                            isUploaded: promoPlanGraphAndApiCountShowModel.totalNotUploadCount == 0,
                            isUploadData: isPromoPlanFinishLoading,
                            moduleName: "Plan".tr,
                            screenName: "Promotions".tr,
                            totalAdhere:promoPlanGraphAndApiCountShowModel.totalDeployed,
                            totalNotAdhere: promoPlanGraphAndApiCountShowModel.totalDeployed,
                            notMarkedPlanoguide: promoPlanGraphAndApiCountShowModel.totalPending,
                            totalPlanoguide: promoPlanGraphAndApiCountShowModel.totalPromoPLan,),

                        if (totalStockCountData.total_stock_taken > 0 )
                          VisitStockUploadScreenCard(
                            onUploadTap: ()  {
                              stockUploadApi();
                            },
                            isUploaded: totalStockCountData.total_not_upload == 0,
                            isUploadData: isStockFinishLoading,
                            moduleName: "Sku's".tr,
                            screenName: "Stock".tr,
                            totalCases: totalStockCountData.total_cases,
                            totalOuters: totalStockCountData.total_outers,
                            totalPieces: totalStockCountData.total_pieces,
                            totalStock: totalStockCountData.total_stock_taken,
                          ),

                        if (onePlusOneCountModel.totalRtv > 0 )
                          VisitRtvUploadScreenCard(
                            onUploadTap: ()  {
                               uploadImagesToGcs(AppConstants.onePlusOne);
                            },
                            isUploaded: onePlusOneCountModel.totalNotUpload == 0,
                            isUploadData: isOnePlusOneFinishLoading,
                            moduleName: "Sku's".tr,
                            screenName: "1 + 1".tr,
                            uploadedData:onePlusOneCountModel.totalVolume.toInt(),
                            notUploadedData: onePlusOneCountModel.totalValue.toInt(),
                            totalRtv: onePlusOneCountModel.totalRtv,),

                        if (osdCountModel.totalItems > 0 )
                          VisitOsdAndMarketIssueUploadScreenCard(
                            onUploadTap: ()  {

                               uploadImagesToGcs(AppConstants.osdc);
                            },
                            isUploaded: osdCountModel.totalNotUpload == 0,
                            isUploadData: isOsdFinishLoading,
                            moduleName: "Total".tr,
                            screenName: "OSD".tr,
                            totalOsd: osdCountModel.totalItems,),

                        if (marketIssueCountModel.totalItems > 0 )
                          VisitOsdAndMarketIssueUploadScreenCard(
                            onUploadTap: ()  {

                               uploadImagesToGcs(AppConstants.marketIssues);
                            },
                            isUploaded: marketIssueCountModel.totalNotUpload == 0,
                            isUploadData: isMarketIssueFinishLoading,
                            moduleName: "Total".tr,
                            screenName: "Market Issue".tr,
                            totalOsd: marketIssueCountModel.totalItems,),

                        if (posCountModel.totalPosItems > 0 )
                          VisitRtvUploadScreenCard(
                            onUploadTap: () {
                               uploadImagesToGcs(AppConstants.pos);
                            },
                            isUploaded: posCountModel.totalNotUpload == 0,
                            isUploadData: isPosFinishLoading,
                            moduleName: "Total".tr,
                            screenName: "POS".tr,
                            uploadedData:posCountModel.quantity.toInt(),
                            notUploadedData: posCountModel.amount.toInt(),
                            totalRtv: posCountModel.totalPosItems,),

                        if(surveyCountModel.totalQuestions  > 0)
                          VisitBeforeFixingUploadScreenCard(
                              screenName: "Survey".tr,
                              moduleName: "Total".tr,
                              onUploadTap: () {

                                uploadImagesToGcs(AppConstants.survey);

                              },
                              totalBeforeFixing: surveyCountModel.totalImages,
                              uploadedData: surveyCountModel.totalQuestions,
                              isUploadData: isSurveyFinishLoading,
                              isUploaded: surveyCountModel.totalNotUpload == 0),

                      ],
                    ),
                  ),
                ),
                if(isDataUploading)
                const Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: MyLoadingCircle(),
                  ),
                )
              ],
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 77, 145, 1),
                minimumSize: Size(MediaQuery.of(context).size.width/1.1, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed:isDataUploading ? null : isFinishButton ? () async {

                setState(() {
                  isDataUploading = true;
                });

                // GeneralChecksStatusController generalStatusController = await generalControllerInitialization();
                //
                // List<String> latLong = gcode.split('=')[1].split(',');
                // String storeLat = latLong[0];
                // String storeLong = latLong[1];


               // if(generalStatusController.isLocationStatus.value) {
               //
               //   if(generalStatusController.sysAppSettingModel.isGeoLocationEnabled == "0") {
               //     generalStatusController.isGeoFenceDistance.value = 0.5,
               //   } else {
               //
               //     await generalStatusController.getGeoLocationDistance(
               //         double.parse(generalStatusController.isLat.value),
               //         double.parse(generalStatusController.isLong
               //             .value), double.parse(storeLat.trim()),
               //         double.parse(storeLong.trim())),
               //   }
               // },
               // if(generalStatusController.isVpnStatus.value) {
               //   showAnimatedToastMessage("Error!".tr,"Please Disable Your VPN".tr, false),
               // }
               // else if(generalStatusController.isMockLocation.value) {
               //   showAnimatedToastMessage("Error!".tr, "Please Disable Your Fake Locator".tr, false),
               // }
               // else if(!generalStatusController.isAutoTimeStatus.value) {
               //   showAnimatedToastMessage("Error!".tr, "Please Enable Your Auto time Option From Setting".tr, false),
               // }
               // else if(!generalStatusController.isLocationStatus.value) {
               //   showAnimatedToastMessage("Error!".tr, "Please Enable Your Location".tr, false),
               // }
               // else if(generalStatusController.isGeoFenceDistance.value > 0.7) {
               //   showAnimatedToastMessage("Error!".tr, "You’re just 0.7 km away from the store. Please contact your supervisor for the exact location details".tr, false),
               // } else {
               //   Get.delete<GeneralChecksStatusController>(),

                 if (userRole == "TMR") {
                   if(bucketName == "binzagr-bucket" && clientId == "2,0") {
                     setState(() {
                       isDataUploading = false;
                     });
                     showDialog(
                       context: context,
                       barrierDismissible: false,
                       builder: (BuildContext context) {
                         return StatefulBuilder(
                             builder: (BuildContext context1,
                                 StateSetter menuState) {
                               return AlertDialog(
                                 title: Text('Visit'.tr),
                                 content: Text(
                                     'Are you sure you want to finish this visit?'
                                         .tr),
                                 actions: <Widget>[
                                   isDataUploading ? const Row(
                                     mainAxisAlignment: MainAxisAlignment
                                         .center,
                                     crossAxisAlignment: CrossAxisAlignment
                                         .center,
                                     children: [
                                       CircularProgressIndicator(
                                         color: MyColors.appMainColor2,),
                                     ],
                                   ) : Row(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     crossAxisAlignment: CrossAxisAlignment
                                         .end,
                                     children: [
                                       TextButton(
                                         onPressed: () {
                                           Navigator.of(context)
                                               .pop(); // Close the dialog
                                         },
                                         child: Text('No'.tr),
                                       ),
                                       isDataUploading ? const CircularProgressIndicator() : TextButton(
                                         onPressed: () {
                                           // Perform logout operation
                                           finishVisit(menuState);
                                         },
                                         child: Text('Yes'.tr),
                                       ),
                                     ],
                                   )
                                 ],
                               );
                             }
                         );
                       },
                     );
                   } else if ( (moduleIdList.contains("3") || moduleIdList.contains("17")) && ((availabilityCountModel.totalSku != availabilityCountModel.totalUploaded) || availabilityCountModel.totalSku == 0 || availabilityCountModel.totalUploaded.toString() == "null")) {
                     setState(() {
                       isDataUploading = false;
                     });
                     showAnimatedToastMessage(
                         "Error!".tr, "Please Mark All Sku's Availability".tr,
                         false);
                   } else if ((moduleIdList.contains("3")) &&
                       (tmrPickListCountModel.totalPickListItems !=
                           tmrPickListCountModel.totalPickReady)) {
                     setState(() {
                       isDataUploading = false;
                     });
                     showAnimatedToastMessage(
                         "Error!".tr, "Please Wait for pick list response".tr,
                         false);
                   } else if ((moduleIdList.contains("15")) && (planoguideCountModel
                       .totalUploaded.toString() == "null" ||
                       planoguideCountModel.totalUploaded == 0)) {
                     setState(() {
                       isDataUploading = false;
                     });
                     showAnimatedToastMessage("Error!".tr,
                         "PLease Add At lease one planoguide".tr, false);
                   } else if ((moduleIdList.contains("16")) &&
                       (brandShareCountModel.totalUpload.toString() ==
                           "null" || brandShareCountModel.totalUpload == 0)) {
                     setState(() {
                       isDataUploading = false;
                     });
                     showAnimatedToastMessage("Error!".tr,
                         "Please Add at least one brand share".tr, false);
                   } else if(moduleIdList.contains("22") && (surveyCountModel.totalUpload.toString() == "null" || surveyCountModel.totalUpload==0)) {
                     setState(() {
                       isDataUploading = false;
                     });
                     showAnimatedToastMessage("Error!".tr,
                         "Please complete your survey".tr, false);
                   } else {
                     setState(() {
                       isDataUploading = false;
                     });
                     // print("Visit Finished Successfully");

                     showDialog(
                       context: context,
                       barrierDismissible: false,
                       builder: (BuildContext context) {
                         return StatefulBuilder(
                             builder: (BuildContext context1,
                                 StateSetter menuState) {
                               return AlertDialog(
                                 title: Text('Visit'.tr),
                                 content: Text(
                                     'Are you sure you want to finish this visit?'
                                         .tr),
                                 actions: <Widget>[
                                   isDataUploading ? const Row(
                                     mainAxisAlignment: MainAxisAlignment
                                         .center,
                                     crossAxisAlignment: CrossAxisAlignment
                                         .center,
                                     children: [
                                       CircularProgressIndicator(
                                         color: MyColors.appMainColor2,),
                                     ],
                                   ) : Row(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     crossAxisAlignment: CrossAxisAlignment
                                         .end,
                                     children: [
                                       TextButton(
                                         onPressed: () {
                                           Navigator.of(context)
                                               .pop(); // Close the dialog
                                         },
                                         child: Text('No'.tr),
                                       ),
                                       isDataUploading ? const CircularProgressIndicator() : TextButton(
                                         onPressed: () {
                                           // Perform logout operation
                                           finishVisit(menuState);
                                         },
                                         child: Text('Yes'.tr),
                                       ),
                                     ],
                                   )
                                 ],
                               );
                             }
                         );
                       },
                     );
                   }
                 }
                 else {
                   if ((moduleIdList.contains("4")) &&
                       (pickListCountModel.totalPickListItems !=
                           pickListCountModel.totalPickReady) &&
                       (pickListCountModel.totalPickListItems !=
                           pickListCountModel.totalUpload) ||
                       pickListCountModel.totalUpload.toString() == "null") {
                     setState(() {
                       isDataUploading = false;
                     });
                     // ToastMessage.errorMessage(context, "Please make all pick list ready and upload it".tr);
                     showAnimatedToastMessage("Error!".tr,
                         "Please make all pick list ready and upload it".tr,
                         false);
                   } else {
                     setState(() {
                       isDataUploading = false;
                     });
                     showDialog(
                       context: context,
                       barrierDismissible: false,
                       builder: (BuildContext context) {
                         return StatefulBuilder(
                             builder: (BuildContext context1,
                                 StateSetter menuState) {
                               return AlertDialog(
                                 title: Text('Visit'.tr),
                                 content: Text(
                                     'Are you sure you want to finish this visit?'
                                         .tr),
                                 actions: <Widget>[
                                   isDataUploading ? const Row(
                                     mainAxisAlignment: MainAxisAlignment
                                         .center,
                                     crossAxisAlignment: CrossAxisAlignment
                                         .center,
                                     children: [
                                       CircularProgressIndicator(
                                         color: MyColors.appMainColor2,),
                                     ],
                                   ) : Row(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     crossAxisAlignment: CrossAxisAlignment
                                         .end,
                                     children: [
                                       TextButton(
                                         onPressed: () {
                                           Navigator.of(context)
                                               .pop(); // Close the dialog
                                         },
                                         child: Text('No'.tr),
                                       ),
                                       isDataUploading ? const CircularProgressIndicator() : TextButton(
                                         onPressed: () {
                                           // Perform logout operation
                                           finishVisit(menuState);
                                         },
                                         child: Text('Yes'.tr),
                                       ),
                                     ],
                                   )
                                 ],
                               );
                             }
                         );
                       },
                     );
                   }
                 }
               // }

              } : null,
              child: Text(
                "Finish Visit".tr,style: TextStyle(color: isFinishButton ? MyColors.whiteColor : MyColors.appMainColor2),
              ),
            ),
          )
        ],
      )
    );
  }

  Future<void> _getImages(String module) async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      final String dirPath = (await getExternalStorageDirectory())!.path;
      final String folderPath = '$dirPath/cstore/$workingId/$module';
      final Directory folder = Directory(folderPath);
      // print(folderPath);
      if (await folder.exists()) {
        final List<FileSystemEntity> files = folder.listSync();
        _imageFiles = files.whereType<File>().toList();
        // print("****************** $module");
        // print(_imageFiles);
      } else {
        print("Folder does not exist");
      }
    } catch (e) {
      print('Error reading images: $e');
    }
  }

  Future<bool> getAllCountData() async {
    setState(() {
      isFinishButton = true;
    });

    await DatabaseHelper.getAvailabilityCountData(workingId).then((value) {
      availabilityCountModel = value;

      setState((){});
    });

    await DatabaseHelper.getTmrPickListCountData(workingId).then((value) {
      tmrPickListCountModel = value;

      setState((){});
    });

    await DatabaseHelper.getPlanoguideCountData(workingId).then((value) {
      planoguideCountModel = value;

      setState((){});
    });

    await DatabaseHelper.getBrandShareCountData(workingId).then((value) {
      brandShareCountModel = value;

      setState((){});
    });

    await DatabaseHelper.getPicklistCountData(userName).then((value) {
      pickListCountModel = value;

      setState((){});
    });

    await DatabaseHelper.getRtvCountDataServices(workingId).then((value) {
      rtvCountModel = value;

      setState(() {

      });
    });


    await DatabaseHelper.getPriceCheckCountData(workingId).then((value) {

      priceCheckCountModel = value;

      setState(() {

      });
    });

    await DatabaseHelper.getReplenishmentCountDataForSummary(workingId).then((value) {

      replenishmentCountModel = value;

      setState(() {

      });
    });

    await DatabaseHelper.getFreshnessGraphCount(workingId,"-1",clientId.toString(),"-1","-1","-1").then((value) {
      setState(() {
        freshnessGraphCountShowModel = value;
      });
    });

    await DatabaseHelper.getPromoGraphAndApiCount(workingId).then((value) {

      promoPlanGraphAndApiCountShowModel = value;

      setState(() {

      });
    });

    await DatabaseHelper.getStockCount(workingId,
        "-1",
        "-1",
        "-1",
       "-1").then((value) {
      totalStockCountData = value;
      setState(() {
      });
    });

    await DatabaseHelper.getBeforeFixingCountData(workingId).then((value) {

      beforeFixingCountModel = value;

    });

    await DatabaseHelper.getOtherPhotoCountData(workingId).then((value) {

      otherPhotoCountModel = value;

    });

    await DatabaseHelper.getSosCountData(workingId).then((value) {

      sosCountModel = value;

    });

    await DatabaseHelper.getTransPlanogramCountData(workingId).then((value) {

      planogramCountModel = value;

    });

    await DatabaseHelper.getOnePLusOneCountDataServices(workingId).then((value) {

      onePlusOneCountModel = value;

    });

    await DatabaseHelper.getPosCountDataServices(workingId).then((value) {

      posCountModel = value;

    });

    await DatabaseHelper.getOsdCountDataServices(workingId).then((value) {

      osdCountModel = value;

    });

    await DatabaseHelper.getMarketIssueCountDataServices(workingId).then((value) {

      marketIssueCountModel = value;

    });

    await DatabaseHelper.getSurveyCountData(workingId).then((value) {

      surveyCountModel = value;

    });

    setState(() {

      if(beforeFixingCountModel.totalNotUpload > 0) {
        isFinishButton = false;
      }

      if(otherPhotoCountModel.totalNotUpload > 0) {
        isFinishButton = false;
      }

      if(sosCountModel.totalNotUpload > 0) {
        isFinishButton = false;
      }

      if(planogramCountModel.totalNotUpload > 0) {

        isFinishButton = false;

      }

      if(availabilityCountModel.totalNotUploaded > 0) {
        isFinishButton = false;
      }

      if( planoguideCountModel.totalNotUploaded >0) {
        isFinishButton = false;
      }
      if(brandShareCountModel.totalNotUpload >0) {
        isFinishButton = false;
      }

      if(pickListCountModel.totalUpload < pickListCountModel.totalPickListItems) {
        isFinishButton = false;
      }

      if(tmrPickListCountModel.totalPickUpload < tmrPickListCountModel.totalPickListItems) {
        isFinishButton = false;
      }

      if(rtvCountModel.totalNotUpload > 0) {
        isFinishButton = false;
      }

      if(priceCheckCountModel.totalNotUpload > 0) {
        isFinishButton = false;
      }

      if(freshnessGraphCountShowModel.totalNotUploadCount > 0) {
        isFinishButton = false;
      }

      if(promoPlanGraphAndApiCountShowModel.totalNotUploadCount > 0) {
        isFinishButton = false;
      }

      if(totalStockCountData.total_not_upload > 0) {
        isFinishButton = false;
      }

      if(onePlusOneCountModel.totalNotUpload > 0) {
        isFinishButton = false;
      }

      if(posCountModel.totalNotUpload > 0) {
        isFinishButton = false;
      }

      if(osdCountModel.totalNotUpload > 0) {
        isFinishButton = false;
      }

      if(marketIssueCountModel.totalNotUpload > 0) {
        isFinishButton = false;
      }

      if(surveyCountModel.totalNotUpload > 0) {
        isFinishButton = false;
      }

    });
    print("isFinishButtonisFinishButton");
    print(isFinishButton);

    return true;
  }

  setTransPhotoInList(String module) {

    if(module == AppConstants.planoguide) {

      for (int j=0;j<planoguideGcsImagesList.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if(planoguideGcsImagesList[j].imageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(planoguideGcsImagesList[j].imageName)) {
              planoguideGcsImagesList[j].imageFile = _imageFiles[i];
            }
          }
        }
      }
    }

    if(module == AppConstants.rtv) {

      for (int j=0;j<rtvGcsImagesList.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if(rtvGcsImagesList[j].imageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(rtvGcsImagesList[j].imageName)) {
              rtvGcsImagesList[j].imageFile = _imageFiles[i];
            }
          }
        }
      }
    }

    if(module == AppConstants.promoPlan) {

      for (int j=0;j<promoPlanGcsImagesList.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if(promoPlanGcsImagesList[j].imageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(promoPlanGcsImagesList[j].imageName)) {
              promoPlanGcsImagesList[j].imageFile = _imageFiles[i];
            }
          }
        }
      }
    }

    if(module == AppConstants.beforeFixing) {

      for (int j=0;j<beforeFixingGcsImagesList.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if(beforeFixingGcsImagesList[j].imageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(beforeFixingGcsImagesList[j].imageName)) {
              beforeFixingGcsImagesList[j].imageFile = _imageFiles[i];
            }
          }
        }
      }
    }

    if(module == AppConstants.otherPhoto) {

      for (int j=0;j<otherPhotoGcsImagesList.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if(otherPhotoGcsImagesList[j].imageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(otherPhotoGcsImagesList[j].imageName)) {
              otherPhotoGcsImagesList[j].imageFile = _imageFiles[i];
            }
          }
        }
      }

    }

    if(module == AppConstants.planogram) {

      for (int j=0;j<planogramGcsImagesList.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if(planogramGcsImagesList[j].imageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(planogramGcsImagesList[j].imageName)) {
              planogramGcsImagesList[j].imageFile = _imageFiles[i];
            }
          }
        }
      }

    }

    if(module == AppConstants.marketIssues) {

      for (int j=0;j<marketIssueGcsImagesList.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if(marketIssueGcsImagesList[j].imageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(marketIssueGcsImagesList[j].imageName)) {
              marketIssueGcsImagesList[j].imageFile = _imageFiles[i];
            }
          }
        }
      }

    }

    if(module == AppConstants.pos) {

      for (int j=0;j<posGcsImagesList.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if(posGcsImagesList[j].imageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(posGcsImagesList[j].imageName)) {
              posGcsImagesList[j].imageFile = _imageFiles[i];
            }
          }
        }
      }

    }

    if(module == AppConstants.osdc) {

      for (int j=0;j<osdGcsImagesList.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if(osdGcsImagesList[j].imageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(osdGcsImagesList[j].imageName)) {
              osdGcsImagesList[j].imageFile = _imageFiles[i];
            }
          }
        }
      }

    }

    if(module == AppConstants.onePlusOne) {

      for (int j=0;j<onePlusOneGcsImageList.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if(onePlusOneGcsImageList[j].imageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(onePlusOneGcsImageList[j].imageName)) {
              onePlusOneGcsImageList[j].imageFile = _imageFiles[i];
            }
          }

          if(onePlusOneGcsImageList[j].docImageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(onePlusOneGcsImageList[j].docImageName)) {
              onePlusOneGcsImageList[j].docImageFile = _imageFiles[i];
            }
          }
        }
      }

    }

    if(module == AppConstants.survey) {

      surveyImagesDataList.clear();

      for(int i = 0; i<surveyGcsImagesList.length; i++) {
        List surveyImages = surveyGcsImagesList[i].imageName.split(",");

        for(int j = 0; j < surveyImages.length; j++) {
         surveyImagesDataList.add(TransPlanoGuideGcsImagesListModel(id: surveyGcsImagesList[i].id, imageFile: null, imageName: surveyImages[j]));
        }
      }

      for (int j=0;j<surveyImagesDataList.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if(surveyImagesDataList[j].imageName.isNotEmpty)
          {
            if (_imageFiles[i].path.endsWith(surveyImagesDataList[j].imageName)) {
              surveyImagesDataList[j].imageFile = _imageFiles[i];
            }
          }
        }

        print("-------------------------");
        print(surveyImagesDataList[j].id);
        print(surveyImagesDataList[j].imageName);
        print(surveyImagesDataList[j].imageFile);
        print("-------------------------");

      }


    }


  }

  Future<bool>uploadImagesToGcs(String moduleName) async {
    try {
      final credentials = ServiceAccountCredentials.fromJson(
        await rootBundle.loadString(
            'assets/google_cloud_creds/appimages-keycstoreapp-7c0f4-a6d4c3e5b590.json'),
      );

      final httpClient = await clientViaServiceAccount(credentials, [StorageApi.devstorageReadWriteScope]);

      // Create a Storage client with the credentials
      final storage = StorageApi(httpClient);

      if(moduleName == AppConstants.planoguide) {

        setState(() {
          isPlanoguideFinishLoading = true;
        });

        await DatabaseHelper.getPlanoGuideGcsImagesList(workingId).then((value) async {

          planoguideGcsImagesList = value.cast<TransPlanoGuideGcsImagesListModel>();

          await _getImages(AppConstants.planoguide).then((value) {
            setTransPhotoInList(AppConstants.planoguide);

            setState(() {

            });
          });

        });

        print("------Planoguide Image Upload -------- ");
        for(int j = 0; j < planoguideGcsImagesList.length; j++) {


          if(planoguideGcsImagesList[j].imageFile != null) {

            bool isCorruptImage = await isImageCorrupted(XFile(planoguideGcsImagesList[j].imageFile!.path));
            if(isCorruptImage) {
              await updatePLanoguideAfterGcs1(planoguideGcsImagesList[j].id);
            } else {

              final filename =  planoguideGcsImagesList[j].imageName;
              final filePath = 'capture_photo/$filename';
              final fileContent = await planoguideGcsImagesList[j].imageFile!.readAsBytes();
              final bucketObject = Object(name: filePath);

              final resp = await storage.objects.insert(
                bucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([fileContent]),
                  fileContent.length,
                ),
              );
              print("Image Uploaded successfully");

              await updatePLanoguideAfterGcs1(planoguideGcsImagesList[j].id);

            }
          } else {
            await updatePLanoguideAfterGcs1(planoguideGcsImagesList[j].id);
          }

        }
        setState(() {
          isPlanoguideFinishLoading = false;
        });

        planoguideUploadApi();

      }

      if(moduleName == AppConstants.rtv) {

        setState(() {
          isRtvFinishLoading = true;
        });

        await DatabaseHelper.getRtvGcsImagesList(workingId).then((value) async {

          rtvGcsImagesList = value.cast<TransPlanoGuideGcsImagesListModel>();

          await _getImages(AppConstants.rtv).then((value) {
            setTransPhotoInList(AppConstants.rtv);

            setState(() {

            });
          });

        });

        print("------RTV Image Upload -------- ");
        for(int j = 0; j < rtvGcsImagesList.length; j++) {

          if(rtvGcsImagesList[j].imageFile != null) {

            bool isCorruptImage = await isImageCorrupted(XFile(rtvGcsImagesList[j].imageFile!.path));

            if(isCorruptImage) {
              await updateRtvAfterGcs1(rtvGcsImagesList[j].id);
            } else {

              final filename =  rtvGcsImagesList[j].imageName;
              final filePath = 'capture_photo/$filename';
              final fileContent = await rtvGcsImagesList[j].imageFile!.readAsBytes();
              final bucketObject = Object(name: filePath);

              final resp = await storage.objects.insert(
                bucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([fileContent]),
                  fileContent.length,
                ),
              );
              print("Image Uploaded successfully");

              await updateRtvAfterGcs1(rtvGcsImagesList[j].id);

            }

          } else {
            await updateRtvAfterGcs1(rtvGcsImagesList[j].id);
          }


        }
        setState(() {
          isRtvFinishLoading = false;
        });

        rtvUploadApi();
      }

      if(moduleName == AppConstants.promoPlan) {

        setState(() {
          isPromoPlanFinishLoading = true;
        });

        await DatabaseHelper.getPromoPlanGcsImagesList(workingId).then((value) async {

          promoPlanGcsImagesList = value.cast<TransPlanoGuideGcsImagesListModel>();

          await _getImages(AppConstants.promoPlan).then((value) {
            setTransPhotoInList(AppConstants.promoPlan);

            setState(() {});
          });

        });

        print("------Promo Plan Image Upload -------- ");
        for(int j = 0; j < promoPlanGcsImagesList.length; j++) {

          if(promoPlanGcsImagesList[j].imageFile != null) {

            bool isCorruptImage = await isImageCorrupted(XFile(promoPlanGcsImagesList[j].imageFile!.path));

            if(isCorruptImage) {

              await updatePromoPlanAfterGcs1(promoPlanGcsImagesList[j].id);

            } else {

              final filename =  promoPlanGcsImagesList[j].imageName;
              final filePath = 'capture_photo/$filename';
              final fileContent = await promoPlanGcsImagesList[j].imageFile!.readAsBytes();
              final bucketObject = Object(name: filePath);

              final resp = await storage.objects.insert(
                bucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([fileContent]),
                  fileContent.length,
                ),
              );
              print(resp.mediaLink);
              print("Image Uploaded successfully");

              await updatePromoPlanAfterGcs1(promoPlanGcsImagesList[j].id);

            }
          } else {
            await updatePromoPlanAfterGcs1(promoPlanGcsImagesList[j].id);
          }


        }
        setState(() {
          isPromoPlanFinishLoading = false;
        });

        promoPlanUploadApi();
      }

      if(moduleName == AppConstants.beforeFixing) {

        setState(() {
          isBeforeFixingFinishLoading = true;
        });

        await DatabaseHelper.geBeforeFixingGcsImagesList(workingId).then((value) async {

          beforeFixingGcsImagesList = value.cast<TransPlanoGuideGcsImagesListModel>();

          await _getImages(AppConstants.beforeFixing).then((value) {
            setTransPhotoInList(AppConstants.beforeFixing);

            setState(() {});
          });

        });

        print("------Before Fixing Image Upload -------- ");
        for(int j = 0; j < beforeFixingGcsImagesList.length; j++) {

          if(beforeFixingGcsImagesList[j].imageFile != null) {

            bool isCorruptImage = await isImageCorrupted(XFile(beforeFixingGcsImagesList[j].imageFile!.path));
            if(isCorruptImage) {
              await updatBeforeFixingAfterGcs1(beforeFixingGcsImagesList[j].id);
            } else {

              final filename =  beforeFixingGcsImagesList[j].imageName;
              final filePath = 'capture_photo/$filename';
              final fileContent = await beforeFixingGcsImagesList[j].imageFile!.readAsBytes();
              final bucketObject = Object(name: filePath);

              final resp = await storage.objects.insert(
                bucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([fileContent]),
                  fileContent.length,
                ),
              );
              print("Image Uploaded successfully");

              await updatBeforeFixingAfterGcs1(beforeFixingGcsImagesList[j].id);

            }
          } else {
            await updatBeforeFixingAfterGcs1(beforeFixingGcsImagesList[j].id);
          }

        }
        setState(() {
          isBeforeFixingFinishLoading = false;
        });

        beforeFixingUploadApi();
      }

      if(moduleName == AppConstants.otherPhoto) {

        setState(() {
          isOtherPhotoFinishLoading = true;
        });

        await DatabaseHelper.getOtherPhotoGcsImagesList(workingId).then((value) async {

          otherPhotoGcsImagesList = value.cast<TransPlanoGuideGcsImagesListModel>();

          await _getImages(AppConstants.otherPhoto).then((value) {
            setTransPhotoInList(AppConstants.otherPhoto);

            setState(() {});
          });

        });

        print("------Other Photo Image Upload -------- ");
        for(int j = 0; j < otherPhotoGcsImagesList.length; j++) {

          if(otherPhotoGcsImagesList[j].imageFile != null) {

            bool isCorruptImage = await isImageCorrupted(XFile(otherPhotoGcsImagesList[j].imageFile!.path));
            if(isCorruptImage) {
              await updateOtherAfterGcs1(otherPhotoGcsImagesList[j].id);
            } else {
              final filename =  otherPhotoGcsImagesList[j].imageName;
              final filePath = 'capture_photo/$filename';
              final fileContent = await otherPhotoGcsImagesList[j].imageFile!.readAsBytes();
              final bucketObject = Object(name: filePath);

              final resp = await storage.objects.insert(
                bucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([fileContent]),
                  fileContent.length,
                ),
              );
              print("Image Uploaded successfully");

              await updateOtherAfterGcs1(otherPhotoGcsImagesList[j].id);

            }
          } else {
            await updateOtherAfterGcs1(otherPhotoGcsImagesList[j].id);
          }

        }
        setState(() {
          isOtherPhotoFinishLoading = false;
        });

        otherPhotoUploadApi();

      }

      if(moduleName == AppConstants.planogram) {

        setState(() {
          isPlanogramFinishLoading = true;
        });

        await DatabaseHelper.getTransPlanogramGcsImagesList(workingId).then((value) async {

          planogramGcsImagesList = value.cast<TransPlanoGuideGcsImagesListModel>();

          await _getImages(AppConstants.planogram).then((value) {
            setTransPhotoInList(AppConstants.planogram);

            setState(() {});
          });

        });

        print("------Planogram Image Upload -------- ");
        for(int j = 0; j < planogramGcsImagesList.length; j++) {

          if(planogramGcsImagesList[j].imageFile != null) {

            bool isCorruptImage = await isImageCorrupted(XFile(planogramGcsImagesList[j].imageFile!.path));

            if(isCorruptImage) {
              await updatePlanogramAfterGcs1(planogramGcsImagesList[j].id);
            } else {

              final filename =  planogramGcsImagesList[j].imageName;
              final filePath = 'planogram/$filename';
              final fileContent = await planogramGcsImagesList[j].imageFile!.readAsBytes();
              final bucketObject = Object(name: filePath);

              final resp = await storage.objects.insert(
                bucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([fileContent]),
                  fileContent.length,
                ),
              );
              print("Image Uploaded successfully");

              await updatePlanogramAfterGcs1(planogramGcsImagesList[j].id);

            }
          } else {
            await updatePlanogramAfterGcs1(planogramGcsImagesList[j].id);
          }

        }
        setState(() {
          isPlanogramFinishLoading = false;
        });

        planogramUploadApi();

      }

      if(moduleName == AppConstants.marketIssues) {

        setState(() {
          isMarketIssueFinishLoading = true;
        });

        await DatabaseHelper.getMarketIssueGcsImagesList(workingId).then((value) async {

          marketIssueGcsImagesList = value.cast<TransPlanoGuideGcsImagesListModel>();

          await _getImages(AppConstants.marketIssues).then((value) {
            setTransPhotoInList(AppConstants.marketIssues);

            setState(() {

            });
          });

        });

        print("------Market Issue Image Upload -------- ");
        for(int j = 0; j < marketIssueGcsImagesList.length; j++) {

          if(marketIssueGcsImagesList[j].imageFile != null) {

            bool isCorruptImage = await isImageCorrupted(XFile(marketIssueGcsImagesList[j].imageFile!.path));
            if(isCorruptImage) {
              await updateMarketIssueAfterGcs1(marketIssueGcsImagesList[j].id);
            } else {
              final filename =  marketIssueGcsImagesList[j].imageName;
              final filePath = 'capture_photo/$filename';
              final fileContent = await marketIssueGcsImagesList[j].imageFile!.readAsBytes();
              final bucketObject = Object(name: filePath);

              final resp = await storage.objects.insert(
                bucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([fileContent]),
                  fileContent.length,
                ),
              );
              print("Image Uploaded successfully");

              await updateMarketIssueAfterGcs1(marketIssueGcsImagesList[j].id);

            }
          } else {
            await updateMarketIssueAfterGcs1(marketIssueGcsImagesList[j].id);
          }

        }
        setState(() {
          isMarketIssueFinishLoading = false;
        });

        marketIssueUploadApi();

      }

      if(moduleName == AppConstants.pos) {

        setState(() {
          isPosFinishLoading = true;
        });

        await DatabaseHelper.getPosGcsImagesList(workingId).then((value) async {

          posGcsImagesList = value.cast<TransPlanoGuideGcsImagesListModel>();

          await _getImages(AppConstants.pos).then((value) {
            setTransPhotoInList(AppConstants.pos);

            setState(() {

            });
          });

        });

        print("------POS Image Upload -------- ");
        for(int j = 0; j < posGcsImagesList.length; j++) {

          if(posGcsImagesList[j].imageFile != null) {

            bool isCorruptImage = await isImageCorrupted(XFile(posGcsImagesList[j].imageFile!.path));
            if(isCorruptImage) {
              await updatePosAfterGcs1(posGcsImagesList[j].id);
            } else {

              final filename =  posGcsImagesList[j].imageName;
              final filePath = 'capture_photo/$filename';
              final fileContent = await posGcsImagesList[j].imageFile!.readAsBytes();
              final bucketObject = Object(name: filePath);

              final resp = await storage.objects.insert(
                bucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([fileContent]),
                  fileContent.length,
                ),
              );
              print("Image Uploaded successfully");

              await updatePosAfterGcs1(posGcsImagesList[j].id);

            }
          } else {
            await updatePosAfterGcs1(posGcsImagesList[j].id);
          }
        }
        setState(() {
          isPosFinishLoading = false;
        });

        posUploadApi();

      }

      if(moduleName == AppConstants.osdc) {

        setState(() {
          isOsdFinishLoading = true;
        });

        await DatabaseHelper.getOsdcGcsImagesList(workingId).then((value) async {

          osdGcsImagesList = value.cast<TransPlanoGuideGcsImagesListModel>();

          await _getImages(AppConstants.osdc).then((value) {
            setTransPhotoInList(AppConstants.osdc);

            setState(() {

            });
          });

        });

        print("------OSD Image Upload -------- ");
        for(int j = 0; j < osdGcsImagesList.length; j++) {

          if(osdGcsImagesList[j].imageFile != null) {

            bool isCorruptImage = await isImageCorrupted(XFile(osdGcsImagesList[j].imageFile!.path));

            if(isCorruptImage) {
              await updateOsdAfterGcs1(osdGcsImagesList[j].id);
            } else {
              final filename =  osdGcsImagesList[j].imageName;
              final filePath = 'osd_images/$filename';
              final fileContent = await osdGcsImagesList[j].imageFile!.readAsBytes();
              final bucketObject = Object(name: filePath);

              final resp = await storage.objects.insert(
                bucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([fileContent]),
                  fileContent.length,
                ),
              );
              print(resp.mediaLink);
              print("Image Uploaded successfully");

              await updateOsdAfterGcs1(osdGcsImagesList[j].id);

            }
          } else {
            await updateOsdAfterGcs1(osdGcsImagesList[j].id);
          }
        }
        setState(() {
          isOsdFinishLoading = false;
        });

        osdUploadApi();

      }

      if(moduleName == AppConstants.onePlusOne) {

        setState(() {
          isOnePlusOneFinishLoading = true;
        });

        await DatabaseHelper.getOnePlusOneGcsImagesList(workingId).then((value) async {

          onePlusOneGcsImageList = value.cast<TransOnePlusOneGcsImagesListModel>();

          await _getImages(AppConstants.onePlusOne).then((value) {
            setTransPhotoInList(AppConstants.onePlusOne);

            setState(() {

            });
          });

        });

        print("------One Plus One Image Upload -------- ");
        for(int j = 0; j < onePlusOneGcsImageList.length; j++) {

          if(onePlusOneGcsImageList[j].imageFile != null && onePlusOneGcsImageList[j].docImageFile != null ) {

            bool isCorruptImage = await isImageCorrupted(XFile(onePlusOneGcsImageList[j].imageFile!.path));

            bool isFileCorrupt = await isImageCorrupted(XFile(onePlusOneGcsImageList[j].docImageFile!.path));

            if(isCorruptImage || isFileCorrupt) {
              await updateOnePlusAfterGcs1(onePlusOneGcsImageList[j].id);
            } else {

              final filename =  onePlusOneGcsImageList[j].imageName;
              final filePath = 'capture_photo/$filename';
              final fileContent = await onePlusOneGcsImageList[j].imageFile!.readAsBytes();
              final bucketObject = Object(name: filePath);

              final resp = await storage.objects.insert(
                bucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([fileContent]),
                  fileContent.length,
                ),
              );

              final docFilename =  onePlusOneGcsImageList[j].docImageName;
              final docFilePath = 'capture_photo/$docFilename';
              final docFileContent = await onePlusOneGcsImageList[j].docImageFile!.readAsBytes();
              final docBucketObject = Object(name: docFilePath);

              final respDoc = await storage.objects.insert(
                docBucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([docFileContent]),
                  docFileContent.length,
                ),
              );
              print("Image Uploaded successfully");

              await updateOnePlusAfterGcs1(onePlusOneGcsImageList[j].id);

            }
          } else {
            await updateOnePlusAfterGcs1(onePlusOneGcsImageList[j].id);
          }


        }
        setState(() {
          isOnePlusOneFinishLoading = false;
        });

        onePlusOneUploadApi();
      }

      if(moduleName == AppConstants.survey) {

        setState(() {
          isSurveyFinishLoading = true;
        });

        await DatabaseHelper.getSurveyGcsImagesList(workingId).then((value) async {

          surveyGcsImagesList = value.cast<TransPlanoGuideGcsImagesListModel>();

          await _getImages(AppConstants.survey).then((value) {
            setTransPhotoInList(AppConstants.survey);

            setState(() {

            });
          });

          setState(() {
            isSurveyFinishLoading = false;
          });

        });

        setState(() {
          isSurveyFinishLoading = true;
        });


        print("------Survey Image Upload -------- ");
        for(int j = 0; j < surveyImagesDataList.length; j++) {

          if(surveyImagesDataList[j].imageFile != null) {

            bool isCorruptImage = await isImageCorrupted(XFile(surveyImagesDataList[j].imageFile!.path));
            if(isCorruptImage) {
              await updateSurveyAfterGcs1(surveyImagesDataList[j].id);
            } else {

              final filename =  surveyImagesDataList[j].imageName;
              final filePath = 'survey_photo/$filename';
              final fileContent = await surveyImagesDataList[j].imageFile!.readAsBytes();
              final bucketObject = Object(name: filePath);

              final resp = await storage.objects.insert(
                bucketObject,
                bucketName,
                predefinedAcl: 'publicRead',
                uploadMedia: Media(
                  Stream<List<int>>.fromIterable([fileContent]),
                  fileContent.length,
                ),
              );
              print("Image Uploaded successfully");

              await updateSurveyAfterGcs1(surveyImagesDataList[j].id);

            }
          } else {
            await updateSurveyAfterGcs1(surveyImagesDataList[j].id);
          }

        }
        setState(() {
          isSurveyFinishLoading = false;
        });

        surveyUploadApi();

      }

      return true;
    } catch (e) {
      // Handle any errors that occur during the upload
      print("Upload GCS Error $e");
      setState(() {
        isAvlFinishLoading = false;
         isPickListFinishLoading = false;
         isPlanoguideFinishLoading = false;
         isShelfShareFinishLoading = false;
         isRtvFinishLoading = false;
         isPriceCheckFinishLoading = false;
         isFreshnessFinishLoading = false;
         isPromoPlanFinishLoading = false;
         isStockFinishLoading = false;
         isBeforeFixingFinishLoading = false;
         isOtherPhotoFinishLoading = false;
         isSosFinishLoading = false;
         isPlanogramFinishLoading = false;
         isMarketIssueFinishLoading = false;
         isOsdFinishLoading = false;
         isOnePlusOneFinishLoading = false;
         isPosFinishLoading = false;
      });
      showAnimatedToastMessage("Error!".tr,"Uploading images error please try again!".tr,false);
      return false;
    }
  }

  Future<bool> updateSurveyAfterGcs1(int surveyQuestionId) async {
    print("UPLOAD SURVEY AFTER GCS");
    await DatabaseHelper.updateSurveyAfterGcsAfterFinish(surveyQuestionId,workingId).then((value) {

    });

    return true;
  }

  Future<bool> updatePLanoguideAfterGcs1(int planoguideId) async {
    print("UPLOAD PLANO AFTER GCS");
    await DatabaseHelper.updatePlanoguideAfterGcsAfterFinish(planoguideId,workingId).then((value) {

    });

    return true;
  }

  Future<bool> updateRtvAfterGcs1(int rtvId) async {
    print("UPLOAD Rtv AFTER GCS");
    await DatabaseHelper.updateRtvAfterGcsAfterFinish(rtvId,workingId).then((value) {

    });

    return true;
  }

  Future<bool> updatePromoPlanAfterGcs1(int promoId) async {
    print("UPLOAD Rtv AFTER GCS");
    await DatabaseHelper.updatePromoPlanAfterGcsImageUpload(workingId,promoId.toString()).then((value) {

    });

    return true;
  }

  Future<bool> updatBeforeFixingAfterGcs1(int promoId) async {
    print("UPLOAD Before Fixing AFTER GCS");
    await DatabaseHelper.updateBeforeFixingAfterGcsImageUpload(workingId,promoId.toString()).then((value) {

    });

    return true;
  }

  Future<bool> updateOtherAfterGcs1(int promoId) async {
    print("UPLOAD Other Photo AFTER GCS");
    await DatabaseHelper.updateOtherPhotoAfterGcsImageUpload(workingId,promoId.toString()).then((value) {

    });

    return true;
  }

  Future<bool> updatePlanogramAfterGcs1(int promoId) async {
    print("UPLOAD Planogram AFTER GCS");
    await DatabaseHelper.updateTransPlanogramAfterGcsImageUpload(workingId,promoId.toString()).then((value) {

    });

    return true;
  }

  Future<bool> updateMarketIssueAfterGcs1(int marketIssueId) async {
    print("UPLOAD Market Issue AFTER GCS");
    await DatabaseHelper.updateMarketIssueAfterGcsImageUpload(workingId,marketIssueId.toString()).then((value) {

    });

    return true;
  }

  Future<bool> updatePosAfterGcs1(int posId) async {
    print("UPLOAD POS AFTER GCS");
    await DatabaseHelper.updatePosAfterGcsImageUpload(workingId,posId.toString()).then((value) {

    });

    return true;
  }

  Future<bool> updateOsdAfterGcs1(int posId) async {
    print("UPLOAD Osd AFTER GCS");
    await DatabaseHelper.updateOsdAfterGcsImageUpload(workingId,posId.toString()).then((value) {

    });

    return true;
  }

  Future<bool> updateOnePlusAfterGcs1(int posId) async {
    print("UPLOAD One Plus One AFTER GCS");
    await DatabaseHelper.updateOnePlusOneAfterGcsImageUpload(workingId,posId.toString()).then((value) {

    });

    return true;
  }

  availabilityUploadToAPI() async {
    bool isAvlUp = false;

    await DatabaseHelper.getAvlDataListForApi(workingId).then((value) {
      availabilityDataList = value;
    });

    SaveAvailability saveAvailability = SaveAvailability(
      username: userName,
      workingId: workingId,
      workingDate: workingDate,
      storeId: storeId,
      availabilityList: availabilityDataList,
    );

    await DatabaseHelper.getAvlPickListDataListForApi(workingId).then((value) {
      availabilityPickList = value;
    });


    print("************ Availablity Upload in Api **********************");
    print(jsonEncode(saveAvailability));

    setState(() {
      isAvlFinishLoading = true;
    });

    await SqlHttpManager()
        .saveAvailabilityTrans(token, baseUrl,saveAvailability)
        .then((value) => {
      print("************ Availability Values **********************"),
      isAvlUp = true,
      setState(() {
      }),

      showAnimatedToastMessage("Success".tr, "Availability data Uploaded Successfully".tr, true),

      // ToastMessage.succesMessage(context, "Availability data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      showAnimatedToastMessage("Error!".tr,onError.toString(),false),
      // ToastMessage.errorMessage(context, onError.toString()),
      print(onError.toString()),
      setState(() {
        isAvlUp = false;
      }),
    });

    if(isAvlUp) {
      await updateTransAvailabilityAfterApi();

      await getAllCountData();

      setState(() {
        isAvlFinishLoading = false;
      });
    } else {
      setState(() {
        isAvlFinishLoading = false;
      });
    }
  }

  Future <bool> updateTransAvailabilityAfterApi() async {
    String skuId = "";
    for(int i=0;i<availabilityDataList.length;i++) {
      skuId = "${availabilityDataList[i].skuId.toString()},$skuId";
    }
    skuId = removeLastComma(skuId);
    print(skuId);
    await DatabaseHelper.updateTransAVLAfterUpdate(workingId,skuId).then((value) {

    });

    return true;
  }

  beforeFixingUploadApi() async {

    await DatabaseHelper.getBeforeFixingApiUploadDataList(workingId).then((value) {
      beforeFixingImageList  = value.cast<SaveOtherPhotoData>();

      setState((){});
    });

    SaveOtherPhoto saveOtherPhoto  = SaveOtherPhoto(
        username: userName,
        workingId: workingId,
        workingDate: workingDate,
        storeId: storeId, images: beforeFixingImageList);

    print("************ Before Fixing Upload in Api **********************");
    print(jsonEncode(saveOtherPhoto));

    setState((){
      isBeforeFixingFinishLoading = true;
    });

    SqlHttpManager()
        .saveBeforeFixingAndOtherPhotoTrans(token, baseUrl,saveOtherPhoto)
        .then((value) async => {
      print("************ Before Fixing Values **********************"),

      await updateBeforeFixingStatusAfterApi(),

      await getAllCountData(),

      setState(() {
        isBeforeFixingFinishLoading  = false;
      }),
      showAnimatedToastMessage("Success".tr, "Before Fixing Data Uploaded Successfully".tr, true),
      // ToastMessage.succesMessage(context, "Before Fixing Data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      showAnimatedToastMessage("Error!".tr,onError.toString(),false),
      print(onError.toString()),
      setState(() {
        isBeforeFixingFinishLoading = false;
      }),
    });

  }

  Future <bool> updateBeforeFixingStatusAfterApi() async {
    String ids = "";
    for(int i=0;i<beforeFixingImageList.length;i++) {
      ids = "${beforeFixingImageList[i].transPhotoId.toString()},$ids";
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateBeforeFixingAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  otherPhotoUploadApi() async {

    await DatabaseHelper.getOtherPhotoApiUploadDataList(workingId).then((value) {
      otherPhotoImageList  = value.cast<SaveOtherPhotoData>();

      setState((){});
    });

    SaveOtherPhoto saveOtherPhoto  = SaveOtherPhoto(
        username: userName,
        workingId: workingId,
        workingDate: workingDate,
        storeId: storeId, images: otherPhotoImageList);

    print("************ Other Photo Upload in Api **********************");
    print(jsonEncode(saveOtherPhoto));

    setState((){
      isOtherPhotoFinishLoading = true;
    });

    SqlHttpManager()
        .saveBeforeFixingAndOtherPhotoTrans(token, baseUrl,saveOtherPhoto)
        .then((value) async => {
      print("************ Other Photo Values **********************"),

      await updateOtherPhotoStatusAfterApi(),

      await getAllCountData(),

      setState(() {
        isOtherPhotoFinishLoading  = false;
      }),

      showAnimatedToastMessage("Success".tr, "Other Photo Data Uploaded Successfully".tr, true),

      // ToastMessage.succesMessage(context, "Other Photo Data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      showAnimatedToastMessage("Error!".tr,onError.toString(),false),
      print(onError.toString()),
      setState(() {
        isOtherPhotoFinishLoading = false;
      }),
    });

  }

  Future <bool> updateOtherPhotoStatusAfterApi() async {
    String ids = "";
    for(int i=0;i<otherPhotoImageList.length;i++) {
      ids = "${otherPhotoImageList[i].transPhotoId.toString()},$ids";
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateOtherPhotoAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  sosUploadApi() async {

    await DatabaseHelper.getSosApiUploadDataList(workingId).then((value) {
      sosDataForApi  = value.cast<SaveSosData>();

      setState((){});
    });

    SaveSosPhoto saveSosPhoto  = SaveSosPhoto(
        username: userName,
        workingId: workingId,
        workingDate: workingDate,
        storeId: storeId, sosList: sosDataForApi);

    print("************ Sos Upload in Api **********************");
    print(jsonEncode(saveSosPhoto));

    setState((){
      isSosFinishLoading = true;
    });

    SqlHttpManager()
        .saveSosTrans(token, baseUrl,saveSosPhoto)
        .then((value) async => {
      print("************Sos Values **********************"),

      await updateSosStatusAfterApi(),

      await getAllCountData(),

      setState(() {
        isSosFinishLoading  = false;
      }),

      showAnimatedToastMessage("Success".tr, "Share Of Shelf Data Uploaded Successfully".tr, true),

      // ToastMessage.succesMessage(context, "Share Of Shelf Data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      showAnimatedToastMessage("Error!".tr,onError.toString(),false),
      print(onError.toString()),
      setState(() {
        isSosFinishLoading = false;
      }),
    });

  }

  Future <bool> updateSosStatusAfterApi() async {
    String ids = "";
    for(int i=0;i<sosDataForApi.length;i++) {
      ids = "${sosDataForApi[i].id.toString()},$ids";
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateSosAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  tmrUploadPickList() async {
    bool isPickUp = false;

    await DatabaseHelper.getAvlPickListDataListForApi(workingId).then((value) {
      availabilityPickList = value;
    });

    SavePickList savePickList = SavePickList(
      username: userName,
      workingId: workingId,
      workingDate: workingDate,
      storeId: storeId,
      pickList: availabilityPickList,
    );
    //
    print("************ Availablity Upload in Api **********************");
    print(jsonEncode(jsonEncode(savePickList)));

    if(availabilityPickList.isNotEmpty) {

      setState((){
        isPickListFinishLoading = true;
      });
      await SqlHttpManager()
          .savePickListTrans(token, baseUrl, savePickList)
          .then((value) =>
      {
        print("************ PickList Values **********************"),
        isPickUp = true,
        setState(() {}),

        showAnimatedToastMessage("Success".tr, "Pick List Uploaded Successfully".tr, true),

        // ToastMessage.succesMessage(
        //     context, "Pick List Uploaded Successfully".tr),
      }).catchError((onError) => {
        showAnimatedToastMessage("Error!".tr,onError.toString(),false),
        print(onError.toString()),
        setState(() {
          isPickUp = false;
        }),
      });
    } else {
      isPickUp = true;
      setState((){});
    }

    if(isPickUp) {
      await updateTmrPickListAfterAPi();

      await getAllCountData();

      setState(() {
        isPickListFinishLoading = false;
      });
    } else {
      setState(() {
        isPickListFinishLoading = false;
      });
    }

  }

  updateTmrPickListAfterAPi() async {

    DateTime now = DateTime.now();
    String currentTime = DateFormat.Hm().format(now);

    String pickIds = "";
    for(int i=0;i<availabilityPickList.length;i++) {
      pickIds = "${availabilityPickList[i].skuId.toString()},$pickIds";
    }
    pickIds = removeLastComma(pickIds);
    print(pickIds);
    await DatabaseHelper.updateTransAVLAfterPickListUpdate(workingId,pickIds,currentTime).then((value) {

    });
  }

  shareShelfUploadToApi() async {

    await DatabaseHelper.getActivityStatusBrandSharesDataList(workingId).then((value) async {
      brandShareImageList = value.cast<SaveBrandShareListData>();

      setState(() {});
    });

    SaveBrandShare saveBrandShare = SaveBrandShare(
        username: userName,
        workingId: workingId,
        workingDate: workingDate,
        storeId: storeId,
        brandShares: brandShareImageList);

    print("************ Brand Share Upload in Api **********************");
    print(jsonEncode(saveBrandShare));

    setState(() {
      isShelfShareFinishLoading = true;
    });
    SqlHttpManager()
        .saveBrandShare(token, baseUrl,saveBrandShare)
        .then((value) async => {
      print("************ Brand Share Values **********************"),

      await  updateTransBrandShareAfterApi(),

      await getAllCountData(),

      setState(() {
        isShelfShareFinishLoading = false;
      }),

      showAnimatedToastMessage("Success".tr, "Share Shelf Data Uploaded Successfully".tr, true),

      // ToastMessage.succesMessage(context, "Share Shelf Data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      showAnimatedToastMessage("Error!".tr,onError.toString(),false),
      print(onError.toString()),
      setState(() {
        isShelfShareFinishLoading = false;
      }),
    });
  }

  Future<bool> updateTransBrandShareAfterApi() async {

    String ids = "";
    for(int i=0;i<brandShareImageList.length;i++) {
      ids = "${brandShareImageList[i].id.toString()},$ids";
    }
    ids = removeLastComma(ids);
    print(ids);

    await DatabaseHelper.updateShelfShareAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  planoguideUploadApi() async {

    await DatabaseHelper.getActivityStatusPlanoGuideDataList(workingId).then((value) async {

      planoguideImageList = value.cast<SavePlanoguideListData>();

      setState((){});
    });

    SavePlanoguide savePlanoguide = SavePlanoguide(
        username: userName,
        workingId: workingId,
        workingDate: workingDate,
        storeId: storeId,
        pogs: planoguideImageList);

    print("************ Planoguide Upload in Api **********************");
    print(jsonEncode(savePlanoguide));

    setState((){
      isPlanoguideFinishLoading = true;
    });

    SqlHttpManager()
        .savePlanoguide(token, baseUrl,savePlanoguide)
        .then((value) async => {
      print("************ Planoguide Values **********************"),

      await updateTransPlanoguideAfterApi(),

      await getAllCountData(),

      setState(() {
        isPlanoguideFinishLoading  = false;
      }),

      showAnimatedToastMessage("Success".tr, "Planoguide Data Uploaded Successfully".tr, true),

      // ToastMessage.succesMessage(context, "Planoguide Data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      showAnimatedToastMessage("Error!".tr,onError.toString(),false),
      print(onError.toString()),
      setState(() {
        isPlanoguideFinishLoading = false;
      }),
    });

  }

  Future<bool> updateTransPlanoguideAfterApi() async {
    String ids = "";
    for(int i=0;i<planoguideImageList.length;i++) {
      ids = "${planoguideImageList[i].pogId.toString()},$ids";
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updatePlanoguideAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

 surveyUploadApi() async {

    await DatabaseHelper.getActivityStatusSurveyDataList(workingId).then((value) async {

      surveyImageList = value.cast<SaveSurveyData>();

      setState((){});
    });

    SaveSurvey saveSurvey = SaveSurvey(
        username: userName,
        workingId: workingId,
        workingDate: workingDate,
        storeId: storeId,
        surveyList: surveyImageList);

    print("************ Survey Upload in Api **********************");
    print(jsonEncode(saveSurvey));

    setState((){
      isSurveyFinishLoading = true;
    });

    SqlHttpManager()
        .saveSurvey(token, baseUrl,saveSurvey)
        .then((value) async => {
      print("************ Survey Values **********************"),

      await updateTransSurveyAfterApi(),

      await getAllCountData(),

      setState(() {
        isSurveyFinishLoading  = false;
      }),

      showAnimatedToastMessage("Success".tr, "Survey Data Uploaded Successfully".tr, true),

      // ToastMessage.succesMessage(context, "Planoguide Data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      showAnimatedToastMessage("Error!".tr,onError.toString(),false),
      print(onError.toString()),
      setState(() {
        isSurveyFinishLoading = false;
      }),
    });

  }

  Future<bool> updateTransSurveyAfterApi() async {
    String ids = "";
    for(int i=0;i<surveyImageList.length;i++) {
      ids = "${surveyImageList[i].questionId.toString()},$ids";
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateSurveyAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  rtvUploadApi() async {
    await DatabaseHelper.getActivityStatusRtvDataList(workingId).then((value) async {

      rtvImageList = value.cast<SaveRtvDataListData>();

      setState((){});
    });

    SaveRtvData saveRtvData = SaveRtvData(username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        rtvList: rtvImageList);

    print("************ RTV Upload in Api **********************");
    print(jsonEncode(saveRtvData));

    setState((){
      isRtvFinishLoading = true;
    });

    SqlHttpManager().saveRtvList(token, baseUrl, saveRtvData).then((value) async => {

      print("************ RTV Values **********************"),

      await updateTransRtvAfterApi(),

      await getAllCountData(),

      setState((){
        isRtvFinishLoading = false;
      }),

      showAnimatedToastMessage("Success".tr, "RTV Data Uploaded Successfully".tr, true),

      // ToastMessage.succesMessage(context, "RTV Data Uploaded Successfully".tr),
    }).catchError((e)=>{
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
        setState((){
      isRtvFinishLoading = false;
    }),
    });

  }

  Future<bool> updateTransRtvAfterApi() async {
    String ids = "";
    for(int i=0;i<rtvImageList.length;i++) {
      ids = "${rtvImageList[i].skuId.toString()},$ids";
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateRtvAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  replenishUploadAPi() async {
    await DatabaseHelper.getActivityStatusReplenishDataList(workingId).then((value) {

      replenishImageList = value.cast<SaveReplenishListData>();

      setState(() {

      });
    });

    SaveReplenishData saveReplenishData = SaveReplenishData(
      username: userName,
      workingId: workingId,
      storeId: storeId,
      workingDate: workingDate,
      replenishList: replenishImageList
    );

    print("************ Replenish Upload in Api **********************");
    print(jsonEncode(saveReplenishData));

    setState((){
      isReplenishmentFinishLoading = true;
    });

    SqlHttpManager().saveReplenishData(token, baseUrl, saveReplenishData).then((value) async => {


      print("************ Replenish Values **********************"),

      await updateTransReplenishAfterApi(),

      await getAllCountData(),

      setState((){
        isReplenishmentFinishLoading = false;
      }),

      showAnimatedToastMessage("Success".tr, "Replenish Data Uploaded Successfully".tr, true),

      // ToastMessage.succesMessage(context, "Price Check Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
      setState((){
        isReplenishmentFinishLoading = false;
      }),
    });

  }

  Future<bool> updateTransReplenishAfterApi() async {
    String ids = "";
    for(int i=0;i<replenishImageList.length;i++) {
      ids = "${replenishImageList[i].skuId.toString()},$ids";
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateReplenishmentAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  priceCheckUploadApi() async {

    await DatabaseHelper.getActivityStatusPriceCheckDataList(workingId).then((value) {

      priceCheckImageList = value.cast<SavePricingDataListData>();

      setState(() {

      });
    });

    SavePricingData savePricingData = SavePricingData(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        pricingList: priceCheckImageList);

    print("************ Pricing Upload in Api **********************");
    print(jsonEncode(savePricingData));

    setState((){
      isPriceCheckFinishLoading = true;
    });

    SqlHttpManager().savePricing(token, baseUrl, savePricingData).then((value) async => {


      print("************ Price Check Values **********************"),

      await updateTransPricingAfterApi(),

      await getAllCountData(),

      setState((){
        isPriceCheckFinishLoading = false;
      }),

      showAnimatedToastMessage("Success".tr, "Price Check Data Uploaded Successfully".tr, true),

      // ToastMessage.succesMessage(context, "Price Check Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
      setState((){
        isPriceCheckFinishLoading = false;
      }),
    });
  }

  Future<bool> updateTransPricingAfterApi() async {
    String ids = "";
    for(int i=0;i<priceCheckImageList.length;i++) {
      ids = "${priceCheckImageList[i].skuId.toString()},$ids";
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updatePriceCheckAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  pickListUploadAPi() async {
    await DatabaseHelper.getPickListDataForApi(userName).then((value) async {
      pickListDataForApi = value.cast<ReadyPickListData>();

      setState(() {});
    });


    ReadyPickList readyPickList = ReadyPickList(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        readyPickList: pickListDataForApi
    );


    print("Pick Data For API");
    print(readyPickList);

    if (pickListDataForApi.isNotEmpty) {
      setState(() {
        isPickListFinishLoading = true;
      });
      SqlHttpManager().readyPickList(token, baseUrl, readyPickList).then((
          value) async =>
      {

        print(value),

        await updateSqlPickListAfterApi(),

        await getAllCountData(),

        setState(() {
          isPickListFinishLoading = false;
        }),
        showAnimatedToastMessage("Success".tr, "Pick List Uploaded Successfully".tr, true),
        // ToastMessage.succesMessage(context, "Pick List Uploaded Successfully".tr),
      }).catchError((e) =>
      {
        setState(() {
          isPickListFinishLoading = false;
        }),
        showAnimatedToastMessage("Error!".tr,e.toString(),false),
      });
    } else {
      showAnimatedToastMessage("Error!".tr,"Please complete your picklist".tr,false);
    }
  }

  Future<bool> updateSqlPickListAfterApi() async {

    DateTime now = DateTime.now();
    String currentTime = DateFormat.Hm().format(now);

    String ids = "";
    for(int i=0;i<pickListDataForApi.length;i++) {
      ids = "${pickListDataForApi[i].pickListId.toString()},$ids";
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updatePickListAfterApi(ids,currentTime).then((value) {

    });

    return true;
  }

  freshnessUploadApi() async {

    await DatabaseHelper.getFreshnessDataListFromApi(workingId).then((value) {

      saveFreshnessList = value.cast<SaveFreshnessListData>();

      setState(() {

      });
    });

    SaveFreshnessData saveFreshnessData = SaveFreshnessData(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        freshnessList: saveFreshnessList);

    print("************ Freshness Upload in Api **********************");
    print(jsonEncode(saveFreshnessData));

    setState((){
      isFreshnessFinishLoading = true;
    });

    SqlHttpManager().saveFreshness(token, baseUrl, saveFreshnessData).then((value) async => {


      print("************ Freshness Values **********************"),

      await updateTransFreshnessAfterApi(),

      await getAllCountData(),

      setState((){
        isFreshnessFinishLoading = false;
      }),
      showAnimatedToastMessage("Success".tr, "Freshness Data Uploaded Successfully".tr, true),
      // ToastMessage.succesMessage(context, "Freshness Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
      setState((){
        isFreshnessFinishLoading = false;
      }),
    });
  }

  Future<bool> updateTransFreshnessAfterApi() async {
    String ids = "";
    for(int i=0;i<saveFreshnessList.length;i++) {
      ids = '${wrapIfString(saveFreshnessList[i].dateTime.toString())},$ids';
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateFresshnessAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  stockUploadApi() async {

    await DatabaseHelper.getStockDataListFromApi(workingId).then((value) {

      saveStockList = value.cast<SaveStockListData>();

      setState(() {

      });
    });

    SaveStockData saveStockData = SaveStockData(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        stockList: saveStockList);

    print("************ Stock Upload in Api **********************");
    print(jsonEncode(saveStockData));

    setState((){
      isStockFinishLoading = true;
    });

    SqlHttpManager().saveStock(token, baseUrl, saveStockData).then((value) async => {

      print("************ Stock Values **********************"),

      await updateTransStockAfterApi(),

      await getAllCountData(),

      setState((){
        isStockFinishLoading = false;
      }),
      showAnimatedToastMessage("Success".tr, "Stock Data Uploaded Successfully".tr, true),
      // ToastMessage.succesMessage(context, "Stock Data Uploaded Successfully".tr),

    }).catchError((e)=> {
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
      setState((){
        isStockFinishLoading = false;
      }),
    });


  }

  Future<bool> updateTransStockAfterApi() async {
    String ids = "";
    for(int i=0;i<saveStockList.length;i++) {
      ids = '${wrapIfString(saveStockList[i].dateTime.toString())},$ids';
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateStockAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  promoPlanUploadApi() async {

    await DatabaseHelper.getPromoPlansListDataForAPi(workingId).then((value) {

      savePromoPlanList = value.cast<SavePromoPlanDataListData>();

      setState(() {

      });
    });

    SavePromoPlanData savePromoPlanData = SavePromoPlanData(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        promoPlanList: savePromoPlanList);

    print("************ Promo Plan Upload in Api **********************");
    print(jsonEncode(savePromoPlanData));

    String ids = "";
    for(int i=0;i<savePromoPlanList.length;i++) {
      ids = '${wrapIfString(savePromoPlanList[i].promoId.toString())},$ids';
    }
    ids = removeLastComma(ids);
    print(ids);

    setState((){
      isPromoPlanFinishLoading = true;
    });

    SqlHttpManager().savePromoPlan(token, baseUrl, savePromoPlanData).then((value) async => {


      print("************ Promo Plan Values **********************"),

      await updateTransPromoPlanAfterApi(),

      await getAllCountData(),

      setState((){
        isPromoPlanFinishLoading = false;
      }),
      showAnimatedToastMessage("Success".tr, "Promotions Data Uploaded Successfully".tr, true),
      // ToastMessage.succesMessage(context, "Promotions Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
      setState((){
        isPromoPlanFinishLoading = false;
      }),
    });
  }

  Future<bool> updateTransPromoPlanAfterApi() async {
    String ids = "";
    for(int i=0;i<savePromoPlanList.length;i++) {
      ids = '${wrapIfString(savePromoPlanList[i].promoId.toString())},$ids';
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updatePromoPlanAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  planogramUploadApi() async {

    await DatabaseHelper.getTransPlanogramApiUploadDataList(workingId).then((value) {

      planogramImageList = value.cast<SavePlanogramPhotoData>();

      setState(() {

      });
    });

    SavePlanogramPhoto savePlanogramPhoto = SavePlanogramPhoto(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        planograms: planogramImageList);

    print("************ Planogram Upload in Api **********************");
    print(jsonEncode(savePlanogramPhoto));

    setState((){
      isPlanogramFinishLoading = true;
    });

    SqlHttpManager().savePlanogramTrans(token, baseUrl, savePlanogramPhoto).then((value) async => {


      print("************ Planogram Values **********************"),

      await updatePlanogramAfterApi(),

      await getAllCountData(),

      setState((){
        isPlanogramFinishLoading = false;
      }),

      showAnimatedToastMessage("Success".tr, "Planogram Data Uploaded Successfully".tr, true),

      // ToastMessage.succesMessage(context, "Planogram Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
      setState((){
        isPlanogramFinishLoading = false;
      }),
    });
  }

  Future<bool> updatePlanogramAfterApi() async {
    String ids = "";
    for(int i=0;i<planogramImageList.length;i++) {
      ids = '${wrapIfString(planogramImageList[i].id.toString())},$ids';
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateTransPlanogramAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  posUploadApi() async {

    await DatabaseHelper.getTransPosApiUploadDataList(workingId).then((value) {

      posImageList = value.cast<SavePosListData>();

      setState(() {

      });
    });

    SavePosData savePosData = SavePosData(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        posList: posImageList);

    print("************ POS Upload in Api **********************");
    print(jsonEncode(savePosData));

    setState((){
      isPosFinishLoading = true;
    });

    SqlHttpManager().savePos(token, baseUrl, savePosData).then((value) async => {


      print("************ POS Values **********************"),

      await updatePosAfterApi1(),

      await getAllCountData(),

      setState((){
        isPosFinishLoading = false;
      }),
      showAnimatedToastMessage("Success".tr, "POS Data Uploaded Successfully".tr, true),
      // ToastMessage.succesMessage(context, "POS Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
      setState((){
        isPosFinishLoading = false;
      }),
    });
  }

  Future<bool> updatePosAfterApi1() async {
    String ids = "";
    for(int i=0;i<posImageList.length;i++) {
      ids = '${wrapIfString(posImageList[i].skuId.toString())},$ids';
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updatePosAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  marketIssueUploadApi() async {

    await DatabaseHelper.getTransMarketIssueApiUploadDataList(workingId).then((value) {

      marketIssueImageList = value.cast<SaveMarketIssueListData>();

      setState(() {

      });
    });

    SaveMarketIssueData saveMarketIssueData = SaveMarketIssueData(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        marketIssueList: marketIssueImageList);

    print("************ Market ISsue Upload in Api **********************");
    print(jsonEncode(marketIssueImageList));

    setState((){
      isMarketIssueFinishLoading = true;
    });

    SqlHttpManager().saveMarketIssue(token, baseUrl, saveMarketIssueData).then((value) async => {


      print("************ Market Issue Values **********************"),

      await updateMarketIssueAfterApi1(),

      await getAllCountData(),

      setState((){
        isMarketIssueFinishLoading = false;
      }),

      showAnimatedToastMessage("Success".tr, "Market Issue Data Uploaded Successfully".tr, true),
      // ToastMessage.succesMessage(context, "Market Issue Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
      setState((){
        isMarketIssueFinishLoading = false;
      }),
    });
  }

  Future<bool> updateMarketIssueAfterApi1() async {
    String ids = "";
    for(int i=0;i<marketIssueImageList.length;i++) {
      ids = '${wrapIfString(marketIssueImageList[i].id.toString())},$ids';
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateMarketIssueAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  onePlusOneUploadApi() async {

    await DatabaseHelper.getTransOnePlusPneApiUploadDataList(workingId).then((value) {

      onePlusOneImageList = value.cast<SaveOnePlusOneListData>();

      setState(() {

      });
    });

    SaveOnePlusOneData saveOnePlusOneData = SaveOnePlusOneData(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        onePlusOneList: onePlusOneImageList);

    print("************ One Plus One Upload in Api **********************");
    print(jsonEncode(saveOnePlusOneData));

    setState((){
      isOnePlusOneFinishLoading = true;
    });

    SqlHttpManager().saveOnePlusOne(token, baseUrl, saveOnePlusOneData).then((value) async => {


      print("************ One Plus One Values **********************"),

      await updateOnePlusOneAfterApi1(),

      await getAllCountData(),

      setState((){
        isOnePlusOneFinishLoading = false;
      }),
      showAnimatedToastMessage("Success".tr, "1 + 1 Data Uploaded Successfully".tr, true),
      // ToastMessage.succesMessage(context, "1 + 1 Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
      setState((){
        isOnePlusOneFinishLoading = false;
      }),
    });
  }

  Future<bool> updateOnePlusOneAfterApi1() async {
    String ids = "";
    for(int i=0;i<onePlusOneImageList.length;i++) {
      ids = '${wrapIfString(onePlusOneImageList[i].id.toString())},$ids';
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateOnePlusOneAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  osdUploadApi() async {

    await DatabaseHelper.getOsdDataListForApi(workingId).then((value) {

      osdImageList = value.cast<SaveOsdListData>();

      setState(() {

      });
    });


    for(int i = 0; i< osdImageList.length; i++) {


      await DatabaseHelper.getOsdDataImagesListForApi(workingId,osdImageList[i].id).then((value) {

        osdDataImagesList = value.cast<SaveOsdImageNameListData>();

        osdImageList[i].osdImagesList = osdDataImagesList;

        setState(() {

        });
      });
    }

    SaveOsdData saveOsdData = SaveOsdData(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        osdList: osdImageList);

    print("************ OSD Upload in Api **********************");
    print(jsonEncode(osdImageList));

    setState((){
      isOsdFinishLoading = true;
    });

    SqlHttpManager().saveOsd(token, baseUrl, saveOsdData).then((value) async => {


      print("************ OSD Values **********************"),

      await updateOsdAfterApi1(),

      await getAllCountData(),

      setState((){
        isOsdFinishLoading = false;
      }),
      showAnimatedToastMessage("Success".tr, "OSD Data Uploaded Successfully".tr, true),
      // ToastMessage.succesMessage(context, "OSD Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
      setState((){
        isOsdFinishLoading = false;
      }),
    });
  }

  Future<bool> updateOsdAfterApi1() async {
    String ids = "";
    for(int i=0;i<osdImageList.length;i++) {
      ids = '${wrapIfString(osdImageList[i].id.toString())},$ids';
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateOsdAfterApi(workingId,ids).then((value) {

    });

    return true;
  }



  uploadDbFile() async {

    String dbFileName = "${userName}_${DateTime.now().millisecondsSinceEpoch}.db";

    SaveDbFileRequest saveDbFileRequest = SaveDbFileRequest(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        fileName: dbFileName);

    print(jsonEncode(saveDbFileRequest));

    setState(() {
      isDataUploading = true;
    });

      try {
        final credentials = ServiceAccountCredentials.fromJson(
          await rootBundle.loadString(
              'assets/google_cloud_creds/appimages-keycstoreapp-7c0f4-a6d4c3e5b590.json'),
        );

        const databaseName = 'cstore_pro.db';
        var databasesPath = await getDatabasesPath();

        await DatabaseHelper.closeDb('$databasesPath/$databaseName');

        final httpClient = await clientViaServiceAccount(
            credentials, [StorageApi.devstorageReadWriteScope]);

        // Create a Storage client with the credentials
        final storage = StorageApi(httpClient);

        // Generate a unique filename and path
        final filename = dbFileName;
        final filePath = 'post_dbs/$filename';

        final fileContent = await File('$databasesPath/$databaseName').readAsBytes();
        final bucketObject = Object(name: filePath);

        // Upload the image
        final resp = await storage.objects.insert(
          bucketObject,
          "support-desk",
          predefinedAcl: 'publicRead',
          uploadMedia: Media(
            Stream<List<int>>.fromIterable([fileContent]),
            fileContent.length,
          ),
        );
        final downloadUrl =
            'https://storage.googleapis.com/support-desk/$filePath';
        print(downloadUrl);

        await saveDbFile(context,dbFileName);

        SqlHttpManager().saveDbFile(token, baseUrl, saveDbFileRequest).then((value) async => {

          showAnimatedToastMessage("Success".tr, "Your Request has been recieved Successfully".tr, true),
          setState(() {
            isDataUploading = false;
          }),

        }).catchError((e)=>{
          print(e.toString()),
          showAnimatedToastMessage("Error!".tr,e.toString(),false),
          setState(() {
            isDataUploading = false;
          }),
        });


      } catch (e) {

        // Handle any errors that occur during the upload
        print("Upload GCS Error $e");
        showAnimatedToastMessage("Error!".tr, "Uploading images error please try again!".tr, false);
        setState(() {
          isDataUploading = false;
        });
      }
  }

  finishVisit(StateSetter menuState) async {
    menuState(() {
      isDataUploading = true;
    });
    await LocationService.getLocation().then((value) async {

      print(value);

      if(value['locationIsPicked']) {


        GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

        List<String> latLong = gcode.split('=')[1].split(',');
        String storeLat = latLong[0];
        String storeLong = latLong[1];


        if(generalStatusController.isLocationStatus.value) {

          if(generalStatusController.sysAppSettingModel.isGeoLocationEnabled == "0") {
            generalStatusController.isGeoFenceDistance.value = 0.5;
            menuState((){});
            setState(() {

            });
          } else {

            await generalStatusController.getGeoLocationDistance(
                double.parse(generalStatusController.isLat.value),
                double.parse(generalStatusController.isLong
                    .value), double.parse(storeLat.trim()),
                double.parse(storeLong.trim()));
          }
        };
        if(generalStatusController.isVpnStatus.value) {
          showAnimatedToastMessage("Error!".tr,"Please Disable Your VPN".tr, false);
        }
        else if(generalStatusController.isMockLocation.value) {
          showAnimatedToastMessage("Error!".tr, "Please Disable Your Fake Locator".tr, false);
        }
        else if(!generalStatusController.isAutoTimeStatus.value) {
          showAnimatedToastMessage("Error!".tr, "Please Enable Your Auto time Option From Setting".tr, false);
        }
        else if(!generalStatusController.isLocationStatus.value) {
          showAnimatedToastMessage("Error!".tr, "Please Enable Your Location".tr, false);
        }
        else if(generalStatusController.isGeoFenceDistance.value > 0.7) {
          showAnimatedToastMessage("Error!".tr, "You’re just 0.7 km away from the store. Please contact your supervisor for the exact location details".tr, false);
        } else {
          Get.delete<GeneralChecksStatusController>();

          setState(() {
            location = value['lat'] +","+ value['long'];
          });

          print(location);
          JourneyPlanHTTP().finishVisit(token, baseUrl, FinishVisitRequestModel(
            username: userName,
            workingId: workingId,
            workingDate: workingDate,
            storeId: storeId,
            checkOutGps: location,
          )).then((value) async => {

            await deleteVisitData(),

            menuState(() {
              isDataUploading = false;
            }),
            showAnimatedToastMessage("Success".tr, "Visit Ended Successfully".tr, true),
            // ToastMessage.succesMessage(context, "Visit Ended Successfully".tr),
            Navigator.popUntil(context, (route) => count++ == 3),
          }).catchError((e) =>{
            print(e.toString()),
            menuState(() {
              isDataUploading = false;
            }),
            setState(() {

            }),
            showAnimatedToastMessage("Error!".tr,e.toString(),false),
          });

      }

      }

    }).catchError((onError) {
      setState(() {
        isDataUploading = false;
      });
    });

  }

  Future <bool>  deleteVisitData() async {

    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransAvailability,workingId);
    ///Due to working_id issue
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblPicklist,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransPlanoguide,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransBrandShare,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransRtv,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransPricing,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tbTransPromoPlan,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransFreshness,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransStock,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransBeforeFaxing,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransPhoto,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransSos,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransPlanogram,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransMarketIssue,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransPOS,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransOsdc,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransOnePlusOne,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.transReplenishmentTable,workingId);

    await deleteFolder(workingId);

    return true;

  }

  String removeLastComma(String input) {
    if (input.endsWith(',')) {
      return input.substring(0, input.length - 1);
    }
    return input;
  }

}
