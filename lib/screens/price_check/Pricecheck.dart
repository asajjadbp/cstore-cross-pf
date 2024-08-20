import 'package:cstore/screens/price_check/widget/pricecheckcad.dart';
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
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class PriceCheck_Screen extends StatefulWidget {
  static const routeName = "/priceCheck_screen";

  const PriceCheck_Screen({super.key});

  @override
  State<PriceCheck_Screen> createState() => _PriceCheck_ScreenState();
}

class _PriceCheck_ScreenState extends State<PriceCheck_Screen> {
  List<PricingShowModel> transData = [];
  List<PricingShowModel> filterTransData = [];
  List<TextEditingController> promoController = [];
  List<TextEditingController> regularController = [];
  bool isLoading = false;
  String workingId = "";
  String clientId = "";
  String imageBaseUrl = "";
  String storeName = "";
  String userName = "";
  bool isBtnLoading = false;
  bool isFilter = false;
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
   PricingCountModel countPricing=PricingCountModel(total_pricing_products: 0,total_regular_pricing: 0,total_promo_pricing: 0);
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
      userName = sharedPreferences.getString(AppConstants.userName)!;
      clientId = sharedPreferences.getString(AppConstants.clientId)!;
      imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;
    });
    getTransPricingOne();
    getClientData();
    getPricingCount();
  }
  getPricingCount()async {
    await DatabaseHelper.getPricingCountData(workingId,selectedClientId.toString(),selectedBrandId.toString(),selectedCategoryId.toString(),selectedSubCategoryId.toString()).then((value) {
      countPricing = value;
      print("TOTAL total_pricing");
      print(countPricing.total_pricing_products);
      setState(() {
      });
    });
  }
  Future<void> getTransPricingOne() async {
    await DatabaseHelper.getDataListPriceCheck(workingId,selectedClientId.toString(),clientId,selectedBrandId.toString(),selectedCategoryId.toString(),selectedSubCategoryId.toString())
        .then((value) async {
        transData = value;

        getPricingCount();
        setState(() {});
    });
  }
  void InsertTransPromoPrice(String regularPrice,String promoPrice,skuId) async{
    print("Insert Data Getting");
    if (regularPrice == "0" || regularPrice == "0.0" || regularPrice.isEmpty) {
      ToastMessage.errorMessage(context, "Please add proper regular price");
    } else if(promoPrice.isNotEmpty && (double.parse(promoPrice) >= double.parse(regularPrice))) {
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

  searchFilter() {
    if(isFilter) {
      isFilter = false;
      setState(() {

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
  void dispose() {
    // TODO: implement dispose
    for (var element in promoController) {element.dispose();}
    for (var element in regularController) {element.dispose();}
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
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

        getTransPricingOne();

        setState(() {

        });
        Navigator.of(context).pop();
      }),

      body: Padding(
        padding:  const EdgeInsets.all(5),
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
                            const Text("Price Sku's"),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(FontAwesomeIcons.layerGroup,color: MyColors.savebtnColor,)),
                            Text("${countPricing.total_pricing_products}"),

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
                            const Text("Regular Sku's"),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(FontAwesomeIcons.circleDollarToSlot,color: MyColors.savebtnColor,)),
                            Text("${countPricing.total_regular_pricing}"),

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
                            const Text("Promo Sku's",),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(FontAwesomeIcons.bullhorn,color: MyColors.savebtnColor,)),
                            Text("${countPricing.total_promo_pricing}"),

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
          ) : isFilter ? filterTransData.isEmpty ? const Center(
            child: Text("No data found"),
          ) : Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: filterTransData.length,
                itemBuilder: (ctx, i) {
                  return pricecheckcard(
                    image:
                    "${imageBaseUrl}sku_pictures/${filterTransData[i].img_name}",
                    proName: filterTransData[i].pro_en_name,
                    regular: filterTransData[i].regular_price,
                    promo:filterTransData[i].promo_price,
                    rsp: filterTransData[i].rsp,
                    pricingValues: (String regular, String promo) {
                      promoController[i].text = promo;
                      regularController[i].text = regular;

                      print(regular);
                      print(promo);


                      if(filterTransData[i].act_status!=1){
                        InsertTransPromoPrice(regular,promo,filterTransData[i].pro_id);
                      } else{
                        UpdateTransPromoPrice(regular,promo,filterTransData[i].pro_id);}

                    }, actStatus: filterTransData[i].act_status,
                  );
                }),
          ) :
          transData.isEmpty
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
                    image:
                        "${imageBaseUrl}sku_pictures/${transData[i].img_name}",
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
