
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/trans_brand_shares_model.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';
import '../widget/percent_indicator.dart';
import 'widgets/BrandSharesCard.dart';

class BrandShares_Screen extends StatefulWidget {
  static const routename = "shelfShare_screem";

  const BrandShares_Screen({super.key});

  @override
  State<BrandShares_Screen> createState() => BrandShares_ScreenState();
}

class BrandShares_ScreenState extends State<BrandShares_Screen> {
  bool isLoading = true;
  bool isFilterLoading = true;
  List<TransBransShareModel> transData = [];
  final languageController = Get.put(LocalizationController());
  bool isFilter = false;
  List<TransBransShareModel> filteredList = [];
  String currentSelectedValue = "All";

  String clientId = "";
  String workingId = "";
  String storeEnName = "";
  String storeArName = "";
  String userName = "";

  int doneItems = 0;
  int pendingItems = 0;

  bool isBtnLoading = false;

  @override
  void initState() {
    super.initState();
    getStoreDetails();
  }

  getStoreDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    storeEnName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;
    getTransBrandShareOne(true);
  }

  Future<void> getTransBrandShareOne(bool isLoader) async {

    setState(() {
      isLoading = isLoader;
    });
    await DatabaseHelper.getBransSharesDataList(workingId).then((value) async {
      transData = value.cast<TransBransShareModel>();
      doneItems = transData.where((element) => element.activity_status == 1).toList().length;
      pendingItems = transData.where((element) => element.activity_status == 0).toList().length;
     setState(() {
       isLoading = false;
     });
      print("___  BrandShare Data List Screen_______");
      print(doneItems);
      print(pendingItems);
    });
  }

  searchFilteredList() async {
    isFilter = true;
    setState(() {
      isFilterLoading = true;
    });
    if(currentSelectedValue == "Done") {
      await DatabaseHelper.getBransSharesFilteredDataList(workingId,1).then((value) {
        setState(() {
          filteredList = value;
          isFilterLoading = false;
        });
      });

    } else if(currentSelectedValue == "Pending") {
      await DatabaseHelper.getBransSharesFilteredDataList(workingId,0).then((value) {
        setState(() {
          filteredList = value;
          isFilterLoading = false;
        });
      });
    }  else {
      isFilter = false;
    }


    print("FILTER STATUS");
    print(isFilter);

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF4F7FD),
        appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName, (){
          Navigator.of(context).pop();
        }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

        }),
        body: isLoading ? const Center(child: MyLoadingCircle(),) : transData.isEmpty
            ?  Center(
                child: Text("No Data found".tr),
              )
            : Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 1),
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                            onTap: (){
                              currentSelectedValue = "Done";

                              searchFilteredList();

                              setState(() {

                              });
                            },
                            child: PercentIndicator(
                                isSelected: currentSelectedValue == "Done",
                                titleText: "Done".tr,
                                isIcon: true,
                                percentColor: MyColors.greenColor,
                                iconData: Icons.check_circle,
                                percentValue: (doneItems/transData.length).toDouble(),
                                percentText: doneItems.toString()),
                          )
                      ),
                      Expanded(
                          child: InkWell(
                            onTap: (){
                              currentSelectedValue = "Pending";

                              searchFilteredList();

                              setState(() {

                              });
                            },
                            child: PercentIndicator(
                                isSelected: currentSelectedValue == "Pending",
                                titleText: "Pending".tr,
                                percentColor: MyColors.warningColor,
                                isIcon: true,
                                iconData: Icons.pending,
                                percentValue: (pendingItems/transData.length).toDouble(),
                                percentText: pendingItems.toString()),
                          )
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: isFilter ? isFilterLoading ? const Center(child: CircularProgressIndicator(),) : filteredList.isEmpty ? Center(
                    child: Text("No Data found".tr),
                  ) :  ListView.builder(
                    itemCount: filteredList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, filterIndex) {
                      print(filteredList.length);
                      return Shelf_SharesCard(
                        isDone: filteredList[filterIndex].activity_status == 1,
                        fieldName1: languageController.isEnglish.value ? filteredList[filterIndex].cat_en_name : filteredList[filterIndex].cat_ar_name ,
                        labelName1: "Department".tr,
                        fieldName2: languageController.isEnglish.value ? filteredList[filterIndex].brand_en_name : filteredList[filterIndex].brand_ar_name,
                        labelName2: "Brand".tr,
                        fieldName3: filteredList[filterIndex].given_faces,
                        labelName3: "Given Faces".tr,
                        fieldName4: filteredList[filterIndex].actual_faces,
                        labelName4: "Actual Faces".tr,
                        context: context,
                        onSaveClick: (){
                          saveBrandShareData(filteredList[filterIndex]);},
                        onActualValue: (value) {
                          setState(() {
                            filteredList[filterIndex].actual_faces = value;
                            int ind = transData.indexWhere((element) => element.id == filteredList[filterIndex].id);
                            transData[ind].actual_faces = value;

                            print(filteredList[filterIndex].id);
                            print(transData[ind].id);
                          });
                        },
                        isBtnLoading: isBtnLoading,
                      );
                    },
                  )  :
                  ListView.builder(
                      itemCount: transData.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        print(transData.length);
                        return Shelf_SharesCard(
                          isDone: transData[index].activity_status == 1,
                          fieldName1: languageController.isEnglish.value ? transData[index].cat_en_name : transData[index].cat_ar_name,
                          labelName1: "Department".tr,
                          fieldName2: languageController.isEnglish.value ? transData[index].brand_en_name : transData[index].brand_ar_name,
                          labelName2: "Brand".tr,
                          fieldName3: transData[index].given_faces,
                          labelName3: "Given Faces".tr,
                          fieldName4: transData[index].actual_faces,
                          labelName4: "Actual Faces".tr,
                          context: context,
                          onSaveClick: (){saveBrandShareData(transData[index]);},
                          onActualValue: (value) {
                            transData[index].actual_faces = value;
                            print(value);
                            print(transData[index].actual_faces);
                          },
                          isBtnLoading: isBtnLoading,
                        );
                      },
                    ),
                ),
              ],
            ));
  }

  void saveBrandShareData(TransBransShareModel transBransShareModel) async {
    if (transBransShareModel.actual_faces.isEmpty ) {
      ToastMessage.errorMessage(context, "Please add actual faces".tr);
    } else {
      setState(() {
        isBtnLoading = true;
      });

        await DatabaseHelper.updateTransBrandShares(
            transBransShareModel.brand_id, workingId, transBransShareModel.actual_faces,transBransShareModel.cat_id.toString())
            .then((_) {

          if(isFilter) {
            searchFilteredList();
          }

          getTransBrandShareOne(false);

          ToastMessage.succesMessage(context, "Data Saved Successfully".tr);

          setState(() {
            isBtnLoading = false;
          });
        }).catchError((e) {
          setState(() {
            ToastMessage.errorMessage(context, e.toString());
            isBtnLoading = false;
          });
        });

    }
  }
}
