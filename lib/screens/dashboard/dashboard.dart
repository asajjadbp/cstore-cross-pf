import 'dart:convert';
import 'dart:io';
import 'package:cstore/screens/dashboard/widgets/CheckInDialog.dart';
import 'package:cstore/screens/dashboard/widgets/dashboard_table_widget.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:cstore/screens/Journey%20Plan/journey_plan_screen.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/sys_osdc_type_model.dart';
import '../../Model/response_model.dart/user_dashboard_model.dart';
import '../../Network/jp_http.dart';
import '../Language/localization_controller.dart';
import '../universe/universe_screen.dart';
import '../utils/appcolor.dart';
import '../utils/services/getting_gps.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class DashBoard extends StatefulWidget {
  static const routeName = "/dashboard1";

  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String userName = "";
  String baseUrl = "";
  var token = "";
  bool isLoading = true;
  bool isCheckListLoading = true;
  bool isButtonLoading = true;
  bool isServiceLoading = false;
  int totalPlanned = 0;
  int totalJP = 0;
  int totalHours = 0;

  List<Sys_OSDCTypeModel> checkListData = [Sys_OSDCTypeModel(id: -1,
      en_name: "", ar_name: "")];
  UserDashboardModel userDashboardModel = UserDashboardModel
    (user_id: 0,
      jp_planned: 0,
      jp_visited: 0,
      out_of_planned: 0,
      out_of_planned_visited: 0,
      jpc: 0,
      pro: 0,
      working_hrs: 0,
      eff: 0,
      monthly_attend: 0,
      monthly_pro: 0,
      monthly_eff: 0,
      monthly_incentives: 0,
      monthly_deduction: 0);

  // late UserDashboardModel _userDashboardModelSetValue;
  // late List<UserDashboardModel> userDashboardList;
  bool isinit = true;
  bool isError = false;
  String errorText = "";
  String workingId = "";
  final languageController = Get.put(LocalizationController());


  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences.getString(AppConstants.userName)!;
    baseUrl = sharedPreferences.getString(AppConstants.baseUrl)!;
    token = sharedPreferences.getString(AppConstants.tokenId)!;
   // workingId = sharedPreferences.getString(AppConstants.workingId)!;

    getSqlUserDashboard();
    getCheckListData();
  }

  Future<void> getSqlUserDashboard() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper
        .getMainDashboardData(userName)
        .then((value) async {
      setState(() {
        userDashboardModel = value;
      });
      totalPlanned =
          userDashboardModel.jp_planned + userDashboardModel.out_of_planned;
      totalJP = userDashboardModel.jp_visited +
          userDashboardModel.out_of_planned_visited;
      isLoading = false;

      setState(() {});
    }).catchError((onError) {
      print(onError);
      isError = true;
      errorText = onError.toString();
      setState(() {
        isLoading = false;
      });
      ToastMessage.errorMessage(context, onError.toString());
      print("error is $onError");
    });
  }

  Future<void> getApiUserDashboard() async {
    setState(() {
      isLoading = true;
    });
    await JourneyPlanHTTP()
        .getUserDashboard(userName, token, baseUrl)
        .then((value) async {
      isError = false;
      errorText = "";
      if(value.data!.isNotEmpty) {
        // userDashboardModel = value.data![0];
        DatabaseHelper.delete_table(TableName.tblSysDashboard);
        await DatabaseHelper.insertSysDashboardArray(value.data!)
            .then((_) async {
          // ToastMessage.succesMessage(context, "Data updated successfully");
          getSqlUserDashboard();

          // isError=false;
        });
      } else {
        userDashboardModel = UserDashboardModel(
            user_id: 0,
            jp_planned: 0,
            jp_visited: 0,
            out_of_planned: 0,
            out_of_planned_visited: 0,
            jpc: 0,
            pro: 0,
            working_hrs: 0,
            eff: 0,
            monthly_attend: 0,
            monthly_pro: 0,
            monthly_eff: 0,
            monthly_incentives: 0,
            monthly_deduction: 0);
      }
      isLoading = false;
      isError = false;
      totalPlanned =
          userDashboardModel.jp_planned + userDashboardModel.out_of_planned;
      totalJP = userDashboardModel.jp_visited +
          userDashboardModel.out_of_planned_visited;
      // setState(() {
      //
      // });
      setState(() {});
    }).catchError((onError) {
      print(onError);
      isError = true;
      errorText = onError.toString();
      setState(() {
        isLoading = false;
      });
      ToastMessage.errorMessage(context, onError.toString());
      print("error is $onError");
    });
  }

  // Future<bool> getUserDashboardList() async {
  //   await DatabaseHelper.getUserDashboardList().then((value) async {
  //     userDashboardList = value.cast<UserDashboardModel>();
  //     for (int i = 0; i < userDashboardList.length; i++) {
  //       userDashboardModel = userDashboardList[i];
  //       print("user data is");
  //       print(jsonEncode(userDashboardModel));
  //     }
  //
  //   });
  //   return true;
  // }
  final RefreshController _refreshController = RefreshController(
      initialRefresh: false);

  void _onRefresh() async {
    getApiUserDashboard();
    _refreshController.refreshCompleted();
  }
  void getCheckListData() async {
    setState(() {
      isCheckListLoading = true;
    });

    await DatabaseHelper.getSysDailyCheckList().then((value) {
      setState(() {
        isCheckListLoading = false;
      });
      checkListData = value;
    });
    print("checkList data is..");
    print(checkListData[0].en_name);
  }
  void saveCheckListData(File? imageFile,String imageName,String selectedIds) async {
    if (selectedIds==null ||
        imageFile == null) {
      ToastMessage.errorMessage(context, "Please fill the form and take image");
      return;
    }
    setState(() {
      isButtonLoading = true;
    });
    try {
      await takePicture(context,imageFile,imageName,workingId,AppConstants.beforeFixing).then((_) async {
        var now = DateTime.now();
      });
      setState(() {
        isButtonLoading = false;
      });
    } catch (error) {
      setState(() {
        isButtonLoading = false;
      });
      ToastMessage.errorMessage(context, error.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget circularProgressCard(double percentValue, String cardName) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: MyColors.formFileColor, width: 1),
              borderRadius:
              const BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                const SizedBox(height: 5,),
                Text(
                  cardName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: 'lato'),
                ),
                const SizedBox(height: 3,),
                CircularPercentIndicator(
                  radius: 29.0,
                  lineWidth: 6.0,
                  animation: true,
                  percent: percentValue.toInt() >= 100 ? 1 : percentValue / 100,
                  center: Text(
                    "${percentValue.toInt()}%",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: 'lato'),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: MyColors.appMainColor,
                ),
                const SizedBox(height: 6,),
              ],
            ),
          ),
        ),
      );
    }

    Widget cardActivity(String label, String imageName,Function onTap) {
      return Expanded(
        child: InkWell(
          onTap: () {
            onTap();
            // setState(() {
            //   isServiceLoading = true;
            // });
            // LocationService.getLocation().then((value) => {
            //   if (value["locationIsPicked"]) {
            // Navigator.of(context).pushNamed(JourneyPlanScreen.routename).then((value) {
            // getApiUserDashboard();
            //
            // // setState(() {
            // //   isServiceLoading = false;
            // // });
            // //   }), } else {
            // //     setState(() {
            // //   isServiceLoading = false;
            // //   }),
            // //     showAnimatedToastMessage("Error!".tr, "Please Enable Your Location".tr, false)
            // //   }
            // });
          },
          child:  Card(
            color:  MyColors.appMainColor,
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                    color: MyColors.appMainColor, width: 1.0),
                borderRadius: BorderRadius.circular(5.0)),
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Row(children: [
                SvgPicture.asset(imageName),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  label,
                  style: const TextStyle(color: MyColors.whiteColor),
                )
              ]),
            ),
          ),
        ),
      );
    }

    Widget cardActivity2(String label, String imageName,String btnName) {
      return Expanded(
        child: InkWell(
          onTap: () async {
            if(btnName=="checkIn"){
              await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
            return CustomCheckListDialog(checkListData: checkListData,userName: userName,
            onTakeImages: (File? imageFiles, String imageName,String ids){
            saveCheckListData(imageFiles, imageName, ids);
            setState(() {
            });
            print("selected Ids is $ids");
            print("imageName is $imageName");
            print("imageFiles is $imageFiles");
            });
            },
            );
          }
          },
          child: Card(
            color: MyColors.appMainColor,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: MyColors.appMainColor, width: 1.0),
                borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    SvgPicture.asset(imageName),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        const Text(
                          "12:00 PM",
                          style:
                          TextStyle(fontSize: 10, color: MyColors.whiteColor),
                        ),
                        Text(
                          label,
                          style: const TextStyle(color: MyColors.whiteColor),
                        )
                      ],
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget linerProgressbar(String barname, double percentValue) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 10, bottom: 5),
            child: LinearPercentIndicator(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.75,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 2500,
              percent: percentValue.toInt() >= 100 ? 1 : percentValue / 100,
              center: Text(
                barname,maxLines: 1,overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: MyColors.appMainColor,
            ),
          ),
          Text("${percentValue.toInt()}%")
        ],
      );
    }

    return Scaffold(
        backgroundColor: MyColors.background,
        appBar: generalAppBar(context, "${"Good Morning".tr}, $userName", "", (){

        },  false, false, true,(int getClient, int getCat, int getSubCat, int getBrand) {

        }),
        floatingActionButton: FloatingActionButton(
            backgroundColor: MyColors.appMainColor,
            child: Text('lang'.tr),
            onPressed: () {
              // saveDbFile(context);
              languageController.changeLanguage();
              setState(() {
              });
            }),
        body: isLoading
            ? const Center(
          child: MyLoadingCircle(),
        ) : SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: IgnorePointer(
              ignoring: isServiceLoading,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          "Today".tr,
                          style: const TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'lato'),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: TableWidget(
                              jpPlanned: userDashboardModel.jp_planned,
                              specialPlanned: userDashboardModel.out_of_planned,
                              jpHours: userDashboardModel.working_hrs,
                              totalPlanned: userDashboardModel.jp_planned + userDashboardModel.out_of_planned,
                              jpFinished: userDashboardModel.jp_visited,
                              specialFinished: userDashboardModel.out_of_planned_visited,
                              totalFinished: userDashboardModel.jp_visited + userDashboardModel.out_of_planned_visited ,
                              totalHours: userDashboardModel.working_hrs),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            circularProgressCard(
                                userDashboardModel.jpc.toDouble(), "JPC".tr),
                            circularProgressCard(
                                userDashboardModel.pro.toDouble(),
                                "Productivity".tr),
                            circularProgressCard(
                                userDashboardModel.eff.toDouble(),
                                "Efficiency".tr),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                "Activity".tr,
                                style:const TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'lato'),
                              ),
                              Row(
                                children: [
                                  cardActivity("Visit Pool".tr, "assets/icons/jp_icon.svg",() {
                                    Navigator.of(context).pushNamed(JourneyPlanScreen.routename).then((value) {
                                      getApiUserDashboard();
                                    });
                                  }),
                                  cardActivity("Universe".tr, "assets/icons/universe_icon.svg",() {
                                    Navigator.of(context).pushNamed(UniverseList.routename).then((value) {
                                      getApiUserDashboard();
                                    });
                                  })
                                ],
                              ),
                              Visibility(
                                visible: false,
                                child: Row(
                                  children: [
                                    cardActivity2(
                                        "Check in".tr, "assets/icons/check_in_icon.svg","checkIn"),
                                    cardActivity2(
                                        "Check out".tr, "assets/icons/check_out_icon.svg","checkOut")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "MTD".tr,
                          style: const TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'lato'),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: MyColors.formFileColor, width: 1),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                          child: Column(
                            children: [
                              linerProgressbar(
                                  "Attendance".tr,
                                  userDashboardModel.monthly_attend
                                      .toDouble()),
                              linerProgressbar("Productivity".tr,
                                  userDashboardModel.monthly_pro.toDouble()),
                              const SizedBox(height: 5)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: MyColors.formFileColor, width: 1),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                       Text("Efficiency".tr,maxLines: 1,overflow: TextOverflow.ellipsis,
                                          style:
                                          const TextStyle(fontWeight: FontWeight.w600)),
                                      SvgPicture.asset(
                                        "assets/icons/efficiency_icon.svg",),
                                      Text("${userDashboardModel.monthly_eff
                                          .toString()} %",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 11, fontWeight: FontWeight.w600
                                        ),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 5, left: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: MyColors.formFileColor, width: 1),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                       Text("Deduction".tr,maxLines: 1,overflow: TextOverflow.ellipsis,
                                          style:
                                          const TextStyle(fontWeight: FontWeight.w600)),
                                      SvgPicture.asset(
                                          "assets/icons/deduction_icon.svg"),
                                      Text("${userDashboardModel.monthly_deduction
                                          .toString()} SAR",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: MyColors.backbtnColor
                                        ),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 5, left: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: MyColors.formFileColor, width: 1),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                       Text("Incentives".tr,maxLines: 1,overflow: TextOverflow.ellipsis,
                                          style:
                                          const  TextStyle(fontWeight: FontWeight.w600)),
                                      SvgPicture.asset(
                                          "assets/icons/incentives_icon.svg"),
                                      Text("${userDashboardModel.monthly_incentives
                                          .toString()} SAR",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 11, fontWeight: FontWeight.w600
                                        ),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  if(isServiceLoading)
                    const Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: MyLoadingCircle(),),
                    )
                ],
              ),
            ),
          ),
        ));
  }
}
