import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_trans_sos.dart';
import '../utils/app_constants.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/shareofshellshow.dart';

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
  String storeName = '';
  String userName = '';

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
    await DatabaseHelper.deleteOneRecord(TableName.tbl_trans_sos, recordId)
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
      appBar: generalAppBar(context, storeName, userName, (){
        Navigator.of(context).pop();
      }, (){print("filter Click");}, true, false, false),
      body: transData.isEmpty ? const Center(child: Text("No Data Available"),) : ListView.builder(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          shrinkWrap: true,
          itemCount: transData.length,
          itemBuilder: (ctx, i) {
            return shareofshellshow(
              catName: transData[i].cat_en_name,
              total: transData[i].total_cat_space,
              actual: transData[i].actual_space,
              unit: transData[i].unit,
              brandName: transData[i].brand_en_name,
            );
          }),
    );
  }
}
