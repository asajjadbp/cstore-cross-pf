import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_trans_osdc_model.dart';
import '../Gallery/gallery_screen.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import 'widgets/ViewOSDcard.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class ViewOSDC extends StatefulWidget {
  static const routename = "view_osdc_route";

  const ViewOSDC({super.key});

  @override
  State<ViewOSDC> createState() => _ViewOSDCState();
}

class _ViewOSDCState extends State<ViewOSDC> {
  List<File> _imageFiles = [];
  List<GetTransOSDCModel> transData = [];
  List<GetTransImagesOSDCModel> transImagesList = [];
  bool isLoading = true;
  String workingId = "";
  String storeName = '';
  String userName = '';

  final languageController = Get.put(LocalizationController());

  @override
  void initState() {
    super.initState();
    getStoreDetails();
  }
  getStoreDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;

    getTransOSDCOne();
  }
  Future<void> getTransOSDCOne() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getTransOSDC(workingId).then((value) async {
      transData = value;

      getTransOSDImages();

    });
  }

  Future<void> getTransOSDImages() async {

    await DatabaseHelper.getTransOSDCImages(workingId).then((value) async {
      transImagesList = value;
      await _loadImages().then((value) {
        setTransOSDC();
      });

      setState(() {
        isLoading = false;
      });

    });

  }

  Future<void> setTransOSDC() async {
    for (int i = 0; i < transData.length; i++) {
      for (int j = 0; j < transImagesList.length; j++) {
        if (transData[i].id == transImagesList[j].id) {
          for (int k = 0; k < _imageFiles.length; k++) {
            if (_imageFiles[k].path.endsWith(transImagesList[j].imgName)) {
              transData[i].imageFile.add(File(_imageFiles[k].path));
            }
          }
        }
      }

      if (transData[i].imageFile.isEmpty) {
        File assetFile = await convertAssetToFile(
            "assets/images/no_image_found.png");

        transData[i].imageFile.add(assetFile);
      } else {

      for (int k = 0; k < transData[i].imageFile.length; k++) {
        bool isImageCorrupt = await isImageCorrupted(
            XFile(transData[i].imageFile[k].path));

        if (isImageCorrupt) {
          transData[i].imageFile[k] =
          await convertAssetToFile("assets/images/no_image_found.png");
        }
      }
    }

    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadImages() async {
    setState(() {
      isLoading = true;
    });
    try {
      final String dirPath = (await getExternalStorageDirectory())!.path;
      final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.osdc}';

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
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.camera.request();
    return permission;
  }
  Future<void> deleteImageFromLocal(int recordId) async {
    try {



      final PermissionStatus permissionStatus = await _getPermission();
      if (permissionStatus == PermissionStatus.granted) {

        final String dirPath = (await getExternalStorageDirectory())!.path;
        final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.osdc}';

        for(int i = 0; i<transImagesList.length; i++) {
          String imgName = transImagesList[i].imgName;

          if(transImagesList[i].id == recordId) {

            final file = File('$folderPath/$imgName');
            if (await file.exists()) {
              await file.delete();
              print("File deleted: $folderPath/$imgName");
            } else {
              print("File not found: $folderPath/$imgName");
            }

          }
        }

      } else {
        // print('Permission denied');
        ToastMessage.errorMessage(context, "Permission denied".tr);
      }
    } catch (e) {
      ToastMessage.errorMessage(context, "Permission denied".tr);
    }
  }
  void deletePhoto(int recordId, String imgName) async {
    await DatabaseHelper.deleteOneRecord(TableName.tblTransOsdc, recordId)
        .then((_) async {
      await deleteImageFromLocal(recordId).then((_) {
        _loadImages();
        getTransOSDCOne();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FD),
      appBar: generalAppBar(context, storeName, userName, (){
        Navigator.of(context).pop();
      },  true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: isLoading
          ? const Center(
              child: MyLoadingCircle(),
            )
          : transData.isEmpty
              ? const Center(
                  child: Text("No Data Found"),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 15),
                  shrinkWrap: true,
                  itemCount: transData.length,
                  itemBuilder: (ctx, i) {
                    return ViewOSDcard(
                      onImageClick: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NearestStoreGalleryScreen(imagesList: transData[i].imageFile))).then((value) {
                          print("OSDC Screen Loading");
                          getTransOSDCOne();
                        });
                      },
                      uploadStatus: transData[i].upload_status,
                      imageName: transData[i].imageFile,
                      brandName: languageController.isEnglish.value ? transData[i].brand_en_name : transData[i].brand_ar_name,
                      icon1: "assets/icons/Component 13.svg",
                      OSDCReason: languageController.isEnglish.value ? transData[i].reason_en_name : transData[i].reason_ar_name,
                      icon2: "assets/icons/Masseage.svg",
                      OSDCType: languageController.isEnglish.value ? transData[i].type_en_name : transData[i].type_ar_name,
                      icon3: "assets/icons/Handplus.svg",
                      Qty: transData[i].quantity,
                      onDelete: (){
                        showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:  Text("Are you sure you want to delete this item Permanently".tr,
                              style:const TextStyle(
                                fontSize: 13,
                              ),),
                              actions: [
                                TextButton.icon(
                                  icon: const Icon(Icons.cancel_outlined),
                                  label:  Text("No".tr),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.check),
                                  label:  Text("Yes".tr),
                                  onPressed: () {
                                    deletePhoto(transData[i].id, transData[i].img_name);
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ],
                            );
                          },);

                      });
                  }),
    );
  }
}
