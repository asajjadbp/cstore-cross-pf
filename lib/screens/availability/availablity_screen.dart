import 'dart:convert';

import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/Model/request_model.dart/get_tmr_pick_list_request.dart';
import 'package:cstore/screens/Language/localization_controller.dart';
import 'package:cstore/screens/availability/widgets/availability_card_item.dart';
import 'package:cstore/screens/availability/widgets/custom_dialogue.dart';
import 'package:cstore/screens/availability/widgets/pick_list_card_item.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/database_model/availability_show_model.dart';
import '../../Model/database_model/avl_product_placement_model.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/sys_brand_model.dart';
import '../../Model/database_model/total_count_response_model.dart';
import '../../Model/request_model.dart/availability_api_request_model.dart';
import '../../Model/response_model.dart/adherence_response_model.dart';
import '../../Model/response_model.dart/tmr_pick_list_response_model.dart';
import '../../Network/sql_data_http_manager.dart';
import '../ImageScreen/image_screen.dart';
import '../important_service/genral_checks_status.dart';
import '../utils/app_constants.dart';
import '../utils/services/general_checks_controller_call_function.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import 'package:badges/badges.dart' as badges;
import '../widget/percent_indicator.dart';
import 'package:intl/intl.dart';

class Availability extends StatefulWidget {
  static const routename = "view_availability_route";
  const Availability({super.key});

