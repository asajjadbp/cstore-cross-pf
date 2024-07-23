
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
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/database_model/drop_reason_model.dart';
import '../grid_dashboard/grid_dashboard.dart';
import '../utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/app_bar_widgets.dart';

class JourneyPlanScreen extends StatefulWidget {
  static const routename = "/journeyPlanScreen";
  const JourneyPlanScreen({super.key});

  @override
  State<JourneyPlanScreen> createState() => _JourneyPlanScreenState();
}

class _JourneyPlanScreenState extends State<JourneyPlanScreen> {
  File? _pickedImage;
  var userName = "";
  var token = "";
  var baseUrl = "";
  String imageBaseUrl = "";
  bool isLoading = false;
  bool isDropLoading = false;
  bool isError = false;
  String errorText = "";
  int selectedReasonId = -1;

  // This id is taking to recognize that card and start reloading
  var dropWorkingId = "";
  List<JourneyPlanDetail> jpData = [];

  List<DropReasonModel> dropReasonList = [];

  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userName = prefs.getString(AppConstants.userName)!;
    token = prefs.getString(AppConstants.tokenId)!;

    imageBaseUrl = prefs.getString(AppConstants.imageBaseUrl)!;

    print(userName);
    print(prefs.getString(AppConstants.tokenId)!);
    print("jp screen");
    // print(urlData["data"][0]["base_url"]);
    baseUrl = prefs.getString(AppConstants.baseUrl)!;

    getDropReasons();

    callJp();
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

  Future callJp() async {
    setState(() {
      isError = false;
      isLoading = true;
    });
    // try {
    await JourneyPlanHTTP()
        .getJourneyPlan(userName, token, baseUrl)
        .then((value) {
      setState(() {
        isLoading = false;
      });

      if (value.status) {
        jpData = value.data;
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
      appBar: generalAppBar(context, userName, "Visit Pool", (){
        Navigator.of(context).pop();
      }, (){print("filter Click");}, true, false, true),
      body: isLoading
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
              callJp();
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
              child: const Text("Retry",
                style: TextStyle(color: MyColors.backbtnColor, fontSize: 20),),
            ),
          )
        ],
      )
          : jpData.isEmpty
          ? const Center(
        child: Text("No journey plan found"),
      )
          : ListView.builder(
          itemCount: jpData.length,
          itemBuilder: (ctx, i) {
            print(
                "https://storage.googleapis.com/pandaimage-bucket/visits/${jpData[i]
                    .startVisitPhoto}");
            return JourneyPlan(
              onLocationTap: () {
                launchStoreUrl(jpData[i].gcode);
              },
              imageBaseUrl: imageBaseUrl,
              jp: jpData[i],
              onStartClick: () {
                if (jpData[i].visitStatus == "1") {
                  setVisitSession(jpData[i]);
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
                        title: const Text(
                            "Are you sure you want to drop this visit?"),
                        content: ReasonDropDown(hintText: "Select Reason",
                            reasonData: dropReasonList,
                            onChange: (value) {
                              selectedReasonId = value.id;
                            }),
                        actions: [
                          TextButton(
                            child: const Text("No"),
                            onPressed: () {
                              // returnValue = true;
                              Navigator.of(context).pop(true);
                            },
                          ),
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              // returnValue = true;
                              if (selectedReasonId != -1) {
                                dropVisit(jpData[i].workingId.toString());
                                Navigator.of(context).pop();
                              } else {
                                ToastMessage.errorMessage(
                                    context, "Please Select reason");
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
                        title: const Text("Do you want to UnDrop this visit?"),
                        actions: [
                          TextButton(
                            child: const Text("No"),
                            onPressed: () {
                              // returnValue = true;
                              Navigator.of(context).pop(true);
                            },
                          ),
                          TextButton(
                            child: const Text("Yes"),
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
        AppConstants.availableExclude, journeyPlanDetail.avlExclude.toString());
    sharedPreferences.setString(
        AppConstants.otherExclude, journeyPlanDetail.otherExclude.toString());
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
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        ToastMessage.errorMessage(context, "No Image Picked");
        return;
      }
      print("working id is ");
      print(journeyPlanDetail.workingId);
      // return;
      // _pickedImage = value;
      Navigator.of(context).pushNamed(ViewJPPhoto.routename, arguments: {
        "image": value,
        "visitItem": journeyPlanDetail
      }).then((value) {
        print("JP SCREEN LOADING");
        callJp();
      });
    });
  }

  Future<void> dropVisit(String workingId) async {
    if (selectedReasonId == -1) {
      ToastMessage.errorMessage(context, "Please Select Reason first");
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
        ToastMessage.succesMessage(context, value.msg);
      } else {
        ToastMessage.errorMessage(context, value.msg);
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      ToastMessage.errorMessage(context, onError.toString());
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
        ToastMessage.succesMessage(context, value.msg);
      } else {
        ToastMessage.errorMessage(context, value.msg);
      }
    }).catchError((onError) {
      setState(() {
        isDropLoading = false;
      });
      ToastMessage.errorMessage(context, onError.toString());
    });
  }

  Future<void> launchStoreUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
