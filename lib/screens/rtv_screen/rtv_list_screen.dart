import 'dart:io';
import 'package:cstore/screens/rtv_screen/widgets/rtv_list_card.dart';
import 'package:cstore/screens/rtv_screen/view_rtv_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Database/table_name.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/rtv_show_model.dart';
import '../../Model/database_model/sys_brand_model.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/drop_downs.dart';
import '../widget/elevated_buttons.dart';
import '../widget/loading.dart';
import '../widget/percent_indicator.dart';
import 'addnewrtv.dart';
class Rtv_List_Screen extends StatefulWidget {
  static const routeName = "/rtv_screen";

  const Rtv_List_Screen({super.key});

  @override
  State<Rtv_List_Screen> createState() => _Rtv_List_ScreenState();
}
class _Rtv_List_ScreenState extends State<Rtv_List_Screen> {
  List<File> _imageFiles = [];
  List<RTVShowModel> transData = [];
  List<RTVShowModel> filterTransData = [];
  bool isLoading = false;
  bool isFilter = false;
  String workingId = "";
  String imageBaseUrl = "";
  String clientId = "";
  String storeName = '';
  String userName = '';
  int totalPieces = 0;
  bool isCategoryLoading = false;
  bool isSubCategoryLoading = false;
  bool isBrandLoading = false;
  final GlobalKey<FormFieldState> clientKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> subCategoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> brandKey = GlobalKey<FormFieldState>();
  List<ClientModel> clientData = [];
  List<CategoryModel> categoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  List<CategoryModel> subCategoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  List<SYS_BrandModel> brandData = [SYS_BrandModel( client: -1, id: -1, en_name: '', ar_name: '')];
  int selectedClientId = -1;
  int selectedCategoryId = -1;
  int selectedSubCategoryId = -1;
  int selectedBrandId = -1;

