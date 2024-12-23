
import 'dart:convert';
import 'dart:io';

import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/utils/services/take_image_and_save_to_folder.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/database_model/promo_plan_graph_api_count_model.dart';
import '../../Model/database_model/sys_osdc_reason_model.dart';
import '../../Model/database_model/trans_promo_plan_list_model.dart';
import '../Language/localization_controller.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/percent_indicator.dart';
import 'Promoplancard.dart';
import 'package:path/path.dart' as path;

class PromoPlan_scrren extends StatefulWidget {
  static const routeName = "/promoPlane";

  const PromoPlan_scrren({super.key});

  @override
  State<PromoPlan_scrren> createState() => _PromoPlan_scrrenState();
}

class _PromoPlan_scrrenState extends State<PromoPlan_scrren> {
  final languageController = Get.put(LocalizationController());
  String storeEnName = "";
  String storeArName = "";
  String userName = "";
  String workingId = "";
  String imageBaseUrl = "";
  bool isLoading = true;
  bool isBtnLoading = false;
  bool isYesFilter = false;
  bool isNoFilter = false;
  bool isPendingFilter = false;
  File? imageFile;
  String currentSelectedValue = "";
  int selectedReasonId=-1;
  List<Sys_OSDCReasonModel> promoReason=[Sys_OSDCReasonModel(id: -1, en_name: "", ar_name: "")];
  List<TransPromoPlanListModel> promoTransData = <TransPromoPlanListModel>[];
  List<TransPromoPlanListModel> filterTransData = <TransPromoPlanListModel>[];
  List<File> imageFilesList = [];

  PromoPlanGraphAndApiCountShowModel promoPlanGraphAndApiCountShowModel = PromoPlanGraphAndApiCountShowModel(totalPromoPLan: 0, totalDeployed: 0, totalNotDeployed: 0, totalPending: 0, totalUploadCount: 0, totalNotUploadCount: 0);

  @override
  void initState() {
    // TODO: implement initState

    getUserData();
    PromoReasonData();
    super.initState();
  }

  getUserData()  async {

    SharedPreferences sharedPreferences =  await SharedPreferences.getInstance();

    storeEnName  = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    storeArName  = sharedPreferences.getString(AppConstants.storeArNAme)!;
    userName  = sharedPreferences.getString(AppConstants.userName)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;

    setState(() {

    });
    getGraphCount();
    getPromoPlanTransData("");
  }


  void PromoReasonData() async {

    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getPromoPlaneReasonList().then((value) {
      setState(() {
        isLoading = false;
      });
      promoReason = value;
    });
  }

  getPromoPlanTransData(String promoReason12) async {
    setState(() {
      isLoading = true;
    });
    print(promoReason12);
    await DatabaseHelper.getTransPromoPlanList(workingId,promoReason12).then((value) async {
      promoTransData = value;

      for(int i = 0; i < promoTransData.length; i++ ) {
        for( int j = 0; j < promoReason.length; j++ ) {
          if(promoTransData[i].promoReasonId == promoReason[j].id ) {
            promoTransData[i].initialOsdcItem = promoReason[j];
          }
        }
      }
setState(() {

});
      await _loadImages().then((value) {
        setTransPhoto();
      });
      if(promoReason == "") {
        getGraphCount();
      }
      setState((){});
    });
  }

  getGraphCount() async {
    await DatabaseHelper.getPromoGraphAndApiCount(workingId).then((value) {

      promoPlanGraphAndApiCountShowModel = value;

      setState(() {

      });
    });
  }

  Future<void> _loadImages() async {
    setState(() {
      isLoading = true;
    });
    try {
      final String dirPath = (await getExternalStorageDirectory())!.path;
      final String folderPath =
          '$dirPath/cstore/$workingId/${AppConstants.promoPlan}';
      print("******************");
      print(folderPath);
      final Directory folder = Directory(folderPath);
      if (await folder.exists()) {
        final List<FileSystemEntity> files = folder.listSync();
        imageFilesList = files.whereType<File>().toList();
      }
    } catch (e) {
      print('Error reading images: $e');
    }

    // setState(() {});
  }

