import 'dart:io';
import 'package:cstore/screens/rtv_screen/rtv_list_card.dart';
import 'package:cstore/screens/rtv_screen/view_rtv_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
import '../widget/drop_downs.dart';
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
  String clientId = "";
  String otherExcludes = "";
  String storeName = '';
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

    await DatabaseHelper.getSubCategoryList(selectedClientId).then((value) {

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

    await DatabaseHelper.getBrandList(selectedClientId).then((value) {
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
      clientId = sharedPreferences.getString(AppConstants.clientId)!;
      otherExcludes = sharedPreferences.getString(AppConstants.otherExclude)!;
    });
    getClientData();
    getTransRTVOne();
    getRtvCount();
  }
  Future<void> getTransRTVOne() async {

    await DatabaseHelper.getDataListRTV(workingId,selectedClientId.toString(),clientId,otherExcludes,selectedBrandId.toString(),selectedCategoryId.toString(),selectedSubCategoryId.toString()).then((value) async {
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
    await DatabaseHelper.deleteOneRecord(TableName.tbl_trans_osdc, recordId).then((_) async {
      await deleteImageFromLocal(imgName).then((_) {
        _loadImages();
        getTransRTVOne();
      });
    });
  }

  searchFilter() {
    setState(() {
      isFilter = true;

      filterTransData = transData.where((element) => element.act_status == 1).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:MyColors.background,
      appBar: AppBar(title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(storeName,style: const TextStyle(fontSize: 13),),
          const Text("RTV",style: TextStyle(fontSize: 12),),
        ],
      ),
        actions: [
            IconButton(onPressed: (){
              showModalBottomSheet<void>(
                isDismissible: false,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: StatefulBuilder(
                          builder: (BuildContext context1, StateSetter menuState) {

                            return Container(
                              height: MediaQuery.of(context).size.height * 0.90,
                              decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),
                              margin: const EdgeInsets.only(right: 10,left: 10,bottom: 10),
                              child: SingleChildScrollView(

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            "Filter",
                                            style: TextStyle(
                                                color: MyColors.appMainColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ElevatedButton(onPressed: (){
                                          menuState(() {
                                            clientKey.currentState!.reset();
                                            categoryKey.currentState!.reset();
                                            subCategoryKey.currentState!.reset();
                                            brandKey.currentState!.reset();

                                            selectedClientId = -1;
                                            selectedCategoryId = -1;
                                            selectedSubCategoryId = -1;
                                            selectedBrandId = -1;

                                            initialClientItem = clientData[0];
                                            initialCategoryItem = categoryData[0];
                                            initialSubCategoryItem = subCategoryData[0];
                                            initialBrandItem = brandData[0];
                                          });
                                        }, child: const Text("Reset Filter",style: TextStyle(color: MyColors.whiteColor),))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Client",
                                      style: TextStyle(
                                          color: MyColors.appMainColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    // dropdownwidget("Company Name"),
                                    ClientListDropDownWithInitialValue(
                                        clientKey: clientKey,
                                        initialValue: initialClientItem,
                                        hintText: "Client", clientData: clientData, onChange: (value){
                                      selectedClientId = value.client_id;
                                      initialClientItem = value;
                                      getCategoryData(selectedClientId,menuState);
                                      getSubCategoryData(selectedClientId,menuState);
                                      getBrandData(selectedClientId,menuState);
                                      menuState(() {

                                      });
                                    }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Category",
                                      style: TextStyle(
                                          color: MyColors.appMainColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    isCategoryLoading
                                        ? Center(
                                      child: Container(
                                        height: 60,
                                        child: const MyLoadingCircle(),
                                      ),
                                    )
                                        : CategoryDropDownWithInitialValue(
                                        initialValue: initialCategoryItem,
                                        categoryKey:categoryKey,hintText: "Category", categoryData: categoryData, onChange: (value){
                                      selectedCategoryId = value.id;
                                      initialCategoryItem = value;
                                      menuState(() {

                                      });
                                    }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Sub Category",
                                      style: TextStyle(
                                          color: MyColors.appMainColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    isSubCategoryLoading
                                        ? Center(
                                      child: Container(
                                        height: 60,
                                        child: const MyLoadingCircle(),
                                      ),
                                    )
                                        : CategoryDropDownWithInitialValue(
                                        initialValue: initialSubCategoryItem,
                                        categoryKey:subCategoryKey,hintText: "Sub Category", categoryData: subCategoryData, onChange: (value){
                                      selectedSubCategoryId = value.id;
                                      initialSubCategoryItem = value;
                                      menuState(() {

                                      });
                                    }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Brand",
                                      style: TextStyle(
                                          color: MyColors.appMainColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SysBrandDropDownWithInitialValue(
                                        initialValue: initialBrandItem,
                                        brandKey:brandKey,hintText: "Brand", brandData: brandData, onChange: (value){
                                      selectedBrandId = value.id;
                                      initialBrandItem = value;
                                      menuState(() {

                                      });
                                    }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: MyColors.appMainColor,
                                          minimumSize: Size(screenWidth, 45),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5))),
                                      onPressed: () {
                                        getTransRTVOne();
                                        getRtvCount();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Search",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      )
                  );
                },
              );
            },
                icon: const Icon(Icons.filter_alt_outlined,color: MyColors.whiteColor,))
        ],
      ),
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
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          decoration: BoxDecoration(
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            decoration: BoxDecoration(
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
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
                            "https://storage.googleapis.com/panda-static/sku_pictures/${filterTransData[i].img_name}",
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
                      "https://storage.googleapis.com/panda-static/sku_pictures/${filterTransData[i].img_name}",
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
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => addnewrtvscreen(
                                sku_id: transData[i].pro_id,
                                imageName:
                                "https://storage.googleapis.com/panda-static/sku_pictures/${transData[i].img_name}",
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
                          "https://storage.googleapis.com/panda-static/sku_pictures/${transData[i].img_name}",
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
            InkWell(
              onTap: () {
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
              child: Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                height: screenHeight / 19,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(91, 149, 75, 1),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        "View RTVS",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
