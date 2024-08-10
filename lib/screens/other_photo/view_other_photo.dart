

import 'dart:io';

import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/get_trans_photo_model.dart';
import '../utils/app_constants.dart';
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

  void setTransPhoto() {
    for (var trans in transData) {
      String imageName = trans.img_name;

      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.img_name)) {
          trans.imageFile = _imageFiles[i];
        }
        print(_imageFiles[i].path.endsWith(trans.img_name));
      }
      print("++++++++++++++++++Other Check Status++++++++");
      print(transData);
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
        ToastMessage.errorMessage(context, "Permissing denied");
      }
    } catch (e) {
      ToastMessage.errorMessage(context, "Permissing denied");
    }
  }

  void deletePhoto(int recordId, String imgName) async {
    await DatabaseHelper.deleteOneRecord(TableName.tbl_trans_photo, recordId)
        .then((_) async {
      await deleteImageFromLocal(imgName).then((_) {
        _loadImages();
        getTransPhotoOne();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:MyColors.background ,
      appBar: generalAppBar(context, storeName, userName, (){
        Navigator.of(context).pop();
      }, (){print("filter Click");}, true, false, false),
      body: isLoading
          ? const Center(
        child: MyLoadingCircle(),
      )
          : transData.isEmpty
          ? const Center(
        child: Text("No data found"),
      )
          : ListView.builder(
          itemCount: transData.length,
          itemBuilder: (ctx, i) {
            return Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 96,
                          height: 100,
                          padding: const EdgeInsets.all(6),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6.0),
                                bottomLeft: Radius.circular(6.0),
                                topRight: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0),
                              ), // Image border
                              child: FittedBox(
                                  fit: BoxFit.cover, child: Image.file(transData[i].imageFile as File))),
                        ),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("assets/icons/client_icon.png"),
                                  const SizedBox(width: 10,),
                                  Expanded(child: Text(transData[i].clientName,overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500)))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/Component 13.svg",
                                    width: 10,
                                    height: 12,
                                  ),
                                  const SizedBox(width: 5,),
                                  Expanded(child: Text(transData[i].categoryEnName,overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500)))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("assets/icons/pick_list_icon_blue.png",width: 14,height: 14,),
                                  const SizedBox(width: 5,),
                                  Expanded(child: Text(transData[i].type_en_name,overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),))
                                ],
                              ),
                            ],
                          ),
                        ),

                        Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        "Are you sure you want to delete this item Permanently",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text("No"),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () {
                                            deletePhoto(transData[i].trans_photo_type_id,
                                                transData[i].img_name);
                                            Navigator.of(context).pop(true);
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );

                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          // Icon(
                          //   Icons.delete,
                          //   color: Colors.red,
                          // ),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: MyColors.appMainColor,
                            borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(10))),
                        child: Text(
                          DateFormat('hh:mm aa').format(DateTime.parse(transData[i].dateTime)),
                          style: const TextStyle(color: MyColors.whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
