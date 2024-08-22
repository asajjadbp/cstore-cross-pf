import 'dart:io';
import 'package:cstore/screens/rtv_1+1/view_rtv_one_plus_one.dart';
import 'package:cstore/screens/rtv_screen/widgets/rtv_list_card.dart';
import 'package:cstore/screens/rtv_screen/view_rtv_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/rtv_show_model.dart';
import '../rtv_screen/addnewrtv.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/elevated_buttons.dart';
import '../widget/loading.dart';
import '../widget/search_bottom_sheet.dart';
import 'widgets/1+1_list_ard.dart';
import 'add_new_rtv_1+1.dart';

class RtvOnePlusOneListScreen extends StatefulWidget {
  static const routeName = "/rtvOnePlusOne_screen";
  const RtvOnePlusOneListScreen({super.key});

  @override
  State<RtvOnePlusOneListScreen> createState() =>
      _RtvOnePlusOneListScreenState();
}

class _RtvOnePlusOneListScreenState extends State<RtvOnePlusOneListScreen> {
  List<File> _imageFiles = [];
  List<RTVShowModel> transData = [];
  List<RTVShowModel> filterTransData = [];
  bool isLoading = false;
  bool isFilter = false;
  String workingId = "";
  String userName = "";
  String clientId = "";
  String storeName = '';
  int totalPieces = 0;
  int selectedClientId = -1;
  int selectedCategoryId = -1;
  int selectedSubCategoryId = -1;
  int selectedBrandId = -1;
  String imageBaseUrl = "";
  RTVCountModel rtvCountModel =
      RTVCountModel(total_rtv_pro: 0, total_volume: 0, total_value: 0);

  @override
  void initState() {
    super.initState();
    getStoreDetails();
  }

  getStoreDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      workingId = sharedPreferences.getString(AppConstants.workingId)!;
      storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
      clientId = sharedPreferences.getString(AppConstants.clientId)!;
      userName = sharedPreferences.getString(AppConstants.userName)!;
      imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;
    });
    getTransRTVOne(selectedClientId, selectedCategoryId, selectedSubCategoryId,
        selectedBrandId);
    getRtvCount();
  }

  Future<void> getTransRTVOne(
      int client, int category, int subcategory, int brand) async {
    await DatabaseHelper.getDataListRTVOnePlusOne(
            workingId,
            client.toString(),
            clientId,
            brand.toString(),
            category.toString(),
            subcategory.toString())
        .then((value) async {
      transData = value;
      await _loadImages().then((value) {
        setTransRTV();
        setState(() {});
      });
    });
  }

  void setTransRTV() {
    for (var trans in transData) {
      for (int i = 0; i < _imageFiles.length; i++) {
        if (_imageFiles[i].path.endsWith(trans.img_name)) {
          trans.imageFile = _imageFiles[i];
        }
      }
    }
    totalPieces = transData.length;
    setState(() {
      isLoading = false;
    });
  }

  getRtvCount() async {
    setState(() {});
    await DatabaseHelper.getRTVCountData(
            workingId,
            selectedClientId.toString(),
            selectedBrandId.toString(),
            selectedCategoryId.toString(),
            selectedSubCategoryId.toString())
        .then((value) {
      rtvCountModel = value;
      print("TOTAL PRODUCTS");
      print(rtvCountModel.total_value);
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
      }
    } catch (e) {
      print('Error reading images: $e');
    }

    setState(() {
      isLoading = false;
    });
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
        final String folderPath =
            '$dirPath/cstore/$workingId/${AppConstants.rtv}';
        final file = File('$folderPath/$imgName');

        if (await file.exists()) {
          await file.delete();
          print("File deleted: $folderPath/$imgName");
        } else {
          print("File not found: $folderPath/$imgName");
        }
      } else {
        ToastMessage.errorMessage(context, "Permission denied");
      }
    } catch (e) {
      ToastMessage.errorMessage(context, "Permission denied");
    }
  }

  void deletePhoto(int recordId, String imgName) async {
    await DatabaseHelper.deleteOneRecord(TableName.tblTransOsdc, recordId)
        .then((_) async {
      await deleteImageFromLocal(imgName).then((_) {
        _loadImages();
        getTransRTVOne(selectedClientId, selectedCategoryId,
            selectedSubCategoryId, selectedBrandId);
      });
    });
  }

  searchFilter() {
    setState(() {
      isFilter = true;

      filterTransData =
          transData.where((element) => element.act_status == 1).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: generalAppBar(context, storeName, userName, (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {
        getTransRTVOne(getClient, getCat, getSubCat, getBrand);
        Navigator.of(context).pop();
      }),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      searchFilter();
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("1 + 1 Sku's"),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(
                                  FontAwesomeIcons.layerGroup,
                                  color: MyColors.greenColor,
                                )),
                            Text("${rtvCountModel.total_rtv_pro}"),
                          ],
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      searchFilter();
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("1 + 1 Pieces"),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(
                                  FontAwesomeIcons.cubesStacked,
                                  color: MyColors.savebtnColor,
                                )),
                            Text("${rtvCountModel.total_volume}"),
                          ],
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      searchFilter();
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("RTV Values"),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(
                                  FontAwesomeIcons.circleDollarToSlot,
                                  color: MyColors.savebtnColor,
                                )),
                            Text("${rtvCountModel.total_value}"),
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: MyLoadingCircle(),
                    )
                  : isFilter
                      ? filterTransData.isEmpty
                          ? const Center(
                              child: Text("No data found"),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filterTransData.length,
                              itemBuilder: (ctx, i) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => addnewrtvscreen(
                                          sku_id: filterTransData[i].pro_id,
                                          imageName:
                                          "${imageBaseUrl}sku_pictures/${filterTransData[i].img_name}",
                                          SkuName:
                                              filterTransData[i].pro_en_name,
                                        ),
                                      ),
                                    ).then((value) {
                                      if (isFilter) {
                                        searchFilter();
                                      }
                                      getStoreDetails();
                                      getRtvCount();
                                    });
                                  },
                                  child: Rtvcard(
                                    imageName:
                                    "${imageBaseUrl}sku_pictures/${filterTransData[i].img_name}",
                                    productName: filterTransData[i].pro_en_name,
                                    icon1: const Icon(
                                      Icons.category_rounded,
                                      color: MyColors.appMainColor,
                                    ),
                                    category: filterTransData[i].cat_en_name,
                                    icon2: const Icon(
                                      Icons.account_tree,
                                      color: MyColors.appMainColor,
                                    ),
                                    brandName: filterTransData[i].brand_en_name,
                                    rsp: filterTransData[i].rsp,
                                    skuId: filterTransData[i].pro_id,
                                    activityStatus:
                                        filterTransData[i].act_status,
                                  ),
                                );
                              },
                            )
                      : transData.isEmpty
                          ? const Center(
                              child: Text("No data found"),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: transData.length,
                              itemBuilder: (ctx, i) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddRtvOnePlusOne(
                                        ),
                                      ),
                                    ).then((value) {
                                      getStoreDetails();
                                      getRtvCount();
                                    });
                                  },
                                  child: RtvOnePlusOneListCard(
                                    imageName:
                                    "${imageBaseUrl}sku_pictures/${transData[i].img_name}",
                                    productName: transData[i].pro_en_name,
                                    icon1: const Icon(
                                      Icons.category_rounded,
                                      color: MyColors.appMainColor,
                                    ),
                                    category: transData[i].cat_en_name,
                                    icon2: const Icon(
                                      Icons.account_tree,
                                      color: MyColors.appMainColor,
                                    ),
                                    brandName: transData[i].brand_en_name,
                                    rsp: transData[i].rsp,
                                    skuId: transData[i].pro_id,
                                    activityStatus: transData[i].act_status,
                                  ),
                                );

                              },
                            ),
            ),

            Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
              child: BigElevatedButton(
                  buttonName: "View 1 + 1",
                  submit: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewRtvOnePlusOneScreen(),
                      ),
                    ).then((value) {
                      getStoreDetails();
                      getRtvCount();
                    });
                  },
                  isBlueColor: false),
            )
            // InkWell(
            //   onTap: () {
            //
            //   },
            //   child: Container(
            //
            //     height: screenHeight / 19,
            //     decoration: const BoxDecoration(
            //       color: Color.fromRGBO(91, 149, 75, 1),
            //       borderRadius: BorderRadius.all(Radius.circular(5)),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Container(
            //           margin: const EdgeInsets.only(left: 10),
            //           child: const Text(
            //             ,
            //             style: TextStyle(fontSize: 18, color: Colors.white),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
