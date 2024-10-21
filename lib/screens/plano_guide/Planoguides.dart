import 'dart:io';
import 'package:cstore/screens/Language/localization_controller.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/trans_planoguide_model.dart';
import '../ImageScreen/image_screen.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/percent_indicator.dart';
import 'widgets/PlanoguidesCard.dart';
import 'package:path/path.dart' as path;

class Planoguides_Screen extends StatefulWidget {
  static const routename = "Planoguides_Screen";
  const Planoguides_Screen({super.key});
  @override
  State<Planoguides_Screen> createState() => _Planoguides_ScreenState();
}
class _Planoguides_ScreenState extends State<Planoguides_Screen> {
  final languageController = Get.put(LocalizationController());

  bool isLoading = true;
  bool isFilterLoading = true;
  
  List<TransPlanoGuideModel> transData = [];
  List<String> unitList = ['Adhere', 'Not Adhere'];
  String clientId = "";
  String workingId = "";
  String storeEnName = "";
  String storeArName = "";
  String userName = "";
  String imageBaseUrl = "";
  // var imageName = "";
  File? imageFile;
  bool isBtnLoading = false;
  List<File> _imageFiles = [];

  bool isFilter = false;
  List<TransPlanoGuideModel> filteredData = [];
  String currentSelectedValue = "All";

  int isAdhere = 0;
  int isNotAdhere = 0;
  int pendingItems = 0;

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
    imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;