  @override
  State<Availability> createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {

  final languageController = Get.put(LocalizationController());

  String workingId = "";
  String storeEnName = "";
  String storeArName = "";
  String userName = "";
  String workingDate = "";
  String storeId = "";
  String clientId = "";
  String imageBaseUrl = "";

  String token = "";
  String baseUrl = "";

  int selectedIndex = 0;
  bool isLoading = true;
  bool isCountLoading = true;
  bool isUpdateLoading = false;
  bool isDataUploading = false;
  bool isEdit = false;
  bool isFilter = false;
  bool isSearchFilter = false;

  bool isError = false;
  String errorText = "";

  bool isAll = true;
  bool isAvl = false;
  bool isNotAvl = false;
  bool isNotMarked = false;


  String currentSelectedValue = "Requested";
  final dropTypes = ['All', 'Available', 'Not Available', 'Not Marked'];

  TextEditingController textEditingController = TextEditingController();

  List<TextEditingController> controllerList = <TextEditingController>[];

  List<AvailabilityShowModel> availableData = <AvailabilityShowModel>[];

  List<AvailabilityShowModel> filteredList = <AvailabilityShowModel>[];

  List<AvailabilityShowModel> updatedAvailableData = <AvailabilityShowModel>[];
  AvailableCountModel availableCountModel = AvailableCountModel(totalAvl: 0, totalNotAvl: 0,totalProducts: 0);
  List<AvailabilityShowModel> updatedFilterAvailableData = <AvailabilityShowModel>[];
  bool isUpdateSearchFilter = false;

  final GlobalKey<FormFieldState> clientKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> subCategoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> brandKey = GlobalKey<FormFieldState>();

  bool isCategoryLoading = false;
  bool isSubCategoryLoading = false;
  bool isBrandLoading = false;

  TmrPickListCountModel tmrPickListCountModel = TmrPickListCountModel(totalPickListItems: 0,totalPickNotUpload: 0,totalPickUpload: 0,totalPickReady: 0,totalPickNotReady: 0);

  List<ClientModel> clientData = [];
  List<CategoryModel> categoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  List<CategoryModel> subCategoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  List<SYS_BrandModel> brandData = [SYS_BrandModel( client: -1, id: -1, en_name: '', ar_name: '')];

  late ClientModel initialClientItem;
  late CategoryModel initialCategoryItem;
  late CategoryModel initialSubCategoryItem;
  late SYS_BrandModel initialBrandItem;
  late AvlProductPlacementModel avlProductPlacementModel;

  int selectedClientId = -1;
  int selectedCategoryId = -1;
  int selectedSubCategoryId = -1;
  int selectedBrandId = -1;

  int avlCount = 0;
  int notAvlCount = 0;
  int notMarkedCount = 0;

  int requestsItems = 0;
  int doneItems = 0;
  int pendingItems = 0;

  changeIndex(value) {
    selectedIndex = value;
    if(selectedIndex == 1) {
      getTmrPickListApi();
    } else {
      getAvailableData();
      getAvailableCount();
    }
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    textEditingController.text = "0";
    setState(() {

    });
    getUserData();

  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    userName = sharedPreferences.getString(AppConstants.userName)!;
    workingDate = sharedPreferences.getString(AppConstants.workingDate)!;
    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    storeId = sharedPreferences.getString(AppConstants.storeId)!;
    imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;
    token = sharedPreferences.getString(AppConstants.tokenId)!;
    baseUrl = sharedPreferences.getString(AppConstants.baseUrl)!;

    getStoreDetails();
  }

  void getClientData() async {

    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getVisitClientList(clientId).then((value) {
      setState(() {
        isLoading = false;
      });
      clientData = value;
      clientData.insert(0,ClientModel(client_id: -1, client_name: "Select Client"));
      categoryData.insert(0, CategoryModel(en_name: "Select Category",ar_name: "Select Category",id: -1, client: -1));
      subCategoryData.insert(0, CategoryModel(en_name: "Select Sub Category",ar_name: "Select Sub Category",id: -1, client: -1));
      brandData.insert(0, SYS_BrandModel(en_name: "Select Brand",ar_name: "Select Brand",id: -1, client: -1));

      initialClientItem = clientData[0];
      initialCategoryItem = categoryData[0];
      initialSubCategoryItem = subCategoryData[0];
      initialBrandItem = brandData[0];

    });
    print(clientData[0].client_name);
  }

  void getCategoryData(int clientId,StateSetter menuState) async {
    categoryKey.currentState!.reset();
    selectedCategoryId = -1;
    menuState(() {
      isCategoryLoading = true;
    });

    await DatabaseHelper.getCategoryList(selectedClientId).then((value) {

      categoryData = value;
      categoryData.insert(0, CategoryModel(en_name: "Select Category",ar_name: "Select Category",id: -1, client: -1));

      initialCategoryItem = categoryData[0];
      menuState(() {
        isCategoryLoading = false;
      });
    });
    print(categoryData[0].en_name);
  }

  void getSubCategoryData(int clientId,StateSetter menuState) async {
    subCategoryKey.currentState!.reset();
    selectedSubCategoryId = -1;
    menuState(() {
      isSubCategoryLoading = true;
    });

    await DatabaseHelper.getSubCategoryList(selectedClientId,selectedCategoryId.toString()).then((value) {

      subCategoryData = value;
      subCategoryData.insert(0, CategoryModel(en_name: "Select Sub Category",ar_name: "Select Sub Category",id: -1, client: -1));

      initialSubCategoryItem = subCategoryData[0];
      // print(jsonEncode(subCategoryData));
      menuState(() {
        isSubCategoryLoading = false;
      });
    });
    
  }

  void getBrandData(int clientId,StateSetter menuState) async {
    brandKey.currentState!.reset();
    selectedBrandId = -1;
    menuState(() {
      isBrandLoading = true;
    });

    await DatabaseHelper.getBrandList(selectedClientId,selectedCategoryId.toString()).then((value) {
      brandData = value;

      brandData.insert(0, SYS_BrandModel(en_name: "Select Brand",ar_name: "Select Brand",id: -1, client: -1));

      initialBrandItem = brandData[0];
      menuState(() {
        isBrandLoading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllerList.forEach((element) {element.dispose();});
    super.dispose();
  }
  getStoreDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    storeEnName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
    clientId = sharedPreferences.getString(AppConstants.clientId)!;

    getAvailableData();
    getClientData();
    getAvailableCount();
    // getPickListData();
  }

  getTmrPickListApi() {
    setState(() {
      isLoading = true;
      isError = false;
    });
    SqlHttpManager().getTmrPickList(token, baseUrl, TmrPickListRequestModel(username: userName, workingId: workingId)).then((value) => {
      updatePickListDataInSql(value.data!),

    }).catchError((e)=> {
      setState(() {
        isError = true;
        errorText = e.toString();
        isLoading = false;
      }),
        print(e.toString())
    });
  }

  updatePickListDataInSql(List<TmrPickList> valueList) async {
    try {
      for (int i = 0; i < valueList.length; i++) {
        await DatabaseHelper.updateTransAVLAPicklist(
            valueList[i].skuId!, valueList[i].actPicklist!, 1,
            valueList[i].workingId!, valueList[i].pickerName!,
            valueList[i].pickListReadyTime!).then((value) {});
      }
      getPickListData();
    } catch (e) {
      print("SQL ERRor");
      print(e.toString());
    }

  }

  getAvailableCount()async {
    setState(() {
      isCountLoading = false;
    });
    await DatabaseHelper.getAvailableCountData(workingId).then((value) {
      print(jsonEncode(value));
      availableCountModel = value;
      print("TOTAL PRODUCTS");
      print(availableCountModel.totalProducts);
      setState(() {
        isCountLoading = false;
      });
    });
  }

  getAvailableData() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getAvlDataList(workingId,selectedClientId.toString(),selectedBrandId.toString(),selectedCategoryId.toString(),selectedSubCategoryId.toString()).then((value) {
      availableData = value;

      avlCount = availableData.where((element) => element.avl_status == 1).toList().length;
      notAvlCount = availableData.where((element) => element.avl_status == 0).toList().length;
      notMarkedCount = availableData.where((element) => element.activity_status == 0).toList().length;

      print(jsonEncode(availableData.where((element) => element.pro_id == 6357).toList()));
      print("________ AVL DATA _________");
      setState(() {
        isLoading = false;
      });
    });
  }

  getPickListData() async {
    try {
      await DatabaseHelper.getUpdateAvlDataList(workingId).then((value) async {
        print(jsonEncode(value));

        updatedAvailableData = value;

        requestsItems = updatedAvailableData.length;
        doneItems = updatedAvailableData
            .where((element) => element.picklist_ready == 1)
            .toList()
            .length;
        pendingItems = updatedAvailableData
            .where((element) => element.picklist_ready == 0)
            .toList()
            .length;

        await getTmrPickListCount();

        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      print("SQL ERRor11");
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> getTmrPickListCount() async {
    await DatabaseHelper.getTmrPickListCountData(workingId).then((value) {
      tmrPickListCountModel = value;

      setState((){});
    });

    return true;
  }

  updatePickListAfterSave(int index,bool isNotAvl,String requiredPickList,String skuId) async {
    try {
      if (requiredPickList != "0") {
        await DatabaseHelper.updateSavePickList(
            workingId, requiredPickList, skuId).then((value) {
          ToastMessage.succesMessage(context, "Data Saved Successfully".tr);
          Navigator.of(context).pop();

          if (isNotAvl) {
            if (isFilter) {
              filteredList[index].avl_status = 0;
              filteredList[index].activity_status = 1;
              int ind = availableData.indexWhere(
                      (element) =>
                  element.pro_id == filteredList[index].pro_id);
              availableData[ind].avl_status = 0;
              availableData[ind].activity_status = 1;
              updateAvailableItem(false, filteredList[index].pro_id,
                  filteredList[index].avl_status);
              isEdit = true;
            } else {
              availableData[index].avl_status = 0;
              availableData[index].activity_status = 1;
              updateAvailableItem(false, availableData[index].pro_id,
                  availableData[index].avl_status);
              isEdit = true;
            }
          }

          setState(() {

          });
        });
      } else {
        ToastMessage.errorMessage(context, "Please enter a valid number".tr);
      }
    } catch (e) {
      showAnimatedToastMessage("Error!".tr, e.toString(), false);
    }
  }

  updateAvailableItem(bool isMessage,int skuId,int avlStatus) async {
    setState(() {
      isUpdateLoading = true;
    });
    await DatabaseHelper.updateTransAVL(avlStatus,workingId,skuId.toString()).then((value) {

      // getAvailableCount();
      avlCount = availableData.where((element) => element.avl_status == 1).toList().length;
      notAvlCount = availableData.where((element) => element.avl_status == 0).toList().length;
       notMarkedCount = availableData.where((element) => element.activity_status == 0).toList().length;

      if(isMessage) {
        ToastMessage.succesMessage(context, "Data Saved Successfully".tr);
      }
          setState(() {
            isUpdateLoading = false;
          });
    }).catchError((e){
      print(e.toString());
      ToastMessage.errorMessage(context, e.toString());
      setState(() {
        isUpdateLoading = false;
      });
    });
  }

  searchFilteredList() {
    isFilter = true;
    if(currentSelectedValue == "Available") {

      filteredList = availableData.where((element) => element.avl_status == 1).toList();

    } else if(currentSelectedValue == "Not Available") {

      filteredList = availableData.where((element) => element.avl_status == 0).toList();

    } else if(currentSelectedValue == 'Not Marked') {

      filteredList = availableData.where((element) => element.activity_status == 0).toList();

    } else {
      isFilter = false;
    }

    setState(() {

    });
  }

  searchUpdatedFilteredList() {
    isUpdateSearchFilter = true;
    if(currentSelectedValue == "Requested") {

      updatedFilterAvailableData = updatedAvailableData;

    } else if(currentSelectedValue == "Ready") {

      updatedFilterAvailableData = updatedAvailableData.where((element) => element.picklist_ready == 1).toList();

    } else if(currentSelectedValue == 'Pending') {

      updatedFilterAvailableData = updatedAvailableData.where((element) => element.picklist_ready == 0).toList();

    } else {
      isUpdateSearchFilter = false;
    }

    setState(() {

    });
  }

  getDetailsDialogue(AvailabilityShowModel availabilityShowModel) async {
    await DatabaseHelper.getAvlProductPlacement(availabilityShowModel.pro_id.toString(),storeId).then((value) {
      avlProductPlacementModel = value[0];
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDetailsDialogue(
              pogOnTap: (){
                print("${imageBaseUrl}pog/${avlProductPlacementModel.pog}.pdf");
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PdfScreen( type: "PDF", pdfUrl: "${imageBaseUrl}pog/${avlProductPlacementModel.pog}.pdf")));
              },
              title:languageController.isEnglish.value ? availabilityShowModel.pro_en_name : availabilityShowModel.pro_ar_name,
              shelfNo: avlProductPlacementModel.shelfNo,
              bayNo: avlProductPlacementModel.buyNo,
              hFacings: avlProductPlacementModel.h_facing,
              vFacings: avlProductPlacementModel.v_facing,
              dFacings: avlProductPlacementModel.d_facing,
              pog: avlProductPlacementModel.pog,
            );
          }
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName , (){
        Navigator.of(context).pop();
      }, true, selectedIndex == 0, false,(int getClient, int getCat, int getSubCat, int getBrand) {
        setState(() {
          currentSelectedValue = "All";
          isAll = true;
          isAvl = false;
          isNotAvl = false;
          isNotMarked = false;

          searchFilteredList();
        });

        selectedClientId = getClient;
        selectedCategoryId = getCat;
        selectedSubCategoryId = getSubCat;
        selectedBrandId = getBrand;

        getAvailableData();

        setState(() {

        });
        Navigator.of(context).pop();
      }),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => changeIndex(index),
        selectedItemColor: MyColors.appMainColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: selectedIndex == 0 ? Image.asset("assets/icons/home_icon_blue.png") : Image.asset("assets/icons/home_icon_grey.png"), label: "Home".tr),
          BottomNavigationBarItem(
              icon: selectedIndex == 1 ? Image.asset("assets/icons/pick_list_icon_blue.png") : Image.asset("assets/icons/pick_list_icon_grey.png"),  label: "Pick List".tr),
        ],
      ),
      body: Container(
        margin:const EdgeInsets.symmetric(horizontal: 10),
        child: isLoading || isCountLoading ? const MyLoadingCircle() : Column(
          children: [
            if(selectedIndex == 0)
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child:  InkWell(
                            onTap: (){
                              setState(() {
                                currentSelectedValue = "All";
                                isAll = true;
                                isAvl = false;
                                isNotAvl = false;
                                isNotMarked = false;
                              });
                              searchFilteredList();
                            },
                            child: Card(
                              // color: isAll ? MyColors.appMainColorButton : MyColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: badges.Badge(
                                position: badges.BadgePosition.topEnd(top: -5, end: -5),
                                showBadge: true,
                                ignorePointer: false,
                                badgeContent: Text(" ${availableData.length} ",style: const TextStyle(color:MyColors.whiteColor),),
                                badgeStyle:  const badges.BadgeStyle(
                                  badgeColor: MyColors.appMainColor,
                                  padding: EdgeInsets.all(8),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding:const EdgeInsets.symmetric(vertical: 20),
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 10,),
                                          isAll ? const Icon(Icons.check_circle_rounded,color: MyColors.appMainColor,) : const Icon(Icons.circle_outlined,color: MyColors.appMainColor,),
                                          const SizedBox(width: 10,),
                                           Text("Total".tr,style:const TextStyle(color: MyColors.appMainColor,fontSize: 16),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                      Expanded(
                          child:  InkWell(
                            onTap: (){
                              setState(() {
                                currentSelectedValue = 'Not Marked';
                                isAll = false;
                                isAvl = false;
                                isNotAvl = false;
                                isNotMarked = true;
                              });
                              searchFilteredList();
                            },
                            child: Card(
                              // color: isAll ? MyColors.appMainColorButton : MyColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: badges.Badge(
                                position: badges.BadgePosition.topEnd(top: -5, end: -5),
                                showBadge: true,
                                ignorePointer: false,
                                badgeContent: Text(" $notMarkedCount ",style: const TextStyle(color:MyColors.whiteColor),),
                                badgeStyle:  const badges.BadgeStyle(
                                    badgeColor: MyColors.darkGreyColor,
                                  padding: EdgeInsets.all(8),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding:const EdgeInsets.symmetric(vertical: 20),
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 10,),
                                          isNotMarked ? const Icon(Icons.check_circle_rounded,color: MyColors.appMainColor,) : const Icon(Icons.circle_outlined,color: MyColors.appMainColor,),
                                          const SizedBox(width: 10,),
                                           Text("Not Marked".tr,style:const TextStyle(color: MyColors.appMainColor,fontSize: 16),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),
                  ],),
                  const SizedBox(height: 5,),
                  Row(
                    children: [

                      Expanded(
                          child:  InkWell(
                            onTap: (){
                              setState(() {
                                currentSelectedValue = "Available";
                                isAll = false;
                                isAvl = true;
                                isNotAvl = false;
                                isNotMarked = false;
                              });
                              searchFilteredList();
                            },
                            child: Card(
                              // color: isAll ? MyColors.appMainColorButton : MyColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: badges.Badge(
                                position: badges.BadgePosition.topEnd(top: -5, end: -5),
                                showBadge: true,
                                ignorePointer: false,
                                badgeContent: Text(" $avlCount ",style: const TextStyle(color:MyColors.whiteColor),),
                                badgeStyle:  const badges.BadgeStyle(
                                    badgeColor: MyColors.greenColor,
                                  padding: EdgeInsets.all(8),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding:const EdgeInsets.symmetric(vertical: 20),
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 10,),
                                          isAvl ? const Icon(Icons.check_circle_rounded,color: MyColors.appMainColor,) : const Icon(Icons.circle_outlined,color: MyColors.appMainColor,),
                                          const SizedBox(width: 10,),
                                           Text("Available".tr,style:const TextStyle(color: MyColors.appMainColor,fontSize: 16),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),

                      Expanded(
                          child:  InkWell(
                            onTap: (){
                              setState(() {
                                currentSelectedValue = "Not Available";
                                isAll = false;
                                isAvl = false;
                                isNotAvl = true;
                                isNotMarked = false;
                              });
                              searchFilteredList();
                            },
                            child: Card(
                              // color: isAll ? MyColors.appMainColorButton : MyColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: badges.Badge(
                                position: badges.BadgePosition.topEnd(top: -5, end: -5),
                                showBadge: true,
                                ignorePointer: false,
                                badgeContent: Text(" $notAvlCount ",style: const TextStyle(color:MyColors.whiteColor),),
                                badgeStyle:  const badges.BadgeStyle(
                                    badgeColor: MyColors.backbtnColor,
                                  padding: EdgeInsets.all(8),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding:const EdgeInsets.symmetric(vertical: 20),
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 10,),
                                          isNotAvl ? const Icon(Icons.check_circle_rounded,color: MyColors.appMainColor,) : const Icon(Icons.circle_outlined,color: MyColors.appMainColor,),
                                          const SizedBox(width: 10,),
                                           Text("Not Available".tr,style:const TextStyle(color: MyColors.appMainColor,fontSize: 16),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                      ),

                    ],
                  ),
                  Expanded(
                      child:availableData.isEmpty ?  Center(
                        child: Text("No Data Found".tr),
                      ) : isFilter ?  ListView.builder(
                          itemCount: filteredList.length,
                          shrinkWrap: true,
                          itemBuilder: (context,index) {
                            return AvailabilityItem(
                                onImageTap: (){
                                  getDetailsDialogue(filteredList[index]);
                                },
                                imageName: "${imageBaseUrl}sku_pictures/${filteredList[index].image}",
                                isAvailable: filteredList[index].avl_status,
                                brandName: languageController.isEnglish.value ? filteredList[index].pro_en_name : filteredList[index].pro_ar_name,
                                categoryName: languageController.isEnglish.value ? filteredList[index].cat_en_name : filteredList[index].cat_ar_name,
                                pickListText: filteredList[index].requried_picklist.toString(),
                                onTapPickList: () async {
                                  GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

                                  if(generalStatusController.isVpnStatus.value) {
                                    showAnimatedToastMessage("Error!".tr,"Please Disable Your VPN".tr, false);
                                  } else if(generalStatusController.isMockLocation.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Disable Your Fake Locator".tr, false);
                                  } else if(!generalStatusController.isAutoTimeStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Auto time Option From Setting".tr, false);
                                  } else if(!generalStatusController.isLocationStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Location".tr, false);
                                  } else {
                                    Get.delete<GeneralChecksStatusController>();

                                    if (filteredList[index].avl_status != -1) {
                                      textEditingController.text =
                                          filteredList[index].requried_picklist
                                              .toString();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialog(
                                              isButtonActive: true,
                                              badgeNumber: 0,
                                              textEditingController: textEditingController,
                                              title: languageController
                                                  .isEnglish.value
                                                  ? filteredList[index]
                                                  .pro_en_name
                                                  : filteredList[index]
                                                  .pro_ar_name,
                                              pickListValue: (value) {
                                                setState(() {
                                                  filteredList[index]
                                                      .requried_picklist =
                                                      int.parse(value);
                                                  filteredList[index]
                                                      .pick_upload_status = 0;
                                                  int ind = availableData
                                                      .indexWhere((element) =>
                                                  element.pro_id ==
                                                      filteredList[index]
                                                          .pro_id);
                                                  availableData[ind]
                                                      .requried_picklist =
                                                      int.parse(value);
                                                  availableData[ind]
                                                      .pick_upload_status = 0;
                                                  updatePickListAfterSave(
                                                      index, false,
                                                      filteredList[index]
                                                          .requried_picklist
                                                          .toString(),
                                                      filteredList[index].pro_id
                                                          .toString());
                                                });
                                              },
                                            );
                                          }
                                      );
                                    } else {
                                      ToastMessage.errorMessage(context,
                                          "Please mark item status first".tr);
                                    }
                                  }
                                },
                                onAvailable: () async {
                                  GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

                                  if(generalStatusController.isVpnStatus.value) {
                                    showAnimatedToastMessage("Error!".tr,"Please Disable Your VPN".tr, false);
                                  } else if(generalStatusController.isMockLocation.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Disable Your Fake Locator".tr, false);
                                  } else if(!generalStatusController.isAutoTimeStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Auto time Option From Setting".tr, false);
                                  } else if(!generalStatusController.isLocationStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Location".tr, false);
                                  } else {
                                    Get.delete<GeneralChecksStatusController>();
                                    setState(() {
                                      filteredList[index].avl_status = 1;
                                      filteredList[index].activity_status = 1;
                                      int ind = availableData.indexWhere((
                                          element) =>
                                      element.pro_id ==
                                          filteredList[index].pro_id);
                                      availableData[ind].avl_status = 1;
                                      availableData[ind].activity_status = 1;
                                      // checkId(index);
                                      updateAvailableItem(
                                          false, filteredList[index].pro_id,
                                          filteredList[index].avl_status);
                                      isEdit = true;
                                    });
                                  }
                                  // updateAvailableItem(index, 1, "reason");
                                },
                                onNotAvailable: () async {
                                  GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

                                  if(generalStatusController.isVpnStatus.value) {
                                    showAnimatedToastMessage("Error!".tr,"Please Disable Your VPN".tr, false);
                                  } else if(generalStatusController.isMockLocation.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Disable Your Fake Locator".tr, false);
                                  } else if(!generalStatusController.isAutoTimeStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Auto time Option From Setting".tr, false);
                                  } else if(!generalStatusController.isLocationStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Location".tr, false);
                                  } else {
                                    Get.delete<GeneralChecksStatusController>();
                                    setState(() {
                                      textEditingController.text =
                                          filteredList[index].requried_picklist
                                              .toString();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialog(
                                              isButtonActive: filteredList[index]
                                                  .requried_picklist == 0,
                                              badgeNumber: 0,
                                              textEditingController: textEditingController,
                                              title: languageController
                                                  .isEnglish.value
                                                  ? filteredList[index]
                                                  .pro_en_name
                                                  : filteredList[index]
                                                  .pro_ar_name,
                                              pickListValue: (value) {
                                                setState(() {
                                                  filteredList[index]
                                                      .requried_picklist =
                                                      int.parse(value);
                                                  filteredList[index]
                                                      .pick_upload_status = 0;
                                                  int ind = availableData
                                                      .indexWhere((element) =>
                                                  element.pro_id ==
                                                      filteredList[index]
                                                          .pro_id);
                                                  availableData[ind]
                                                      .requried_picklist =
                                                      int.parse(value);
                                                  availableData[ind]
                                                      .pick_upload_status = 0;

                                                  updatePickListAfterSave(
                                                      index, true,
                                                      filteredList[index]
                                                          .requried_picklist
                                                          .toString(),
                                                      filteredList[index].pro_id
                                                          .toString());
                                                });
                                              },
                                            );
                                          }
                                      );
                                    });
                                  }
                                  // updateAvailableItem(index, 0, "reason");
                                });

                          }
                      )  : ListView.builder(
                          itemCount: availableData.length,
                          shrinkWrap: true,
                          itemBuilder: (context,index) {
                            return AvailabilityItem(
                              onImageTap: (){
                                getDetailsDialogue(availableData[index]);
                              },
                                imageName: "${imageBaseUrl}sku_pictures/${availableData[index].image}",
                                isAvailable: availableData[index].avl_status,
                                brandName: languageController.isEnglish.value ? availableData[index].pro_en_name : availableData[index].pro_ar_name,
                                categoryName:languageController.isEnglish.value ? availableData[index].cat_en_name : availableData[index].cat_ar_name,
                                pickListText: availableData[index].requried_picklist.toString(),
                                onTapPickList: () async {
                                  GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

                                  if(generalStatusController.isVpnStatus.value) {
                                    showAnimatedToastMessage("Error!".tr,"Please Disable Your VPN".tr, false);
                                  } else if(generalStatusController.isMockLocation.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Disable Your Fake Locator".tr, false);
                                  } else if(!generalStatusController.isAutoTimeStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Auto time Option From Setting".tr, false);
                                  } else if(!generalStatusController.isLocationStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Location".tr, false);
                                  } else {
                                    Get.delete<GeneralChecksStatusController>();
                                    if (availableData[index].avl_status != -1) {
                                      textEditingController.text =
                                          availableData[index].requried_picklist
                                              .toString();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialog(
                                              badgeNumber: 0,
                                              isButtonActive: true,
                                              textEditingController: textEditingController,
                                              title: languageController
                                                  .isEnglish.value
                                                  ? availableData[index]
                                                  .pro_en_name
                                                  : availableData[index]
                                                  .pro_ar_name,
                                              pickListValue: (value) {
                                                setState(() {
                                                  availableData[index]
                                                      .requried_picklist =
                                                      int.parse(value);
                                                  availableData[index]
                                                      .activity_status = 1;
                                                  updatePickListAfterSave(
                                                      index, false,
                                                      availableData[index]
                                                          .requried_picklist
                                                          .toString(),
                                                      availableData[index]
                                                          .pro_id
                                                          .toString());
                                                });
                                              },
                                            );
                                          }
                                      );
                                    } else {
                                      ToastMessage.errorMessage(context,
                                          "Please mark item status first".tr);
                                    }
                                  }
                                },
                                onAvailable: ()async {
                                  GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

                                  if(generalStatusController.isVpnStatus.value) {
                                    showAnimatedToastMessage("Error!".tr,"Please Disable Your VPN".tr, false);
                                  } else if(generalStatusController.isMockLocation.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Disable Your Fake Locator".tr, false);
                                  } else if(!generalStatusController.isAutoTimeStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Auto time Option From Setting".tr, false);
                                  } else if(!generalStatusController.isLocationStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Location".tr, false);
                                  } else {
                                    Get.delete<GeneralChecksStatusController>();
                                    setState(() {
                                      availableData[index].avl_status = 1;
                                      availableData[index].activity_status = 1;
                                      // checkId(index);
                                      updateAvailableItem(
                                          false, availableData[index].pro_id,
                                          availableData[index].avl_status);
                                      isEdit = true;
                                    });
                                  }
                                  // updateAvailableItem(index, 1, "reason");
                                },
                                onNotAvailable: ()async {
                                  GeneralChecksStatusController generalStatusController = await generalControllerInitialization();

                                  if(generalStatusController.isVpnStatus.value) {
                                    showAnimatedToastMessage("Error!".tr,"Please Disable Your VPN".tr, false);
                                  } else if(generalStatusController.isMockLocation.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Disable Your Fake Locator".tr, false);
                                  } else if(!generalStatusController.isAutoTimeStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Auto time Option From Setting".tr, false);
                                  } else if(!generalStatusController.isLocationStatus.value) {
                                    showAnimatedToastMessage("Error!".tr, "Please Enable Your Location".tr, false);
                                  } else {
                                    Get.delete<GeneralChecksStatusController>();
                                    setState(() {
                                      textEditingController.text =
                                          availableData[index].requried_picklist
                                              .toString();

                                      print(
                                          availableData[index].requried_picklist
                                              .toString());
                                      print(textEditingController.text);
                                      print("Required PickList Value");

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialog(
                                              badgeNumber: 0,
                                              isButtonActive: availableData[index]
                                                  .requried_picklist == 0,
                                              textEditingController: textEditingController,
                                              title: languageController
                                                  .isEnglish.value
                                                  ? availableData[index]
                                                  .pro_en_name
                                                  : availableData[index]
                                                  .pro_ar_name,
                                              pickListValue: (value) {
                                                setState(() {
                                                  availableData[index]
                                                      .requried_picklist =
                                                      int.parse(value);
                                                  availableData[index]
                                                      .activity_status = 1;
                                                  updatePickListAfterSave(
                                                      index, true,
                                                      availableData[index]
                                                          .requried_picklist
                                                          .toString(),
                                                      availableData[index]
                                                          .pro_id.toString());
                                                });
                                              },
                                            );
                                          }
                                      );
                                    });
                                  }
                                  // updateAvailableItem(index, 0, "reason");
                                });

                          }
                      )
                  ),

                ],
              ),
            ),
            if(selectedIndex == 1)
            Expanded(
              child: isError ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(errorText,style: const TextStyle(color: MyColors.backbtnColor,fontSize: 20),),
                  const SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      getTmrPickListApi();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColors.backbtnColor,width: 2)
                      ),
                      alignment: Alignment.center,
                      padding:const EdgeInsets.symmetric(vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      child: Text("Retry".tr,style:const TextStyle(color: MyColors.backbtnColor,fontSize: 20),),
                    ),
                  )
                ],
              ) : Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  currentSelectedValue = "Requested";

                                  searchUpdatedFilteredList();
                                });
                              },
                              child: PercentIndicator(
                                  isSelected: currentSelectedValue == "Requested",
                                  titleText: "Requested".tr,
                                  isIcon: false,
                                  percentColor: MyColors.appMainColor,
                                  iconData: Icons.check_circle,
                                  percentValue: requestsItems == 0 ? 0 : requestsItems/updatedAvailableData.length,
                                  percentText: requestsItems.toString()),
                            )
                        ),
                          Expanded(
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    currentSelectedValue = "Ready";

                                    searchUpdatedFilteredList();
                                  });
                                },
                                child: PercentIndicator(
                                    isSelected: currentSelectedValue == "Ready",
                                    titleText: "Ready".tr,
                                    percentColor: MyColors.greenColor,
                                    isIcon: false,
                                    iconData: Icons.done,
                                    percentValue: doneItems==0 ? 0 : doneItems/updatedAvailableData.length,
                                    percentText: doneItems.toString()),
                              )
                          ),
                          Expanded(
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    currentSelectedValue = "Pending";
                                    searchUpdatedFilteredList();
                                  });
                                },
                                child: PercentIndicator(
                                    isSelected: currentSelectedValue == "Pending",
                                    titleText: "Not Ready".tr,
                                    percentColor: MyColors.backbtnColor,
                                    isIcon: false,
                                    iconData: Icons.pending,
                                    percentValue: pendingItems==0 ? 0 : pendingItems/updatedAvailableData.length,
                                    percentText: pendingItems.toString()),
                              )
                          ),
                        ],
                      ),
                       Expanded(
                          child: isUpdateSearchFilter ? updatedFilterAvailableData.isEmpty ?  Center(
                            child: Text("No Data Found".tr),
                          ) : ListView.builder(
                              itemCount: updatedFilterAvailableData.length,
                              shrinkWrap: true,
                              itemBuilder: (context,index) {
                                controllerList.add(TextEditingController());
                                controllerList[index].text = updatedFilterAvailableData[index].actual_picklist.toString();

                                return PickListCardItem(
                                    isButtonActive: false,
                                    imageName: "${imageBaseUrl}sku_pictures/${updatedFilterAvailableData[index].image}",
                                    brandName: languageController.isEnglish.value ? updatedFilterAvailableData[index].cat_en_name : updatedFilterAvailableData[index].cat_ar_name,
                                    skuName: languageController.isEnglish.value ? updatedFilterAvailableData[index].pro_en_name : updatedFilterAvailableData[index].pro_ar_name,
                                    pickerName: updatedFilterAvailableData[index].picker_name ?? "",
                                    pickListSendTime: updatedFilterAvailableData[index].pick_list_send_time,
                                    pickListReceiveTime: updatedFilterAvailableData[index].pick_list_receive_time,
                                    requiredPickItems: updatedFilterAvailableData[index].requried_picklist.toString(),
                                    // pickerName: updatedAvailableData[index].picker_name.toString(),
                                    onSaveClick: (){
                                      // updatedAvailableData[index].actual_picklist = int.parse(controllerList[index].text);
                                      //
                                      // updatePickListAfterSave(updatedAvailableData[index].pro_id,updatedAvailableData[index].avl_status);
                                    },
                                    isAvailable: updatedFilterAvailableData[index].picklist_ready == 1 ? true : false,
                                    onChange: (value){
                                      print(value);
                                      print(updatedFilterAvailableData[index].requried_picklist);
                                      if(value.length>1 && value.startsWith("0")) {
                                        controllerList[index].text = value.substring(1);
                                      }

                                      if(int.parse(value) > updatedFilterAvailableData[index].requried_picklist) {
                                        controllerList[index].text = updatedFilterAvailableData[index].requried_picklist.toString();
                                      } else {
                                        controllerList[index].text = value;
                                      }
                                      updatedFilterAvailableData[index].actual_picklist = int.parse(controllerList[index].text);
                                    },
                                    onItemSelected: (value){

                                    },
                                    dropdownList: const <String>[],
                                    isReasonShow: false,
                                    reasonValue: [""],
                                    textEditingController: controllerList[index],
                                    onIncrement: (){
                                      if(int.parse(controllerList[index].text) < updatedFilterAvailableData[index].requried_picklist) {
                                        controllerList[index].text =
                                            (int.parse(controllerList[index].text) +
                                                1).toString();
                                      }
                                    },
                                    onDecrement: (){
                                      if(int.parse(controllerList[index].text) > 0) {
                                        controllerList[index].text =
                                            (int.parse(controllerList[index].text) -
                                                1).toString();
                                      }
                                    });

                              }
                          )
                              : updatedAvailableData.isEmpty ?  Center(
                            child: Text("No Data Found".tr),
                          ) :
                          ListView.builder(
                              itemCount: updatedAvailableData.length,
                              shrinkWrap: true,
                              itemBuilder: (context,index) {
                                controllerList.add(TextEditingController());
                                controllerList[index].text = updatedAvailableData[index].actual_picklist.toString();

                                return PickListCardItem(
                                    isButtonActive: false,
                                    isReasonShow: false,
                                    reasonValue: [""],
                                    imageName: "${imageBaseUrl}sku_pictures/${updatedAvailableData[index].image}",
                                    brandName: languageController.isEnglish.value ? updatedAvailableData[index].cat_en_name : updatedAvailableData[index].cat_ar_name,
                                    skuName: languageController.isEnglish.value ? updatedAvailableData[index].pro_en_name : updatedAvailableData[index].pro_ar_name,
                                    pickerName: updatedAvailableData[index].picker_name ?? "",
                                    requiredPickItems: updatedAvailableData[index].requried_picklist.toString(),
                                    pickListSendTime: updatedAvailableData[index].pick_list_send_time,
                                    pickListReceiveTime: updatedAvailableData[index].pick_list_receive_time,
                                    // pickerName: updatedAvailableData[index].picker_name.toString(),
                                    onSaveClick: (){
                                      // updatedAvailableData[index].actual_picklist = int.parse(controllerList[index].text);
                                      //
                                      // updatePickListAfterSave(updatedAvailableData[index].pro_id,updatedAvailableData[index].avl_status);
                                    },
                                    isAvailable: updatedAvailableData[index].picklist_ready == 1 ? true : false,
                                    onChange: (value){
                                      print(value);
                                      print(updatedAvailableData[index].requried_picklist);
                                      if(value.length>1 && value.startsWith("0")) {
                                        controllerList[index].text = value.substring(1);
                                      }

                                      if(int.parse(value) > updatedAvailableData[index].requried_picklist) {
                                        controllerList[index].text = updatedAvailableData[index].requried_picklist.toString();
                                      } else {
                                        controllerList[index].text = value;
                                      }
                                      updatedAvailableData[index].actual_picklist = int.parse(controllerList[index].text);
                                    },
                                    onItemSelected: (value){

                                    },
                                    dropdownList: const <String>[],
                                    textEditingController: controllerList[index],
                                    onIncrement: (){
                                      if(int.parse(controllerList[index].text) < updatedAvailableData[index].requried_picklist) {
                                        controllerList[index].text =
                                            (int.parse(controllerList[index].text) +
                                                1).toString();
                                      }
                                    },
                                    onDecrement: (){
                                      if(int.parse(controllerList[index].text) > 0) {
                                        controllerList[index].text =
                                            (int.parse(controllerList[index].text) -
                                                1).toString();
                                      }
                                    });

                              }
                          )
                      ),

                      InkWell(
                        onTap: tmrPickListCountModel.totalPickNotUpload > 0 ?  () {
                          saveRequiredPickList();
                        } : null,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration:  BoxDecoration(
                              color: tmrPickListCountModel.totalPickNotUpload > 0 ? MyColors.savebtnColor : MyColors.disableColor,
                              borderRadius: const BorderRadius.all(Radius.circular(5))),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                             const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.black,
                                ),
                              ),
                            const  SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Send To Picker".tr,
                                style:const TextStyle(
                                    fontSize: 12,
                                    color: MyColors.whiteColor,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // RowButtons(
                      //     buttonText: "Send To Picker",
                      //     isNextActive: isNextButton,
                      //     onSaveTap: () {
                      //       saveRequiredPickList();
                      // }, onBackTap: () {
                      //   Navigator.of(context).pop();
                      // }),
                    ],
                  ),
                  if(isDataUploading)
                    const Center(child: SizedBox(
                        height: 60,
                        width: 60,
                        child: MyLoadingCircle()),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveRequiredPickList(){
    setState(() {
      isDataUploading  = true;
    });

    DateTime now = DateTime.now();
    String currentTime = DateFormat.Hm().format(now);

    List<SavePickListData> availabilityPickList = [];

    for (int i = 0; i < updatedAvailableData.length; i++) {

      if(updatedAvailableData[i].pick_upload_status == 0 && updatedAvailableData[i].requried_picklist > 0){

        availabilityPickList.add(SavePickListData(
          clientId: updatedAvailableData[i].client_id,
          skuId: updatedAvailableData[i].pro_id,
          reqPicklist: updatedAvailableData[i].requried_picklist,
        ));
      }
    }

    SavePickList savePickList = SavePickList(
      username: userName,
      workingId: workingId,
      workingDate: workingDate,
      storeId: storeId,
      pickList: availabilityPickList,
    );
    if(availabilityPickList.isNotEmpty) {
      SqlHttpManager()
          .savePickListTrans(token, baseUrl, savePickList)
          .then((value) async =>
      {
        print("************ PickList Values **********************"),
        print(jsonEncode(availabilityPickList)),

        for(int i = 0; i < availabilityPickList.length; i++){
          if(availableData[i].pro_id == availabilityPickList[i].skuId) {
        availableData[i].pick_upload_status = 1,
        availableData[i].pick_list_send_time = currentTime,
      },
          // updateTransAvlAfterAPi(availableData[i].pro_id),
        },


      await  updateTmrPickListAfterAPi(availabilityPickList,currentTime),

      await getTmrPickListCount(),

      getPickListData(),

        setState(() {
          isDataUploading = false;
        }),
        ToastMessage.succesMessage(context, "Pick List Uploaded Successfully".tr),
      }).catchError((onError) => {
        print("API ERROR Before"),
        print(onError.toString()),
        ToastMessage.errorMessage(context, onError.toString()),
        setState(() {
          isDataUploading = false;
        }),
      });
    } else {
      setState(() {
        isDataUploading  = false;
      });
      ToastMessage.errorMessage(context, "Already sent to picker".tr);
    }
  }

  Future<bool> updateTmrPickListAfterAPi(List<SavePickListData> availabilityPickList,String currentTime) async {
    String pickIds = "";
    for(int i=0;i<availabilityPickList.length;i++) {
      pickIds = "${availabilityPickList[i].skuId.toString()},$pickIds";
    }
    pickIds = removeLastComma(pickIds);
    print(pickIds);
    await DatabaseHelper.updateTransAVLAfterPickListUpdate(workingId,pickIds,currentTime).then((value) {

    });

    return true;
  }

  updateTransAvlAfterAPi(int skuId)async {

    await DatabaseHelper.updateTransAVLAfterApiPickList(skuId,workingId)
        .then((_) {
      print("Updated available Data");
      print(jsonEncode(availableData));
      setState(() {

      });

    });
  }

  String removeLastComma(String input) {
    if (input.endsWith(',')) {
      return input.substring(0, input.length - 1);
    }
    return input;
  }
}