  late ClientModel initialClientItem;
  late CategoryModel initialCategoryItem;
  late CategoryModel initialSubCategoryItem;
  late SYS_BrandModel initialBrandItem;
   RTVCountModel rtvCountModel=RTVCountModel(total_rtv_pro: 0, total_volume: 0, total_value: 0);
  void getClientData() async {

    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getVisitClientList(clientId).then((value) {
      setState(() {
        isLoading = false;
      });
      clientData = value;
      clientData.insert(0,ClientModel(client_id: -1, client_name: "Select Client"));
      categoryData.insert(0, CategoryModel(en_name: "Select Category",ar_name: "Select Category",id: -1, client: -1));
      subCategoryData.insert(0, CategoryModel(en_name: "Select Sub Category",ar_name: "Select Sub Category",id: -1, client: -1));
      brandData.insert(0, SYS_BrandModel(en_name: "Select Brand",ar_name: "Select Brand",id: -1, client: -1));

      initialClientItem = clientData[0];
      initialCategoryItem = categoryData[0];
      initialSubCategoryItem = subCategoryData[0];
      initialBrandItem = brandData[0];

    });
    print(clientData[0].client_name);
  }
  void getCategoryData(int clientId,StateSetter menuState) async {
    categoryKey.currentState!.reset();
    selectedCategoryId = -1;
    menuState(() {
      isCategoryLoading = true;
    });

    await DatabaseHelper.getCategoryList(selectedClientId).then((value) {

      categoryData = value;
      categoryData.insert(0, CategoryModel(en_name: "Select Category",ar_name: "Select Category",id: -1, client: -1));

      initialCategoryItem = categoryData[0];
      menuState(() {
        isCategoryLoading = false;
      });
    });
    print(categoryData[0].en_name);
  }
  void getSubCategoryData(int clientId,StateSetter menuState) async {
    subCategoryKey.currentState!.reset();
    selectedSubCategoryId = -1;
    menuState(() {
      isSubCategoryLoading = true;
    });

    await DatabaseHelper.getSubCategoryList(selectedClientId,selectedCategoryId.toString()).then((value) {

      subCategoryData = value;
      subCategoryData.insert(0, CategoryModel(en_name: "Select Sub Category",ar_name: "Select Sub Category",id: -1, client: -1));

      initialSubCategoryItem = subCategoryData[0];
      // print(jsonEncode(subCategoryData));
      menuState(() {
        isSubCategoryLoading = false;
      });
    });

  }
  void getBrandData(int clientId,StateSetter menuState) async {
    brandKey.currentState!.reset();
    selectedBrandId = -1;
    menuState(() {
      isBrandLoading = true;
    });

    await DatabaseHelper.getBrandList(selectedClientId,selectedCategoryId.toString()).then((value) {
      brandData = value;

      brandData.insert(0, SYS_BrandModel(en_name: "Select Brand",ar_name: "Select Brand",id: -1, client: -1));

      initialBrandItem = brandData[0];
      menuState(() {
        isBrandLoading = false;
      });
    });
  }
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
      userName = sharedPreferences.getString(AppConstants.userName)!;
      clientId = sharedPreferences.getString(AppConstants.clientId)!;
      imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;
    });
    getClientData();
    getTransRTVOne();
    getRtvCount();
  }
  Future<void> getTransRTVOne() async {

    await DatabaseHelper.getDataListRTV(workingId,selectedClientId.toString(),clientId,selectedBrandId.toString(),selectedCategoryId.toString(),selectedSubCategoryId.toString()).then((value) async {
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
    totalPieces=transData.length;
    setState(() {
      isLoading = false;
    });
  }

  getRtvCount()async {
    setState(() {
    });
    await DatabaseHelper.getRTVCountData(workingId,selectedClientId.toString(),selectedBrandId.toString(),selectedCategoryId.toString(),selectedSubCategoryId.toString()).then((value) {
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
      final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.rtv}';
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
        final String folderPath = '$dirPath/cstore/$workingId/${AppConstants.rtv}';
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
    await DatabaseHelper.deleteOneRecord(TableName.tblTransOsdc, recordId).then((_) async {
      await deleteImageFromLocal(imgName).then((_) {
        _loadImages();
        getTransRTVOne();
      });
    });
  }

  searchFilter() {
    if(isFilter) {
      setState(() {
        isFilter = false;
      });
    } else {
      setState(() {
        isFilter = true;


        filterTransData =
            transData.where((element) => element.act_status == 1).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:MyColors.background,
      appBar: generalAppBar(context, storeName, userName, (){
        Navigator.of(context).pop();
      }, true, true, false,(int getClient, int getCat, int getSubCat, int getBrand) {

        setState(() {
          isFilter = false;
        });

        selectedClientId = getClient;
        selectedCategoryId = getCat;
        selectedSubCategoryId = getSubCat;
        selectedBrandId = getBrand;

        getTransRTVOne();

        setState(() {

        });
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
                      onTap: (){
                        searchFilter();
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all( color: isFilter ? MyColors.appMainColor2 : MyColors.whiteColor,width: 3),
                              borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("RTV Sku's"),
                             Container(
                                 margin: const EdgeInsets.symmetric(vertical: 5),
                                 child: const FaIcon(FontAwesomeIcons.layerGroup,color: MyColors.greenColor,)),
                             Text("${rtvCountModel.total_rtv_pro}"),
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                      child: InkWell(
                        onTap: (){
                          searchFilter();
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all( color: isFilter ? MyColors.appMainColor2 : MyColors.whiteColor,width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("RTV Pieces"),
                                Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    child: const FaIcon(FontAwesomeIcons.cubesStacked,color: MyColors.savebtnColor,)),
                                Text("${rtvCountModel.total_volume}"),
                              ],
                            ),
                          ),
                        ),
                      )
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                      child: InkWell(
                        onTap: (){
                          searchFilter();
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all( color: isFilter ? MyColors.appMainColor2 : MyColors.whiteColor,width: 3),
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
                                    child: const FaIcon(FontAwesomeIcons.circleDollarToSlot,color: MyColors.savebtnColor,)),
                                Text("${rtvCountModel.total_value}"),

                              ],
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                    child: MyLoadingCircle(),
                  )
                  : isFilter
                  ? filterTransData.isEmpty ? const Center(
                child: Text("No data found"),
              ) : ListView.builder(
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
                            SkuName: filterTransData[i].pro_en_name,
                          ),
                        ),
                      ).then((value) {
                        if(isFilter) {
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
                      activityStatus: filterTransData[i].act_status,
                    ),
                  );
                },
              )  : transData.isEmpty
                  ? const Center(
                child: Text("No data found"),
              )
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount: transData.length,
                    itemBuilder: (ctx, i) {
                      print( "${imageBaseUrl}sku_pictures/${transData[i].img_name}");
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => addnewrtvscreen(
                                sku_id: transData[i].pro_id,
                                imageName:
                                "${imageBaseUrl}sku_pictures/${transData[i].img_name}",
                                SkuName: transData[i].pro_en_name,
                              ),
                            ),
                          ).then((value) {
                            getStoreDetails();
                            getRtvCount();
                          });
                        },
                        child: Rtvcard(
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
            BigElevatedButton(
                buttonName: "View RTVS",
                submit: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const viewrtvScreen(),
                    ),
                  ).then((value) {
                    getStoreDetails();
                    getRtvCount();

                  });
                },
                isBlueColor: false),

            // InkWell(
            //   onTap: () {
            //
            //   },
            //   child: Container(
            //     margin: const EdgeInsets.only(left: 5, right: 5),
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
            //             "View RTVS",
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