    getTransPlanoGuideOne();
  }

  Future<void> getTransPlanoGuideOne() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getPlanoGuideDataList(workingId).then((value) async {
      print("TRANS PLANOGUIDE");
      print(workingId);
      print(value.length);
      transData = value.cast<TransPlanoGuideModel>();

      isAdhere = transData.where((element) => element.isAdherence == "1").toList().length;
      isNotAdhere = transData.where((element) => element.isAdherence == "0").toList().length;
      pendingItems = transData.where((element) => element.isAdherence == "-1").toList().length;

      await _loadImages().then((value) {
        setTransPhoto();
      });
      setState((){});
    });
  }


  void setTransPhoto() {
    if(isFilter) {
      for (int j = 0; j < filteredData.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if (filteredData[j].imageName.isNotEmpty) {
            if (_imageFiles[i].path.endsWith(filteredData[j].imageName)) {
              setState(() {
                filteredData[j].imageFile = _imageFiles[i];
              });
            }
          }
          print("________________");
          print(filteredData[j].imageName);
          print(filteredData[j].imageFile);
          // print(_imageFiles[i].path.endsWith(trans.skuImageName));
        }
      }
    } else {
      for (int j = 0; j < transData.length; j++) {
        for (int i = 0; i < _imageFiles.length; i++) {
          if (transData[j].imageName.isNotEmpty) {
            if (_imageFiles[i].path.endsWith(transData[j].imageName)) {
              setState(() {
                transData[j].imageFile = _imageFiles[i];
              });
            }
          }
          print("________________");
          print(transData[j].imageName);
          print(transData[j].imageFile);
          // print(_imageFiles[i].path.endsWith(trans.skuImageName));
        }
      }
    }
    setState(() {
      isLoading = false;
      isFilterLoading = false;
    });
  }

  Future<void> _loadImages() async {
    setState(() {
      isLoading = true;
    });
    try {
      final String dirPath = (await getExternalStorageDirectory())!.path;
      final String folderPath =
          '$dirPath/cstore/$workingId/${AppConstants.planoguide}';
      print("******************");
      print(folderPath);
      final Directory folder = Directory(folderPath);
      if (await folder.exists()) {
        final List<FileSystemEntity> files = folder.listSync();
        _imageFiles = files.whereType<File>().toList();
      }
    } catch (e) {
      print('Error reading images: $e');
    }

    // setState(() {});
  }

  Future<void> getImage(int index,List<TransPlanoGuideModel> transDataUpdate) async {
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        return;
      }
      imageFile = value;
      transDataUpdate[index].imageFile = imageFile;

      final String extension = path.extension( transDataUpdate[index].imageFile!.path);
      transDataUpdate[index].skuImageName = "${userName}_${DateTime.now().millisecondsSinceEpoch}$extension";
      if(transDataUpdate[index].activity_status == 1) {
        transDataUpdate[index].gcs_status = 0;
        savePlanoGuideData(index, false,0,transDataUpdate[index]);
      }
      setState(() {

      });
      // _takePhoto(value);
    });
  }


  searchFilteredList() async {
    isFilter = true;
    setState(() {
      isFilterLoading = true;
    });
    if(currentSelectedValue == "Adhere") {

      await DatabaseHelper.getPlanoGuideFilteredDataList(workingId,1,"1").then((value) async {
        print("Filtered PLANOGUIDE");
        print(workingId);
        print(value.length);
        filteredData = value.cast<TransPlanoGuideModel>();

        await _loadImages().then((value) {
          setTransPhoto();
        });
        setState((){});
      });

    } else if(currentSelectedValue == "Not Adhere") {

      await DatabaseHelper.getPlanoGuideFilteredDataList(workingId,1,"0").then((value) async {
        print("Filtered PLANOGUIDE");
        print(workingId);
        print(value.length);
        filteredData = value.cast<TransPlanoGuideModel>();

        await _loadImages().then((value) {
          setTransPhoto();
        });
        setState((){});
      });

    } else if(currentSelectedValue == 'Pending') {

      await DatabaseHelper.getPlanoGuideFilteredDataList(workingId,0,"-1").then((value) async {
        print("Filtered PLANOGUIDE");
        print(workingId);
        print(value.length);
        filteredData = value.cast<TransPlanoGuideModel>();

        await _loadImages().then((value) {
          setTransPhoto();
        });
        setState((){});
      });

    } else {
      isFilter = false;
    }

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
        body: isLoading ? const Center(child: MyLoadingCircle(),) :transData.isEmpty
            ? Center(
          child: Text("No Data Found".tr),
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
                              setState(() {
                                currentSelectedValue = "Adhere";
                                searchFilteredList();
                              });
                            },
                            child: PercentIndicator(
                              isSelected: currentSelectedValue == "Adhere",
                                titleText: "Adhere".tr,
                                isIcon: true,
                                percentColor: MyColors.greenColor,
                                iconData: Icons.check_circle,
                                percentValue: (isAdhere/transData.length).toDouble(),
                                percentText: isAdhere.toString()),
                          )
                      ),
                      Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                currentSelectedValue = "Not Adhere";
                                searchFilteredList();
                              });
                            },
                            child: PercentIndicator(
                              isSelected: currentSelectedValue == "Not Adhere",
                                titleText: "Not Adhere".tr,
                                percentColor: MyColors.backbtnColor,
                                isIcon: true,
                                iconData: Icons.warning_amber_rounded,
                                percentValue: (isNotAdhere/transData.length).toDouble(),
                                percentText: isNotAdhere.toString()),
                          )
                      ),
                      Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                currentSelectedValue = "Pending";
                                searchFilteredList();
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
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isFilter ? isFilterLoading ? const Center(child: CircularProgressIndicator(),) : filteredData.isEmpty ? Center(
                    child: Text("No Data Found".tr),
                  ) : ListView.builder(
                    itemCount: filteredData.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      return PlanoguidesCard(
                        onImageTap: (){
                          // launchUrlOpen("${imageBaseUrl}pog/${filteredData[index].imageName}");
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PdfScreen(type: "PDF",pdfUrl: "${imageBaseUrl}pog/${filteredData[index].imageName}")));
                        },
                        isActivity: filteredData[index].activity_status == 1,
                        fieldValue1:languageController.isEnglish.value ? filteredData[index].cat_en_name : filteredData[index].cat_ar_name,
                        labelName1: "Department".tr,
                        fieldValue2: filteredData[index].pog,
                        labelName2: "Planoguide".tr,
                        unitList: unitList,
                        selectedUnit: (value) {
                          if(value == "Adhere") {
                            filteredData[index].isAdherence = "1";
                           int ind = transData.indexWhere((element) => element.id == filteredData[index].id);

                           transData[ind].isAdherence = "1";
                          } else {
                            filteredData[index].isAdherence = "0";

                            int ind = transData.indexWhere((element) => element.id == filteredData[index].id);
                            transData[ind].isAdherence = "0";
                          }
                          setState(() {

                          });
                        },
                        image: "${imageBaseUrl}pog/${filteredData[index].imageName}",
                        imageFile: filteredData[index].imageFile,
                        onSelectImage: (){
                          getImage(index,filteredData);
                        },
                        context: context,
                        isBtnLoading: isBtnLoading,
                        onSaveClick: (){savePlanoGuideData(index,true,filteredData[index].gcs_status,filteredData[index]);},
                        initialValue: filteredData[index].isAdherence == "-1" ? "" : filteredData[index].isAdherence == "1" ? "Adhere" : "Not Adhere",
                      );
                    },)  : ListView.builder(
          itemCount: transData.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {

                  return PlanoguidesCard(
                    onImageTap: (){

                      // launchUrlOpen("${imageBaseUrl}pog/${transData[index].imageName}");
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PdfScreen(type: "PDF",pdfUrl: "${imageBaseUrl}pog/${transData[index].imageName}")));
                    },
                    isActivity: transData[index].activity_status == 1,
                    fieldValue1:languageController.isEnglish.value ? transData[index].cat_en_name : transData[index].cat_ar_name,
                        labelName1: "Department".tr,
                    fieldValue2: transData[index].pog,
                        labelName2: "POG".tr,
                        unitList: unitList,
                        selectedUnit: (value) {
                          if(value == "Adhere") {
                            transData[index].isAdherence = "1";
                          } else {
                            transData[index].isAdherence = "0";
                          }

                          setState(() {

                          });
                        },
                        image: "${imageBaseUrl}pog/${transData[index].imageName}",
                        imageFile: transData[index].imageFile,
                    onSelectImage: (){
                        getImage(index,transData);
                    },
                      context: context,
                    isBtnLoading: isBtnLoading,
                      onSaveClick: (){savePlanoGuideData(index,true,transData[index].gcs_status,transData[index]);},
                    initialValue: transData[index].isAdherence == "-1" ? "" : transData[index].isAdherence == "1" ? "Adhere" : "Not Adhere",
                  );
          },),
                ),
              ],
            )

    );
  }

  void savePlanoGuideData(int index,bool isMessageShow,int gcsStatus,TransPlanoGuideModel transPlanoGuideModel) async {

      if (transPlanoGuideModel.isAdherence == "-1") {
        if (isMessageShow) {
          showAnimatedToastMessage("Error!".tr, "Please fill the form".tr, false);
        }
        return;
      } else if( transPlanoGuideModel.imageFile == null) {
        if (isMessageShow) {
          showAnimatedToastMessage("Error!".tr, "Please take an image".tr, false);
        }
        return;
      }
      try {
        setState(() {
          isBtnLoading = isMessageShow;
        });
        print("SKU IMAGE NAME");
        print(transPlanoGuideModel.skuImageName);
        await takePicture(
                context,
            transPlanoGuideModel.imageFile,
            transPlanoGuideModel.skuImageName,
                workingId,
                AppConstants.planoguide)
            .then((_) async {
          await DatabaseHelper.updateTransPlanoGuides(
                  gcsStatus,
              transPlanoGuideModel.id,
                  workingId,
                  transPlanoGuideModel.skuImageName,
              transPlanoGuideModel.isAdherence)
              .then((_) {
            if (isMessageShow) {
              showAnimatedToastMessage("Success".tr, "Data Saved Successfully".tr, true);
              print("Update data planoguide successfully");
              transData[index].activity_status = 1;
            }
            isAdhere = transData
                .where((element) => element.isAdherence == "1")
                .toList()
                .length;
            isNotAdhere = transData
                .where((element) => element.isAdherence == "0")
                .toList()
                .length;
            pendingItems = transData
                .where((element) => element.isAdherence == "-1")
                .toList()
                .length;
            searchFilteredList();
            setState(() {
              isBtnLoading = false;
            });
            //imageFile = null;
          });
        });
      } catch (error) {
        showAnimatedToastMessage("Error!".tr, error.toString(), false);
        setState(() {
          isBtnLoading = false;
        });
      }
  }

}
