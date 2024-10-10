
import 'package:cstore/screens/Replenishment/widget/replenishmentcard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/pricing_show_model.dart';
import '../../Model/database_model/sys_brand_model.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class ReplenishmentScreen extends StatefulWidget {
  static const routeName = "/ReplenishmentScreen";

  const ReplenishmentScreen({super.key});

  @override
  State<ReplenishmentScreen> createState() => _ReplenishmentScreenState();
}

class _ReplenishmentScreenState extends State<ReplenishmentScreen> {
  List<PricingShowModel> transData = [];
  List<PricingShowModel> filterTransData = [];
  List<TextEditingController> promoController = [];
  List<TextEditingController> regularController = [];

  final languageController = Get.put(LocalizationController());

  String currentSelectedItem = "All";

  bool isLoading = false;
  String workingId = "";
  String clientId = "";
  String imageBaseUrl = "";
  String storeENName = "";
  String storeArName = "";
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
      storeENName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
      storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
      userName = sharedPreferences.getString(AppConstants.userName)!;
      clientId = sharedPreferences.getString(AppConstants.clientId)!;
      imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;
    });

    setState(() {

    });
    print("STORE NAME");
    print(storeENName);
    print(storeArName);
    getTransReplenishment();
    getClientData();
    getReplenishmentCount();
  }
  getReplenishmentCount()async {
    await DatabaseHelper.getReplenishmentCountData(workingId).then((value) {
      countPricing = value;
      setState(() {
      });
    });
  }
  Future<void> getTransReplenishment() async {
    await DatabaseHelper.getDataListReplenishment(workingId,selectedClientId.toString(),clientId,selectedBrandId.toString(),selectedCategoryId.toString(),selectedSubCategoryId.toString(),currentSelectedItem)
        .then((value) async {
        transData = value;
        getReplenishmentCount();
        getReplenishmentCount();
        setState(() {});
    });
  }
  void InsertTransPromoPrice(String regularPrice,String promoPrice,skuId) async {
    try {
      if (regularPrice == "0" || regularPrice == "0.0" || regularPrice.isEmpty) {
        showAnimatedToastMessage("Error!".tr,"Please add proper required pieces".tr, false);
      } else if (promoPrice.isNotEmpty && (double.parse(promoPrice) > double.parse(regularPrice))) {
        showAnimatedToastMessage("Error!".tr,"Picked pieces can't be greater than required pieces".tr, false);
      } else {
        setState(() {
          isBtnLoading = false;
        });
        await DatabaseHelper.insertTransReplenishment(
            skuId, regularPrice.toString(), promoPrice.toString(),'', workingId)
            .then((_) {
          showAnimatedToastMessage("Success".tr, "Data Saved Successfully".tr, true);
          promoPrice = "";
          regularPrice = "";
          Navigator.of(context).pop();
          getTransReplenishment();
          getReplenishmentCount();
        });
      }
    } catch (e) {
      print(e.toString());
      showAnimatedToastMessage("Error!".tr,e.toString(), false);
    }
  }
  void UpdateTransPromoPrice(regularPrice,promoPrice,skuId) async {
    if (regularPrice == "0" || regularPrice == "0.0" || regularPrice.isEmpty) {
      showAnimatedToastMessage("Error!".tr,"Please add proper required pieces".tr, false);
    } else if (promoPrice.isNotEmpty && (double.parse(promoPrice) > double.parse(regularPrice))) {
      showAnimatedToastMessage("Error!".tr,"Picked pieces can't be greater than required pieces".tr, false);
    } else {
    setState(() {
      isBtnLoading = false;
    });
    await DatabaseHelper.updateTransReplenishment(
        skuId, regularPrice.toString(), promoPrice.toString(),'', workingId)
        .then((_) {
      showAnimatedToastMessage("Success".tr,"Data update successfully".tr, true);

      promoPrice = 0;
      regularPrice = 0;
      getTransReplenishment();
      getReplenishmentCount();
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
    if(currentSelectedItem == "All") {
      isFilter = false;
      setState(() {

        getTransReplenishment();

      });
    } else if(currentSelectedItem == "Required") {
      setState(() {
        isFilter = false;

        getTransReplenishment();
      });
    } else {
      setState(() {
        isFilter = false;

        getTransReplenishment();
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
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeENName : storeArName, userName, (){
        Navigator.of(context).pop();
      }, true, true, false,(int getClient, int getCat, int getSubCat, int getBrand) {

        setState(() {
          isFilter = false;
        });

        selectedClientId = getClient;
        selectedCategoryId = getCat;
        selectedSubCategoryId = getSubCat;
        selectedBrandId = getBrand;

        getTransReplenishment();

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
                      setState(() {
                        currentSelectedItem = "All";
                      });
                      searchFilter();
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all( color:  currentSelectedItem == "All" ? MyColors.appMainColor2 : MyColors.whiteColor,width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("All Sku's".tr,maxLines: 1,overflow: TextOverflow.ellipsis,),
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
                      setState(() {
                        currentSelectedItem = "Required";
                      });
                      searchFilter();
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all( color: currentSelectedItem == "Required" ? MyColors.appMainColor2 : MyColors.whiteColor,width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Text("Required".tr,maxLines: 1,overflow: TextOverflow.ellipsis,),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(Icons.pending,color: MyColors.savebtnColor,)),
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
                      setState(() {
                        currentSelectedItem = "Picked";
                      });
                      searchFilter();
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all( color: currentSelectedItem == "Picked" ? MyColors.appMainColor2 : MyColors.whiteColor,width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Text("Picked".tr,maxLines: 1,overflow: TextOverflow.ellipsis,),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(Icons.done,color: MyColors.savebtnColor,)),
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
          ) : isFilter ? filterTransData.isEmpty ? Center(
            child: Text("No Data Found".tr),
          ) : Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: filterTransData.length,
                itemBuilder: (ctx, i) {
                  return pricecheckcard(
                    onDeleteTap: () {
                      deletePriceCheckData(filterTransData[i].pro_id);
                    },
                    image: "${imageBaseUrl}sku_pictures/${filterTransData[i].img_name}",
                    proName: languageController.isEnglish.value ? filterTransData[i].pro_en_name:filterTransData[i].pro_ar_name,
                    regular: filterTransData[i].regular_price,
                    promo:filterTransData[i].promo_price,
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
              ?  Center(
            child: Text("No Data Found".tr),
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
                    onDeleteTap: () {
                      deletePriceCheckData(transData[i].pro_id);
                    },
                    image:
                        "${imageBaseUrl}sku_pictures/${transData[i].img_name}",
                    proName: languageController.isEnglish.value ? transData[i].pro_en_name:transData[i].pro_ar_name,
                    regular: transData[i].regular_price,
                    promo:transData[i].promo_price,
                    pricingValues: (String regular, String promo) {
                      promoController[i].text = promo;
                      regularController[i].text = regular;

                      print("SAVING REPLENISHMENT");
                      print(regular);
                      print(promo);
                      print(transData[i].act_status);


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
  deletePriceCheckData(int proId) {
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

                await DatabaseHelper.deleteTransReplenishment(proId,workingId).then((value) {
                  setState(() {
                    int transIndex = transData.indexWhere((element) => element.pro_id == proId);

                    if(filterTransData.isNotEmpty) {
                      int filteredIndex = filterTransData.indexWhere((element) => element.pro_id == proId);

                      filterTransData[filteredIndex].regular_price = "";
                      filterTransData[filteredIndex].promo_price = "";
                      filterTransData[filteredIndex].act_status = 0;
                    }
                    transData[transIndex].regular_price = "";
                    transData[transIndex].promo_price = "";
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
