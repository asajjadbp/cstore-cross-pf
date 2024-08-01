import 'dart:convert';
import 'dart:io';

import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../Model/request_model.dart/planoguide_request_model.dart';
import '../../Model/request_model.dart/ready_pick_list_request.dart';
import '../../Model/request_model.dart/save_api_pricing_data_request.dart';
import '../../Model/request_model.dart/save_api_rtv_data_request.dart';
import '../../Model/request_model.dart/save_freshness_request_model.dart';
import '../../Model/request_model.dart/save_promo_plan_request_model.dart';
import '../../Model/request_model.dart/save_stock_request_model.dart';
import '../../Network/jp_http.dart';
import '../../Network/sql_data_http_manager.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/services/getting_gps.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import 'VisitUploadScreencard.dart';

class VisitUploadScreen extends StatefulWidget {
  static const routeName = "/visit_upload_screen";

  const VisitUploadScreen({super.key});

  @override
  State<VisitUploadScreen> createState() => _VisitUploadScreenState();
}

class _VisitUploadScreenState extends State<VisitUploadScreen> {
  String storeName = "";
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
  String visitAvlExcludes = "";
  String workingDate="";
  String location = "";
  String visitActivity = "";

  int count = 0;

  bool isDataUploading = false;
  List<AvailabilityShowModel> availableData = <AvailabilityShowModel>[];
  List<SaveAvailabilityData> availabilityDataList = [];
  List<SavePickListData> availabilityPickList = [];
  AvailabilityCountModel availabilityCountModel = AvailabilityCountModel(totalSku: 0,totalAvl: 0,totalNotAvl: 0,totalUploaded: 0,totalNotUploaded: 0,totalNotMarked: 0);
  TmrPickListCountModel tmrPickListCountModel = TmrPickListCountModel(totalPickListItems: 0,totalPickNotUpload: 0,totalPickUpload: 0,totalPickReady: 0,totalPickNotReady: 0);

  List<TransPlanoGuideModel> planoguidData = <TransPlanoGuideModel>[];
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
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;
    storeId = sharedPreferences.getString(AppConstants.storeId)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    clientId  = sharedPreferences.getString(AppConstants.clientId)!;
    visitAvlExcludes  = sharedPreferences.getString(AppConstants.availableExclude)!;
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

    print(moduleIdList);

    getAllCountData();

