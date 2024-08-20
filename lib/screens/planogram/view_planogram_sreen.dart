

import 'dart:io';

import 'package:cstore/Model/response_model.dart/adherence_response_model.dart';
import 'package:cstore/screens/planogram/widgets/planogram_item_card.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/widget/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_planogram_model.dart';
import '../utils/app_constants.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';
import 'package:intl/intl.dart';

class ViewPlanogramScreen extends StatefulWidget {
  static const routename = "view_planogram_route";
  const ViewPlanogramScreen({super.key});

  @override
  State<ViewPlanogramScreen> createState() => _ViewPlanogramScreenState();
}

class _ViewPlanogramScreenState extends State<ViewPlanogramScreen> {
  List<File> _imageFiles = [];
  List<ShowPlanogramModel> transData = [];
  AdherenceModel adherenceModel  = AdherenceModel(adhereCount: 0, notAdhereCount: 0);
  bool isLoading = false;
  String workingId = "";
  String storeName = "";
  String userName = "";
  DateTime now = DateTime.now();

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
    getTransPlanogramOne();
    getGraphData();
  }

  Future<void> getGraphData()async {
    await DatabaseHelper.getAdherenceData(workingId).then((value) async {
      adherenceModel = value;
    });
  }

  Future<void> getTransPlanogramOne() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getTransPlanogram(workingId).then((value) async {
      transData = value;
      await _loadImages().then((value) {
        setTransPhoto();
      });
    });
  }

  void setTransPhoto() {
    for (var trans in transData) {

      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.image_name)) {
          trans.imageFile = _imageFiles[i];
        }
        print(_imageFiles[i].path.endsWith(trans.image_name));
      }
      print("++++++++++++++++++Plano Check Status++++++++");
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
      final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.planogram}';

      final Directory folder = Directory(folderPath);
      if (await folder.exists()) {
        final List<FileSystemEntity> files = folder.listSync();
        _imageFiles = files.whereType<File>().toList();
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error reading images: $e');
      setState(() {
        isLoading = false;
      });
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
        final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.planogram}';
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
    await DatabaseHelper.deleteOneRecord(TableName.tblTransPlanogram, recordId)
        .then((_) async {
      await deleteImageFromLocal(imgName).then((_) {
        _loadImages();
        getGraphData();
        getTransPlanogramOne();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: generalAppBar(context, storeName, userName, (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {
      }),
      body: Container(
        margin:const EdgeInsets.symmetric(horizontal: 10),
        child: isLoading
            ? const Center(
          child: MyLoadingCircle(),
        )
            :Column(
          children: [
            Row(
              children: [
                 Expanded(
                   child: PercentIndicator(
                     isSelected: false,
                titleText: "Adherence",
                isIcon: true,
                percentColor: MyColors.greenColor,
                iconData: Icons.check_circle,
                percentValue: adherenceModel.notAdhereCount+ adherenceModel.adhereCount == 0 ? 0 : adherenceModel.adhereCount/(adherenceModel.notAdhereCount+ adherenceModel.adhereCount),
                percentText: adherenceModel.adhereCount.toString())
                 ),
                 Expanded(
                   child: PercentIndicator(
                     isSelected: false,
                      titleText: "Not Adherence",
                      percentColor: MyColors.backbtnColor,
                      isIcon: true,
                      iconData: Icons.warning_amber_rounded,
                      percentValue: adherenceModel.notAdhereCount+ adherenceModel.adhereCount == 0 ? 0 : adherenceModel.notAdhereCount/(adherenceModel.notAdhereCount+ adherenceModel.adhereCount),
                      percentText: adherenceModel.notAdhereCount.toString())
                 )
              ],
            ),
            Expanded(
              child: transData.isEmpty
                  ? const Center(
                child: Text("No data found"),
              )
                  : ListView.builder(
                  itemCount: transData.length,
                  itemBuilder: (ctx, i) {
                    return PlanogramItemCard(
                      uploadStatus: transData[i].upload_status,
                      itemTime: DateFormat('hh:mm aa').format(DateTime.parse(transData[i].dateTime)),
                        reason: transData[i].not_adherence_reason,
                        clientName: transData[i].client_name,
                        brandName: transData[i].brand_en_name,
                        imageFile: transData[i].imageFile as File,
                        isAdherence: transData[i].is_adherence,
                        onDelete: (){
                          showDialog(context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Are you sure you want to delete this item Permanently"),
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
                                      deletePhoto(transData[i].id,
                                          transData[i].image_name);
                                    },
                                  )
                                ],
                              );
                            },);

                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

