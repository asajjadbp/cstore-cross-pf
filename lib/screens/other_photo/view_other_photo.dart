

import 'dart:io';

import 'package:cstore/screens/other_photo/widgets/other_photo_card.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/get_trans_photo_model.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class ViewOtherPhoto extends StatefulWidget {
  static const routename = "view_other_route";
  const ViewOtherPhoto({super.key});

  @override
  State<ViewOtherPhoto> createState() => _ViewOtherPhotoState();
}

class _ViewOtherPhotoState extends State<ViewOtherPhoto> {
  List<File> _imageFiles = [];
  List<GetTransPhotoModel> transData = [];
  bool isLoading = false;
  String workingId = "";
  String storeEnName = '';
  String storeArName = '';
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
    storeEnName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;

    getTransPhotoOne();
  }

  Future<void> getTransPhotoOne() async {
    // setState(() {
    //   isLoading = true;
    // });
    await DatabaseHelper.getTransPhoto(workingId).then((value) async {
      transData = value;
      await _loadImages().then((value) {
        setTransPhoto();
      });
    });
  }

  // void setTransPhoto() {
  //   for (var trans in transData) {
  //     String imageName = trans.img_name;
  //
  //     for (int i = 0; i < _imageFiles.length; i++) {
  //       if (_imageFiles[i].path.endsWith(trans.img_name)) {
  //         trans.imageFile = _imageFiles[i];
  //       }
  //       print(_imageFiles[i].path.endsWith(trans.img_name));
  //     }
  //     print("++++++++++++++++++Other Check Status++++++++");
  //     print(transData);
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  Future<void> setTransPhoto() async {
    for (var trans in transData) {
      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.img_name)) {
          trans.imageFile = _imageFiles[i];
        }
      }

      if(trans.imageFile != null) {
        bool isImageCorrupt = await isImageCorrupted(XFile(trans.imageFile!.path));

        if(isImageCorrupt) {
          trans.imageFile = await convertAssetToFile("assets/images/no_image_found.png");
        }

      } else {
        trans.imageFile = await convertAssetToFile("assets/images/no_image_found.png");
      }
    }
    print("TRANS");
    print(transData);
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
      final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.otherPhoto}';

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

  Future<void> deleteImageFromLocal(String imgName) async {
    try {
      final PermissionStatus permissionStatus = await _getPermission();
      if (permissionStatus == PermissionStatus.granted) {
        final String dirPath = (await getExternalStorageDirectory())!.path;
        final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.otherPhoto}';
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
    await DatabaseHelper.deleteOneRecord(TableName.tblTransPhoto, recordId)
        .then((_) async {
      await deleteImageFromLocal(imgName).then((_) {
        _loadImages();
        getTransPhotoOne();

        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:MyColors.background ,
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName, (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: isLoading
            ? const Center(
          child: MyLoadingCircle(),
        )
            : transData.isEmpty
            ?  Center(
          child: Text("No Data Found".tr),
        )
            : ListView.builder(
            itemCount: transData.length,
            itemBuilder: (ctx, i) {
              return OtherPhotoCard(
                  imageFile: transData[i].imageFile!,
                  clientName: transData[i].clientName,
                  categoryName:  languageController.isEnglish.value ? transData[i].categoryEnName : transData[i].categoryArName,
                  typeName: languageController.isEnglish.value ? transData[i].type_en_name : transData[i].type_ar_name,
                  uploadStatus: transData[i].upload_status,
                  dateTime: transData[i].dateTime,
                  onDeleteTap: () {
                    deletePhoto(transData[i].trans_photo_type_id,transData[i].img_name);
                  });

            }),
      ),
    );
  }
}