  setTransPhoto() async {

    for(int i = 0; i < promoTransData.length; i++) {
      for(int j = 0; j < imageFilesList.length; j++) {
       if(promoTransData[i].imageName.isNotEmpty || promoTransData[i].imageName != "") {
         if (imageFilesList[j].path.endsWith(promoTransData[i].imageName)) {
           setState(() {
             promoTransData[i].imageFile = imageFilesList[j];
           });
         }
       }
      }
      print(promoTransData[i].imageFile);

      if(promoTransData[i].imageFile != null) {
        bool isImageCorrupt = await isImageCorrupted(XFile(promoTransData[i].imageFile!.path));

        if(isImageCorrupt) {
          promoTransData[i].imageFile = await convertAssetToFile("assets/images/no_image_found.png");
        }

      } else {
        promoTransData[i].imageFile = await convertAssetToFile("assets/images/no_image_found.png");
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  ///Image Selection
  Future<void> getImage(int index) async {
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        return;
      }
      imageFile = value;
      promoTransData[index].imageFile = imageFile;

      final String extension = path.extension( promoTransData[index].imageFile!.path);
      promoTransData[index].imageName = "${userName}_${DateTime.now().millisecondsSinceEpoch}$extension";
      if(promoTransData[index].actStatus == 1) {
        promoTransData[index].gcsStatus = 0;
        savePromoPlanImage(false, index);
      }
      setState(() {

      });
      // _takePhoto(value);
    });
  }

  void savePromoPlanImage(bool isMessageShow,int index) async {

    if (promoTransData[index].promoStatus.isEmpty) {
      if (isMessageShow) {
        showAnimatedToastMessage("Error!".tr, "Please fill the form".tr, false);
      }
      return;
    } else if( promoTransData[index].imageFile == null) {
      if (isMessageShow) {
        showAnimatedToastMessage("Error!".tr, "Please take an image".tr, false);
      }
      return;
    } else if(promoTransData[index].promoStatus == "No") {
      if(selectedReasonId == -1 ) {
        if (isMessageShow) {
          showAnimatedToastMessage("Error!".tr, "Please fill the form".tr, false);
        }
        return;
      }
    }
    try {
      setState(() {
        isBtnLoading = isMessageShow;
      });
      await takePicture(context, promoTransData[index].imageFile,
          promoTransData[index].imageName, workingId,
          AppConstants.promoPlan).then((_) async {

            await DatabaseHelper.updateTransPromoPlan(
                promoTransData[index].gcsStatus,
                promoTransData[index].skuId,
                workingId,
                promoTransData[index].imageName,
                promoTransData[index].promoStatus,
                selectedReasonId.toString(),
            ).then((_) {

              if (isMessageShow) {
                showAnimatedToastMessage("Success".tr, "Data Saved Successfully".tr, true);
                promoTransData[index].actStatus = 1;
              }
              getGraphCount();
            });
            setState(() {
              isBtnLoading = false;
            });
      });
    } catch (error) {
      showAnimatedToastMessage("Error!".tr,error.toString(), false);
      setState(() {
        isBtnLoading = false;
      });
    }
  }

