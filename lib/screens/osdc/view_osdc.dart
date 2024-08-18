import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_trans_osdc_model.dart';
import '../utils/app_constants.dart';
import '../utils/toast/toast.dart';
import '../widget/ViewOSDcard.dart';
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
    getTransOSDCOne();
  }
  Future<void> getTransOSDCOne() async {
    // setState(() {
    //   isLoading = true;
    // });
    await DatabaseHelper.getTransOSDC(workingId).then((value) async {
      transData = value;
      await _loadImages().then((value) {
        setTransOSDC();
      });
    });
  }
  void setTransOSDC() {
    for (var trans in transData) {
      String imageName = trans.img_name;

      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.img_name)) {
          trans.imageFile = _imageFiles[i];
        }
        print(_imageFiles[i].path.endsWith(trans.img_name));
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
        ToastMessage.errorMessage(context, "Permissing denied");
      }
    } catch (e) {
      ToastMessage.errorMessage(context, "Permissing denied");
    }
  }
  void deletePhoto(int recordId, String imgName) async {
    await DatabaseHelper.deleteOneRecord(TableName.tbl_trans_osdc, recordId)
        .then((_) async {
      await deleteImageFromLocal(imgName).then((_) {
        _loadImages();
        getTransOSDCOne();
      });
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
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenHeight / 110),
                      child: Icon(Icons.arrow_back),
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
                        const Text("OSD",
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
      body: isLoading
          ? const Center(
              child: MyLoadingCircle(),
            )
          : transData.isEmpty
              ? const Center(
                  child: Text("No data found"),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 15),
                  shrinkWrap: true,
                  itemCount: transData.length,
                  itemBuilder: (ctx, i) {
                    return ViewOSDcard(
                      uploadStatus: transData[i].upload_status,
                      imageName:transData[i].imageFile as File,
                      brandName: transData[i].brand_en_name,
                      icon1: "assets/icons/Component 13.svg",
                      OSDCReason: transData[i].reason_en_name,
                      icon2: "assets/icons/Masseage.svg",
                      OSDCType: transData[i].type_en_name,
                      icon3: "assets/icons/Handplus.svg",
                      Qty: transData[i].quantity,
                      onDelete: (){
                        showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Are you sure you want to delete this item Permanently",
                              style: TextStyle(
                                fontSize: 13,
                              ),),
                              actions: [
                                TextButton.icon(
                                  icon: const Icon(Icons.cancel_outlined),
                                  label: const Text("No"),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.check),
                                  label: const Text("Yes"),
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
