import 'dart:io';
import 'package:cstore/screens/proof_of_sale/widgets/proof_of_sale_card.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/show_proof_of_sale_model.dart';
import '../../Model/database_model/show_trans_osdc_model.dart';
import '../utils/app_constants.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class ShowProofOfSaleScreen extends StatefulWidget {
  static const routename = "view_osdc_route";

  const ShowProofOfSaleScreen({super.key});

  @override
  State<ShowProofOfSaleScreen> createState() => _ShowProofOfSaleScreenState();
}

class _ShowProofOfSaleScreenState extends State<ShowProofOfSaleScreen> {
  List<File> _imageFiles = [];
  List<ShowProofOfSaleModel> transData = [];
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
    await DatabaseHelper.getTransPOS(workingId).then((value) async {
      transData = value;
      await _loadImages().then((value) {
        setTransOSDC();
      });
    });
  }
  void setTransOSDC() {
    for (var trans in transData) {
      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.image_name)) {
          trans.imageFile = _imageFiles[i];
        }
        print(_imageFiles[i].path.endsWith(trans.image_name));
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
      final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.pos}';

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
        final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.pos}';
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
    await DatabaseHelper.deleteOneRecord(TableName.tblTransPOS, recordId)
        .then((_) async {
      await deleteImageFromLocal(imgName).then((_) {
        _loadImages();
        getTransOSDCOne();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FD),
      appBar: generalAppBar(context, storeName, "View POS", (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: isLoading
          ? const Center(
        child: MyLoadingCircle(),
      )
          : transData.isEmpty
          ? const Center(
        child: Text("No data found"),
      )
          : ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          itemCount: transData.length,
          itemBuilder: (ctx, i) {
            return ProofOfSaleCard(
                imageName:transData[i].imageFile as File,
                proName: transData[i].pro_en_name,
                catName: transData[i].cat_en_name,
                name: transData[i].name,
                phone: transData[i].phone,
                amount: transData[i].amount,
                Qty: transData[i].qty,
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
                              deletePhoto(transData[i].id, transData[i].image_name);
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },);

                }, upload_status: transData[i].upload_status,);
          }),
    );
  }
}