    checkInTime = sharedPreferences.getString(AppConstants.visitCheckIn)!;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FD),
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storeName,
              style: const TextStyle(fontSize: 16),
            ),
            const Text(
              "Visit Upload",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
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
                            storeName:storeName,
                            moduleName: "Total Sku's",
                            screenName: "Availability",
                            checkinTime:checkInTime,
                            avlSkus:availabilityCountModel.totalAvl,
                            notAvlSkus: availabilityCountModel.totalNotAvl,
                            notMarkedSkus: availabilityCountModel.totalNotMarked,
                            totalSkus: availabilityCountModel.totalSku,),

                        if (tmrPickListCountModel.totalPickListItems > 0 )
                          VisitPickListUploadScreenCard(
                            onUploadTap: (){
                              tmrUploadPickList();
                            },
                            isUploadData: isPickListFinishLoading,
                            isUploaded: tmrPickListCountModel.totalPickNotUpload == 0,
                            moduleName: "Requests",
                            screenName: "Picklist",
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
                            moduleName: "Pog",
                            screenName: "Planoguide",
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
                            moduleName: "Brands",
                            screenName: "Shelf Share",
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
                            moduleName: "Requests",
                            screenName: "Picklist",
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
                            moduleName: "Sku's",
                            screenName: "RTV",
                            uploadedData:rtvCountModel.totalVolume,
                            notUploadedData: rtvCountModel.totalValue,
                            totalRtv: rtvCountModel.totalRtv,),

                        if(priceCheckCountModel.totalPriceCheck > 0)
                          VisitPriceCheckUploadScreenCard(
                            onUploadTap: () {
                              priceCheckUploadApi();
                            },
                            isUploaded: priceCheckCountModel.totalNotUpload == 0,
                            isUploadData: isPriceCheckFinishLoading,
                            moduleName: "Sku's",
                            screenName: "Price Check",
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
                            moduleName: "Sku's",
                            screenName: "Freshness",
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
                            moduleName: "Plan",
                            screenName: "Promotions",
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
                            moduleName: "Sku's",
                            screenName: "Stock",
                            totalCases: totalStockCountData.total_cases,
                            totalOuters: totalStockCountData.total_outers,
                            totalPieces: totalStockCountData.total_pieces,
                            totalStock: totalStockCountData.total_stock_taken,
                          ),

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
                if(userRole == "TMR") {
                  if ((moduleIdList.contains("3")) && (availabilityCountModel.totalSku != availabilityCountModel.totalUploaded) || availabilityCountModel.totalSku == 0 || availabilityCountModel.totalUploaded.toString() == "null") {
                    ToastMessage.errorMessage(context, "Please Mark All Sku's Availability");
                  } else if ((moduleIdList.contains("3")) && tmrPickListCountModel.totalPickListItems != tmrPickListCountModel.totalPickReady) {
                    ToastMessage.errorMessage(context, "Please Wait for pick list response");
                  } else if ((moduleIdList.contains("15")) &&
                      planoguideCountModel.totalUploaded.toString() == "null" ||
                      planoguideCountModel.totalUploaded == 0) {
                    ToastMessage.errorMessage(
                        context, "PLease Add At lease one planoguide");
                  } else if ((moduleIdList.contains("16")) &&
                      brandShareCountModel.totalUpload.toString() == "null" ||
                      brandShareCountModel.totalUpload == 0) {
                    ToastMessage.errorMessage(
                        context, "Please Add at least one brand share");
                  } else {
                    // print("Visit Finished Successfully");

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Visit'),
                          content: const Text('Are you sure you want to finish this visit?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Perform logout operation
                                finishVisit();
                              },
                              child: const Text('Continue'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {

                  if ((moduleIdList.contains("4")) && (pickListCountModel.totalPickListItems != pickListCountModel.totalPickReady) && (pickListCountModel.totalPickListItems != pickListCountModel.totalUpload) || pickListCountModel.totalUpload.toString() == "null") {

                    ToastMessage.errorMessage(context, "Please make all pick list ready and upload it");

                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Visit'),
                          content: const Text(
                              'Are you sure you want to finish this visit?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Perform logout operation
                                finishVisit();
                              },
                              child: const Text('Continue'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              } : null,
              child: Text(
                "Finish Visit",style: TextStyle(color: isFinishButton ? MyColors.whiteColor : MyColors.appMainColor2),
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
    // uploadToGcs();

    // setState(() {});
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

    setState(() {

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

      return true;
    } catch (e) {
      // Handle any errors that occur during the upload
      print("Upload GCS Error $e");
      setState(() {
        isPlanoguideFinishLoading = false;
        isRtvFinishLoading = false;
        isPromoPlanFinishLoading = false;
      });
      ToastMessage.errorMessage(context, "Something went wrong please try again later");
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
      ToastMessage.succesMessage(context, "Availability data Uploaded Successfully"),
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
            context, "Pick List Uploaded Successfully"),
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
      ToastMessage.succesMessage(context, "Share Shelf Data Uploaded Successfully"),
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
      print("************ Planogram Values **********************"),

      await updateTransPlanoguideAfterApi(),

      await getAllCountData(),

      setState(() {
        isPlanoguideFinishLoading  = false;
      }),
      ToastMessage.succesMessage(context, "Planoguide Data Uploaded Successfully"),
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

      ToastMessage.succesMessage(context, "RTV Data Uploaded Successfully"),
    }).catchError((e)=>{
      print(e.toString()),
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

      ToastMessage.succesMessage(context, "Price Check Data Uploaded Successfully"),

    }).catchError((e) =>{
      print(e.toString()),
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
        ToastMessage.succesMessage(context, "Pick List Uploaded Successfully"),
      }).catchError((e) =>
      {
        setState(() {
          isPickListFinishLoading = false;
        }),
        ToastMessage.errorMessage(context, e.toString()),
      });
    } else {
      ToastMessage.errorMessage(context, "Please complete your picklist");
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

      ToastMessage.succesMessage(context, "Freshness Data Uploaded Successfully"),

    }).catchError((e) =>{
      print(e.toString()),
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

      ToastMessage.succesMessage(context, "Stock Data Uploaded Successfully"),

    }).catchError((e)=> {
      print(e.toString()),
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

      ToastMessage.succesMessage(context, "Promotions Data Uploaded Successfully"),

    }).catchError((e) =>{
      print(e.toString()),
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

  finishVisit() async {
    setState(() {
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

          setState(() {
            isDataUploading = false;
          }),
          ToastMessage.succesMessage(context, "Visit Ended Successfully"),
          Navigator.popUntil(context, (route) => count++ == 3),
        }).catchError((e) =>{
          print(e.toString()),
          setState(() {
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

    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tbl_trans_availability,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tbl_trans_planoguide,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tbl_trans_BrandShare,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tbl_trans_rtv,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tbl_trans_pricing,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tbTransPromoPlan,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tbl_trans_freshness,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tbl_trans_stock,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tbl_picklist,workingId);

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
