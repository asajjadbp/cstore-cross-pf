import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/Database/table_name.dart';
import 'package:cstore/Model/database_model/required_module_model.dart';
import 'package:cstore/Network/sql_data_http_manager.dart';
import 'package:cstore/screens/availability/availablity_screen.dart';
import 'package:cstore/screens/freshness/Freshness.dart';
import 'package:cstore/screens/planogram/planogram_screen.dart';
import 'package:cstore/screens/proof_of_sale/proof_of_sale.dart';
import 'package:cstore/screens/sidco_availability/sidco_availablity_screen.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/visit_upload/visitUploadScreen.dart';
import 'package:cstore/screens/widget/app_bar_widgets.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import '../../Model/database_model/availability_show_model.dart';
import '../../Model/database_model/dashboard_model.dart';
import '../../Model/database_model/picklist_model.dart';
import '../../Model/database_model/planoguide_gcs_images_list_model.dart';
import '../../Model/database_model/total_count_response_model.dart';
import '../../Model/database_model/trans_brand_shares_model.dart';
import '../../Model/database_model/trans_planoguide_model.dart';
import '../../Model/request_model.dart/availability_api_request_model.dart';
import '../../Model/request_model.dart/brand_share_request.dart';
import '../../Model/request_model.dart/finish_visit_request_model.dart';
import '../../Model/request_model.dart/jp_request_model.dart';
import '../../Model/request_model.dart/planoguide_request_model.dart';
import '../../Model/request_model.dart/ready_pick_list_request.dart';
import '../../Model/request_model.dart/sos_end_api_request_model.dart';
import '../../Network/jp_http.dart';
import '../before_fixing/before_fixing.dart';
import '../brand_share/AddBrandShares.dart';
import '../knowledge_share/knowledge_share_screen.dart';
import '../market_issues_show/add_market_issue_screen.dart';
import '../osdc/add_osdc.dart';
import '../other_photo/add_other_photo.dart';
import '../pick_list/pick_list.dart';
import '../plano_guide/Planoguides.dart';
import '../price_check/Pricecheck.dart';
import '../promoplane/PromoPlan.dart';
import '../rtv_1+1/add_new_rtv_1+1.dart';
import '../rtv_1+1/rtv_one_plus_one_list.dart';
import '../rtv_screen/rtv_list_screen.dart';
import '../share_of_shelf/add_share_of_shelf.dart';
import '../stock/stock_list_screen.dart';
import '../utils/services/getting_gps.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import 'card_widget.dart';

class GridDashBoard extends StatefulWidget {
  static const routeName = "/GridDashboard";
  const GridDashBoard({super.key});

  @override
  State<GridDashBoard> createState() => _GridDashBoardState();
}

class _GridDashBoardState extends State<GridDashBoard> {
  bool isLoading = false;
  bool isinit = true;
  String storeName = "";
  String userName = "";
  String userId = "";
  String storeId = "";
  String token = "";
  String baseUrl = "";
  String bucketName = "";
  String userRole = "";
  String visitActivity = "";
  List<File> _imageFiles = [];

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
  BrandShareCountModel brandShareCountModel = BrandShareCountModel(totalBrandShare: 0,totalUpload: 0,totalNotUpload: 0,totalReadyBrands: 0,totalNotReadyBrands: 0);

  PickListCountModel pickListCountModel = PickListCountModel(totalNotUpload: 0,totalUpload: 0,totalPickListItems: 0,totalPickReady: 0,totalPickNotReady: 0);
  List<ReadyPickListData> pickListDataForApi = [];

  bool isFinishButton = true;

  final FlutterInternetSpeedTest _internetSpeedTest = FlutterInternetSpeedTest();

  double _uploadSpeed = 0.0;

  String workingId = "";
  String workingDate = "";
  String clientId = "";
  bool isUplaodStatus = false;
  String location = "";
  List<AgencyDashboardModel> allAgencyData = [];
  List<AgencyDashboardModel> agencyData = [];

  List<String> moduleIdList = [];

  List<String> agencyModuleNameList=[];

  bool isAvlFinishLoading = false;
  bool isPickListFinishLoading = false;
  bool isPlanoguideFinishLoading = false;
  bool isShelfShareFinishLoading = false;

