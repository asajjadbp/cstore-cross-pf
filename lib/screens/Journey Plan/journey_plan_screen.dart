
import 'dart:convert';
import 'dart:io';

import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/Model/response_model.dart/jp_response_model.dart';
import 'package:cstore/Network/jp_http.dart';
import 'package:cstore/screens/Journey%20Plan/journey_plan.dart';
import 'package:cstore/screens/Journey%20Plan/view_jp_photo.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/utils/services/image_picker.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:cstore/screens/widget/drop_downs.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/drop_reason_model.dart';
import '../../Network/app_exceptions.dart';
import '../Language/localization_controller.dart';
import '../grid_dashboard/grid_dashboard.dart';
import '../important_service/genral_checks_status.dart';
import '../utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

import '../utils/services/general_checks_controller_call_function.dart';
import '../utils/services/getting_gps.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../widget/app_bar_widgets.dart';

class JourneyPlanScreen extends StatefulWidget {
  static const routename = "/journeyPlanScreen";
  const JourneyPlanScreen({super.key});

  @override
  State<JourneyPlanScreen> createState() => _JourneyPlanScreenState();
}

class _JourneyPlanScreenState extends State<JourneyPlanScreen> {

  final languageController = Get.put(LocalizationController());

  File? _pickedImage;
  var userName = "";
  var token = "";
  var baseUrl = "";
  String imageBaseUrl = "";
  bool isLoading = false;
  bool isCheckLoading = false;
  bool isDropLoading = false;
  bool isError = false;
  String errorText = "";
  int selectedReasonId = -1;
  String bucketName = "";

  // This id is taking to recognize that card and start reloading
  var dropWorkingId = "";
  List<JourneyPlanDetail> jpData = [];

  List<DropReasonModel> dropReasonList = [];

  final RefreshController _refreshController = RefreshController(
      initialRefresh: false);

  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userName = prefs.getString(AppConstants.userName)!;
    token = prefs.getString(AppConstants.tokenId)!;
    bucketName = prefs.getString(AppConstants.bucketName)!;
    imageBaseUrl = prefs.getString(AppConstants.imageBaseUrl)!;

    print(userName);
    print(prefs.getString(AppConstants.tokenId)!);
    print("jp screen");
    // print(urlData["data"][0]["base_url"]);
    baseUrl = prefs.getString(AppConstants.baseUrl)!;

    getDropReasons();

