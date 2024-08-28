import 'dart:convert';
import 'dart:io';

import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import '../../Model/request_model.dart/save_stock_request_model.dart';
import '../../Model/request_model.dart/sos_end_api_request_model.dart';
import '../../Network/jp_http.dart';
import '../../Network/sql_data_http_manager.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
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

    print("USER ROLE");
    print(token);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageController.isEnglish.value ? storeEnName : storeArName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                Row(
                  children: [
                     Text(
                      "${"CheckIn".tr} : ",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:MyColors.darkGreyColor),
                    ),

                    Text(
                      checkInTime,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:MyColors.darkGreyColor),
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
                              onUploadTap: () async {

                                await uploadImagesToGcs(AppConstants.beforeFixing);

                               beforeFixingUploadApi();

                              },
                              totalBeforeFixing: beforeFixingCountModel.totalBeforeFixing,
                              uploadedData: beforeFixingCountModel.totalCategories,
                              isUploadData: isBeforeFixingFinishLoading,
                              isUploaded: beforeFixingCountModel.totalNotUpload == 0),

                        if(otherPhotoCountModel.totalOtherPhotos  > 0)
                          VisitBeforeFixingUploadScreenCard(
                              screenName: "Other Photo".tr,
                              moduleName: "Category".tr,
                              onUploadTap: () async {

                                await uploadImagesToGcs(AppConstants.otherPhoto);

                                otherPhotoUploadApi();

                              },
                              totalBeforeFixing: otherPhotoCountModel.totalOtherPhotos,
                              uploadedData: otherPhotoCountModel.totalCategories,
                              isUploadData: isOtherPhotoFinishLoading,
                              isUploaded: otherPhotoCountModel.totalNotUpload == 0),

                        if(sosCountModel.totalSosItems  > 0)
                          VisitSosUploadScreenCard(
                              screenName: "Share of Shelf".tr,
                              moduleName: "Records".tr,
                              onUploadTap: () async {

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
                              onUploadTap: () async {
                                await uploadImagesToGcs(AppConstants.planogram);

                                planogramUploadApi();
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
                            onUploadTap: () async {
                              await uploadImagesToGcs(AppConstants.planoguide);

                              planoguideUploadApi();
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
                            onUploadTap: () async {
                              await uploadImagesToGcs(AppConstants.rtv);

                              rtvUploadApi();
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

                        if (freshnessGraphCountShowModel.totalFreshnessTaken > 0 )
                          VisitFreshnessUploadScreenCard(
                            onUploadTap: () async {
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
                            onUploadTap: () async {
                              await uploadImagesToGcs(AppConstants.promoPlan);

                              promoPlanUploadApi();
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
                            onUploadTap: () async {
                              await uploadImagesToGcs(AppConstants.onePlusOne);
                              //
                              onePlusOneUploadApi();
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
                            onUploadTap: () async {
                              print("OSDC Click");
                              await uploadImagesToGcs(AppConstants.osdc);
                              //
                              osdUploadApi();
                            },
                            isUploaded: osdCountModel.totalNotUpload == 0,
                            isUploadData: isOsdFinishLoading,
                            moduleName: "Total".tr,
                            screenName: "OSD".tr,
                            totalOsd: osdCountModel.totalItems,),

                        if (marketIssueCountModel.totalItems > 0 )
                          VisitOsdAndMarketIssueUploadScreenCard(
                            onUploadTap: () async {

                              await uploadImagesToGcs(AppConstants.marketIssues);
                              //
                              marketIssueUploadApi();
                            },
                            isUploaded: marketIssueCountModel.totalNotUpload == 0,
                            isUploadData: isMarketIssueFinishLoading,
                            moduleName: "Total".tr,
                            screenName: "Market Issue".tr,
                            totalOsd: marketIssueCountModel.totalItems,),

                        if (posCountModel.totalPosItems > 0 )
                          VisitRtvUploadScreenCard(
                            onUploadTap: () async {
                              await uploadImagesToGcs(AppConstants.pos);

                              posUploadApi();
                            },
                            isUploaded: posCountModel.totalNotUpload == 0,
                            isUploadData: isRtvFinishLoading,
                            moduleName: "Total".tr,
                            screenName: "POS".tr,
                            uploadedData:posCountModel.quantity.toInt(),
                            notUploadedData: posCountModel.amount.toInt(),
                            totalRtv: posCountModel.totalPosItems,),

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
              onPressed:isDataUploading ? null : isFinishButton ? (){
                print((moduleIdList.contains("15")) &&
                    (planoguideCountModel.totalUploaded.toString() == "null" ||
                    planoguideCountModel.totalUploaded == 0));
                if(userRole == "TMR") {
                  if ((moduleIdList.contains("3") || moduleIdList.contains("17") ) && ((availabilityCountModel.totalSku != availabilityCountModel.totalUploaded) || availabilityCountModel.totalSku == 0 || availabilityCountModel.totalUploaded.toString() == "null")) {
                    ToastMessage.errorMessage(context, "Please Mark All Sku's Availability".tr);
                  } else if ((moduleIdList.contains("3")) && (tmrPickListCountModel.totalPickListItems != tmrPickListCountModel.totalPickReady)) {
                    ToastMessage.errorMessage(context, "Please Wait for pick list response".tr);
                  } else if ((moduleIdList.contains("15")) && (planoguideCountModel.totalUploaded.toString() == "null" || planoguideCountModel.totalUploaded == 0)) {
                    ToastMessage.errorMessage(
                        context, "PLease Add At lease one planoguide".tr);
                  } else if ((moduleIdList.contains("16")) && (brandShareCountModel.totalUpload.toString() == "null" || brandShareCountModel.totalUpload == 0)) {
                    ToastMessage.errorMessage(
                        context, "Please Add at least one brand share".tr);
                  } else {
                    // print("Visit Finished Successfully");

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                            builder: (BuildContext context1, StateSetter menuState) {
                              return AlertDialog(
                                title:  Text('Visit'.tr),
                                content:  Text('Are you sure you want to finish this visit?'.tr),
                                actions: <Widget>[
                                  isDataUploading ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                       CircularProgressIndicator(color: MyColors.appMainColor2,),
                                    ],
                                  ) : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child:  Text('No'.tr),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Perform logout operation
                                          finishVisit(menuState);
                                        },
                                        child:  Text('Yes'.tr),
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
                } else {

                  if ((moduleIdList.contains("4")) && (pickListCountModel.totalPickListItems != pickListCountModel.totalPickReady) && (pickListCountModel.totalPickListItems != pickListCountModel.totalUpload) || pickListCountModel.totalUpload.toString() == "null") {

                    ToastMessage.errorMessage(context, "Please make all pick list ready and upload it".tr);

                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                            builder: (BuildContext context1, StateSetter menuState) {
                              return AlertDialog(
                                title: Text('Visit'.tr),
                                content: Text('Are you sure you want to finish this visit?'.tr),
                                actions: <Widget>[
                                  isDataUploading ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(color: MyColors.appMainColor2,),
                                    ],
                                  ) : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child:  Text('No'.tr),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Perform logout operation
                                          finishVisit(menuState);
                                        },
                                        child:  Text('Yes'.tr),
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
        setState(() {
          isPlanoguideFinishLoading = false;
        });
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
        setState(() {
          isRtvFinishLoading = false;
        });
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
          print("Image Uploaded successfully");

          await updatePromoPlanAfterGcs1(promoPlanGcsImagesList[j].id);

        }
        setState(() {
          isPromoPlanFinishLoading = false;
        });
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
        setState(() {
          isBeforeFixingFinishLoading = false;
        });
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
        setState(() {
          isOtherPhotoFinishLoading = false;
        });
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
        setState(() {
          isPlanogramFinishLoading = false;
        });
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
        setState(() {
          isMarketIssueFinishLoading = false;
        });
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
        setState(() {
          isPosFinishLoading = false;
        });
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
        setState(() {
          isOsdFinishLoading = false;
        });
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
        setState(() {
          isOnePlusOneFinishLoading = false;
        });
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
      ToastMessage.errorMessage(context, "Uploading images error please try again!".tr);
      return false;
    }
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
      ToastMessage.succesMessage(context, "Availability data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      ToastMessage.errorMessage(context, onError.toString()),
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
      ToastMessage.succesMessage(context, "Before Fixing Data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      ToastMessage.errorMessage(context, onError.toString()),
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
      ToastMessage.succesMessage(context, "Other Photo Data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      ToastMessage.errorMessage(context, onError.toString()),
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
      ToastMessage.succesMessage(context, "Share Of Shelf Data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      ToastMessage.errorMessage(context, onError.toString()),
      print(onError.toString()),
      setState(() {
        isOtherPhotoFinishLoading = false;
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
        ToastMessage.succesMessage(
            context, "Pick List Uploaded Successfully".tr),
      }).catchError((onError) =>
      {
        ToastMessage.errorMessage(context, onError.toString()),
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
      ToastMessage.succesMessage(context, "Share Shelf Data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      ToastMessage.errorMessage(context, onError.toString()),
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
      ToastMessage.succesMessage(context, "Planoguide Data Uploaded Successfully".tr),
    }).catchError((onError)=>{
      ToastMessage.errorMessage(context, onError.toString()),
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

      ToastMessage.succesMessage(context, "RTV Data Uploaded Successfully".tr),
    }).catchError((e)=>{
      print(e.toString()),
      ToastMessage.errorMessage(context, e.toString()),
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

      ToastMessage.succesMessage(context, "Price Check Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      ToastMessage.errorMessage(context, e.toString()),
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
        ToastMessage.succesMessage(context, "Pick List Uploaded Successfully".tr),
      }).catchError((e) =>
      {
        setState(() {
          isPickListFinishLoading = false;
        }),
        ToastMessage.errorMessage(context, e.toString()),
      });
    } else {
      ToastMessage.errorMessage(context, "Please complete your picklist".tr);
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

      ToastMessage.succesMessage(context, "Freshness Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      ToastMessage.errorMessage(context, e.toString()),
      setState((){
        isFreshnessFinishLoading = false;
      }),
    });
  }

  Future<bool> updateTransFreshnessAfterApi() async {
    String ids = "";
    for(int i=0;i<saveFreshnessList.length;i++) {
      ids = "${wrapIfString(saveFreshnessList[i].dateTime.toString())},$ids";
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

      ToastMessage.succesMessage(context, "Stock Data Uploaded Successfully".tr),

    }).catchError((e)=> {
      print(e.toString()),
      ToastMessage.errorMessage(context, e.toString()),
      setState((){
        isStockFinishLoading = false;
      }),
    });


  }

  Future<bool> updateTransStockAfterApi() async {
    String ids = "";
    for(int i=0;i<saveStockList.length;i++) {
      ids = "${wrapIfString(saveStockList[i].dateTime.toString())},$ids";
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
      ids = "${wrapIfString(savePromoPlanList[i].promoId.toString())},$ids";
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

      ToastMessage.succesMessage(context, "Promotions Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      ToastMessage.errorMessage(context, e.toString()),
      setState((){
        isPromoPlanFinishLoading = false;
      }),
    });
  }

  Future<bool> updateTransPromoPlanAfterApi() async {
    String ids = "";
    for(int i=0;i<savePromoPlanList.length;i++) {
      ids = "${wrapIfString(savePromoPlanList[i].promoId.toString())},$ids";
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

      ToastMessage.succesMessage(context, "Planogram Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      ToastMessage.errorMessage(context, e.toString()),
      setState((){
        isPlanogramFinishLoading = false;
      }),
    });
  }

  Future<bool> updatePlanogramAfterApi() async {
    String ids = "";
    for(int i=0;i<planogramImageList.length;i++) {
      ids = "${wrapIfString(planogramImageList[i].id.toString())},$ids";
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

      ToastMessage.succesMessage(context, "POS Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      ToastMessage.errorMessage(context, e.toString()),
      setState((){
        isPosFinishLoading = false;
      }),
    });
  }

  Future<bool> updatePosAfterApi1() async {
    String ids = "";
    for(int i=0;i<posImageList.length;i++) {
      ids = "${wrapIfString(posImageList[i].skuId.toString())},$ids";
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

      ToastMessage.succesMessage(context, "Market Issue Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      ToastMessage.errorMessage(context, e.toString()),
      setState((){
        isMarketIssueFinishLoading = false;
      }),
    });
  }

  Future<bool> updateMarketIssueAfterApi1() async {
    String ids = "";
    for(int i=0;i<marketIssueImageList.length;i++) {
      ids = "${wrapIfString(marketIssueImageList[i].id.toString())},$ids";
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

      ToastMessage.succesMessage(context, "1 + 1 Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      ToastMessage.errorMessage(context, e.toString()),
      setState((){
        isOnePlusOneFinishLoading = false;
      }),
    });
  }

  Future<bool> updateOnePlusOneAfterApi1() async {
    String ids = "";
    for(int i=0;i<onePlusOneImageList.length;i++) {
      ids = "${wrapIfString(onePlusOneImageList[i].id.toString())},$ids";
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

      // for(int j = 0; j < osdDataImagesList.length; j++ ) {
      //   if(osdImageList[i].id == osdDataImagesList[j].id) {
      //     osdImageList[i].osdImagesList.add(osdDataImagesList[i]);
      //   }
      // }
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

      ToastMessage.succesMessage(context, "OSD Data Uploaded Successfully".tr),

    }).catchError((e) =>{
      print(e.toString()),
      ToastMessage.errorMessage(context, e.toString()),
      setState((){
        isOsdFinishLoading = false;
      }),
    });
  }

  Future<bool> updateOsdAfterApi1() async {
    String ids = "";
    for(int i=0;i<osdImageList.length;i++) {
      ids = "${wrapIfString(osdImageList[i].id.toString())},$ids";
    }
    ids = removeLastComma(ids);
    print(ids);
    await DatabaseHelper.updateOsdAfterApi(workingId,ids).then((value) {

    });

    return true;
  }

  finishVisit(StateSetter menuState) async {
    menuState(() {
      isDataUploading = true;
    });
    await LocationService.getLocation().then((value) async {

      print(value);

      if(value['locationIsPicked']) {
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

          ToastMessage.succesMessage(context, "Visit Ended Successfully".tr),
          Navigator.popUntil(context, (route) => count++ == 3),
        }).catchError((e) =>{
          print(e.toString()),
          menuState(() {
            isDataUploading = false;
          }),
          ToastMessage.errorMessage(context, e.toString()),
        });

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
