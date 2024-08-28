import 'dart:convert';

import 'package:cstore/Model/request_model.dart/ready_pick_list_request.dart';
import 'package:cstore/Network/sql_data_http_manager.dart';
import 'package:cstore/screens/Language/localization_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../../Model/database_model/picklist_model.dart';
import '../../Model/request_model.dart/jp_request_model.dart';
import '../availability/widgets/pick_list_card_item.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';
import '../widget/percent_indicator.dart';
import '../widget/two_buttons_in_row.dart';

class PickListScreen extends StatefulWidget {
  static const routename = "pick_list_route";
  const PickListScreen({super.key});

  @override
  State<PickListScreen> createState() => _PickListScreenState();
}

class _PickListScreenState extends State<PickListScreen> {

  String workingId = "";
  String storeName = "";
  String userName = "";
  String workingDate = "";
  String storeId = "";
  String clientId = "";
  bool isLoading = true;
  bool isDataUploading = false;
  String token = "";
  String baseUrl = "";
  bool isError = false;
  String errorText = "";
  List<PickListModel> pickerPickList = <PickListModel>[];
  List<PickListModel> pickerFilterPickList = <PickListModel>[];

  String imageBaseUrl = "";

  List<String> reasonList = const ["Damage","Expired","Near Expiry","Out Of Stock"];


  int requestsItems = 0;
  int doneItems = 0;
  int pendingItems = 0;

  bool isNextButton = true;

  bool isUpdateSearchFilter = false;
  String currentSelectedValue = "Requested";

  List<TextEditingController> controllerList = <TextEditingController>[];
  final languageController = Get.put(LocalizationController());
  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;
    workingDate = sharedPreferences.getString(AppConstants.workingDate)!;
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    storeId = sharedPreferences.getString(AppConstants.storeId)!;
    token = sharedPreferences.getString(AppConstants.tokenId)!;
    baseUrl = sharedPreferences.getString(AppConstants.baseUrl)!;
    imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;

