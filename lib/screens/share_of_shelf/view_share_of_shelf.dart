import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_trans_sos.dart';
import '../utils/app_constants.dart';
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

  @override
  void initState() {
    super.initState();
    getStoreDetails();
  }

  getStoreDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(0, 77, 145, 1),
        title: Container(
          padding: EdgeInsets.only(
            top: screenHeight / 70,
          ),
          height: screenHeight / 6,
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenHeight / 110),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Panda 251 King Road",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(
                          height: screenHeight / 200,
                        ),
                        const Text("Share Of shelf Show",
                            style: TextStyle(color: Colors.white, fontSize: 12))
                      ],
                    ),
                  ),
                ],
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.white,
                  ),
                  Text("09 May 2024",
                      style: TextStyle(color: Colors.white, fontSize: 10))
                ],
              ),
            ],
          ),
        ),
      ),
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
