
import 'dart:io';

import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/Model/database_model/required_module_model.dart';
import 'package:cstore/Network/sql_data_http_manager.dart';
import 'package:cstore/screens/Replenishment/replenishment.dart';
import 'package:cstore/screens/availability/availablity_screen.dart';
import 'package:cstore/screens/freshness/Freshness.dart';
import 'package:cstore/screens/planogram/planogram_screen.dart';
import 'package:cstore/screens/proof_of_sale/proof_of_sale.dart';
import 'package:cstore/screens/sidco_availability/sidco_availablity_screen.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/visit_upload/visitUploadScreen.dart';
import 'package:cstore/screens/widget/app_bar_widgets.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/database_model/dashboard_model.dart';
import '../../Model/database_model/picklist_model.dart';
import '../../Model/request_model.dart/jp_request_model.dart';
import '../Language/localization_controller.dart';
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
import '../rtv_screen/rtv_list_screen.dart';
import '../share_of_shelf/add_share_of_shelf.dart';
import '../stock/stock_list_screen.dart';
import '../utils/toast/toast.dart';
import '../widget/elevated_buttons.dart';
import 'widgets/card_widget.dart';

class GridDashBoard extends StatefulWidget {
  static const routeName = "/GridDashboard";
  const GridDashBoard({super.key});

  @override
  State<GridDashBoard> createState() => _GridDashBoardState();
}

class _GridDashBoardState extends State<GridDashBoard> {
  bool isLoading = false;
  bool isinit = true;
  String storeEnName = "";
  String storeArName = "";
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
  // List<AvailabilityShowModel> availableData = <AvailabilityShowModel>[];
  // List<SaveAvailabilityData> availabilityDataList = [];
  // List<SavePickListData> availabilityPickList = [];
  // AvailabilityCountModel availabilityCountModel = AvailabilityCountModel(totalSku: 0,totalAvl: 0,totalNotAvl: 0,totalUploaded: 0,totalNotUploaded: 0,totalNotMarked: 0);
  // TmrPickListCountModel tmrPickListCountModel = TmrPickListCountModel(totalPickListItems: 0,totalPickNotUpload: 0,totalPickUpload: 0,totalPickReady: 0,totalPickNotReady: 0);
  //
  // List<TransPlanoGuideModel> planoguidData = <TransPlanoGuideModel>[];
  // List<SavePlanoguideListData> planoguideImageList = [];
  // List<TransPlanoGuideGcsImagesListModel> planoguideGcsImagesList=[];
  // PlanoguideCountModel planoguideCountModel = PlanoguideCountModel(totalPlano: 0,totalAdhere: 0,totalNotAdhere: 0,totalUploaded: 0,totalNotUploaded: 0,totalImagesUploaded: 0,totalImagesNotUploaded: 0,totalNotMarkedPlano: 0);
  //
  // List<TransBransShareModel> brandShareData = <TransBransShareModel>[];
  // List<SaveBrandShareListData> brandShareImageList = [];
  // BrandShareCountModel brandShareCountModel = BrandShareCountModel(totalBrandShare: 0,totalUpload: 0,totalNotUpload: 0,totalReadyBrands: 0,totalNotReadyBrands: 0);
  //
  // PickListCountModel pickListCountModel = PickListCountModel(totalNotUpload: 0,totalUpload: 0,totalPickListItems: 0,totalPickReady: 0,totalPickNotReady: 0);
  // List<ReadyPickListData> pickListDataForApi = [];

  bool isFinishButton = true;

  String workingId = "";
  String workingDate = "";
  String clientId = "";
  bool isUplaodStatus = false;
  String location = "";
  List<AgencyDashboardModel> allAgencyData = [];
  List<AgencyDashboardModel> agencyData = [];

