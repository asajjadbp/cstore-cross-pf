import 'package:cstore/Model/database_model/trans_stock_model.dart';
import 'package:cstore/screens/price_check/pricecheckcad.dart';
import 'package:cstore/screens/stock/stock_list_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/pricing_show_model.dart';
import '../../Model/database_model/sys_brand_model.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/toast/toast.dart';
import '../widget/drop_downs.dart';
import '../widget/loading.dart';
import '../widget/percent_indicator.dart';

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
  late String pro_client_id = "0";
  String storeName = "";
  String UserId = "";
  bool isBtnLoading = false;
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
    print("Insert Data Getting");
    if (cases.isEmpty && outer.isEmpty && pieces.isEmpty) {
      ToastMessage.errorMessage(context, "Please add stock data");
      return;
    }
    if(cases == "0" && outer == "0" && pieces == "0") {
      ToastMessage.errorMessage(context, "Please add stock data");
      return;
    }
      setState(() {
        isBtnLoading = false;
      });
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    String currentUserTimeStamp = "${UserId}_$timeStamp";
    print(currentUserTimeStamp);
      await DatabaseHelper.insertTransStockeCheck(
              skuId, int.parse(cases),int.parse(outer),int.parse(pieces), workingId,currentUserTimeStamp,pro_client_id,)
          .then((_) {
        ToastMessage.succesMessage(context, "Data store successfully");
        cases = "";
        outer = "";
        pieces = "";
        Navigator.of(context).pop();
        getTransStockOne();
        getStockCount();
      });
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

    await DatabaseHelper.getSubCategoryList(selectedClientId).then((value) {
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

    await DatabaseHelper.getBrandList(selectedClientId).then((value) {
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
    isFilter = true;

    filterTransData = transData.where((element) => element.act_status == 1).toList();

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storeName,
              style: const TextStyle(fontSize: 13),
            ),
            const Text(
              "Stock Check",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  isDismissible: false,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(onWillPop: () async {
                      return false;
                    }, child: StatefulBuilder(builder:
                        (BuildContext context1, StateSetter menuState) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.90,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10))),
                        margin: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 10),
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
                                  ElevatedButton(
                                      onPressed: () {
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
                                          initialSubCategoryItem =
                                              subCategoryData[0];
                                          initialBrandItem = brandData[0];
                                        });
                                      },
                                      child: const Text(
                                        "Reset Filter",
                                        style: TextStyle(
                                            color: MyColors.whiteColor),
                                      ))
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
                                  hintText: "Client",
                                  clientData: clientData,
                                  onChange: (value) {
                                    selectedClientId = value.client_id;
                                    initialClientItem = value;
                                    getCategoryData(
                                        selectedClientId, menuState);
                                    getSubCategoryData(
                                        selectedClientId, menuState);
                                    getBrandData(selectedClientId, menuState);
                                    menuState(() {});
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
                                      categoryKey: categoryKey,
                                      hintText: "Category",
                                      categoryData: categoryData,
                                      onChange: (value) {
                                        selectedCategoryId = value.id;
                                        initialCategoryItem = value;
                                        menuState(() {});
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
                                      categoryKey: subCategoryKey,
                                      hintText: "Sub Category",
                                      categoryData: subCategoryData,
                                      onChange: (value) {
                                        selectedSubCategoryId = value.id;
                                        initialSubCategoryItem = value;
                                        menuState(() {});
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
                                  brandKey: brandKey,
                                  hintText: "Brand",
                                  brandData: brandData,
                                  onChange: (value) {
                                    selectedBrandId = value.id;
                                    initialBrandItem = value;
                                    menuState(() {});
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: MyColors.appMainColor,
                                    minimumSize: Size(screenWidth, 45),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                onPressed: () {
                                  getTransStockOne();
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
                    }));
                  },
                );
              },
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: MyColors.whiteColor,
              ))
        ],
      ),
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
                            const Text("Sku's"),
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
                            const Text("CA's"),
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
                            const Text("OUs",),
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
                            const Text("PCs",),
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
                      image:"https://storage.googleapis.com/panda-static/sku_pictures/${filterTransData[i].img_name}",
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
                  ? const Center(
                      child: Text("No data found"),
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
                                image:"https://storage.googleapis.com/panda-static/sku_pictures/${transData[i].img_name}",
                                proName:transData[i].pro_en_name,
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
}
