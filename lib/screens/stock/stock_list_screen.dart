import 'package:cstore/Model/database_model/trans_stock_model.dart';
import 'package:cstore/screens/stock/widget/stock_list_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/sys_brand_model.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class StockListScreen extends StatefulWidget {
  static const routeName = "/StockListScreen";

  const StockListScreen({super.key});

  @override
  State<StockListScreen> createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  List<TransStockModel> transData = [];
  List<TransStockModel> filterTransData = [];
  List<TextEditingController> promoController = [];
  List<TextEditingController> regularController = [];
  bool isLoading = false;
  bool isFilter = false;
  String workingId = "";
  String clientId = "";
  String imageBaseUrl = "";
  late String pro_client_id = "0";
  String storeName = "";
  String UserId = "";
  bool isBtnLoading = false;
  final languageController = Get.put(LocalizationController());
  int cases = 0;
  int outer = 0;
  int pieces = 0;
  int skuId = 0;
  int selectedClientId = -1;
  int selectedCategoryId = -1;
  int selectedSubCategoryId = -1;
  int selectedBrandId = -1;
  bool isCategoryLoading = false;
  bool isSubCategoryLoading = false;
  bool isBrandLoading = false;
  late ClientModel initialClientItem;
  late CategoryModel initialCategoryItem;
  late CategoryModel initialSubCategoryItem;
  late SYS_BrandModel initialBrandItem;
  final GlobalKey<FormFieldState> clientKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> subCategoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> brandKey = GlobalKey<FormFieldState>();
  List<ClientModel> clientData = [];
  List<CategoryModel> categoryData = [
    CategoryModel(client: -1, id: -1, en_name: '', ar_name: '')
  ];
  List<CategoryModel> subCategoryData = [
    CategoryModel(client: -1, id: -1, en_name: '', ar_name: '')
  ];
  List<SYS_BrandModel> brandData = [
    SYS_BrandModel(client: -1, id: -1, en_name: '', ar_name: '')
  ];
  TotalStockCountData countData=TotalStockCountData(total_stock_taken: 0,
      total_not_upload: 0, total_uploaded: 0,total_cases: 0,total_outers: 0,total_pieces: 0);

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
       UserId = sharedPreferences.getString(AppConstants.userName)!;
       imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;
       getTransStockOne();

     });
    getClientData();
    getStockCount();
  }
  Future<void> getTransStockOne() async {
    await DatabaseHelper.getDataListStock(
            workingId,
            selectedClientId.toString(),
            clientId,
            selectedBrandId.toString(),
            selectedCategoryId.toString(),
            selectedSubCategoryId.toString())
        .then((value) async {
      transData = value;
      setState(() {});
    });
  }
  void InsertTransStock(String cases, String outer,String pieces, skuId,pro_client_id) async {

    try {
      if (cases.isEmpty && outer.isEmpty && pieces.isEmpty) {
        showAnimatedToastMessage("Error!".tr, "Please add stock data".tr, false);
        return;
      }
      if (cases == "0" && outer == "0" && pieces == "0") {
        showAnimatedToastMessage("Error!".tr, "Please add stock data".tr, false);
        return;
      }
      setState(() {
        isBtnLoading = false;
      });
      String timeStamp = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      String currentUserTimeStamp = "${UserId}_$timeStamp";
      print(currentUserTimeStamp);
      await DatabaseHelper.insertTransStockeCheck(
        skuId,
        int.parse(cases),
        int.parse(outer),
        int.parse(pieces),
        workingId,
        currentUserTimeStamp,
        pro_client_id,)
          .then((_) {
        showAnimatedToastMessage("Success".tr, "Data Saved Successfully".tr, true);
        cases = "";
        outer = "";
        pieces = "";
        Navigator.of(context).pop();
        getTransStockOne();
        getStockCount();
      });
    } catch (e) {
      showAnimatedToastMessage("Error!".tr, e.toString(), false);
    }
  }
  void getClientData() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getVisitClientList(clientId).then((value) {
      setState(() {
        isLoading = false;
      });
      clientData = value;
      clientData.insert(
          0, ClientModel(client_id: -1, client_name: "Select Client"));
      categoryData.insert(
          0,
          CategoryModel(
              en_name: "Select Category",
              ar_name: "Select Category",
              id: -1,
              client: -1));
      subCategoryData.insert(
          0,
          CategoryModel(
              en_name: "Select Sub Category",
              ar_name: "Select Sub Category",
              id: -1,
              client: -1));
      brandData.insert(
          0,
          SYS_BrandModel(
              en_name: "Select Brand",
              ar_name: "Select Brand",
              id: -1,
              client: -1));

      initialClientItem = clientData[0];
      initialCategoryItem = categoryData[0];
      initialSubCategoryItem = subCategoryData[0];
      initialBrandItem = brandData[0];
    });
    print(clientData[0].client_name);
  }
  void getCategoryData(int clientId, StateSetter menuState) async {
    categoryKey.currentState!.reset();
    selectedCategoryId = -1;
    menuState(() {
      isCategoryLoading = true;
    });

    await DatabaseHelper.getCategoryList(selectedClientId).then((value) {
      categoryData = value;
      categoryData.insert(
          0,
          CategoryModel(
              en_name: "Select Category",
              ar_name: "Select Category",
              id: -1,
              client: -1));

      initialCategoryItem = categoryData[0];
      menuState(() {
        isCategoryLoading = false;
      });
    });
    print(categoryData[0].en_name);
  }
  void getSubCategoryData(int clientId, StateSetter menuState) async {
    subCategoryKey.currentState!.reset();
    selectedSubCategoryId = -1;
    menuState(() {
      isSubCategoryLoading = true;
    });

    await DatabaseHelper.getSubCategoryList(selectedClientId,selectedCategoryId.toString()).then((value) {
      subCategoryData = value;
      subCategoryData.insert(
          0,
          CategoryModel(
              en_name: "Select Sub Category",
              ar_name: "Select Sub Category",
              id: -1,
              client: -1));

      initialSubCategoryItem = subCategoryData[0];
      // print(jsonEncode(subCategoryData));
      menuState(() {
        isSubCategoryLoading = false;
      });
    });
  }
  void getBrandData(int clientId, StateSetter menuState) async {
    brandKey.currentState!.reset();
    selectedBrandId = -1;
    menuState(() {
      isBrandLoading = true;
    });

    await DatabaseHelper.getBrandList(selectedClientId,selectedCategoryId.toString(),selectedSubCategoryId.toString()).then((value) {
      brandData = value;

      brandData.insert(
          0,
          SYS_BrandModel(
              en_name: "Select Brand",
              ar_name: "Select Brand",
              id: -1,
              client: -1));

      initialBrandItem = brandData[0];
      menuState(() {
        isBrandLoading = false;
      });
    });
  }
  getStockCount()async {
    await DatabaseHelper.getStockCount(  workingId,
        selectedClientId.toString(),
        selectedBrandId.toString(),
        selectedCategoryId.toString(),
        selectedSubCategoryId.toString()).then((value) {
      countData = value;
      setState(() {
      });
    });
  }

  searchFilter() {
    if(isFilter) {
      isFilter = false;
    } else {
      isFilter = true;

      filterTransData =
          transData.where((element) => element.act_status == 1).toList();
    }
    setState(() {

    });
  }


  @override
  void dispose() {
    for (var element in promoController) {
      element.dispose();
    }
    for (var element in regularController) {
      element.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: generalAppBar(context, storeName, UserId, (){
        Navigator.of(context).pop();
      }, true, true, false,(int getClient, int getCat, int getSubCat, int getBrand) {

        setState(() {
          isFilter = false;
        });

        selectedClientId = getClient;
        selectedCategoryId = getCat;
        selectedSubCategoryId = getSubCat;
        selectedBrandId = getBrand;

        getTransStockOne();

        setState(() {

        });
        Navigator.of(context).pop();
      }),

      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(children: [
          Row(
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
                            Text("Sku's".tr),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(FontAwesomeIcons.layerGroup,color: MyColors.savebtnColor,)),
                            Text("${countData.total_stock_taken}"),

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
                             Text("CA's".tr),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(FontAwesomeIcons.box,color: MyColors.savebtnColor,)),
                            Text("${countData.total_cases}"),

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
                            Text("OUs".tr,),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(FontAwesomeIcons.boxesStacked,color: MyColors.savebtnColor,)),
                            Text("${countData.total_outers}"),

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
                            Text("PCs".tr,),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(FontAwesomeIcons.cubesStacked,color: MyColors.savebtnColor,)),
                            Text("${countData.total_pieces}"),

                          ],
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
          isLoading
              ? const Expanded(
                  child: Center(
                    child: MyLoadingCircle(),
                  ),
                )
              : isFilter ? filterTransData.isEmpty ? const Center(child: Text("No Data Found"),) :
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: filterTransData.length,
                itemBuilder: (ctx, i) {
                  promoController.insert(i, TextEditingController());
                  regularController.insert(i, TextEditingController());
                  promoController[i].text = filterTransData[i].cases.toString();
                  regularController[i].text = filterTransData[i].outer.toString();
                  return StockListCard(
                      onDeleteTap: () {
                        deleteStockData(filterTransData[i].pro_id);
                      },
                      image:"${imageBaseUrl}sku_pictures/${filterTransData[i].img_name}",
                      proName:filterTransData[i].pro_en_name,
                      pieces: filterTransData[i].pieces,
                      actStatus: filterTransData[i].act_status,
                      cases: filterTransData[i].cases,
                      outer: filterTransData[i].outer,
                      rsp: filterTransData[i].rsp,
                      stockCheckValues: (String cases,String outer,String pieces){
                        InsertTransStock(cases,outer,pieces,filterTransData[i].pro_id,filterTransData[i].client_id);
                      });
                }),
          )
              : transData.isEmpty
                  ?  Center(
                      child: Text("No Data Found".tr),
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: transData.length,
                          itemBuilder: (ctx, i) {
                            promoController.insert(i, TextEditingController());
                            regularController.insert(i, TextEditingController());
                            promoController[i].text = transData[i].cases.toString();
                            regularController[i].text = transData[i].outer.toString();
                            return StockListCard(
                                onDeleteTap: (){
                                  deleteStockData(transData[i].pro_id);
                                },
                                image:"${imageBaseUrl}sku_pictures/${transData[i].img_name}",
                                proName:languageController.isEnglish.value? transData[i].pro_en_name : transData[i].pro_ar_name,
                                pieces: transData[i].pieces,
                                actStatus: transData[i].act_status,
                                cases: transData[i].cases,
                                outer: transData[i].outer,
                                rsp: transData[i].rsp,
                                stockCheckValues: (String cases,String outer,String pieces){
                                  InsertTransStock(cases,outer,pieces,transData[i].pro_id,transData[i].client_id);
                            });
                          }),
                    ),
        ]),
      ),
    );
  }

  deleteStockData(int proId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(
            "Are you sure you want to delete this item Permanently".tr,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          actions: [
            TextButton(
              child:  Text("No".tr),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child:  Text("Yes".tr),
              onPressed: () async {

                await DatabaseHelper.updateTransStockAfterDeleteOneSkuRecord(workingId,proId.toString()).then((value) {
                  setState(() {
                    int transIndex = transData.indexWhere((element) => element.pro_id == proId);

                    if(filterTransData.isNotEmpty) {
                      int filteredIndex = filterTransData.indexWhere((element) => element.pro_id == proId);

                      filterTransData[filteredIndex].cases = 0;
                      filterTransData[filteredIndex].outer = 0;
                      filterTransData[filteredIndex].pieces = 0;
                      filterTransData[filteredIndex].act_status = 0;
                    }
                    transData[transIndex].cases = 0;
                    transData[transIndex].outer = 0;
                    transData[transIndex].pieces = 0;
                    transData[transIndex].act_status = 0;

                  });
                  // ToastMessage.succesMessage(context, "Data deleted Successfully");
                  Navigator.of(context).pop();
                });
              },
            )
          ],
        );
      },
    );
  }

}
