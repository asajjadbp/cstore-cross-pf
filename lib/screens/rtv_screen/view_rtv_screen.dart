import 'dart:io';

import 'package:cstore/screens/rtv_screen/widgets/view_rtv_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_trans_rtv_model.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class viewrtvScreen extends StatefulWidget {
  const viewrtvScreen({super.key});

  @override
  State<viewrtvScreen> createState() => _viewrtvScreenState();
}

class _viewrtvScreenState extends State<viewrtvScreen> {

  final languageController = Get.put(LocalizationController());

  List<File> _imageFiles = [];
  List<ShowTransRTVShowModel> transData = [];
  bool isLoading = false;
  String workingId = "";
  String storeEnName = '';
  String storeArName = '';
  String userName = '';
  String clientId = '';
  String imageBaseUrl = '';

  @override
  void initState() {
    super.initState();
    getStoreDetails();
  }

  getStoreDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    storeEnName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;
    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;
    getTransRTVOne();
  }

  Future<void> getTransRTVOne() async {
    await DatabaseHelper.getTransRTVDataList(workingId, clientId)
        .then((value) async {
      transData = value.cast<ShowTransRTVShowModel>();
      await _loadImages().then((value) {
        print("transDataList");
        print(transData);
        setTransPhoto();
      });
    });
  }

  void setTransPhoto() {
    for (var trans in transData) {
      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.rtv_image)) {
          trans.imageFile = _imageFiles[i];
          print("imagefile check");
          print(_imageFiles[i].path.endsWith(trans.rtv_image));
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
      final String folderPath =
          '$dirPath/cstore/$workingId/${AppConstants.rtv}';
      print("******************");
      print(dirPath);
      final Directory folder = Directory(folderPath);
      if (await folder.exists()) {
        final List<FileSystemEntity> files = folder.listSync();
        _imageFiles = files.whereType<File>().toList();

        print("LoadImages");
        print(_imageFiles);
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

  Future<void> deleteImageFromLocal(String imgName) async {
    try {
      final PermissionStatus permissionStatus = await _getPermission();
      if (permissionStatus == PermissionStatus.granted) {
        final String dirPath = (await getExternalStorageDirectory())!.path;
        final String folderPath = '$dirPath/cstore/$workingId/rtv';
        final file = File('$folderPath/$imgName');

        if (await file.exists()) {
          await file.delete();
          print("File deleted: $folderPath/$imgName");
        } else {
          print("File not found: $folderPath/$imgName");
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
    await DatabaseHelper.deleteOneRecord(TableName.tblTransRtv, recordId)
        .then((_) async {
      _loadImages();
      getTransRTVOne();
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
      body: isLoading
          ? const Center(
              child: MyLoadingCircle(),
            )
          : transData.isEmpty
              ? Center(
                  child: Text("No Data Found".tr),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: transData.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Viewrtvcard(
                      time: transData[i].dateTime,
                      title: languageController.isEnglish.value ? transData[i].pro_en_name : transData[i].pro_ar_name,
                      proImage:
                          "${imageBaseUrl}sku_pictures/${transData[i].pro_image}",
                      rtvImage:transData[i].imageFile as File,
                      type:  languageController.isEnglish.value ? transData[i].reason_en_name : transData[i].reason_ar_name ,
                      piece: transData[i].pieces.toString(),
                      expdate: transData[i].exp_date,
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
                                    label: Text("No".tr),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.check),
                                    label:  Text("Yes".tr),
                                    onPressed: () {
                                      deletePhoto(transData[i].id,transData[i].rtv_image);
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },);

                        }, uploadStatus: transData[i].upload_status,);
                  },
                ),
    );
  }
}
