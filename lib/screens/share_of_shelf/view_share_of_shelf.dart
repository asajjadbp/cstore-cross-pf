import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_trans_sos.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../widget/app_bar_widgets.dart';
import 'widgets/shareofshellshow.dart';

class ViewShareOfShelf extends StatefulWidget {
  static const routename = "view_sos";

  const ViewShareOfShelf({super.key});

  @override
  State<ViewShareOfShelf> createState() => _ViewShareOfShelfState();
}

class _ViewShareOfShelfState extends State<ViewShareOfShelf> {
  List<ShowTransSOSModel> transData = [];
  bool isLoading = false;
  String workingId = "";
  String storeEnName = '';
  String storeArName = '';
  final languageController = Get.put(LocalizationController());
  String userName = '';

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
    getTransSOSOne();
  }

  Future<void> getTransSOSOne() async {
    await DatabaseHelper.getTransSOS(workingId).then((value) async {
      transData = value.cast<ShowTransSOSModel>();
      await _loadImages().then((value) {
        setTransSOS();
      });
    });
  }

  void setTransSOS() {
    for (var trans in transData) {}
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadImages() async {
    setState(() {
      isLoading = true;
    });
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.camera.request();
    return permission;
  }

  void deleteSOS(int recordId) async {
    await DatabaseHelper.deleteOneRecord(TableName.tblTransSos, recordId)
        .then((_) async {
      getTransSOSOne();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FD),
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName, (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: transData.isEmpty ?  Center(child: Text("No Data Found".tr),) : ListView.builder(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          shrinkWrap: true,
          itemCount: transData.length,
          itemBuilder: (ctx, i) {
            return shareofshellshow(
              catName:languageController.isEnglish.value ?  transData[i].cat_en_name: transData[i].cat_ar_name,
              total: transData[i].total_cat_space,
              actual: transData[i].actual_space,
              unit: languageController.isEnglish.value ? transData[i].unitEnName :transData[i].unitArName ,
              brandName: languageController.isEnglish.value ? transData[i].brand_en_name: transData[i].brand_ar_name,
            );
          }),
    );
  }
}