  searchFilter() {

    if(currentSelectedValue == "Yes") {
      if(isYesFilter) {
        currentSelectedValue = "";
        isYesFilter = false;
        getPromoPlanTransData("");
      } else {
        isYesFilter = true;
        isNoFilter = false;
        isPendingFilter = false;
        getPromoPlanTransData("Yes");
      }
    } else if(currentSelectedValue == "No") {
      if(isNoFilter) {
        currentSelectedValue = "";
        isNoFilter = false;
        getPromoPlanTransData("");
      } else {
        isYesFilter = false;
        isNoFilter = true;
        isPendingFilter = false;
        getPromoPlanTransData("No");
      }
    } else {
      if(isPendingFilter) {
        currentSelectedValue = "";
        isPendingFilter = false;
        getPromoPlanTransData("");
      } else {
        isYesFilter = false;
        isNoFilter = false;
        isPendingFilter = true;
        getPromoPlanTransData("Pending");
      }
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FD),
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName:storeArName, userName, (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 1),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            currentSelectedValue = "Yes";
                            searchFilter();

                          });
                        },
                        child: PercentIndicator(
                            isSelected: currentSelectedValue == "Yes",
                            titleText: "Yes".tr,
                            isIcon: true,
                            percentColor: MyColors.greenColor,
                            iconData: Icons.check_circle,
                            percentValue:promoPlanGraphAndApiCountShowModel.totalPromoPLan == 0 ? 0 : (promoPlanGraphAndApiCountShowModel.totalDeployed/promoPlanGraphAndApiCountShowModel.totalPromoPLan).toDouble(),
                            percentText: promoPlanGraphAndApiCountShowModel.totalDeployed.toString()),
                      )
                  ),
                  Expanded(
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            currentSelectedValue = "No";
                            searchFilter();
                          });
                        },
                        child: PercentIndicator(
                            isSelected: currentSelectedValue == "No",
                            titleText: "No".tr,
                            percentColor: MyColors.backbtnColor,
                            isIcon: true,
                            iconData: Icons.warning_amber_rounded,
                            percentValue: promoPlanGraphAndApiCountShowModel.totalPromoPLan == 0 ? 0 : (promoPlanGraphAndApiCountShowModel.totalNotDeployed/promoPlanGraphAndApiCountShowModel.totalPromoPLan).toDouble(),
                            percentText: promoPlanGraphAndApiCountShowModel.totalNotDeployed.toString()),
                      )
                  ),
                  Expanded(
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            currentSelectedValue = "Pending";
                            searchFilter();
                          });
                        },
                        child: PercentIndicator(
                            isSelected: currentSelectedValue == "Pending",
                            titleText: "Pending".tr,
                            percentColor: MyColors.warningColor,
                            isIcon: true,
                            iconData: Icons.pending,
                            percentValue: promoPlanGraphAndApiCountShowModel.totalPromoPLan == 0 ? 0 : (promoPlanGraphAndApiCountShowModel.totalPending/promoPlanGraphAndApiCountShowModel.totalPromoPLan).toDouble(),
                            percentText: promoPlanGraphAndApiCountShowModel.totalPending.toString()),
                      )
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading ? const Center(child: SizedBox(
                  height: 60,
                  child: MyLoadingCircle()),) :

              promoTransData.isEmpty ?  Center(child: Text("No Data Found".tr),)
                  : ListView.builder(
                  itemCount: promoTransData.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                  print(jsonEncode(promoTransData[index].initialOsdcItem));
                  print(promoTransData.length);
                return PromoPlanCard(
                  modalImage: "https://storage.googleapis.com/binzagr-bucket/sku_pictures/${promoTransData[index].modalImage}",
                  isBtnLoading:isBtnLoading,
                  initialItem: promoTransData[index].initialOsdcItem,
                  actStatus: promoTransData[index].actStatus,
                  promoStatus: promoTransData[index].promoStatus,
                  skuName:languageController.isEnglish.value?  promoTransData[index].skuEnName:  promoTransData[index].skuArName,
                  skuImage: "${imageBaseUrl}sku_pictures/${promoTransData[index].skuImageName}",
                  categoryName:languageController.isEnglish.value? promoTransData[index].catEnName:promoTransData[index].catArName,
                  brandName:languageController.isEnglish.value?  promoTransData[index].brandEnName:  promoTransData[index].brandArName,
                  fromDate: promoTransData[index].promoFrom,
                  toDate: promoTransData[index].promoTo,
                  osdType:  promoTransData[index].osdType,
                  promoScope: promoTransData[index].promoScope,
                  promoPrice: promoTransData[index].promoPrice.toString(),
                  leftOverPieces: promoTransData[index].leftOverAction,
                  imageFile: promoTransData[index].imageFile,
                  statusValue: (value) {

                    if(promoTransData[index].actStatus == 1 && promoTransData[index].promoStatus != value) {
                      promoTransData[index].promoStatus = value;
                      promoTransData[index].gcsStatus = 0;
                      savePromoPlanImage(false, index);
                    } else {
                      promoTransData[index].promoStatus = value;
                    }
                    print("Status Promo");
                    print(promoTransData[index].promoStatus);
                    setState(() {});
                  },
                  promoReasonValue: (value) {
                    selectedReasonId=value.id;
                    setState(() {

                    });
                    // promoTransData[index].promoReason = selectedReasonId.toString();
                    print(selectedReasonId);
                    // print(promoTransData[index].promoReason );
                    if(promoTransData[index].actStatus == 1 ) {
                      promoTransData[index].gcsStatus = 0;


                      savePromoPlanImage(false, index);
                    }

                    setState(() {});
                  },
                  onSelectImage: (){
                    getImage(index);
                  },
                  onSaveClick: (){
                    savePromoPlanImage(true, index);
                  },
                  promoReasonModel:promoReason,
                );
              }),
            ),
          ],
        ),
      )
    );
  }
}