  final languageController = Get.put(LocalizationController());

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
      print(visitActivity);

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
      return '"$value"';
    } else {
      return value.toString();
    }
  }

  insertDataToSql(List<PickListModel> valuePickList) async {
    String valueQuery = "";
    if (valuePickList.isNotEmpty) {
      for (int i = 0; i < valuePickList.length; i++) {
        valueQuery = '$valueQuery($workingId,${valuePickList[i]
            .picklist_id},${valuePickList[i].store_id},${valuePickList[i]
            .category_id},${valuePickList[i].tmr_id},${wrapIfString(
            valuePickList[i].tmr_name)},${valuePickList[i]
            .stocker_id},${wrapIfString(
            valuePickList[i].stocker_name)},${wrapIfString(
            valuePickList[i].shift_time)},${wrapIfString(
            valuePickList[i].en_cat_name)},${wrapIfString(
            valuePickList[i].ar_cat_name)},${wrapIfString(
            valuePickList[i].sku_picture)},${wrapIfString(
            valuePickList[i].en_sku_name)},${wrapIfString(
            valuePickList[i].ar_sku_name)},${valuePickList[i]
            .req_pickList},${valuePickList[i].act_pickList},${valuePickList[i]
            .pickList_ready},0,"",${wrapIfString(
            valuePickList[i].pick_list_receive_time)},${wrapIfString(
            valuePickList[i].pick_list_reason)}),';
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
  }

  // Future <GeneralChecksStatusController> generalControllerInitialization () async {
  //   GeneralChecksStatusController generalStatusController;
  //   generalStatusController = Get.put(GeneralChecksStatusController());
  //
  //   await generalStatusController.getAppSetting();
  //
  //   return generalStatusController;
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName, (){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Visit".tr),
              content: Text('Are you sure you want to quit this visit?'.tr),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('No'.tr),
                ),
                TextButton(
                  onPressed: ()async {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes'.tr),
                ),
              ],
            );
          },
        );
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),

      body: WillPopScope(
        onWillPop: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Visit".tr),
                content: Text('Are you sure you want to quit this visit?'.tr),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child:  Text('No'.tr),
                  ),
                  TextButton(
                    onPressed: ()async {
                      // Perform logout operation
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text('Yes'.tr),
                  ),
                ],
              );
            },
          );
          return false;
        },
        child: IgnorePointer(
          ignoring: isDataUploading,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: isLoading
                ? const SizedBox(
                    height: 60,
                    child: MyLoadingCircle(),
                  )
                : IgnorePointer(
                ignoring: isDataUploading,
                child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: GridView.builder(

                                itemCount: agencyData.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 15.0),
                                itemBuilder: (context, i) {

                                  return Container(
                                    margin: const EdgeInsets.only(left: 4, right: 4),
                                    child: CardWidget(
                                        onTap: () async {
                                          // setState(() {
                                          //   isDataUploading = true;
                                          // });
                                          // GeneralChecksStatusController generalStatusController = await generalControllerInitialization();
                                          //
                                          // if(generalStatusController.isVpnStatus.value) {
                                          //   setState(() {
                                          //     isDataUploading = false;
                                          //   });
                                          //   showAnimatedToastMessage("Error!".tr,"Please Disable Your VPN".tr, false);
                                          // } else if(generalStatusController.isMockLocation.value) {
                                          //   setState(() {
                                          //     isDataUploading = false;
                                          //   });
                                          //   showAnimatedToastMessage("Error!".tr, "Please Disable Your Fake Locator".tr, false);
                                          // } else if(!generalStatusController.isAutoTimeStatus.value) {
                                          //   setState(() {
                                          //     isDataUploading = false;
                                          //   });
                                          //   showAnimatedToastMessage("Error!".tr, "Please Enable Your Auto time Option From Setting".tr, false);
                                          // } else if(!generalStatusController.isLocationStatus.value) {
                                          //   setState(() {
                                          //     isDataUploading = false;
                                          //   });
                                          //   showAnimatedToastMessage("Error!".tr, "Please Enable Your Location".tr, false);
                                          // } else {
                                          //   setState(() {
                                          //     isDataUploading = false;
                                          //   });
                                          //   Get.delete<GeneralChecksStatusController>();

                                            print(agencyData[i].en_name);
                                            if (agencyData[i].id == 1) {
                                              Navigator.of(context).pushNamed(
                                                  BeforeFixing.routeName);
                                            } else if (agencyData[i].id == 5) {
                                              Navigator.of(context).pushNamed(
                                                  PlanogramScreen.routeName);
                                            } else if (agencyData[i].id == 10) {
                                              Navigator.of(context).pushNamed(
                                                  ViewKnowledgeShare.routename);
                                            } else if (agencyData[i].id == 3) {
                                              var now = DateTime.now();
                                              await DatabaseHelper
                                                  .insertTransAvailability(
                                                  workingId, clientId,
                                                  now.toString()).then((value) {
                                                Navigator.of(context).pushNamed(
                                                    Availability.routename);
                                              }).catchError((e) {
                                                print(e.toString());
                                                ToastMessage.errorMessage(
                                                    context, e.toString());
                                                setState(() {});
                                              });
                                            }
                                            else if (agencyData[i].id == 11) {
                                              Navigator.of(context).pushNamed(
                                                  AddOtherPhoto.routeName);
                                            } else if (agencyData[i].id == 2) {
                                              Navigator.of(context).pushNamed(
                                                  Rtv_List_Screen.routeName);
                                            } else if (agencyData[i].id == 6) {
                                              Navigator.of(context).pushNamed(
                                                  ShareOfShelf.routeName);
                                            }
                                            else if (agencyData[i].id == 12) {
                                              Navigator.of(context).pushNamed(
                                                  AddOSDC.routeName);
                                            }
                                            else if (agencyData[i].id == 9) {
                                              Navigator.of(context).pushNamed(
                                                  StockListScreen.routeName);
                                            }
                                            else if (agencyData[i].id == 7) {
                                              Navigator.of(context).pushNamed(
                                                  PriceCheck_Screen.routeName);
                                            } else if (agencyData[i].id == 21) {
                                              Navigator.of(context).pushNamed(
                                                  ReplenishmentScreen.routeName);
                                            } else if (agencyData[i].id == 15) {
                                              //Navigator.of(context).pushNamed(Planoguides_Screen.routename);
                                              await DatabaseHelper
                                                  .insertTransPlanoguide(
                                                  workingId).then((value) {
                                                Navigator.of(context).pushNamed(
                                                    Planoguides_Screen.routename);
                                              }).catchError((e) {
                                                print(e.toString());
                                                ToastMessage.errorMessage(
                                                    context, e.toString());
                                                setState(() {});
                                              });
                                            } else if (agencyData[i].id == 16) {
                                              await DatabaseHelper
                                                  .insertTransBrandShares(
                                                  workingId).then((value) {
                                                Navigator.of(context).pushNamed(
                                                    BrandShares_Screen.routename);
                                              }).catchError((e) {
                                                print(e.toString());
                                                ToastMessage.errorMessage(
                                                    context, e.toString());
                                                setState(() {});
                                              });
                                            } else if (agencyData[i].id == 4) {
                                              Navigator.of(context).pushNamed(
                                                  PickListScreen.routename);
                                            } else if (agencyData[i].id == 13) {
                                              await DatabaseHelper
                                                  .insertTransPromoPlan(
                                                  workingId,clientId ,int.parse(storeId))
                                                  .then((value) {
                                                Navigator.of(context).pushNamed(
                                                    PromoPlan_scrren.routeName);
                                              }).catchError((e) {
                                                print(e.toString());
                                                ToastMessage.errorMessage(
                                                    context, e.toString());
                                                setState(() {});
                                              });
                                            } else if (agencyData[i].id == 8) {
                                              Navigator.of(context).pushNamed(
                                                  Freshness_Screen.routeName);
                                            } else if (agencyData[i].id == 14) {
                                              Navigator.of(context).pushNamed(
                                                  AddRtvOnePlusOne.routeName);
                                            } else if (agencyData[i].id == 19) {
                                              Navigator.of(context).pushNamed(
                                                  ProofOfSale.routeName);
                                            } else if (agencyData[i].id == 18) {
                                              Navigator.of(context).pushNamed(
                                                  AddMarketIssue.routeName);
                                            } else if (agencyData[i].id == 17) {
                                              print(workingId);
                                              print(clientId);
                                              var now = DateTime.now();

                                              await DatabaseHelper
                                                  .insertTransAvailability(
                                                  workingId, clientId,
                                                  now.toString()).then((value) {
                                                Navigator.of(context).pushNamed(
                                                    SidcoAvailability.routename);
                                              }).catchError((e) {
                                                print(e.toString());
                                                ToastMessage.errorMessage(
                                                    context, e.toString());
                                                setState(() {});
                                              });
                                            }
                                          // }
                                          // Navigator.of(context).pushNamed(BeforeFixing.routeName);
                                        },
                                        imageUrl: agencyData[i].id.toString(),
                                        // "assets/images/camera.png",
                                        cardName: languageController.isEnglish.value ? agencyData[i].en_name : agencyData[i].ar_name),
                                  );
                                }),
                          ),

                          Container(
                            margin:const EdgeInsets.symmetric(vertical: 5),
                            child: BigElevatedButton(
                                buttonName: "View Visit Summary".tr,
                                submit: (){
                                  Navigator.of(context).pushNamed(VisitUploadScreen.routeName);
                                },
                                isBlueColor: true),
                          )
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: const Color.fromRGBO(0, 77, 145, 1),
                          //     minimumSize: Size(MediaQuery.of(context).size.width/1.1, 45),
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10)),
                          //   ),
                          //   onPressed: () async {
                          //     // setState(() {
                          //     //   isUplaodStatus = true;
                          //     // });
                          //     // getTransData(AppConstants.availability,true);
                          //     // getAllModuleData();
                          //
                          //
                          //
                          //   },
                          //   child: const Text(
                          //     ,style: TextStyle(color: MyColors.whiteColor),
                          //   ),
                          // )
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
        ),
      ),
    );
  }
}
