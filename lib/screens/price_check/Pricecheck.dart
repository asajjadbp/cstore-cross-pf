import 'package:cstore/screens/price_check/pricecheckcad.dart';
import 'package:flutter/material.dart';
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

class PriceCheck_Screen extends StatefulWidget {
  static const routeName = "/priceCheck_screen";

  const PriceCheck_Screen({super.key});

  @override
  State<PriceCheck_Screen> createState() => _PriceCheck_ScreenState();
}

class _PriceCheck_ScreenState extends State<PriceCheck_Screen> {
  List<PricingShowModel> transData = [];
  List<TextEditingController> promoController = [];
  List<TextEditingController> regularController = [];
  bool isLoading = false;
  String workingId = "";
  String clientId = "";
  String storeName = "";
  bool isBtnLoading = false;
  int promoPrice=0;
  int regularPrice=0;
  int skuId=0;
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
   PricingCountModel countPricing=PricingCountModel(total_pricing: 0);
  final GlobalKey<FormFieldState> clientKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> subCategoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> brandKey = GlobalKey<FormFieldState>();
  List<ClientModel> clientData = [];
  List<CategoryModel> categoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  List<CategoryModel> subCategoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  List<SYS_BrandModel> brandData = [SYS_BrandModel( client: -1, id: -1, en_name: '', ar_name: '')];
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
    });
    getTransPricingOne();
    getClientData();
    getPricingCount();
  }
  getPricingCount()async {
    await DatabaseHelper.getPricingCountData(workingId).then((value) {
      countPricing = value;
      print("TOTAL total_pricing");
      print(countPricing.total_pricing);
      setState(() {
      });
    });
  }
  Future<void> getTransPricingOne() async {
    await DatabaseHelper.getDataListPriceCheck(workingId,selectedClientId.toString(),selectedBrandId.toString(),selectedCategoryId.toString(),selectedSubCategoryId.toString())
        .then((value) async {
        transData = value;
        setState(() {});
    });
  }
  void InsertTransPromoPrice(String regularPrice,String promoPrice,skuId) async{
    print("Insert Data Getting");
    if (regularPrice == "0" || regularPrice.isEmpty) {
      ToastMessage.errorMessage(context, "Please add proper regular price");
    } else if(promoPrice.isNotEmpty && (int.parse(promoPrice) >= int.parse(regularPrice))) {
      ToastMessage.errorMessage(context, "Promo price can't be greater than or equal to regular price");
    }else {
      setState(() {
        isBtnLoading = false;
      });
      await DatabaseHelper.insertTransPromoPrice(skuId,regularPrice.toString(),promoPrice.toString(),workingId)
          .then((_) {
        ToastMessage.succesMessage(context, "Data store successfully");
        promoPrice="";
        regularPrice="";
        Navigator.of(context).pop();
        getTransPricingOne();
        getPricingCount();
      });
    }
  }
  void UpdateTransPromoPrice(regularPrice,promoPrice,skuId) async {
    print("Update Data Getting");
    if (regularPrice == "0" || regularPrice.isEmpty) {
      ToastMessage.errorMessage(context, "Please add proper regular price");
    } else if(promoPrice.isNotEmpty && (int.parse(promoPrice) >= int.parse(regularPrice))) {
        ToastMessage.errorMessage(context, "Promo price can't be greater than or equal to regular price");
    } else {
    setState(() {
      isBtnLoading = false;
    });
    await DatabaseHelper.updateTransPromoPricing(
        skuId, regularPrice.toString(), promoPrice.toString(), workingId)
        .then((_) {
      ToastMessage.succesMessage(context, "Data update successfully");
      promoPrice = 0;
      regularPrice = 0;
      getTransPricingOne();
      getPricingCount();
      Navigator.of(context).pop();
    });
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
  void dispose() {
    // TODO: implement dispose
    for (var element in promoController) {element.dispose();}
    for (var element in regularController) {element.dispose();}
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:MyColors.background,
      // bottomNavigationBar: Container(
      //   color: MyColors.background,
      //   padding: const EdgeInsets.only(left: 15, right: 15, bottom: 2),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Container(
      //           height: screenHeight / 18,
      //           width: screenWidth / 1.2,
      //           decoration: BoxDecoration(
      //               color: const Color.fromRGBO(26, 91, 140, 1),
      //               borderRadius: BorderRadius.circular(5)),
      //           child: const Row(
      //             children: [
      //               SizedBox(
      //                 width: 15,
      //               ),
      //               Center(
      //                 child: Icon(
      //                   Icons.remove_red_eye_outlined,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //               SizedBox(
      //                 width: 10,
      //               ),
      //               Center(
      //                 child: Text(
      //                   "View",
      //                   style: TextStyle(
      //                       fontSize: 18,
      //                       fontWeight: FontWeight.w400,
      //                       color: Colors.white),
      //                 ),
      //               )
      //             ],
      //           )),
      //     ],
      //   ),
      // ),
      appBar: AppBar(title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(storeName,style: const TextStyle(fontSize: 13),),
          const Text("Price check",style: TextStyle(fontSize: 12),),
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
                                      getTransPricingOne();
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
        padding:  const EdgeInsets.all(5),
        child: Column(children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: PercentIndicator(
                  isSelected: false,
                  titleText: "Total Sku's",
                  isIcon: false,
                  iconData: Icons.add_circle,
                  percentValue: transData.length/transData.length,
                  percentText: transData.length.toString(),
                  percentColor: MyColors.appMainColor,
                ),
              ),
              Expanded(
                child: PercentIndicator(
                  isSelected: false,
                  titleText: "Total Values",
                  isIcon: false,
                  iconData: Icons.add_circle,
                  percentValue: countPricing.total_pricing / 100,
                  percentText:countPricing.total_pricing.toString(),
                  percentColor: MyColors.appMainColor,
                ),
              ),
            ],
          ),
          isLoading
              ? const Expanded(
            child: Center(
              child: MyLoadingCircle(),
            ),
          )
              : transData.isEmpty
              ? const Center(
            child: Text("No data found"),
          )
              :Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: transData.length,
                itemBuilder: (ctx, i) {
                  promoController.insert(i, TextEditingController());
                  regularController.insert(i, TextEditingController());

                  promoController[i].text = transData[i].promo_price;
                  regularController[i].text = transData[i].regular_price;

                  return pricecheckcard(
                    valueControllerPromo: promoController[i],
                    valueControllerRegular: regularController[i],
                    image:
                        "https://storage.googleapis.com/panda-static/sku_pictures/${transData[i].img_name}",
                    proName: transData[i].pro_en_name,
                    regular: transData[i].regular_price,
                    promo:transData[i].promo_price,
                    rsp: transData[i].rsp,
                    pricingValues: (String regular, String promo) {
                      promoController[i].text = promo;
                      regularController[i].text = regular;

                      print(regular);
                      print(promo);


                       if(transData[i].act_status!=1){
                        InsertTransPromoPrice(regular,promo,transData[i].pro_id);
                       } else{
                        UpdateTransPromoPrice(regular,promo,transData[i].pro_id);}

                    }, actStatus: transData[i].act_status,
                  );
                }),
          ),
        ]),
      ),
    );
  }
}
