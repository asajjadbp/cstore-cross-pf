import 'dart:io';
import 'package:cstore/screens/before_fixing/widgets/before_listng_card_item.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_before_fixing.dart';
import '../utils/app_constants.dart';
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

  void setTransPhoto() {
    for (var trans in transData) {
      String imageName = trans.img_name;

      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.img_name)) {
          trans.imageFile = _imageFiles[i];
        }
        print(_imageFiles[i].path.endsWith(trans.img_name));
      }
    }
    print("TRANSASDJJJJJJJJJJJJJJJJ");
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
        ToastMessage.errorMessage(context, "Permissing denied");
      }
    } catch (e) {
      ToastMessage.errorMessage(context, "Permissing denied");
    }
  }

  void deletePhoto(int recordId, String imgName) async {
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
      appBar: generalAppBar(context, storeName, userName, (){
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
                          categoryEnName: transData[i].categoryEnName,
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