    getJpDataFromSqlDb();
  }

  void _onRefresh() async {
    // await Future.delayed(const Duration(milliseconds: 1000));
    // DatabaseHelper.delete_table(TableName.tbl_user_dashboard);
    callJp();
    _refreshController.refreshCompleted();
  }

  getDropReasons() async {
    isError = false;
    await DatabaseHelper.getDropReason().then((value) {
      print(value);
      print("__________DROP REASON____________");

      dropReasonList = value;

      setState(() {});
    }).catchError((e) {
      isError = true;
      errorText = e.toString();
      print(e.toString());
      setState(() {

      });
    });
  }

  getJpDataFromSqlDb() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getJourneyPlanData(userName).then((value) {
      jpData = value;
      setState(() {
        isLoading = false;
        isCheckLoading = false;
      });
    });
  }

  Future callJp() async {
    setState(() {
      isError = false;
      isLoading = true;
    });
    // try {
    await JourneyPlanHTTP()
        .getJourneyPlan(userName, token, baseUrl)
        .then((value) async {
      setState(() {
        isLoading = false;
      });

      if (value.status) {
        jpData = value.data;
        DatabaseHelper.delete_table(TableName.tblSysJourneyPlan);

        await DatabaseHelper.insertSysJourneyPlanArray(value.data);

        getJpDataFromSqlDb();
      }
    }).catchError((onError) {
      isError = true;
      errorText = onError.toString();
      print(onError.toString());
      setState(() {
        isLoading = false;
      });
      ToastMessage.errorMessage(context, onError.toString());
    });
    // } catch (error) {

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: generalAppBar(context, userName, "Visit Pool".tr, (){
        Navigator.of(context).pop();
      }, true, false, true,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _onRefresh,
        child: isLoading
            ? const Center(
          child: MyLoadingCircle(),
        ) : isError ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(errorText, style: const TextStyle(
                color: MyColors.backbtnColor, fontSize: 20),),
            const SizedBox(height: 10,),
            InkWell(
              onTap: () {
                getDropReasons();
                getJpDataFromSqlDb();
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.backbtnColor, width: 2)
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child:  Text("Retry".tr,
                  style:const TextStyle(color: MyColors.backbtnColor, fontSize: 20),),
              ),
            )
          ],
        )
            : jpData.isEmpty
            ?  Center(
          child: Text("No journey plan found".tr),
        )
            :  ListView.builder(
                itemCount: jpData.length,
                itemBuilder: (ctx, i) {
                  // print(
                  //     "https://storage.googleapis.com/$bucketName/visits/${jpData[i]
                  //         .startVisitPhoto}");
                  return JourneyPlan(
                    languageController: languageController,
                    onLocationTap: () {
                      launchStoreUrl(jpData[i].gcode);
                    },
                    isCheckLoading: isCheckLoading,
                    imageBaseUrl: bucketName,
                    jp: jpData[i],
                    onStartClick: () async {
                      print(jsonEncode(jpData[i]));
                      setState(() {
                        isCheckLoading = true;
                      });

                      if (jpData[i].visitStatus == "1") {
                        // GeneralChecksStatusController generalStatusController = await generalControllerInitialization();
                        // List<String> latLong = jpData[i].gcode.split('=')[1].split(',');
                        // String storeLat = latLong[0];
                        // String storeLong = latLong[1];

                        await LocationService.getLocation().then((value) async => {
                        if (value["locationIsPicked"]) {
                          setVisitSession(jpData[i]),
                        //     if(generalStatusController.isLocationStatus.value) {
                        //
                        //   if(generalStatusController.isGeoLocation.value) {
                        //     generalStatusController.isGeoFenceDistance.value = 0.5,
                        //   } else {
                        //
                        //     print("Store Lat Long"),
                        //     print(latLong),
                        //     print(storeLong),
                        //     print(storeLat),
                        //     print("User Lat Long"),
                        //     print(generalStatusController.isLat),
                        //     print(generalStatusController.isLong),
                        //     print(generalStatusController.isLatLong),
                        //
                        //     await generalStatusController.getGeoLocationDistance(
                        //         double.parse(generalStatusController.isLat.value),
                        //         double.parse(generalStatusController.isLong
                        //             .value), double.parse(storeLat.trim()),
                        //         double.parse(storeLong.trim())),
                        //   },
                        //   print("Distance From Store"),
                        //   print(generalStatusController.isGeoFenceDistance.value),
                        // },
                        // if(generalStatusController.isVpnStatus.value) {
                        //   setState(() {
                        //     isCheckLoading = false;
                        //   }),
                        //   showAnimatedToastMessage("Error!".tr,"Please Disable Your VPN".tr, false),
                        // }
                        // else if(generalStatusController.isMockLocation.value) {
                        //   setState(() {
                        //     isCheckLoading = false;
                        //   }),
                        //   showAnimatedToastMessage("Error!".tr, "Please Disable Your Fake Locator".tr, false),
                        // }
                        // else if(!generalStatusController.isAutoTimeStatus.value) {
                        //   setState(() {
                        //     isCheckLoading = false;
                        //   }),
                        //   showAnimatedToastMessage("Error!".tr, "Please Enable Your Auto time Option From Setting".tr, false),
                        // }
                        // else if(!generalStatusController.isLocationStatus.value) {
                        //   setState(() {
                        //     isCheckLoading = false;
                        //   }),
                        //   showAnimatedToastMessage("Error!".tr, "Please Enable Your Location".tr, false),
                        // }
                        // else if(generalStatusController.isGeoFenceDistance.value > 0.7) {
                        //   setState(() {
                        //     isCheckLoading = false;
                        //   }),
                        //   showAnimatedToastMessage("Error!".tr, "You’re just 0.7 km away from the store. Please contact your supervisor for the exact location details".tr, false),
                        // }
                        // else {
                        //   setState(() {
                        //     isCheckLoading = false;
                        //   }),
                        //   Get.delete<GeneralChecksStatusController>(),
                        //
                        // }
                        //
                        } else {
                            setState(() {
                          isCheckLoading = false;
                        }),
                          showAnimatedToastMessage("Error!".tr, value["msg"].toString().tr, false),
                        }
                        });
                      } else {
                        getImage(jpData[i]);
                      }
                    },
                    onDropClick: () {
                      if (jpData[i].isDrop == 0) {
                        // dropVisit(jpData[i].workingId.toString());
                        showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  "Are you sure you want to drop this visit?".tr),
                              content: ReasonDropDown(hintText: "Select Reason".tr,
                                  reasonData: dropReasonList,
                                  onChange: (value) {
                                    selectedReasonId = value.id;
                                  }),
                              actions: [
                                TextButton(
                                  child:  Text("No".tr),
                                  onPressed: () {
                                    // returnValue = true;
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                                TextButton(
                                  child:  Text("Yes".tr),
                                  onPressed: () {
                                    // returnValue = true;
                                    if (selectedReasonId != -1) {
                                      dropVisit(jpData[i].workingId.toString());
                                      Navigator.of(context).pop();
                                    } else {
                                      ToastMessage.errorMessage(
                                          context, "Please Select reason".tr);
                                    }
                                  },
                                )
                              ],
                            );
                          },);
                      } else {
                        showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Do you want to Activate this visit?".tr),
                              actions: [
                                TextButton(
                                  child:  Text("No".tr),
                                  onPressed: () {
                                    // returnValue = true;
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                                TextButton(
                                  child:  Text("Yes".tr),
                                  onPressed: () {
                                    // returnValue = true;
                                    undropVisit(jpData[i].workingId.toString());
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },);
                      }
                    },
                    isDropLoading: isDropLoading,
                    workingId: dropWorkingId,
                  );
                }),
      ),
    );
  }

  setVisitSession(JourneyPlanDetail journeyPlanDetail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        AppConstants.workingId, journeyPlanDetail.workingId.toString());
    sharedPreferences.setString(
        AppConstants.storeId, journeyPlanDetail.storeId.toString());
    sharedPreferences.setString(
        AppConstants.clientId, journeyPlanDetail.clientIds.toString());
    sharedPreferences.setString(
        AppConstants.storeEnNAme, journeyPlanDetail.enStoreName.toString());
    sharedPreferences.setString(
        AppConstants.storeArNAme, journeyPlanDetail.arStoreName.toString());
    sharedPreferences.setString(
        AppConstants.gcode, journeyPlanDetail.gcode.toString());
    sharedPreferences.setString(
        AppConstants.workingDate, journeyPlanDetail.workingDate.toString());
    sharedPreferences.setString(
        AppConstants.visitCheckIn, journeyPlanDetail.checkIn.toString());
    sharedPreferences.setString(
        AppConstants.visitActivity, journeyPlanDetail.visitActivity.toString());

    Navigator.of(context).pushNamed(GridDashBoard.routeName).then((value) {
      print("JP SCREEN LOADING");
      callJp();
    });
  }

  Future<void> getImage(JourneyPlanDetail journeyPlanDetail) async {

    await ImageTakingService.imageSelect().then((value) async {
      if (value == null) {
        setState(() {
          isCheckLoading = false;
        });
        showAnimatedToastMessage("Error!".tr, "No Image Picked".tr, false);
        return;
      }


      XFile compressedImageFile;
      XFile compressedWaterMarkImageFile;

      final filename = '${userName}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final dir = await getTemporaryDirectory();
      final targetPath = path.join(dir.path, filename);

      int sizeInBytes = value.readAsBytesSync().lengthInBytes;
      final kb = sizeInBytes / 1024;
      final mb = kb / 1024;

      if(mb >= 6) {
        compressedImageFile = await testCompressAndGetFile(value, targetPath,60);
      } else if(mb < 6 && mb > 4) {
        compressedImageFile = await testCompressAndGetFile(value, targetPath,75);
      } else if(mb < 4 && mb > 2) {
        compressedImageFile = await testCompressAndGetFile(value, targetPath,90);
      } else {
        compressedImageFile = await testCompressAndGetFile(value, targetPath,100);
      }

      compressedWaterMarkImageFile = await addWatermark(compressedImageFile,DateTime.now().toString());
      print(mb);
      print(kb);
      print(compressedWaterMarkImageFile.path);
      print(compressedWaterMarkImageFile.name);
      File waterMarkImageFile = File(compressedWaterMarkImageFile.path);

      // return;
      // _pickedImage = value;
      Navigator.of(context).pushNamed(ViewJPPhoto.routename, arguments: {
        "image": waterMarkImageFile,
        "visitItem": journeyPlanDetail,
        "image_name":filename,
      }).then((value) {
        print("JP SCREEN LOADING");
        callJp();
      });
    });
  }

  Future<void> dropVisit(String workingId) async {
    if (selectedReasonId == -1) {
      showAnimatedToastMessage("Error!".tr, "Please Select Reason first".tr, false);
      return;
    }
    setState(() {
      isDropLoading = true;
    });
    await JourneyPlanHTTP()
        .dropVisit(
        userName, workingId, selectedReasonId.toString(), token, baseUrl)
        .then((value) {
      callJp();
      setState(() {
        isDropLoading = false;
        dropWorkingId = workingId;
      });
      if (value.status) {
        showAnimatedToastMessage("Error!".tr, "Visit Drop Successfully".tr, false);
      } else {
        showAnimatedToastMessage("Error!".tr, value.msg.tr, false);
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showAnimatedToastMessage("Error!".tr, onError.toString().tr, false);
    });
  }

  void undropVisit(String workingId) async {
    setState(() {
      isDropLoading = true;
      isLoading = true;
      dropWorkingId = "";
    });
    await JourneyPlanHTTP()
        .unDropVisit(userName, workingId, token, baseUrl)
        .then((value) {
      callJp();
      setState(() {
        isDropLoading = false;
      });
      if (value.status) {
        showAnimatedToastMessage("Success".tr, "Visit Activate Successfully".tr, true);
      } else {
        showAnimatedToastMessage("Error!".tr, value.msg.tr, false);
      }
    }).catchError((onError) {
      setState(() {
        isDropLoading = false;
      });
      showAnimatedToastMessage("Error!".tr, onError.toString().tr, false);
    });
  }

  Future<void> launchStoreUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
