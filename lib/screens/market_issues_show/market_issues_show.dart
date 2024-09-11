import 'dart:io';
import 'package:cstore/screens/market_issues_show/widgets/view_market_issue_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_market_issue_model.dart';
import '../../Model/database_model/show_proof_of_sale_model.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class ViewMarketIssueScreen extends StatefulWidget {
  static const routename = "view_market_issue";
  const ViewMarketIssueScreen({super.key});
  @override
  State<ViewMarketIssueScreen> createState() => _ViewMarketIssueScreenState();
}

class _ViewMarketIssueScreenState extends State<ViewMarketIssueScreen> {
  List<File> _imageFiles = [];
  final languageController = Get.put(LocalizationController());
  List<ShowMarketIssueModel> transData = [];
  bool isLoading = false;
  String workingId = "";
  String storeEnName = '';
  String storeArName = '';

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
    getTransMarketIssueOne();
  }
  Future<void> getTransMarketIssueOne() async {
    await DatabaseHelper.getTransMarketIssue(workingId).then((value) async {
      transData = value;
      print("transData is $transData");
      await _loadImages().then((value) {
        setTransMaekeIssue();
      });
    });
  }
  void setTransMaekeIssue() {
    for (var trans in transData) {
      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.image)) {
          trans.imageFile = _imageFiles[i];
        }
        print(_imageFiles[i].path.endsWith(trans.image));
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
      final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.marketIssues}';

      final Directory folder = Directory(folderPath);
      if (await folder.exists()) {
        final List<FileSystemEntity> files = folder.listSync();
        _imageFiles = files.whereType<File>().toList();
      }
    } catch (e) {
      print('Error reading images: $e');
    }
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
        final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.marketIssues}';
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
    await DatabaseHelper.deleteOneRecord(TableName.tblTransMarketIssue, recordId)
        .then((_) async {
      await deleteImageFromLocal(imgName).then((_) {
        _loadImages();
        getTransMarketIssueOne();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FD),
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName:storeArName, "View Market Issue".tr, (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: isLoading
          ? const Center(
        child: MyLoadingCircle(),
      )
          : transData.isEmpty
          ?  Center(
        child: Text("No Data Found".tr),
      )
          : ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          itemCount: transData.length,
          itemBuilder: (ctx, i) {
            return ViewMarketIssueCard(
                imageName:transData[i].imageFile as File,
                comment: transData[i].comment,
                marketIssue: transData[i].Issuetype,
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
                              deletePhoto(transData[i].id, transData[i].image);
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
