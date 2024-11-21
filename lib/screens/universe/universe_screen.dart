import 'dart:convert';

import 'package:cstore/Network/jp_http.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/sys_store_model.dart';
import '../../Model/request_model.dart/assign_special_vsit.dart';
import '../../Network/sql_data_http_manager.dart';
import '../Journey Plan/journey_plan.dart';
import '../Journey Plan/journey_plan_screen.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';
import '../widget/search_text_field.dart';

class UniverseList extends StatefulWidget {
  static const routename = "/universeScreen";
  const UniverseList({super.key});

  @override
  State<UniverseList> createState() => _UniverseListState();
}

class _UniverseListState extends State<UniverseList> {

  final languageController = Get.put(LocalizationController());

  var userName = "";
  String token = "";
  String baseUrl = "";
  String imageBaseUrl = "";
  String bucketName = "";
  bool isLoading = false;
  bool isAssigning = false;
  List<SysStoreModel> universeStoresList = <SysStoreModel>[];
  List<ClientModel> clientList = <ClientModel>[];
  List<int> selectedClientList = <int>[];
  int visitTypeId = 1;

  final TextEditingController searchController = TextEditingController();
  String searchText = "";

  final RefreshController _refreshController = RefreshController(
      initialRefresh: false);

  void initState() {
    getUserData();
    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (searchController.text.isNotEmpty) {
      setState(() {
        searchText = searchController.text;

        getUniverseDataFromSqlDb();

        print("Searching for: $searchText");
      });
    }
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

    getUniverseDataFromSqlDb();

    getClientsListFromDb();
  }

  void _onRefresh() async {
    // await Future.delayed(const Duration(milliseconds: 1000));
    // DatabaseHelper.delete_table(TableName.tbl_user_dashboard);
    getUniverseDataFromSqlDb();
    _refreshController.refreshCompleted();
  }

  getUniverseDataFromSqlDb () async {
    setState(() {
      isLoading = true;
    });

    await DatabaseHelper.getUniverseStoreData(searchText).then((value) {
      universeStoresList = value;
      setState(() {
        isLoading = false;
      });
    });

  }

  getClientsListFromDb() async {
    setState(() {
      isLoading = true;
    });

    await DatabaseHelper.getAllClients().then((value) {
      clientList = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: generalAppBar(context, userName, "Universe".tr, (){
        Navigator.of(context).pop();
      }, true, false, true,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: SearchTextField(searchController: searchController,hintText: "Search with store name..",)),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: false,
                onRefresh: _onRefresh,
                child: isLoading
                    ? const Center(
                  child: MyLoadingCircle(),
                ) : universeStoresList.isEmpty ?  Center(
                  child: Text("No journey plan found".tr),
                ) : ListView.builder(
                    itemCount: universeStoresList.length,
                    itemBuilder: (ctx, i) {
                      // print(
                      //     "https://storage.googleapis.com/$bucketName/visits/${jpData[i]
                      //         .startVisitPhoto}");
                      return UniverseStore(
                          languageController: languageController,
                          storeModel:universeStoresList[i],isCheckLoading: false, onStartClick: (){

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (BuildContext context1,
                                StateSetter menuState) {
                              return AlertDialog(
                                title: Text('Assign visit'.tr),
                                content: SizedBox(
                                  height: MediaQuery.of(context).size.height/2.8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              visitTypeId = 1;
                                              setState(() {

                                              });
                                              menuState(() {

                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(visitTypeId == 1 ? Icons.radio_button_checked : Icons.circle_outlined,color: MyColors.appMainColor,),
                                               const SizedBox(width: 5,),
                                                Text("Normal".tr),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              visitTypeId = 2;
                                              setState(() {

                                              });
                                              menuState(() {

                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(visitTypeId == 2 ? Icons.radio_button_checked :Icons.circle_outlined,color: MyColors.appMainColor,),
                                                const SizedBox(width: 5,),
                                                Text("check In".tr),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          margin:const EdgeInsets.symmetric(vertical: 5),
                                          child: Text('Select Clients'.tr)),
                                      Expanded(
                                        child: ListView.builder(
                                            itemCount: clientList.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context,index1) {
                                              return InkWell(
                                                onTap: (){
                                                  if(selectedClientList.contains(clientList[index1].client_id)) {

                                                    selectedClientList.remove(clientList[index1].client_id);

                                                  } else {
                                                    selectedClientList.add(clientList[index1].client_id);
                                                  }

                                                  print(selectedClientList);
                                                  print(selectedClientList.contains(clientList[index1].client_id));
                                                  setState(() {

                                                  });
                                                  menuState(() {

                                                  });

                                                },
                                                child: Card(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          margin:const EdgeInsets.all(5),
                                                          child: Icon(selectedClientList.contains(clientList[index1].client_id) ? Icons.check_box : Icons.check_box_outline_blank,color: MyColors.appMainColor,)),
                                                      Expanded(child: Text(clientList[index1].client_name))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  isAssigning ? const Center(
                                    child: CircularProgressIndicator(),
                                  ) : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: MyColors.buttonBackgroundColor
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child:  const Icon(Icons.close,color: MyColors.backbtnColor,size: 30,),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: MyColors.buttonBackgroundColor
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            // Perform logout operation
                                            assignSpecialVisit(universeStoresList[i].id,menuState);
                                          },
                                          child: const Icon(Icons.check,color: MyColors.greenColor,size: 30,),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            });
                          },
                        );

                      },  onLocationTap: (){
                        launchStoreUrl(universeStoresList[i].gcode);
                      });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  assignSpecialVisit(int storeId,StateSetter menuState) {

    if(selectedClientList.isEmpty) {
      showAnimatedToastMessage("Error!".tr, "Please Select Any Client first".tr, false);
      return;
    }

   String selectedClients = selectedClientList.join(',');

    menuState(() {
      isAssigning = true;
    });

    AssignSpecialVisitRequest assignSpecialVisitRequest = AssignSpecialVisitRequest(
      username: userName,
      clientIds: selectedClients,
      storeId: storeId.toString(),
      visitActivityType: visitTypeId.toString(),
    );


    print(token);
    print(jsonEncode(assignSpecialVisitRequest));

    SqlHttpManager().assignUniverseStores(token,baseUrl,assignSpecialVisitRequest).then((value) => {

      menuState(() {
        isAssigning = true;
      }),

      callJp(menuState),

    }).catchError((e) =>{
      print(e.toString()),
      showAnimatedToastMessage("Error!".tr,e.toString(),false),
      menuState((){
        isAssigning = false;
      }),
    });
  }

  Future callJp(StateSetter menuState) async {
    // try {
    await JourneyPlanHTTP()
        .getJourneyPlan(userName, token, baseUrl)
        .then((value) async {

      if (value.status) {
        DatabaseHelper.delete_table(TableName.tblSysJourneyPlan);

        await DatabaseHelper.insertSysJourneyPlanArray(value.data);

        showAnimatedToastMessage("Success".tr, "Visit Assigned Successfully".tr, true);

        Navigator.of(context).pop();

      Navigator.of(context).popAndPushNamed(JourneyPlanScreen.routename);

        menuState(() {
          isAssigning = false;
        });

      }
    }).catchError((onError) {
      print(onError.toString());
      showAnimatedToastMessage("Error!".tr,onError.toString().tr, false);

      menuState(() {
        isAssigning = false;
      });
    });
    // } catch (error) {

    // }
  }


  Future<void> launchStoreUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