    getPickerPickList();

  }

  getPickerPickList() {
    setState(() {
      isError = false;
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
      isError = true;
      errorText = e.toString();
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
    if (valuePickList.isNotEmpty) {
      String valueQuery = "";
      for (int i = 0; i < valuePickList.length; i++) {
        valueQuery =
            "$valueQuery($workingId,${wrapIfString(workingId)},${valuePickList[i].picklist_id},${valuePickList[i].store_id},${valuePickList[i].category_id},${valuePickList[i].tmr_id},${wrapIfString(valuePickList[i].tmr_name)},${valuePickList[i].stocker_id},${wrapIfString(valuePickList[i].stocker_name)},${wrapIfString(valuePickList[i].shift_time)},${wrapIfString(valuePickList[i].en_cat_name)},${wrapIfString(valuePickList[i].ar_cat_name)},${wrapIfString(valuePickList[i].sku_picture)},${wrapIfString(valuePickList[i].en_sku_name)},${wrapIfString(valuePickList[i].ar_sku_name)},${valuePickList[i].req_pickList},${valuePickList[i].act_pickList},${valuePickList[i].pickList_ready},0,'',${wrapIfString(valuePickList[i].pick_list_receive_time)},${wrapIfString(valuePickList[i].pick_list_reason)}),";
      }
      if (valueQuery.endsWith(",")) {
        valueQuery = valueQuery.substring(0, valueQuery.length - 1);
      }
      print("Query Part");
      print(valueQuery);

      await DatabaseHelper.insertPickListByQuery(valueQuery).then((value) {
        print("check picklist screen");
        getPickListFromQuery();
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  getPickListFromQuery() async {

    String pickListReasonValue = "";
    var splitPickListReason;

   await DatabaseHelper.getPickListData().then((value) => {
     pickerPickList = value,

   requestsItems = pickerPickList.length,
     doneItems = pickerPickList.where((element) => element.pickList_ready == "1").toList().length,
    pendingItems = pickerPickList.where((element) => element.pickList_ready == "0").toList().length,

     isNextButton = pickerPickList.where((element) => element.upload_status == 0).toList().isNotEmpty,

     for(int i=0; i<pickerPickList.length; i++) {

       pickListReasonValue = pickerPickList[i].pick_list_reason,

       if(pickListReasonValue.isNotEmpty) {
         splitPickListReason = pickListReasonValue.split(","),
        for(int j = 0; j < splitPickListReason.length; j++) {
          setState(() {
             pickerPickList[i].reasonValue?.add(splitPickListReason[j].toString().trim());
          }),
        }
       } else {
         setState(() {
           pickerPickList[i].reasonValue = [];
         }),
       },

       print(pickListReasonValue),
       print(pickerPickList[i].reasonValue),

       if(int.parse(pickerPickList[i].act_pickList) == int.parse(pickerPickList[i].req_pickList)) {
         pickerPickList[i].isReasonShow = false,
       } else {
         pickerPickList[i].isReasonShow = true,
    }
     },

     setState(() {
       isLoading = false;
     }),
   }).catchError((e)=>{
     print(e.toString()),
     setState(() {
       isLoading = false;
     }),
   });
  }

  searchUpdatedFilteredList() {
    isUpdateSearchFilter = true;
    if(currentSelectedValue == "Requested") {

      pickerFilterPickList = pickerPickList;

    } else if(currentSelectedValue == "Ready") {

      pickerFilterPickList = pickerPickList.where((element) => element.pickList_ready == "1").toList();

    } else if(currentSelectedValue == 'Pending') {

      pickerFilterPickList = pickerPickList.where((element) => element.pickList_ready == "0").toList();

    } else {
      isUpdateSearchFilter = false;
    }

    setState(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllerList.forEach((element) {element.dispose();});
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generalAppBar(context, storeName, userName, (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child:isLoading ? const MyLoadingCircle() : isError ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(errorText,style: const TextStyle(color: MyColors.backbtnColor,fontSize: 20),),
            const SizedBox(height: 10,),
            InkWell(
              onTap: (){
                getPickerPickList();
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
        ) : pickerPickList.isEmpty ? Center(child: Text("Pick List is not added yet".tr),) : Column(
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
                          percentValue: requestsItems/pickerPickList.length,
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
                          iconData: Icons.close,
                          percentValue: doneItems/pickerPickList.length,
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
                          titleText: "Pending".tr,
                          percentColor: MyColors.backbtnColor,
                          isIcon: false,
                          iconData: Icons.close,
                          percentValue: pendingItems/pickerPickList.length,
                          percentText: pendingItems.toString()),
                    )
                ),
              ],
            ),
            Expanded(
              child:  isUpdateSearchFilter ? pickerFilterPickList.isEmpty ?  Center(child: Text("No Data Found".tr),) :
              ListView.builder(
                  itemCount: pickerFilterPickList.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index) {
                    controllerList.add(TextEditingController());
                    controllerList[index].text =  pickerFilterPickList[index].act_pickList;

                    return PickListCardItem(
                        isButtonActive: true,
                        reasonValue: pickerFilterPickList[index].reasonValue!,
                        imageName: "${imageBaseUrl}sku_pictures/${pickerFilterPickList[index].sku_picture}",
                        brandName: languageController.isEnglish.value ? pickerFilterPickList[index].en_cat_name : pickerFilterPickList[index].ar_cat_name,
                        skuName: languageController.isEnglish.value ? pickerFilterPickList[index].en_sku_name : pickerFilterPickList[index].ar_sku_name,
                        pickerName: pickerFilterPickList[index].tmr_name ?? "",
                        requiredPickItems: pickerFilterPickList[index].req_pickList,
                        pickListSendTime: pickerFilterPickList[index].pick_list_send_time,
                        pickListReceiveTime: pickerFilterPickList[index].pick_list_receive_time,
                        isReasonShow: pickerFilterPickList[index].isReasonShow!,
                        onSaveClick: (){
                          setState(() {
                            pickerFilterPickList[index].pickList_ready = "1";
                            pickerFilterPickList[index].act_pickList =
                                controllerList[index].text;

                            int ind = pickerPickList.indexWhere((element) => element.picklist_id == pickerFilterPickList[index].picklist_id);
                            pickerPickList[ind].pickList_ready == "1";
                            updateSqlPickTable(ind);
                          });
                        },
                        isAvailable: pickerFilterPickList[index].pickList_ready == "0" ? false : true,
                        onChange: (value){
                          print(value);
                          print(pickerFilterPickList[index].req_pickList);

                          if(value.length>1 && value.startsWith("0")) {
                            controllerList[index].text = value.substring(1);
                          }

                          if(int.parse(value) > int.parse(pickerFilterPickList[index].req_pickList)) {
                            controllerList[index].text = pickerFilterPickList[index].req_pickList.toString();
                          } else {
                            controllerList[index].text = value;
                          }

                         setState(() {
                           pickerFilterPickList[index].act_pickList = controllerList[index].text;

                           if(int.parse(pickerFilterPickList[index].act_pickList) == int.parse(pickerFilterPickList[index].req_pickList)) {
                             pickerFilterPickList[index].isReasonShow = false;
                           } else {
                             pickerFilterPickList[index].isReasonShow = true;
                           }
                         });
                        },
                        onItemSelected: (value){

                        },
                        dropdownList: reasonList,
                        textEditingController: controllerList[index],
                        onIncrement: (){
                          if(int.parse(controllerList[index].text) < int.parse(pickerFilterPickList[index].req_pickList)) {
                            controllerList[index].text = (int.parse(controllerList[index].text) + 1).toString();
                          }

                          setState(() {
                            pickerFilterPickList[index].act_pickList = controllerList[index].text;

                            if(int.parse(pickerFilterPickList[index].act_pickList) == int.parse(pickerFilterPickList[index].req_pickList)) {
                              pickerFilterPickList[index].isReasonShow = false;
                            } else {
                              pickerFilterPickList[index].isReasonShow = true;
                            }
                          });
                        },
                        onDecrement: (){
                          if(int.parse(controllerList[index].text) > 0) {
                            controllerList[index].text = (int.parse(controllerList[index].text) - 1).toString();
                          }

                          setState(() {
                            pickerFilterPickList[index].act_pickList = controllerList[index].text;

                            if(int.parse(pickerFilterPickList[index].act_pickList) == int.parse(pickerFilterPickList[index].req_pickList)) {
                              pickerFilterPickList[index].isReasonShow = false;
                            } else {
                              pickerFilterPickList[index].isReasonShow = true;
                            }
                          });
                        });

                  }
              )
                  : pickerPickList.isEmpty ?  Center(child: Text("No Data Found".tr),)
                  :  ListView.builder(
                  itemCount: pickerPickList.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index) {
                    controllerList.add(TextEditingController());
                    controllerList[index].text =  pickerPickList[index].act_pickList;
                    print("${imageBaseUrl}sku_pictures/${pickerPickList[index].sku_picture}");
                    return PickListCardItem(
                        isButtonActive: true,
                        reasonValue: pickerPickList[index].reasonValue!,
                        imageName: "${imageBaseUrl}sku_pictures/${pickerPickList[index].sku_picture}",
                        brandName: languageController.isEnglish.value ?  pickerPickList[index].en_cat_name : pickerPickList[index].ar_cat_name,
                        skuName: languageController.isEnglish.value ?  pickerPickList[index].en_sku_name : pickerPickList[index].ar_sku_name,
                        pickerName: pickerPickList[index].tmr_name ?? "",
                        requiredPickItems: pickerPickList[index].req_pickList,
                        pickListSendTime: pickerPickList[index].pick_list_send_time,
                        pickListReceiveTime: pickerPickList[index].pick_list_receive_time,
                        isReasonShow: pickerPickList[index].isReasonShow!,
                        onSaveClick: (){
                         setState(() {
                           pickerPickList[index].pickList_ready = "1";
                           pickerPickList[index].act_pickList = controllerList[index].text;
                         });
                          updateSqlPickTable(index);
                        },
                        isAvailable: pickerPickList[index].pickList_ready == "0" ? false : true,
                        onChange: (value){
                          print(value);
                          print(pickerPickList[index].req_pickList);
                          if(value.length>1 && value.startsWith("0")) {
                            controllerList[index].text = value.substring(1);
                          }

                          if(int.parse(value) > int.parse(pickerPickList[index].req_pickList)) {
                            controllerList[index].text = pickerPickList[index].req_pickList.toString();
                          } else {
                            controllerList[index].text = value;
                          }

                         setState(() {
                           pickerPickList[index].act_pickList = controllerList[index].text;

                           if(int.parse(pickerPickList[index].act_pickList) == int.parse(pickerPickList[index].req_pickList)) {
                             pickerPickList[index].isReasonShow = false;
                           } else {
                           pickerPickList[index].isReasonShow = true;
                           }
                         });
                        },
                        onItemSelected: (value){
                          setState(() {
                            pickerPickList[index].reasonValue = value;
                          });
                          print(pickerPickList[index].reasonValue);
                        },
                        dropdownList: reasonList,
                        textEditingController: controllerList[index],
                        onIncrement: (){
                          if(int.parse(controllerList[index].text) < int.parse(pickerPickList[index].req_pickList)) {
                            controllerList[index].text = (int.parse(controllerList[index].text) + 1).toString();
                          }

                          setState(() {
                            pickerPickList[index].act_pickList = controllerList[index].text;

                            if(int.parse(pickerPickList[index].act_pickList) == int.parse(pickerPickList[index].req_pickList)) {
                              pickerPickList[index].isReasonShow = false;
                            } else {
                              pickerPickList[index].isReasonShow = true;
                            }
                          });
                        },
                        onDecrement: (){
                          if(int.parse(controllerList[index].text) > 0) {
                            controllerList[index].text = (int.parse(controllerList[index].text) - 1).toString();
                          }

                          setState(() {
                            pickerPickList[index].act_pickList = controllerList[index].text;

                            if(int.parse(pickerPickList[index].act_pickList) == int.parse(pickerPickList[index].req_pickList)) {
                              pickerPickList[index].isReasonShow = false;
                            } else {
                              pickerPickList[index].isReasonShow = true;
                            }
                          });

                        });

                  }
              ),
            ),
            isDataUploading ? const SizedBox(width: 60,height: 60,child: MyLoadingCircle(),) : InkWell(
              onTap: isNextButton ?  () {
                makePickListReady();
              } : null,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration:  BoxDecoration(
                    color: isNextButton ? MyColors.savebtnColor : MyColors.disableColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const  CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.check,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Send To TMR".tr,
                      style:const TextStyle(
                          fontSize: 12,
                          color: MyColors.whiteColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            // isDataUploading ? const SizedBox(width: 60,height: 60,child: MyLoadingCircle(),) : RowButtons(
            //     buttonText: "Send To TMR",
            //     isNextActive: isNextButton,
            //     onSaveTap: () {
            //       makePickListReady();
            //     }, onBackTap: () {
            //   Navigator.of(context).pop();
            // }),
          ],
        ),
      ),
    );
  }

  updateSqlPickTable(int index) async {
    String reason  = pickerPickList[index].reasonValue!.join(', ');
    if(int.parse(pickerPickList[index].act_pickList) < int.parse(pickerPickList[index].req_pickList) && reason.isEmpty) {
      ToastMessage.errorMessage(context, "Please Select a reason first".tr);

    } else {
      await DatabaseHelper.updateTransPicklist(
          pickerPickList[index].picklist_id, pickerPickList[index].act_pickList,
          pickerPickList[index].pickList_ready,reason).then((value) {
        print(jsonEncode(pickerPickList[index]));

        setState(() {
          pickerPickList[index].upload_status = 0;
        });

        requestsItems = pickerPickList.length;
        doneItems = pickerPickList
            .where((element) => element.pickList_ready == "1")
            .toList()
            .length;
        pendingItems = pickerPickList
            .where((element) => element.pickList_ready == "0")
            .toList()
            .length;

        ToastMessage.succesMessage(context, "Items added successfully".tr);
      });
    }
  }

  makePickListReady () {
    setState(() {
      isDataUploading = true;
    });

    DateTime now = DateTime.now();
    String currentTime = DateFormat.Hm().format(now);

    List<ReadyPickListData> readyPickListData = [];

    for(int i = 0;i<pickerPickList.length; i++) {
      String reason  = pickerPickList[i].reasonValue!.join(', ');
      if(pickerPickList[i].isReasonShow!) {
        reason = reason;
      } else {
        reason = "";
      }
      if(pickerPickList[i].pickList_ready == "1" && pickerPickList[i].upload_status == 0 ) {
        readyPickListData.add(ReadyPickListData(pickListId: int.parse(pickerPickList[i].picklist_id), actualPicklist: int.parse(pickerPickList[i].act_pickList),picklistReason: reason == "Select Reason" ? "" : reason));
      }

    }

    ReadyPickList readyPickList  = ReadyPickList(
        username: userName,
        workingId: workingId,
        storeId: storeId,
        workingDate: workingDate,
        readyPickList: readyPickListData
    );
    SqlHttpManager().readyPickList(token, baseUrl, readyPickList).then((value) async => {

      print(value),

      await updateSqlPickListAfterApi(readyPickListData,currentTime),

      getPickListFromQuery(),

    setState(() {
      isNextButton  = false;
    isDataUploading  = false;
    }),
      ToastMessage.succesMessage(context, "Pick List Uploaded Successfully".tr),
    }).catchError((e) =>{
      setState(() {
        isDataUploading  = false;
      }),
      ToastMessage.errorMessage(context, e.toString()),
    });
  }

  Future<bool> updateSqlPickListAfterApi( List<ReadyPickListData> pickListDataForApi,String currentTime) async {
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

  String removeLastComma(String input) {
    if (input.endsWith(',')) {
      return input.substring(0, input.length - 1);
    }
    return input;
  }

}
