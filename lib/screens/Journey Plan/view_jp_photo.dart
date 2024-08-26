import 'dart:convert';
import 'dart:io';
import 'package:cstore/screens/grid_dashboard/grid_dashboard.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/response_model.dart/jp_response_model.dart';
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
        ToastMessage.succesMessage(context, value['msg']);

        Navigator.of(context).pushNamed(GridDashBoard.routeName).then((value) => {
          Navigator.of(context).pop(),
        });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      print(error.toString());
      ToastMessage.errorMessage(context, error.toString());
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
      File imageFile, String workingId, String clientId) async {
    setState(() {
      isLoading = true;
    });
    try {
      XFile compressedImageFile;
      XFile compressedWaterMarkImageFile;

      await LocationService.getLocation().then((value) async {
        if (value["locationIsPicked"]) {
          final credentials = ServiceAccountCredentials.fromJson(
            await rootBundle.loadString(
                'assets/google_cloud_creds/appimages-keycstoreapp-7c0f4-a6d4c3e5b590.json'),
          );

          final httpClient = await clientViaServiceAccount(
              credentials, [StorageApi.devstorageReadWriteScope]);

          // Create a Storage client with the credentials
          final storage = StorageApi(httpClient);

          // Generate a unique filename and path
          final filename =
              '${userName}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          // const bucketName =
          //     "binzagr-bucket"; // Replace with your bucket name
          final filePath = 'visits/$filename';

          //Image Compress Function call
          final dir = await getTemporaryDirectory();
          final targetPath = path.join(dir.path, filename);

          print("Bucket Name asdwa");
          print(bucketName);
          print(filePath);

          int sizeInBytes = imageFile.readAsBytesSync().lengthInBytes;
          final kb = sizeInBytes / 1024;
          final mb = kb / 1024;

          if(mb >= 6) {
            compressedImageFile = await testCompressAndGetFile(imageFile, targetPath,60);
          } else if(mb < 6 && mb > 4) {
            compressedImageFile = await testCompressAndGetFile(imageFile, targetPath,75);
          } else if(mb < 4 && mb > 2) {
            compressedImageFile = await testCompressAndGetFile(imageFile, targetPath,90);
          } else {
            compressedImageFile = await testCompressAndGetFile(imageFile, targetPath,100);
          }

          compressedWaterMarkImageFile = await addWatermark(compressedImageFile,DateTime.now().toString());
         print(mb);
          print(kb);
          print(compressedWaterMarkImageFile.path);
          print(compressedWaterMarkImageFile.name);
          File waterMarkImageFile = File(compressedWaterMarkImageFile.path);

          final fileContent = await waterMarkImageFile.readAsBytes();
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
          submitStartVist(
              workingId, filename, value['lat'], value['long'], clientId);
        } else {
          setState(() {
            isLoading = false;
          });
          ToastMessage.errorMessage(context, value["msg"]);
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle any errors that occur during the upload
      print("Upload GCS Error $e");
      ToastMessage.errorMessage(context, e.toString());
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
      ToastMessage.errorMessage(context, onError.toString());
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
                  onSaveTap: () {
                      // submitStartVist(routeArg["workingId"].toString());
                      uploadImageToCloud(
                          routeArg["image"],
                          journeyPlanDetail.workingId.toString(),
                          journeyPlanDetail.clientIds.toString());
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
