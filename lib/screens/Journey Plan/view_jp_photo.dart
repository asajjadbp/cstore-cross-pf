import 'dart:convert';
import 'dart:io';
import 'package:cstore/screens/grid_dashboard/grid_dashboard.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/response_model.dart/jp_response_model.dart';
import '../important_service/genral_checks_status.dart';
import '../utils/services/general_checks_controller_call_function.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../widget/app_bar_widgets.dart';
import '/Network/jp_http.dart';
import '../utils/services/getting_gps.dart';
import '/screens/utils/toast/toast.dart';
import '/screens/widget/loading.dart';
import '/screens/widget/two_buttons_in_row.dart';

import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewJPPhoto extends StatefulWidget {
  static const routename = "/view_startJp_image";
  const ViewJPPhoto({super.key});

  @override
  State<ViewJPPhoto> createState() => _ViewJPPhotoState();
}

class _ViewJPPhotoState extends State<ViewJPPhoto> {
  var commentText = TextEditingController();
  bool isLoading = false;
  var userName = "";
  var token = "";
  var baseUrl = "";
  String bucketName = "";
  late  JourneyPlanDetail journeyPlanDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void submitStartVist(String workingId, String storeImage, String lat,
      String long, String clientId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    await JourneyPlanHTTP()
        .startVisit(userName, workingId, storeImage, lat, long, clientId,
            commentText.text, token, baseUrl)
        .then((value) {
          print("CHECKING TIME");
          print(value['data']);

          sharedPreferences.setString(AppConstants.workingId, journeyPlanDetail.workingId.toString());
          sharedPreferences.setString(AppConstants.storeId, journeyPlanDetail.storeId.toString());
          sharedPreferences.setString(AppConstants.clientId, journeyPlanDetail.clientIds.toString());
          sharedPreferences.setString(AppConstants.storeEnNAme, journeyPlanDetail.enStoreName.toString());
          sharedPreferences.setString(AppConstants.storeArNAme, journeyPlanDetail.arStoreName.toString());
          sharedPreferences.setString(AppConstants.gcode, journeyPlanDetail.gcode.toString());
          sharedPreferences.setString(AppConstants.workingDate, journeyPlanDetail.workingDate.toString());
          sharedPreferences.setString(AppConstants.visitCheckIn, value['data'][0]['check_in'].toString());
          sharedPreferences.setString(AppConstants.visitActivity, journeyPlanDetail.visitActivity.toString());

          setState(() {
        isLoading = false;
      });
          callJp();
          showAnimatedToastMessage("Success".tr, "Visit Started Successfully".tr, true);

        Navigator.of(context).pushNamed(GridDashBoard.routeName).then((value) => {
          Navigator.of(context).pop(),
        });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      print(error.toString());
      showAnimatedToastMessage("Error!".tr, error.toString().tr, false);
    });

    // print(commentText.text);
    // await LocationService.getLocation().then((value) {
    //   if (value["locationIsPicked"]) {

    //     JourneyPlanHTTP().startVisit(userName, workingId, storeImage,
    //         value["lat"], value["long"], "1,3,2", commentText.text, token);

    //   } else {
    //     setState(() {
    //       isLoading = false;
    //     });
    //     ToastMessage.errorMessage(context, value["msg"]);
    //   }
    // });
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userName = prefs.getString(AppConstants.userName)!;
    token = prefs.getString(AppConstants.tokenId)!;
    bucketName = prefs.getString(AppConstants.bucketName)!;
    baseUrl = prefs.getString(AppConstants.baseUrl)!;
  }

  void uploadImageToCloud(
      File imageFile, String workingId, String clientId,dynamic value,String imageName) async {

    try {
          final credentials = ServiceAccountCredentials.fromJson(
            await rootBundle.loadString(
                'assets/google_cloud_creds/appimages-keycstoreapp-7c0f4-a6d4c3e5b590.json'),
          );

          final httpClient = await clientViaServiceAccount(
              credentials, [StorageApi.devstorageReadWriteScope]);

          // Create a Storage client with the credentials
          final storage = StorageApi(httpClient);

          // Generate a unique filename and path
          final filename = imageName;
          // const bucketName =
          //     "binzagr-bucket"; // Replace with your bucket name
          final filePath = 'visits/$filename';

          print("Bucket Name asdwa");
          print(bucketName);
          print(filePath);

          final fileContent = await imageFile.readAsBytes();
          final bucketObject = Object(name: filePath);

          // Upload the image
          final resp = await storage.objects.insert(
            bucketObject,
            bucketName,
            predefinedAcl: 'publicRead',
            uploadMedia: Media(
              Stream<List<int>>.fromIterable([fileContent]),
              fileContent.length,
            ),
          );
          // final downloadUrl =
          //     'https://storage.googleapis.com/$bucketName/$filePath';
          // print(downloadUrl);

          submitStartVist(journeyPlanDetail.workingId.toString(), imageName, value['lat'], value['long'],  journeyPlanDetail.clientIds.toString());


    } catch (e) {

      // Handle any errors that occur during the upload
      print("Upload GCS Error $e");
      showAnimatedToastMessage("Error!".tr, "Uploading images error please try again!".tr, false);
    }
  }

