import 'dart:io';
import 'package:cstore/screens/before_fixing/widgets/before_listng_card_item.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_before_fixing.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class ViewBeforeFixing extends StatefulWidget {
  static const routename = "view_before_route";

  const ViewBeforeFixing({super.key});

  @override
  State<ViewBeforeFixing> createState() => _ViewBeforeFixingState();
}

class _ViewBeforeFixingState extends State<ViewBeforeFixing> {
  List<File> _imageFiles = [];
  List<GetTransBeforeFixing> transData = [];
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
    getTransBeforeFixingOne();
  }

  Future<void> getTransBeforeFixingOne() async {
    await DatabaseHelper.getTransBeforeFixing(workingId).then((value) async {
      transData = value.cast<GetTransBeforeFixing>();
      await _loadImages().then((value) {
        setTransPhoto();
      });
    });
  }

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
      final String folderPath =
          '$dirPath/cstore/$workingId/${AppConstants.beforeFixing}';
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

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.camera.request();
    return permission;
  }

  Future<void> deleteImageFromLocal(String imgName) async {
    try {
      final PermissionStatus permissionStatus = await _getPermission();
      if (permissionStatus == PermissionStatus.granted) {
        final String dirPath = (await getExternalStorageDirectory())!.path;
        final String folderPath = '$dirPath/cstore/$workingId/before_fixing';
        final file = File('$folderPath/$imgName');

        if (await file.exists()) {
          await file.delete();
          print("File deleted: $folderPath/$imgName");
        } else {
          print("File not found: $folderPath/$imgName");
        }
      } else {
        // print('Permission denied');
        ToastMessage.errorMessage(context, "Permissing denied".tr);
      }
    } catch (e) {
      ToastMessage.errorMessage(context, "Permissing denied".tr);
    }
  }

  void deletePhoto(int recordId, String imgName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(
            "Are you sure you want to delete this item Permanently".tr,
            style:const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          actions: [
            TextButton(
              child:  Text("No".tr),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child:  Text("Yes".tr),
              onPressed: () async {
                await DatabaseHelper.deleteOneRecord(
                    TableName.tblTransBeforeFaxing, recordId)
                    .then((_) async {
                  deleteImageFromLocal(imgName).then((_) {
                    _loadImages();
                    getTransBeforeFixingOne();
                    Navigator.of(context).pop(true);
                  });
                });
              },
            )
          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName, (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {
      }),
      body: isLoading
          ? const Center(
              child: MyLoadingCircle(),
            )
          : Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        color: MyColors.background,
        child: transData.isEmpty
                ? const Center(
                    child: Text("No data found"),
                  )
                : ListView.builder(
                    itemCount: transData.length,
                    itemBuilder: (ctx, i) {
                      return BeforeFixingCardItem(
                          imageFile: transData[i].imageFile!,
                          clientName: transData[i].clientName,
                          categoryEnName:languageController.isEnglish.value ? transData[i].categoryEnName : transData[i].categoryArName,
                          uploadStatus: transData[i].upload_status,
                          dateTime: transData[i].dateTime,
                          onDeleteTap: (){
                            deletePhoto(
                                transData[i].id, transData[i].img_name);
                          });
                    }),
          ),
    );
  }
}