  @override
  void didChangeDependencies() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // testSpeed();
    if (isinit) {
      setState(() {
        isLoading = true;
      });

      token = sharedPreferences.getString(AppConstants.tokenId)!;
      baseUrl = sharedPreferences.getString(AppConstants.baseUrl)!;
      bucketName = sharedPreferences.getString(AppConstants.bucketName)!;
      storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
      userName = sharedPreferences.getString(AppConstants.userName)!;
      storeId = sharedPreferences.getString(AppConstants.storeId)!;
      workingId = sharedPreferences.getString(AppConstants.workingId)!;
      clientId  = sharedPreferences.getString(AppConstants.clientId)!;
      workingDate = sharedPreferences.getString(AppConstants.workingDate)!;
      userRole = sharedPreferences.getString(AppConstants.userRole)!;
      visitActivity = sharedPreferences.getString(AppConstants.visitActivity)!;

      print("USER ROLE");
      print(userRole);

      if(userRole != "TMR") {
        getPickerPickList();
      }

      allAgencyData = await DatabaseHelper.getAgencyDashboard();

      List<RequiredModuleModel> allReqModuleData = await DatabaseHelper.getRequiredModuleListDataForApi();

      for(int i=0;i<allReqModuleData.length;i++) {
        if(allReqModuleData[i].visitActivityTypeId.toString() == visitActivity) {
          moduleIdList.add(allReqModuleData[i].moduleId.toString().trim());
        }
      }

      print(moduleIdList);

      agencyData = allAgencyData.where((element) => element.accessTo.contains(userRole)).toList();
      for(int i=0;i<agencyData.length;i++) {
        agencyModuleNameList.add(agencyData[i].en_name);
      }
      // insertAvailabilityData();
      setState(() {
        isLoading = false;
      });
    }
    isinit = false;
  }

  getPickerPickList() {
    setState(() {
      isLoading = true;
    });

    SqlHttpManager().getPickerPickList(token, baseUrl, JourneyPlanRequestModel(username: userName)).then((value) => {

      insertDataToSql(value),

      // setState(() {
      //   isLoading = false;
      // }),
    }).catchError((e)=>{
      print(e.toString()),
      setState(() {
        isLoading = false;
      }),
    });

  }

  String wrapIfString(dynamic value) {
    if (value is String) {
      return "'$value'";
    } else {
      return value.toString();
    }
  }

  insertDataToSql(List<PickListModel> valuePickList) async {
    String valueQuery = "";
    for(int i=0; i < valuePickList.length; i++) {
      valueQuery = "$valueQuery(${valuePickList[i].picklist_id},${valuePickList[i].store_id},${valuePickList[i].category_id},${valuePickList[i].tmr_id},${wrapIfString(valuePickList[i].tmr_name)},${valuePickList[i].stocker_id},${wrapIfString(valuePickList[i].stocker_name)},${wrapIfString(valuePickList[i].shift_time)},${wrapIfString(valuePickList[i].en_cat_name)},${wrapIfString(valuePickList[i].ar_cat_name)},${wrapIfString(valuePickList[i].sku_picture)},${wrapIfString(valuePickList[i].en_sku_name)},${wrapIfString(valuePickList[i].ar_sku_name)},${valuePickList[i].req_pickList},${valuePickList[i].act_pickList},${valuePickList[i].pickList_ready},0,'',${wrapIfString(valuePickList[i].pick_list_receive_time)},${wrapIfString(valuePickList[i].pick_list_reason)}),";
    }
    if (valueQuery.endsWith(",")) {
      valueQuery = valueQuery.substring(0, valueQuery.length - 1);
    }
    print("Query Part");
    print(valueQuery);

    await DatabaseHelper.insertPickListByQuery(valueQuery).then((value) {
      print("check picklist screen");

    });
  }

  // void testSpeed() async {
  //   try {
  //     await _internetSpeedTest.startTesting(
  //       onCompleted: (download, upload) {
  //         print('Download: $download, Upload: $upload');
  //         setState(() {
  //           _uploadSpeed = upload.transferRate * 1000;
  //         });
  //
  //         if(_uploadSpeed > 200){
  //           setState(() {
  //             isUplaodStatus = false;
  //           });
  //           getTransData(AppConstants.availability,false);
  //         }
  //       },
  //       onProgress: (percentage, speed) {
  //         print('Progress: $percentage%, Speed: $speed');
  //         setState(() {
  //           _uploadSpeed  = speed.transferRate * 1000;
  //         });
  //         // if(_uploadSpeed > 200){
  //         //   _getImages();
  //         // }
  //       },
  //     );
  //   } catch (e) {
  //     print('Error: $e');
  //     rethrow; // Rethrow for handling in UI
  //   }
  // }
  //
  // getTransData(String module, bool isUpload) async {
  //   print("=============Module Name=============");
  //   print(module);
  //   setState(() {
  //     isDataUploading  = isUpload;
  //   });
  //   if(module == AppConstants.beforeFixing) {
  //     await DatabaseHelper.getTransBeforeFixing(workingId).then((value) async {
  //       beforeFixingTransData = value.cast<GetTransBeforeFixing>();
  //       await _getImages(AppConstants.beforeFixing).then((value) {
  //         setTransPhoto(AppConstants.beforeFixing);
  //       });
  //     });
  //   }
  //   else if(module == AppConstants.otherPhoto) {
  //     await DatabaseHelper.getTransPhoto(workingId).then((value) async {
  //       otherPhotoTransData = value;
  //       await _getImages(module).then((value) {
  //         setTransPhoto(module);
  //       });
  //     });
  //
  //   }
  //   else if(module == AppConstants.planogram) {
  //     await DatabaseHelper.getTransPlanogram(workingId).then((value) async {
  //       planogramTransData = value;
  //       await _getImages(module).then((value) {
  //         setTransPhoto(module);
  //       });
  //     });
  //   }
  //   else if(module == AppConstants.availability) {
  //     await DatabaseHelper.getAvlDataList(workingId,"-1","-1","-1","-1").then((value) {
  //       print(jsonEncode(value));
  //       availableData = value;
  //       print(availableData.length);
  //       print("_______________");
  //       setTransPhoto(module);
  //     });
  //   } else if(module == AppConstants.planoguide) {
  //     await DatabaseHelper.getPlanoGuideDataList(workingId).then((value) async {
  //       planoguidData = value.cast<TransPlanoGuideModel>();
  //       print("___  Planoguide Data List Screen_______");
  //       print(planoguidData);
  //       await _getImages(module).then((value) {
  //         setTransPhoto(module);
  //       });
  //       setState((){});
  //     });
  //   } else if(module == AppConstants.shelfShare) {
  //
  //     await DatabaseHelper.getBransSharesDataList(workingId).then((value) async {
  //       brandShareData = value.cast<TransBransShareModel>();
  //       setState(() {});
  //       print("___  BrandShare Data List Screen_______");
  //       print(brandShareData);
  //       setTransPhoto(module);
  //     });
  //
  //   }
  //   else if(module == AppConstants.osdc) {
  //     setTransPhoto(AppConstants.osdc);
  //     // await DatabaseHelper.getTransOSDC(workingId).then((value) async {
  //     //   osdcTransData = value;
  //     //
  //     //   await _getImages(AppConstants.osdc).then((value) {
  //     //     setTransPhoto(AppConstants.osdc);
  //     //   });
  //     // });
  //
  //   }
  // }
  //
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
  //
  // void setTransPhoto(String module) {
  //   setState(() {
  //     isDataUploading  = true;
  //   });
  //   if(module == AppConstants.beforeFixing) {
  //     for (int j=0;j<beforeFixingTransData.length; j++) {
  //       for (int i = 0; i < _imageFiles.length; i++) {
  //         // print("LIST ITEMS");
  //         // print(_imageFiles[i].path);
  //         // print(beforeFixingTransData[j].img_name);
  //         if (_imageFiles[i].path.endsWith(beforeFixingTransData[j].img_name)) {
  //           beforeFixingTransData[j].imageFile = _imageFiles[i];
  //         }
  //       }
  //       // imageUploadTest(AppConstants.beforeFixing,beforeFixingTransData[j].img_name);
  //     }
  //     print("____________BEFORE FIXING___________________");
  //     print(beforeFixingTransData);
  //     print("____________________________________________");
  //     uploadToGcs(module);
  //
  //   }
  //   else if(module == AppConstants.otherPhoto) {
  //
  //     for (int j=0;j<otherPhotoTransData.length; j++) {
  //       for (int i = 0; i < _imageFiles.length; i++) {
  //         // print("LIST ITEMS");
  //         // print(otherPhotoTransData[j].cat_id);
  //         // print(otherPhotoTransData[j].client_id);
  //         // print(otherPhotoTransData[j].type_id);
  //         if (_imageFiles[i].path.endsWith(otherPhotoTransData[j].img_name)) {
  //           otherPhotoTransData[j].imageFile = _imageFiles[i];
  //         }
  //       }
  //       // imageUploadTest(AppConstants.beforeFixing,beforeFixingTransData[j].img_name);
  //     }
  //     print("____________OTHER PHOTO___________________");
  //     print(otherPhotoTransData);
  //     print("____________________________________________");
  //     uploadToGcs(module);
  //   }
  //   else if(module == AppConstants.planogram) {
  //
  //     for (int j=0;j<planogramTransData.length; j++) {
  //       for (int i = 0; i < _imageFiles.length; i++) {
  //         // print("LIST ITEMS");
  //         // print(_imageFiles[i].path);
  //         // print(planogramTransData[j].image_name);
  //
  //         if (_imageFiles[i].path.endsWith(planogramTransData[j].image_name)) {
  //           planogramTransData[j].imageFile = _imageFiles[i];
  //         }
  //       }
  //       // imageUploadTest(AppConstants.beforeFixing,beforeFixingTransData[j].img_name);
  //     }
  //     print("____________PLANOGRAM___________________");
  //     print(planogramTransData);
  //     print("____________________________________________");
  //     uploadToGcs(module);
  //   }
  //   else if(module == AppConstants.availability) {
  //     uploadTableToApi(module);
  //   }
  //   else if(module == AppConstants.planoguide) {
  //
  //     for (int j=0;j<planoguidData.length; j++) {
  //       for (int i = 0; i < _imageFiles.length; i++) {
  //         // print("LIST ITEMS");
  //         // print(_imageFiles[i].path);
  //         // print(planoguidData[j].skuImageName);
  //         if(planoguidData[j].skuImageName.isNotEmpty)
  //         {
  //           if (_imageFiles[i].path.endsWith(planoguidData[j].skuImageName)) {
  //             planoguidData[j].imageFile = _imageFiles[i];
  //           }
  //         }
  //       }
  //       // imageUploadTest(AppConstants.beforeFixing,beforeFixingTransData[j].img_name);
  //     }
  //     print("____________PLANOGUIDE___________________");
  //     print(planoguidData);
  //     print("____________________________________________");
  //     uploadToGcs(module);
  //   }
  //   else if(module == AppConstants.shelfShare) {
  //     uploadTableToApi(module);
  //
  //   }
  //   else if(module == AppConstants.osdc) {
  //     imageUploadTest(module);
  //     // for (int j=0;j<osdcTransData.length; j++) {
  //     //   for (int i = 0; i < _imageFiles.length; i++) {
  //     //     print("LIST ITEMS");
  //     //     print(_imageFiles[i].path);
  //     //     print(osdcTransData[j].img_name);
  //     //
  //     //     if (_imageFiles[i].path.endsWith(osdcTransData[j].img_name)) {
  //     //       osdcTransData[j].imageFile = _imageFiles[i];
  //     //     }
  //     //   }
  //     //   // imageUploadTest(AppConstants.beforeFixing,beforeFixingTransData[j].img_name);
  //     // }
  //     // print("____________OSDC___________________");
  //     // print(osdcTransData);
  //     // print("____________________________________________");
  //     // uploadToGcs(module);
  //   }
  //
  // }
  //
  //
  // imageUploadTest(String moduleName) async {
  //   _imageFiles.clear();
  //   print("Location Service");
  //   print(moduleName);
  //   if(moduleName == AppConstants.availability) {
  //     getTransData(AppConstants.planoguide,isUplaodStatus);
  //   } else if(moduleName == AppConstants.planoguide) {
  //     getTransData(AppConstants.shelfShare,isUplaodStatus);
  //   } else {
  //     await LocationService.getLocation().then((value) async {
  //
  //       print(value);
  //
  //       if(value['locationIsPicked']) {
  //         setState(() {
  //           location = value['lat'] + value['long'];
  //         });
  //
  //         finishVisit();
  //       }
  //
  //     });
  //
  //   }
  //
  //   // if(moduleName == AppConstants.beforeFixing) {
  //   //   getTransData(AppConstants.otherPhoto);
  //   // } else if(moduleName == AppConstants.otherPhoto) {
  //   //   getTransData(AppConstants.planogram);
  //   // } else if(moduleName == AppConstants.planogram) {
  //   //   getTransData(AppConstants.availability);
  //   // } else if(moduleName == AppConstants.availability) {
  //   //   getTransData(AppConstants.osdc);
  //   // } else if(moduleName == AppConstants.osdc) {
  //   //   getTransData(AppConstants.planoguide);
  //   // } else if(moduleName == AppConstants.planoguide) {
  //   //   getTransData(AppConstants.shelfShare);
  //   // } else {
  //   //   print("Completed Uploaded");
  //   // }
  // }
  //
  // updatePlanoGuideUploadStatus(String moduleName,String tableName,String imageName,int uploadStatus,int index) async {
  //
  //
  //   print(tableName);
  //   print(imageName);
  //   print("DATA UPDATING");
  //   await DatabaseHelper.updatePlanoTableAfterGCSUpload(workingId,tableName,1,uploadStatus,imageName)
  //       .then((_) {
  //       planoguidData[index].gcs_status = 1;
  //
  //     setState(() {
  //
  //     });
  //
  //   });
  // }
  //
  // updateImageUploadStatus(String moduleName,String tableName,String imageName,int uploadStatus,int index) async {
  //   print(tableName);
  //   print(imageName);
  //   print("DATA UPDATING");
  //   if(moduleName == AppConstants.planoguide) {
  //     await DatabaseHelper.updatePlanoTableAfterGCSUpload(workingId,tableName,1,uploadStatus,imageName)
  //         .then((_) {
  //       planoguidData[index].gcs_status = 1;
  //
  //       setState(() {
  //
  //       });
  //
  //     });
  //   } else {
  //     await DatabaseHelper.updateTableAfterGCSUpload(
  //         workingId, tableName, 1, uploadStatus, imageName)
  //         .then((_) {
  //       if (moduleName == AppConstants.beforeFixing) {
  //         beforeFixingTransData[index].gcs_status = 1;
  //       } else if (moduleName == AppConstants.otherPhoto) {
  //         otherPhotoTransData[index].gcs_status = 1;
  //       } else if (moduleName == AppConstants.planogram) {
  //         planogramTransData[index].gcs_status = 1;
  //       } else if (moduleName == AppConstants.osdc) {
  //         osdcTransData[index].gcs_status = 1;
  //       }
  //       setState(() {
  //
  //       });
  //     });
  //   }
  // }
  //
  // uploadToGcs(String moduleName) async {
  //   try {
  //         final credentials = ServiceAccountCredentials.fromJson(
  //           await rootBundle.loadString(
  //               'assets/google_cloud_creds/appimages-keycstoreapp-7c0f4-a6d4c3e5b590.json'),
  //         );
  //
  //         final httpClient = await clientViaServiceAccount(
  //             credentials, [StorageApi.devstorageReadWriteScope]);
  //
  //         // Create a Storage client with the credentials
  //         final storage = StorageApi(httpClient);
  //
  //         if(moduleName == AppConstants.beforeFixing) {
  //           print("------compier is it before ");
  //
  //           for(int j = 0; j < beforeFixingTransData.length; j++) {
  //
  //             if(beforeFixingTransData[j].upload_status != 1) {
  //               // Generate a unique filename and path
  //               final filename =  beforeFixingTransData[j].img_name;
  //               // const bucketName = "binzagr-bucket"; // Replace with your bucket name
  //
  //               final filePath = 'capture_photo/$filename';
  //
  //               final fileContent = await beforeFixingTransData[j].imageFile!.readAsBytes();
  //               final bucketObject = Object(name: filePath);
  //
  //               // Upload the image
  //               final resp = await storage.objects.insert(
  //                 bucketObject,
  //                 bucketName,
  //                 predefinedAcl: 'publicRead',
  //                 uploadMedia: Media(
  //                   Stream<List<int>>.fromIterable([fileContent]),
  //                   fileContent.length,
  //                 ),
  //               );
  //               print("Image URl GCS");
  //               print(resp.mediaLink);
  //
  //               updateImageUploadStatus(AppConstants.beforeFixing,TableName.tbl_trans_before_faxing,beforeFixingTransData[j].img_name,0,j);
  //
  //             }
  //
  //           }
  //           uploadTableToApi(moduleName);
  //           imageUploadTest(moduleName);
  //         }
  //         else if(moduleName == AppConstants.otherPhoto) {
  //           print("------compier is it Other  ");
  //           for(int j = 0; j < otherPhotoTransData.length; j++) {
  //
  //             if(otherPhotoTransData[j].upload_status != 1) {
  //               // Generate a unique filename and path
  //               final filename =  otherPhotoTransData[j].img_name;
  //               // const bucketName = "binzagr-bucket"; // Replace with your bucket name
  //
  //               final filePath = 'capture_photo/$filename';
  //
  //               final fileContent = await otherPhotoTransData[j].imageFile!.readAsBytes();
  //               final bucketObject = Object(name: filePath);
  //
  //               // Upload the image
  //               final resp = await storage.objects.insert(
  //                 bucketObject,
  //                 bucketName,
  //                 predefinedAcl: 'publicRead',
  //                 uploadMedia: Media(
  //                   Stream<List<int>>.fromIterable([fileContent]),
  //                   fileContent.length,
  //                 ),
  //               );
  //               print("Image URl GCS");
  //               print(resp.mediaLink);
  //
  //               updateImageUploadStatus(AppConstants.otherPhoto,TableName.tbl_trans_photo,otherPhotoTransData[j].img_name,0,j);
  //
  //             }
  //
  //           }
  //           uploadTableToApi(moduleName);
  //           imageUploadTest(moduleName);
  //         }
  //         else if(moduleName == AppConstants.osdc) {
  //           // print("------compier is it OSDC ");
  //           // for(int j = 0; j < osdcTransData.length; j++) {
  //           //
  //           //   if(osdcTransData[j].upload_status != 1) {
  //           //     // Generate a unique filename and path
  //           //     final filename =  osdcTransData[j].img_name;
  //           //     const bucketName = "binzagr-bucket"; // Replace with your bucket name
  //           //
  //           //     final filePath = 'capture_photo/$filename';
  //           //
  //           //     final fileContent = await osdcTransData[j].imageFile!.readAsBytes();
  //           //     final bucketObject = Object(name: filePath);
  //           //
  //           //     // Upload the image
  //           //     final resp = await storage.objects.insert(
  //           //       bucketObject,
  //           //       bucketName,
  //           //       predefinedAcl: 'publicRead',
  //           //       uploadMedia: Media(
  //           //         Stream<List<int>>.fromIterable([fileContent]),
  //           //         fileContent.length,
  //           //       ),
  //           //     );
  //           //     print("Image URl GCS");
  //           //     print(resp.mediaLink);
  //           //
  //           //     updateImageUploadStatus(AppConstants.osdc,TableName.tbl_trans_osdc,osdcTransData[j].img_name,0,j);
  //           //
  //           //   }
  //           //
  //           // }
  //           // uploadTableToApi(moduleName);
  //           imageUploadTest(moduleName);
  //         }
  //         else if(moduleName == AppConstants.planogram) {
  //           print("------compier is it Planogram ");
  //           for(int j = 0; j < planogramTransData.length; j++) {
  //
  //             if(planogramTransData[j].upload_status != 1) {
  //               // Generate a unique filename and path
  //               final filename =  planogramTransData[j].image_name;
  //               // const bucketName = "binzagr-bucket"; // Replace with your bucket name
  //
  //               final filePath = 'planogram/$filename';
  //
  //               final fileContent = await planogramTransData[j].imageFile!.readAsBytes();
  //               final bucketObject = Object(name: filePath);
  //
  //               // Upload the image
  //               final resp = await storage.objects.insert(
  //                 bucketObject,
  //                 bucketName,
  //                 predefinedAcl: 'publicRead',
  //                 uploadMedia: Media(
  //                   Stream<List<int>>.fromIterable([fileContent]),
  //                   fileContent.length,
  //                 ),
  //               );
  //               print("Image URl GCS");
  //               print(resp.mediaLink);
  //
  //               updateImageUploadStatus(AppConstants.planogram,TableName.tbl_trans_planogram,planogramTransData[j].image_name,0,j);
  //
  //             }
  //
  //           }
  //           // uploadTableToApi(moduleName);
  //           imageUploadTest(moduleName);
  //         }
  //         else if(moduleName == AppConstants.planoguide) {
  //           print("------compier is it Planoguide  ");
  //           for(int j = 0; j < planoguidData.length; j++) {
  //             // print(planoguidData[j].skuImageName);
  //             // print(planoguidData[j].gcs_status);
  //             if(planoguidData[j].upload_status != 1 && planoguidData[j].gcs_status == 0 && planoguidData[j].skuImageName.isNotEmpty) {
  //               // Generate a unique filename and path
  //               final filename =  planoguidData[j].skuImageName;
  //               // const bucketName = "binzagr-bucket"; // Replace with your bucket name
  //
  //               final filePath = 'capture_photo/$filename';
  //               print("BUCKET NAME CHECKING");
  //               print(filePath);
  //               print(bucketName);
  //               final fileContent = await planoguidData[j].imageFile!.readAsBytes();
  //               final bucketObject = Object(name: filePath);
  //
  //               // Upload the image
  //               final resp = await storage.objects.insert(
  //                 bucketObject,
  //                 bucketName,
  //                 predefinedAcl: 'publicRead',
  //                 uploadMedia: Media(
  //                   Stream<List<int>>.fromIterable([fileContent]),
  //                   fileContent.length,
  //                 ),
  //               );
  //               print("Image URl GCS");
  //               print(resp.mediaLink);
  //
  //               updatePlanoGuideUploadStatus(AppConstants.planoguide,TableName.tbl_trans_planoguide,planoguidData[j].skuImageName,0,j);
  //
  //             }
  //
  //           }
  //           uploadTableToApi(moduleName);
  //           imageUploadTest(moduleName);
  //         }
  //
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     // Handle any errors that occur during the upload
  //     print("Upload GCS Error $e");
  //
  //   }
  // }
  //
  // uploadTableToApi(String moduleName) {
  //   print("------------$moduleName Api Call ------------------");
  //
  //   if(moduleName == AppConstants.otherPhoto) {
  //     if (otherPhotoTransData.isNotEmpty) {
  //       List<SaveOtherPhotoData> imagesList = [];
  //       for (int i = 0; i < otherPhotoTransData.length; i++) {
  //         if (otherPhotoTransData[i].gcs_status == 1 && otherPhotoTransData[i].upload_status == 0) {
  //           imagesList.add(SaveOtherPhotoData(
  //               clientId: otherPhotoTransData[i].client_id,
  //               categoryId: otherPhotoTransData[i].cat_id,
  //               typeId: otherPhotoTransData[i].type_id,
  //               imageName: otherPhotoTransData[i].img_name.toString()));
  //
  //         }
  //       }
  //       SaveOtherPhoto saveOtherPhoto = SaveOtherPhoto(
  //           username: userName,
  //           workingId: workingId,
  //           workingDate: workingDate,
  //           storeId: storeId, images: imagesList);
  //       print("jsonEncode(saveOtherPhoto)");
  //       print(jsonEncode(saveOtherPhoto));
  //       if(imagesList.isNotEmpty) {
  //         SqlHttpManager()
  //             .saveOtherPhotoTrans(token, baseUrl, saveOtherPhoto)
  //             .then((value) =>
  //         {
  //           print(value),
  //           for (int i = 0; i < imagesList.length; i++) {
  //             updateImageUploadStatus(AppConstants.otherPhoto,TableName.tbl_trans_photo, imagesList[i].imageName, 1,-1)
  //           },
  //         setState(() {
  //          isDataUploading  = false;
  //         }),
  //             // ToastMessage.succesMessage(context, "Other Photo Uploaded Successfully"),
  //         }).catchError((e) =>
  //         {
  //           print("API ERROR"),
  //           print(e.toString()),
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //         });
  //       }
  //     }
  //     else {
  //       imageUploadTest(moduleName);
  //     }
  //   }
  //   else if(moduleName == AppConstants.beforeFixing){
  //     print("+++++++++++ Before fixing condition");
  //     if(beforeFixingTransData.isNotEmpty) {
  //       List<SaveOtherPhotoData> beforeImageList = [];
  //       for (int i = 0; i < beforeFixingTransData.length; i++) {
  //         if(beforeFixingTransData[i].gcs_status==1 && beforeFixingTransData[i].upload_status==0){
  //          beforeImageList.add(SaveOtherPhotoData(clientId: beforeFixingTransData[i].client_id,
  //              categoryId: beforeFixingTransData[i].cat_id,
  //              typeId: 1,
  //              imageName: beforeFixingTransData[i].img_name.toString()));
  //         }
  //       }
  //       SaveOtherPhoto saveBeforeFixing=SaveOtherPhoto(
  //           username: userName,
  //           workingId: workingId,
  //           workingDate: workingDate,
  //           storeId: storeId,
  //           images: beforeImageList);
  //       print("************ Before Images Upload in Api **********************");
  //       print(jsonEncode(saveBeforeFixing));
  //
  //       if(beforeImageList.isNotEmpty){
  //         SqlHttpManager()
  //             .saveOtherPhotoTrans(token, baseUrl,saveBeforeFixing)
  //             .then((value) => {
  //         print("************ Before Values **********************"),
  //           for(int i=0;i<beforeImageList.length;i++){
  //             updateImageUploadStatus(AppConstants.beforeFixing,TableName.tbl_trans_before_faxing, beforeImageList[i].imageName,1,-1)
  //           },
  //
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //           // ToastMessage.succesMessage(context, "Before Fixing Uploaded Successfully"),
  //         }).catchError((onError)=>{
  //           print("API ERROR Before"),
  //           print(e.toString()),
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //         });
  //       }
  //     }
  //     else {
  //       setState(() {
  //         isDataUploading  = false;
  //       });
  //       imageUploadTest(moduleName);
  //     }
  //   }
  //   else if(moduleName == AppConstants.planogram) {
  //     print("+++++++++++ Planogram condition");
  //     if(planogramTransData.isNotEmpty) {
  //       List<SavePlanogramPhotoData> planogramImageList = [];
  //       for (int i = 0; i < planogramTransData.length; i++) {
  //
  //         if(planogramTransData[i].gcs_status==1 && planogramTransData[i].upload_status==0){
  //
  //           planogramImageList.add(SavePlanogramPhotoData(
  //               clientId: planogramTransData[i].client_id,
  //               categoryId: planogramTransData[i].cat_id,
  //               brandId: planogramTransData[i].brand_id,
  //               isAdherence: planogramTransData[i].is_adherence,
  //               imageName: planogramTransData[i].image_name.toString(),
  //               reasonId: planogramTransData[i].reason_id,
  //             ));
  //         }
  //       }
  //
  //       SavePlanogramPhoto savePlanogramPhoto = SavePlanogramPhoto(
  //           username: userName,
  //           workingId: workingId,
  //           workingDate: workingDate,
  //           storeId: storeId,
  //           planograms: planogramImageList);
  //
  //       print("************ Planogram Upload in Api **********************");
  //       print(jsonEncode(savePlanogramPhoto));
  //
  //       if(planogramImageList.isNotEmpty){
  //         SqlHttpManager()
  //             .savePlanogramTrans(token, baseUrl,savePlanogramPhoto)
  //             .then((value) => {
  //           print("************ Planogram Values **********************"),
  //           for(int i=0;i<planogramImageList.length;i++){
  //             updateImageUploadStatus(AppConstants.planogram,TableName.tbl_trans_planogram, planogramImageList[i].imageName,1,-1)
  //           },
  //
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //           ToastMessage.succesMessage(context, "Planogram Uploaded Successfully"),
  //         }).catchError((onError)=>{
  //           print("API ERROR Before"),
  //           print(e.toString()),
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //         });
  //       }
  //     }
  //     else {
  //   setState(() {
  //        isDataUploading  = false;
  //       });
  //       imageUploadTest(moduleName);
  //     }
  //   }
  //   else if(moduleName == AppConstants.osdc) {
  //     setState(() {
  //       isDataUploading  = false;
  //     });
  //     imageUploadTest(moduleName);
  //   }
  //   else if(moduleName == AppConstants.availability) {
  //     print("+++++++++++ Availability condition");
  //     if(availableData.isNotEmpty) {
  //       List<SaveAvailabilityData> availabilityDataList = [];
  //       List<SavePickListData> availabilityPickList = [];
  //
  //       for (int i = 0; i < availableData.length; i++) {
  //
  //         if(availableData[i].upload_status == 0 && availableData[i].avl_status != -1){
  //
  //           availabilityDataList.add(SaveAvailabilityData(
  //             clientId: availableData[i].client_id,
  //             skuId: availableData[i].pro_id,
  //             avlStatus: availableData[i].avl_status,
  //           ));
  //         }
  //       }
  //
  //       SaveAvailability saveAvailability = SaveAvailability(
  //           username: userName,
  //           workingId: workingId,
  //           workingDate: workingDate,
  //           storeId: storeId,
  //           availabilityList: availabilityDataList,
  //       );
  //
  //       for (int i = 0; i < availableData.length; i++) {
  //
  //         if(availableData[i].upload_status == 0 && availableData[i].requried_picklist > 0){
  //
  //           availabilityPickList.add(SavePickListData(
  //             clientId: availableData[i].client_id,
  //             skuId: availableData[i].pro_id,
  //            reqPicklist: availableData[i].requried_picklist,
  //           ));
  //         }
  //       }
  //
  //       SavePickList savePickList = SavePickList(
  //         username: userName,
  //         workingId: workingId,
  //         workingDate: workingDate,
  //         storeId: storeId,
  //         pickList: availabilityPickList,
  //       );
  //
  //       print("************ Availablity Upload in Api **********************");
  //       print(jsonEncode(saveAvailability));
  //       print(jsonEncode(jsonEncode(savePickList)));
  //
  //       if(availabilityDataList.isNotEmpty){
  //         SqlHttpManager()
  //             .saveAvailabilityTrans(token, baseUrl,saveAvailability)
  //             .then((value) => {
  //           print("************ Availability Values **********************"),
  //           for(int i=0;i<availabilityDataList.length;i++){
  //             updateTransAvlAfterAPi(availabilityDataList[i].skuId)
  //           },
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //           // ToastMessage.succesMessage(context, "Availability data Uploaded Successfully"),
  //         }).catchError((onError)=>{
  //           print("API ERROR Before"),
  //           print(onError.toString()),
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //         });
  //       }
  //
  //       if(availabilityPickList.isNotEmpty){
  //         SqlHttpManager()
  //             .savePickListTrans(token, baseUrl,savePickList)
  //             .then((value) => {
  //           print("************ PickList Values **********************"),
  //           for(int i=0;i<availabilityPickList.length;i++){
  //             updateTransAvlAfterAPi(availabilityPickList[i].skuId)
  //           },
  //
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //           // ToastMessage.succesMessage(context, "Pick List Uploaded Successfully"),
  //         }).catchError((onError)=>{
  //           print("API ERROR Before"),
  //           print(e.toString()),
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //         });
  //       }
  //       imageUploadTest(moduleName);
  //     } else {
  //       setState(() {
  //         isDataUploading  = false;
  //       });
  //       imageUploadTest(moduleName);
  //     }
  //   }
  //   else if(moduleName == AppConstants.planoguide) {
  //     print("+++++++++++ Planoguide condition");
  //     if(planoguidData.isNotEmpty) {
  //       List<SavePlanoguideListData> planoguideImageList = [];
  //       for (int i = 0; i < planoguidData.length; i++) {
  //
  //         if(planoguidData[i].gcs_status==1 && planoguidData[i].upload_status==0){
  //
  //           planoguideImageList.add(SavePlanoguideListData(
  //             pogId: planoguidData[i].id,
  //             clientId: planoguidData[i].client_id,
  //             catId: planoguidData[i].cat_id,
  //             pogText: planoguidData[i].pog,
  //             adhStatus: int.parse(planoguidData[i].isAdherence),
  //             pogImageName: planoguidData[i].skuImageName,
  //
  //           ));
  //         }
  //       }
  //
  //       SavePlanoguide savePlanoguide = SavePlanoguide(
  //           username: userName,
  //           workingId: workingId,
  //           workingDate: workingDate,
  //           storeId: storeId,
  //           pogs: planoguideImageList);
  //
  //       print("************ Planoguide Upload in Api **********************");
  //       print(jsonEncode(savePlanoguide));
  //
  //       if(planoguideImageList.isNotEmpty){
  //         SqlHttpManager()
  //             .savePlanoguide(token, baseUrl,savePlanoguide)
  //             .then((value) => {
  //           print("************ Planogram Values **********************"),
  //           for(int i=0;i<planoguideImageList.length;i++){
  //
  //             updateTransBrandShareAfterApi(moduleName,planoguideImageList[i].pogId)
  //
  //           },
  //
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //           // ToastMessage.succesMessage(context, "Planoguide Data Uploaded Successfully"),
  //         }).catchError((onError)=>{
  //           print("API ERROR Before"),
  //           print(e.toString()),
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         isDataUploading  = false;
  //       });
  //     }
  //   }
  //   else if(moduleName == AppConstants.shelfShare) {
  //     print("+++++++++++ Share Shelf condition");
  //     print(brandShareData.length);
  //     if(brandShareData.isNotEmpty) {
  //       List<SaveBrandShareListData> brandShareImageList = [];
  //       for (int i = 0; i < brandShareData.length; i++) {
  //
  //         if(brandShareData[i].upload_status==0){
  //
  //           brandShareImageList.add(SaveBrandShareListData(
  //             id: brandShareData[i].id,
  //             clientId: brandShareData[i].client_id,
  //             catId: brandShareData[i].cat_id,
  //             brandId: brandShareData[i].brand_id,
  //             givenFaces: brandShareData[i].given_faces.toString(),
  //             actualFaces: brandShareData[i].actual_faces,
  //           ));
  //         }
  //       }
  //
  //       SaveBrandShare saveBrandShare = SaveBrandShare(
  //           username: userName,
  //           workingId: workingId,
  //           workingDate: workingDate,
  //           storeId: storeId,
  //           brandShares: brandShareImageList);
  //
  //       print("************ Brand Share Upload in Api **********************");
  //       print(jsonEncode(saveBrandShare));
  //
  //       if(brandShareImageList.isNotEmpty){
  //         SqlHttpManager()
  //             .saveBrandShare(token, baseUrl,saveBrandShare)
  //             .then((value) => {
  //           print("************ Brand Share Values **********************"),
  //           for(int i=0;i<brandShareImageList.length;i++){
  //             updateTransBrandShareAfterApi(moduleName,brandShareImageList[i].id)
  //           },
  //
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //         imageUploadTest(moduleName),
  //           // ToastMessage.succesMessage(context, "Share Shelf Data Uploaded Successfully"),
  //         }).catchError((onError)=>{
  //           print("API ERROR Before"),
  //           print(e.toString()),
  //           setState(() {
  //             isDataUploading  = false;
  //           }),
  //         });
  //       } else {
  //         imageUploadTest(moduleName);
  //       }
  //     } else {
  //       imageUploadTest(moduleName);
  //       setState(() {
  //         isDataUploading  = false;
  //       });
  //     }
  //   }
  //   else {
  //     imageUploadTest(moduleName);
  //   }
  // }
  //
  // updateTransBrandShareAfterApi(String moduleName,int id) async {
  //
  //   if(moduleName == AppConstants.planoguide) {
  //
  //     await DatabaseHelper.updatePlanoguideAfterApi(workingId)
  //         .then((_) {
  //       for(int i = 0; i< planoguidData.length; i++) {
  //         if(planoguidData[i].id == id) {
  //           planoguidData[i].upload_status = 1;
  //         }
  //       }
  //       // print("Updated Brand Data");
  //       // print(jsonEncode(brandShareData));
  //       setState(() {
  //
  //       });
  //
  //     });
  //
  //   } else {
  //     await DatabaseHelper.updateShareShelfAfterApi(workingId)
  //         .then((_) {
  //       for (int i = 0; i < brandShareData.length; i++) {
  //         if (brandShareData[i].id == id) {
  //           brandShareData[i].upload_status = 1;
  //         }
  //       }
  //       // print("Updated Brand Data");
  //       // print(jsonEncode(brandShareData));
  //       setState(() {
  //
  //       });
  //     });
  //   }
  //
  // }
  //
  // updateTransAvlAfterAPi(int skuId)async {
  //
  //   await DatabaseHelper.updateTransAVLAfterUpdate(skuId,workingId)
  //       .then((_) {
  //         for(int i = 0; i< availableData.length; i++) {
  //           if(availableData[i].pro_id == skuId) {
  //             availableData[i].upload_status = 1;
  //           }
  //         }
  //         print("Updated available Data");
  //         print(jsonEncode(availableData));
  //     setState(() {
  //
  //     });
  //
  //   });
  // }
  //
  // insertAvailabilityData() async {
  //   print(workingId);
  //   print(clientId);
  //   print(visitAvlExcludes);
  //   var now = DateTime.now();
  //   await DatabaseHelper.insertTransAvailability(workingId,clientId,visitAvlExcludes,now.toString()).then((value) {
  //     print(value);
  //   }).catchError((e) {
  //     print(e.toString());
  //     ToastMessage.errorMessage(context, e.toString());
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: generalAppBar(context, storeName, userName, (){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Visit"),
              content: const Text('Are you sure you want to quit this visit?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: ()async {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      }, (){print("filter Click");}, true, false, false),


      // AppBar(
      //     title:  Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Container(
      //                 margin: const EdgeInsets.symmetric(horizontal: 5),
      //                 child: Text(userName)),
      //             Text("(${DateFormat("yyyy/MM/dd").format(DateTime.now())})")
      //           ],
      //         ),
      //         Text(storeName),
      //       ],
      //     ),
      //   leading: IconButton(onPressed: (){
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AlertDialog(
      //           title: const Text("Visit"),
      //           content: const Text('Are you sure you want to quit this visit?'),
      //           actions: <Widget>[
      //             TextButton(
      //               onPressed: () {
      //                 Navigator.of(context).pop(); // Close the dialog
      //               },
      //               child: const Text('No'),
      //             ),
      //             TextButton(
      //               onPressed: ()async {
      //                 Navigator.of(context).pop();
      //                 Navigator.of(context).pop();
      //               },
      //               child: const Text('Yes'),
      //             ),
      //           ],
      //         );
      //       },
      //     );
      //   }, icon: const Icon(Icons.arrow_back)),
      //   actions: [
      //     IconButton(onPressed: (){}, icon: const Icon(Icons.logout_rounded)),
      //     IconButton(onPressed: (){}, icon: const Icon(Icons.filter_alt_outlined)),
      //   ],
      // ),
      body: WillPopScope(
        onWillPop: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Visit"),
                content: const Text('Are you sure you want to quit this visit?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: ()async {
                      // Perform logout operation
                      Navigator.of(context).pop();
                      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                      sharedPreferences.setBool(AppConstants.userLoggedIn, false);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            },
          );
          return false;
        },
        child: IgnorePointer(
          ignoring: isDataUploading,
          child: isLoading
              ? const SizedBox(
                  height: 60,
                  child: MyLoadingCircle(),
                )
              : Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: GridView.builder(

                            itemCount: agencyData.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 10.0),
                            itemBuilder: (context, i) {
                              print(agencyData[i].id);
                              print(agencyData[i].en_name);
                              return Container(
                                margin: const EdgeInsets.only(left: 4, right: 4),
                                child: CardWidget(
                                    onTap: () async {
                                     print(agencyData[i].en_name);
                                     if(agencyData[i].id == 1) {
                                      Navigator.of(context).pushNamed(BeforeFixing.routeName);
                                      //  Navigator.of(context).pushNamed(ViewKnowledgeShare.routename);
                                     }else if(agencyData[i].id == 5) {
                                       Navigator.of(context).pushNamed(PlanogramScreen.routeName);
                                     }else if(agencyData[i].id == 10) {
                                       Navigator.of(context).pushNamed(ViewKnowledgeShare.routename);
                                     } else if(agencyData[i].id == 3) {

                                         var now = DateTime.now();

                                         await DatabaseHelper.insertTransAvailability(workingId,clientId,now.toString()).then((value) {

                                           Navigator.of(context).pushNamed(Availability.routename);

                                         }).catchError((e) {

                                           print(e.toString());
                                           ToastMessage.errorMessage(context, e.toString());
                                           setState(() {});

                                         });
                                     }
                                     else if(agencyData[i].id == 11){
                                       Navigator.of(context).pushNamed(AddOtherPhoto.routeName);
                                     }  else if(agencyData[i].id == 2){
                                       Navigator.of(context).pushNamed(Rtv_List_Screen.routeName);
                                     } else if(agencyData[i].id == 6){
                                       Navigator.of(context).pushNamed(ShareOfShelf.routeName);
                                     }
                                     else if(agencyData[i].id == 12){
                                       Navigator.of(context).pushNamed(AddOSDC.routeName);
                                     }
                                     else if(agencyData[i].id == 9){
                                       Navigator.of(context).pushNamed(StockListScreen.routeName);
                                     }
                                     else if(agencyData[i].id == 7){
                                       Navigator.of(context).pushNamed(PriceCheck_Screen.routeName);
                                     }else if(agencyData[i].id == 15){
                                       //Navigator.of(context).pushNamed(Planoguides_Screen.routename);
                                       await DatabaseHelper.insertTransPlanoguide(workingId).then((value) {

                                         Navigator.of(context).pushNamed(Planoguides_Screen.routename);
                                       }).catchError((e) {
                                         print(e.toString());
                                         ToastMessage.errorMessage(context, e.toString());
                                         setState(() {});
                                       });
                                     } else if(agencyData[i].id == 16){
                                       await DatabaseHelper.insertTransBrandShares(workingId).then((value) {
                                         Navigator.of(context).pushNamed(BrandShares_Screen.routename);
                                       }).catchError((e) {
                                         print(e.toString());
                                         ToastMessage.errorMessage(context, e.toString());
                                         setState(() {});
                                       });
                                     } else if(agencyData[i].id == 4) {
                                       Navigator.of(context).pushNamed(PickListScreen.routename);
                                     } else if(agencyData[i].id == 13) {
                                       await DatabaseHelper.insertTransPromoPlan(workingId,int.parse(storeId)).then((value) {
                                         Navigator.of(context).pushNamed(PromoPlan_scrren.routeName);
                                       }).catchError((e) {
                                         print(e.toString());
                                         ToastMessage.errorMessage(context, e.toString());
                                         setState(() {});
                                       });
                                     } else if(agencyData[i].id == 8) {
                                       Navigator.of(context).pushNamed(Freshness_Screen.routeName);
                                     } else if(agencyData[i].id == 14) {
                                       Navigator.of(context).pushNamed(RtvOnePlusOneListScreen.routeName);
                                     } else if(agencyData[i].id == 19) {
                                       Navigator.of(context).pushNamed(ProofOfSale.routeName);
                                     } else if(agencyData[i].id == 18) {
                                       Navigator.of(context).pushNamed(AddMarketIssue.routeName);
                                     }  else if(agencyData[i].id == 17) {

                                       print(workingId);
                                       print(clientId);
                                       var now = DateTime.now();

                                       await DatabaseHelper.insertTransAvailability(workingId,clientId,now.toString()).then((value) {

                                         Navigator.of(context).pushNamed(SidcoAvailability.routename);

                                       }).catchError((e) {

                                         print(e.toString());
                                         ToastMessage.errorMessage(context, e.toString());
                                         setState(() {});

                                       });
                                     }
                                      // Navigator.of(context).pushNamed(BeforeFixing.routeName);
                                    },
                                    imageUrl: agencyData[i].id.toString(),
                                    // "assets/images/camera.png",
                                    cardName: agencyData[i].ar_name),
                              );
                            }),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 77, 145, 1),
                          minimumSize: Size(MediaQuery.of(context).size.width/1.1, 45),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          // setState(() {
                          //   isUplaodStatus = true;
                          // });
                          // getTransData(AppConstants.availability,true);
                          // getAllModuleData();

                          Navigator.of(context).pushNamed(VisitUploadScreen.routeName);

                        },
                        child: const Text(
                          "View Visit Summary",style: TextStyle(color: MyColors.whiteColor),
                        ),
                      )
                    ],
                  ),
                  isDataUploading ? const Center(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: MyLoadingCircle(),
                    ),
                  ) : Container()
                ],
              ),
        ),
      ),
    );
  }

  Future <bool>  deleteVisitData() async {

    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransAvailability,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransPlanoguide,workingId);
    await DatabaseHelper.deleteTransTableByWorkingId(TableName.tblTransBrandShare,workingId);

    await deleteFolder(workingId);

    return true;

  }

  getAllModuleData() async {

    /*close button
    * by default enable
    * isAailaibility data check if not uploaded found disable close button else keep enable
    * if isPlanoguide data or gcs found then disble close data
    *
    * */


    // bool isAvlData = await getAvailabilityTransData();
    // bool isPlanoData = await  getPlanoguideTransData();
    // bool isShareShelfData = await getShareShelTransData();

    bool isCountData = await getAllCountData();
    ///Data Uploading Dialogue Box
    if(isCountData){
      showDialogueBox();
    }
  }

  showDialogueBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, menuState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: MyColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Close Visit",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: MyColors.blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SvgPicture.asset(
                            "assets/icons/close.svg",
                            height: 30,
                            width: 30,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            if (availabilityCountModel.totalSku > 0 )
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                     "Availability",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    isAvlFinishLoading
                                        ? Container(
                                        width: 30,
                                        height: 30,
                                        margin: const EdgeInsets.only(
                                            right: 10),
                                        child:
                                        const CircularProgressIndicator()) :  availabilityCountModel.totalNotUploaded == 0 ? Container(
                                      width: 30,
                                      height: 30,
                                      margin: const EdgeInsets.only(
                                          right: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyColors
                                                  .greenColor,
                                              width: 1)),
                                      child: const Icon(
                                        Icons.check,
                                        color: MyColors.greenColor,
                                      ),
                                    ) : ElevatedButton(
                                        style: ElevatedButton
                                            .styleFrom(
                                          minimumSize:
                                          const Size(30, 30),
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                20.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          availabilityUploadToAPI(menuState);
                                        },
                                        child: const Text(
                                          "Upload",
                                          style: TextStyle(
                                              fontSize: 12),
                                        ))
                                  ],
                                ),
                              ),
                            if (tmrPickListCountModel.totalPickListItems > 0 )
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Pick List",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    isPickListFinishLoading
                                        ? Container(
                                        width: 30,
                                        height: 30,
                                        margin: const EdgeInsets.only(
                                            right: 10),
                                        child:
                                        const CircularProgressIndicator()) : tmrPickListCountModel.totalPickListItems ==  tmrPickListCountModel.totalPickUpload ? Container(
                                      width: 30,
                                      height: 30,
                                      margin: const EdgeInsets.only(
                                          right: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyColors
                                                  .greenColor,
                                              width: 1)),
                                      child: const Icon(
                                        Icons.check,
                                        color: MyColors.greenColor,
                                      ),
                                    ) : ElevatedButton(
                                        style: ElevatedButton
                                            .styleFrom(
                                          minimumSize:
                                          const Size(30, 30),
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                20.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          tmrUploadPickList(menuState);
                                        },
                                        child: const Text(
                                          "Upload",
                                          style: TextStyle(
                                              fontSize: 12),
                                        ))
                                  ],
                                ),
                              ),
                            if (planoguideCountModel.totalPlano > 0 )
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Planoguide",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    isPlanoguideFinishLoading
                                        ? Container(
                                        width: 30,
                                        height: 30,
                                        margin: const EdgeInsets.only(
                                            right: 10),
                                        child:
                                        const CircularProgressIndicator()) :  planoguideCountModel.totalNotUploaded==0 ? Container(
                                      width: 30,
                                      height: 30,
                                      margin: const EdgeInsets.only(
                                          right: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyColors
                                                  .greenColor,
                                              width: 1)),
                                      child: const Icon(
                                        Icons.check,
                                        color: MyColors.greenColor,
                                      ),
                                    ) : ElevatedButton(
                                        style: ElevatedButton
                                            .styleFrom(
                                          minimumSize:
                                          const Size(30, 30),
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                20.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          await uploadImagesToGcs(menuState,AppConstants.planoguide);

                                          planoguideUploadApi(menuState);
                                        },
                                        child: const Text(
                                          "Upload",
                                          style: TextStyle(
                                              fontSize: 12),
                                        ))
                                  ],
                                ),
                              ),
                            if (brandShareCountModel.totalBrandShare > 0 )
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Shelf Shares",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    isShelfShareFinishLoading
                                        ? Container(
                                        width: 30,
                                        height: 30,
                                        margin: const EdgeInsets.only(
                                            right: 10),
                                        child:
                                        const CircularProgressIndicator()) :  brandShareCountModel.totalNotUpload==0 ? Container(
                                      width: 30,
                                      height: 30,
                                      margin: const EdgeInsets.only(
                                          right: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyColors
                                                  .greenColor,
                                              width: 1)),
                                      child: const Icon(
                                        Icons.check,
                                        color: MyColors.greenColor,
                                      ),
                                    ) : ElevatedButton(
                                        style: ElevatedButton
                                            .styleFrom(
                                          minimumSize:
                                          const Size(30, 30),
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                20.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          shareShelfUploadToApi(menuState);
                                        },
                                        child: const Text(
                                          "Upload",
                                          style: TextStyle(
                                              fontSize: 12),
                                        ))
                                  ],
                                ),
                              ),
                            if (pickListCountModel.totalPickListItems > 0 )
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Pick List",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    isPickListFinishLoading
                                        ? Container(
                                        width: 30,
                                        height: 30,
                                        margin: const EdgeInsets.only(
                                            right: 10),
                                        child:
                                        const CircularProgressIndicator()) : pickListCountModel.totalPickListItems ==  pickListCountModel.totalUpload ? Container(
                                      width: 30,
                                      height: 30,
                                      margin: const EdgeInsets.only(
                                          right: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyColors
                                                  .greenColor,
                                              width: 1)),
                                      child: const Icon(
                                        Icons.check,
                                        color: MyColors.greenColor,
                                      ),
                                    ) : ElevatedButton(
                                        style: ElevatedButton
                                            .styleFrom(
                                          minimumSize:
                                          const Size(30, 30),
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                20.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          pickListUploadAPi(menuState);
                                        },
                                        child: const Text(
                                          "Upload",
                                          style: TextStyle(
                                              fontSize: 12),
                                        ))
                                  ],
                                ),
                              ),
                          ],
                        )
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    isDataUploading ? const CircularProgressIndicator() : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                          Size(MediaQuery.of(context).size.width / 3, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: isFinishButton ? (){
                          finishVisit();
                        } : null,
                        child: const Text(
                          "Finish Visit",
                          style: TextStyle(fontSize: 12),
                        ))
                  ],
                ),
              ),
            );
          });
        });
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

    setState(() {

      if(moduleIdList.contains("3")) {
        if((availabilityCountModel.totalSku != availabilityCountModel.totalUploaded) || availabilityCountModel.totalSku == 0 || availabilityCountModel.totalUploaded.toString() == "null") {
          isAvlFinishLoading = false;
        } else {
          isAvlFinishLoading = true;
        }
      }

      if(moduleIdList.contains("15")) {
        if((planoguideCountModel.totalPlano != planoguideCountModel.totalUploaded) || planoguideCountModel.totalPlano == 0 || planoguideCountModel.totalUploaded.toString() == "null" ) {
          isAvlFinishLoading = false;
        } else {
          isAvlFinishLoading = true;
        }
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
  }

 Future<bool> uploadImagesToGcs(StateSetter menuState,String moduleName) async {
    try {
      final credentials = ServiceAccountCredentials.fromJson(
          await rootBundle.loadString(
          'assets/google_cloud_creds/appimages-keycstoreapp-7c0f4-a6d4c3e5b590.json'),
    );

    final httpClient = await clientViaServiceAccount(credentials, [StorageApi.devstorageReadWriteScope]);

    // Create a Storage client with the credentials
    final storage = StorageApi(httpClient);

      if(moduleName == AppConstants.planoguide) {

        menuState(() {
          isPlanoguideFinishLoading = true;
        });

        await DatabaseHelper.getPlanoGuideGcsImagesList(workingId).then((value) async {

          planoguideGcsImagesList = value.cast<TransPlanoGuideGcsImagesListModel>();

          await _getImages(AppConstants.planoguide).then((value) {
            setTransPhotoInList(AppConstants.planoguide);

            menuState(() {

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
        menuState(() {
          isPlanoguideFinishLoading = false;
        });
      }
        return true;
    } catch (e) {
      // Handle any errors that occur during the upload
      print("Upload GCS Error $e");
      menuState(() {
        isPlanoguideFinishLoading = false;
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

  availabilityUploadToAPI(StateSetter menuState) async {
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

    SavePickList savePickList = SavePickList(
      username: userName,
      workingId: workingId,
      workingDate: workingDate,
      storeId: storeId,
      pickList: availabilityPickList,
    );
    //
    print("************ Availablity Upload in Api **********************");
    print(jsonEncode(saveAvailability));

    // await updateTransAvailabilityAfterApi();

      menuState(() {
        isAvlFinishLoading = true;
      });
    //
      await SqlHttpManager()
          .saveAvailabilityTrans(token, baseUrl,saveAvailability)
          .then((value) => {
        print("************ Availability Values **********************"),
        isAvlUp = true,
        menuState(() {
        }),
        ToastMessage.succesMessage(context, "Availability data Uploaded Successfully"),
      }).catchError((onError)=>{
        ToastMessage.errorMessage(context, onError.toString()),
        print(onError.toString()),
        menuState(() {
          isAvlUp = false;
        }),
      });

    if(isAvlUp) {
      await updateTransAvailabilityAfterApi();

      await getAllCountData();

      menuState(() {
        isAvlFinishLoading = false;
      });
    } else {
      menuState(() {
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

  tmrUploadPickList(StateSetter menuState) async {
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

      menuState((){
        isPickListFinishLoading = true;
      });
      await SqlHttpManager()
          .savePickListTrans(token, baseUrl, savePickList)
          .then((value) =>
      {
        print("************ PickList Values **********************"),
        isPickUp = true,
        menuState(() {}),
        ToastMessage.succesMessage(
            context, "Pick List Uploaded Successfully"),
      }).catchError((onError) =>
      {
        ToastMessage.errorMessage(context, onError.toString()),
        print(e.toString()),
        menuState(() {
          isPickUp = false;
        }),
      });
    } else {
      isPickUp = true;
      menuState((){});
    }

    if(isPickUp) {
      await updateTmrPickListAfterAPi();

      await getAllCountData();

      menuState(() {
        isPickListFinishLoading = false;
      });
    } else {
      menuState(() {
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

  shareShelfUploadToApi(StateSetter menuState) async {

    await DatabaseHelper.getActivityStatusBrandSharesDataList(workingId).then((value) async {
      brandShareImageList = value.cast<SaveBrandShareListData>();

      menuState(() {});
      });

      SaveBrandShare saveBrandShare = SaveBrandShare(
          username: userName,
          workingId: workingId,
          workingDate: workingDate,
          storeId: storeId,
          brandShares: brandShareImageList);

      print("************ Brand Share Upload in Api **********************");
      print(jsonEncode(saveBrandShare));

        menuState(() {
        isShelfShareFinishLoading = true;
        });
        SqlHttpManager()
            .saveBrandShare(token, baseUrl,saveBrandShare)
            .then((value) async => {
          print("************ Brand Share Values **********************"),

          await  updateTransBrandShareAfterApi(),

          await getAllCountData(),

        menuState(() {
          isShelfShareFinishLoading = false;
        }),
          ToastMessage.succesMessage(context, "Share Shelf Data Uploaded Successfully"),
        }).catchError((onError)=>{
          ToastMessage.errorMessage(context, onError.toString()),
          print(e.toString()),
        menuState(() {
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

  planoguideUploadApi(StateSetter menuState) async {

    await DatabaseHelper.getActivityStatusPlanoGuideDataList(workingId).then((value) async {

      planoguideImageList = value.cast<SavePlanoguideListData>();

      menuState((){});
    });

      SavePlanoguide savePlanoguide = SavePlanoguide(
          username: userName,
          workingId: workingId,
          workingDate: workingDate,
          storeId: storeId,
          pogs: planoguideImageList);

      print("************ Planoguide Upload in Api **********************");
      print(jsonEncode(savePlanoguide));

      menuState((){
        isPlanoguideFinishLoading = true;
      });

        SqlHttpManager()
            .savePlanoguide(token, baseUrl,savePlanoguide)
            .then((value) async => {
          print("************ Planogram Values **********************"),

         await updateTransPlanoguideAfterApi(),

         await getAllCountData(),

        menuState(() {
          isPlanoguideFinishLoading  = false;
        }),
          ToastMessage.succesMessage(context, "Planoguide Data Uploaded Successfully"),
        }).catchError((onError)=>{
          ToastMessage.errorMessage(context, onError.toString()),
          print(e.toString()),
        menuState(() {
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

  pickListUploadAPi(StateSetter menuState) async {
    await DatabaseHelper.getPickListDataForApi(userName).then((value) async {
      pickListDataForApi = value.cast<ReadyPickListData>();

      menuState(() {});
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
      menuState(() {
        isPickListFinishLoading = true;
      });
      SqlHttpManager().readyPickList(token, baseUrl, readyPickList).then((
          value) async =>
      {

        print(value),

        await updateSqlPickListAfterApi(),

        await getAllCountData(),

        menuState(() {
          isPickListFinishLoading = false;
        }),
        ToastMessage.succesMessage(context, "Pick List Uploaded Successfully"),
      }).catchError((e) =>
      {
        menuState(() {
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

  finishVisit() async {
    await LocationService.getLocation().then((value) async {

      print(value);

      if(value['locationIsPicked']) {
        setState(() {
          location = value['lat'] + value['long'];
        });

    setState(() {
      isDataUploading = true;
    });
    JourneyPlanHTTP().finishVisit(token, baseUrl, FinishVisitRequestModel(
      username: userName,
      workingId: workingId,
      workingDate: workingDate,
      storeId: storeId,
      checkOutGps: location,
    )).then((value) => {
    setState(() {
    isDataUploading = false;
    }),
      ToastMessage.succesMessage(context, "Visit Ended Successfully"),
      Navigator.of(context).pop(),
      Navigator.of(context).pop(),
    }).catchError((e) {
      print(e.toString());
      setState(() {
        isDataUploading = false;
      });
      ToastMessage.errorMessage(context, e.toString());
    });

      }

    });

  }

  String removeLastComma(String input) {
    if (input.endsWith(',')) {
      return input.substring(0, input.length - 1);
    }
    return input;
  }
}
