
import 'dart:io';

import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/utils/services/take_image_and_save_to_folder.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/database_model/promo_plan_graph_api_count_model.dart';
import '../../Model/database_model/trans_promo_plan_list_model.dart';
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

  String storeName = "";
  String workingId = "";
  String imageBaseUrl = "";
  bool isLoading = true;
  bool isBtnLoading = false;
  bool isFilter = false;
  File? imageFile;
  String currentSelectedValue = "";

  List<TransPromoPlanListModel> promoTransData = <TransPromoPlanListModel>[];
  List<TransPromoPlanListModel> filterTransData = <TransPromoPlanListModel>[];
  List<File> imageFilesList = [];

  PromoPlanGraphAndApiCountShowModel promoPlanGraphAndApiCountShowModel = PromoPlanGraphAndApiCountShowModel(totalPromoPLan: 0, totalDeployed: 0, totalNotDeployed: 0, totalPending: 0, totalUploadCount: 0, totalNotUploadCount: 0);

  @override
  void initState() {
    // TODO: implement initState

    getUserData();
    super.initState();
  }

  getUserData()  async {

    SharedPreferences sharedPreferences =  await SharedPreferences.getInstance();

    storeName  = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;

    setState(() {

    });
    getPromoPlanTransData();
    print(storeName);
  }

  getPromoPlanTransData() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getTransPromoPlanList(workingId).then((value) async {
      promoTransData = value;

      await _loadImages().then((value) {
        setTransPhoto();
      });

      getGraphCount();
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

  setTransPhoto(){

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
      promoTransData[index].imageName = "${DateTime.now().millisecondsSinceEpoch}$extension";
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

    if (promoTransData[index].promoStatus.isEmpty || promoTransData[index].promoReason.isEmpty) {
      if (isMessageShow) {
        ToastMessage.errorMessage(
            context, "Please fill the form");
      }
      return;
    } else if( promoTransData[index].imageFile == null) {
      if (isMessageShow) {
        ToastMessage.errorMessage(
            context, "Please take an image");
      }
      return;
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
                promoTransData[index].promoId,
                workingId,
                promoTransData[index].imageName,
                promoTransData[index].promoStatus,
                promoTransData[index].promoReason
            ).then((_) {

              if (isMessageShow) {
                ToastMessage.succesMessage(context, "Data stored successfully");
                print("Update data promoplan successfully");
                promoTransData[index].actStatus = 1;
              }
              getGraphCount();
            });
            setState(() {
              isBtnLoading = false;
            });
      });
    } catch (error) {
      ToastMessage.errorMessage(context, error.toString());
      setState(() {
        isBtnLoading = false;
      });
    }
  }

  searchFilter() {
    isFilter = true;
    if(currentSelectedValue == "Yes") {
      filterTransData =
          promoTransData.where((element) => element.promoReason == "Yes").toList();
    } else if(currentSelectedValue == "No") {
      filterTransData =
          promoTransData.where((element) => element.promoReason == "No").toList();
    } else {
      filterTransData =
          promoTransData.where((element) => element.promoReason == "Pending").toList();
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FD),
      appBar: generalAppBar(context, storeName, "Promotion", (){
        Navigator.of(context).pop();
      }, (){print("filter Click");}, true, false, false),
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
                            // currentSelectedValue = "Yes";
                            // searchFilter();

                          });
                        },
                        child: PercentIndicator(
                            isSelected: currentSelectedValue == "Yes",
                            titleText: "Yes",
                            isIcon: true,
                            percentColor: MyColors.greenColor,
                            iconData: Icons.check_circle,
                            percentValue: (promoPlanGraphAndApiCountShowModel.totalDeployed/promoTransData.length).toDouble(),
                            percentText: promoPlanGraphAndApiCountShowModel.totalDeployed.toString()),
                      )
                  ),
                  Expanded(
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            // currentSelectedValue = "No";
                            // searchFilter();
                          });
                        },
                        child: PercentIndicator(
                            isSelected: currentSelectedValue == "No",
                            titleText: "No",
                            percentColor: MyColors.backbtnColor,
                            isIcon: true,
                            iconData: Icons.warning_amber_rounded,
                            percentValue: (promoPlanGraphAndApiCountShowModel.totalNotDeployed/promoTransData.length).toDouble(),
                            percentText: promoPlanGraphAndApiCountShowModel.totalNotDeployed.toString()),
                      )
                  ),
                  Expanded(
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            // currentSelectedValue = "Pending";
                            // searchFilter();
                          });
                        },
                        child: PercentIndicator(
                            isSelected: currentSelectedValue == "Pending",
                            titleText: "Pending",
                            percentColor: MyColors.warningColor,
                            isIcon: true,
                            iconData: Icons.pending,
                            percentValue: (promoPlanGraphAndApiCountShowModel.totalPending/promoTransData.length).toDouble(),
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

              promoTransData.isEmpty ? const Center(child: Text("No Data Available"),)
                  : ListView.builder(
                  itemCount: promoTransData.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                return PromoPlanCard(
                  modalImage: "${imageBaseUrl}modal_pictures/${promoTransData[index].modalImage}",
                  isBtnLoading:isBtnLoading,
                  actStatus: promoTransData[index].actStatus,
                  promoReason: promoTransData[index].promoReason == "1" ? 'Out Of Stock' : promoTransData[index].promoReason ,
                  promoStatus: promoTransData[index].promoStatus,
                  skuName: promoTransData[index].skuEnName,
                  skuImage: "${imageBaseUrl}sku_pictures/${promoTransData[index].skuImageName}",
                  categoryName: promoTransData[index].catEnName,
                  brandName: promoTransData[index].brandEnName,
                  fromDate: promoTransData[index].promoFrom,
                  toDate: promoTransData[index].promoTo,
                  osdType: promoTransData[index].osdType,
                  pieces: promoTransData[index].quantity.toString(),
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
                    print(promoTransData[index].promoStatus);
                    setState(() {});
                  },
                  reasonValue: (value) {

                    if(promoTransData[index].actStatus == 1 && promoTransData[index].promoReason != value) {
                      if(value == 'Out Of Stock') {
                        promoTransData[index].promoReason = "1";
                      }
                      promoTransData[index].gcsStatus = 0;
                      savePromoPlanImage(false, index);
                    } else {

                      if(value == 'Out Of Stock') {
                        promoTransData[index].promoReason = "1";
                      }
                    }
                    print(promoTransData[index].promoReason);
                    setState(() {});
                  },
                  onSelectImage: (){
                    getImage(index);
                  },
                  onSaveClick: (){
                    savePromoPlanImage(true, index);
                  },
                );
              }),
            ),
          ],
        ),
      )
    );
  }
}