  Future callJp() async {
    // try {
    await JourneyPlanHTTP()
        .getJourneyPlan(userName, token, baseUrl)
        .then((value) async {

      if (value.status) {
        DatabaseHelper.delete_table(TableName.tblSysJourneyPlan);

        await DatabaseHelper.insertSysJourneyPlanArray(value.data);

      }
    }).catchError((onError) {
      print(onError.toString());
      showAnimatedToastMessage("Error!".tr,onError.toString().tr, false);
    });
    // } catch (error) {

    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    journeyPlanDetail = routeArg['visitItem'];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: generalAppBar(context, journeyPlanDetail.enStoreName, "Start Visit".tr, (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {
      }),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [

                  Container(
                    margin:const EdgeInsets.symmetric(vertical: 15),
                    height: screenHeight * 0.3,
                    width: screenWidth,
                    child: Card(
                      elevation: 3,
                      child: Image.file(
                        routeArg["image"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Card(
                    child: TextField(
                        controller: commentText,
                        decoration:  InputDecoration(
                            hintText: "Comment".tr,
                            filled: true,
                            fillColor:const Color.fromARGB(255, 223, 218, 218),
                            border: InputBorder.none),
                        maxLines: 4),
                  )
                ],
              ),
              isLoading
                  ? Center(
                      child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          height: 60,
                          child: const MyLoadingCircle()),
                    )
                  : RowButtons(
                isNextActive: true,
                  buttonText: "Save".tr,
                  onSaveTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    GeneralChecksStatusController generalStatusController = await generalControllerInitialization();
                    List<String> latLong = journeyPlanDetail.gcode.split('=')[1].split(',');
                    String storeLat = latLong[0];
                    String storeLong = latLong[1];
                      // submitStartVist(routeArg["workingId"].toString());
                    await LocationService.getLocation().then((value) async => {
                      if (value["locationIsPicked"]) {

                        if(generalStatusController.isLocationStatus.value) {

                      if(generalStatusController.isGeoLocation.value) {
                        generalStatusController.isGeoFenceDistance.value = 0.5,
                      } else {

                        print("Store Lat Long"),
                        print(latLong),
                        print(storeLong),
                        print(storeLat),
                        print("User Lat Long"),
                        print(generalStatusController.isLat),
                        print(generalStatusController.isLong),
                        print(generalStatusController.isLatLong),

                        await generalStatusController.getGeoLocationDistance(
                            double.parse(generalStatusController.isLat.value),
                            double.parse(generalStatusController.isLong
                                .value), double.parse(storeLat.trim()),
                            double.parse(storeLong.trim())),
                      },
                      print("Distance From Store"),
                      print(generalStatusController.isGeoFenceDistance.value),
                    },

                    if(generalStatusController.isVpnStatus.value) {
                      setState(() {
                        isLoading = false;
                      }),
                      showAnimatedToastMessage("Error!".tr,"Please Disable Your VPN".tr, false),
                    }
                    else if(generalStatusController.isMockLocation.value) {
                      setState(() {
                        isLoading = false;
                      }),
                      showAnimatedToastMessage("Error!".tr, "Please Disable Your Fake Locator".tr, false),
                    }
                    else if(!generalStatusController.isAutoTimeStatus.value) {
                        setState(() {
                          isLoading = false;
                        }),
                      showAnimatedToastMessage("Error!".tr, "Please Enable Your Auto time Option From Setting".tr, false),
                    } else if(generalStatusController.isGeoFenceDistance.value > 0.7) {
                            setState(() {
                              isLoading = false;
                            }),
                      showAnimatedToastMessage("Error!".tr, "You’re just 0.7 km away from the store. Please contact your supervisor for the exact location details".tr, false),
                    } else {
                    Get.delete<GeneralChecksStatusController>(),
                              uploadImageToCloud(
                                  routeArg["image"],
                                  journeyPlanDetail.workingId.toString(),
                                  journeyPlanDetail.clientIds.toString(), value,routeArg["image_name"]),
                            }
                      } else {
                        setState(() {
                          isLoading = false;
                        }),

                    showAnimatedToastMessage("Error!".tr, value["msg"].toString().tr, false),
                      }
                    });

                    }, onBackTap: () {
                      Navigator.of(context).pop();
                    }),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
