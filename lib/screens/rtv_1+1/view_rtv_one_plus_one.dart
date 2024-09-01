import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/trans_one_plus_one_mode.dart';
import '../Language/localization_controller.dart';
import 'widgets/view_one_plus_one_card.dart';
import '../utils/app_constants.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class ViewRtvOnePlusOneScreen extends StatefulWidget {
  static const routeName = "/view_onePlusOne";
  const ViewRtvOnePlusOneScreen({super.key});

  @override
  State<ViewRtvOnePlusOneScreen> createState() => _ViewRtvOnePlusOneScreenState();
}

class _ViewRtvOnePlusOneScreenState extends State<ViewRtvOnePlusOneScreen> {
  List<File> _imageFiles = [];
  List<File> _imageFilesDoc = [];
  List<TransOnePlusOneModel> transData = [];
  bool isLoading = false;
  String workingId = "";
  String storeName = '';
  String clientId = '';
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
      clientId = sharedPreferences.getString(AppConstants.clientId)!;
      getTransRTVOne();
  }

  Future<void> getTransRTVOne() async {
    await DatabaseHelper.getTransRTVOnePluOneDataList(workingId)
        .then((value) async {
      transData = value;
      await _loadImages().then((value) {

        setTransPhoto();
        setTransDocImage();
      });
    });
  }

  void setTransPhoto() {
    for (var trans in transData) {
      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.image_name)) {
          print("IMAGE FILE CHECKING");
          print(_imageFiles[i].path);
          trans.imageFile = _imageFiles[i];
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }
  void setTransDocImage() {

    for (var trans in transData) {
      for (int i = 0; i < _imageFilesDoc.length; i++) {
        if (_imageFilesDoc[i].path.endsWith(trans.doc_image)) {

          trans.imageFileDoc = _imageFilesDoc[i];
          print("doc images");
          print(trans.doc_image);
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
          '$dirPath/cstore/$workingId/${AppConstants.onePlusOne}';
      final Directory folder = Directory(folderPath);
      if (await folder.exists()) {
        final List<FileSystemEntity> files = folder.listSync();
        _imageFiles = files.whereType<File>().toList();
        _imageFilesDoc = files.whereType<File>().toList();
      }

    } catch (e) {
      print('Error reading images: $e');
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.camera.request();
    return permission;
  }

  Future<void> deleteImageFromLocal(String imgName,String docImageName) async {
    try {
      final PermissionStatus permissionStatus = await _getPermission();
      if (permissionStatus == PermissionStatus.granted) {
        final String dirPath = (await getExternalStorageDirectory())!.path;
        final String folderPath = '$dirPath/cstore/$workingId/rtv';
        final file = File('$folderPath/$imgName');
        final fileDoc = File('$folderPath/$docImageName');

        if (await file.exists() || await fileDoc.exists()) {
          await file.delete();
          await fileDoc.delete();
          print("File deleted: $folderPath/$imgName");
        } else {
          print("File not found: $folderPath/$imgName");
        }
      } else {
        ToastMessage.errorMessage(context, "Permissing denied");
      }
    } catch (e)
    {
      ToastMessage.errorMessage(context, "Permissing denied");
    }
  }
  void deletePhoto(int recordId, String imgName,String docImageName) async {
    await DatabaseHelper.deleteOneRecord(TableName.tblTransOnePlusOne, recordId)
        .then((_) async {
      await deleteImageFromLocal(imgName,docImageName).then((_) {
        _loadImages();
        getTransRTVOne();
      });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FD),
      appBar: generalAppBar(context, storeName, "View 1 + 1", (){
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
            ? const Center(
          child: Text("No data found"),
        )
            : ListView.builder(
          shrinkWrap: true,
          itemCount: transData.length,
          itemBuilder: (BuildContext context, int i) {
            return ViewrtvOnePlusOnecard(
              time: transData[i].date_time,
              proName: languageController.isEnglish.value ? transData[i].pro_en_name : transData[i].pro_ar_name,
              rtvImage:transData[i].imageFile as File,
              type: transData[i].type,
              piece: transData[i].pieces.toString(),
              onDelete: (){
                showDialog(context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:  Text("Are you sure you want to delete this item Permanently".tr,
                        style: const TextStyle(
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
                            deletePhoto(transData[i].id,transData[i].image_name,transData[i].doc_image);
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },);

              },
              upload_status: transData[i].upload_status,
              docImage: transData[i].imageFileDoc as File,
              docNumber: transData[i].doc_no,
              comment: transData[i].comment,);
          },
        ),
      ),
    );
  }
}
