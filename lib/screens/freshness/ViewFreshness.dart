import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/sys_brand_model.dart';
import '../../Model/database_model/trans_freshness_model.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';
import 'widgets/ViewFreshnesscard.dart';

class ViewFreshness_Screen extends StatefulWidget {
  static const routeName = "/FreshnessViewScreen";

  const ViewFreshness_Screen({super.key});

  @override
  State<ViewFreshness_Screen> createState() => _ViewFreshness_ScreenState();
}

class _ViewFreshness_ScreenState extends State<ViewFreshness_Screen> {
  String storeEnName = '';
  String storeArName = '';
  final languageController = Get.put(LocalizationController());
  String userName = "";
  String imageBaseUrl = "";
  List<TransFreshnessModel> transData = [];
  bool isLoading = true;
  String workingId = "";
  String clientId = '';

  final GlobalKey<FormFieldState> clientKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> subCategoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> brandKey = GlobalKey<FormFieldState>();

  bool isCategoryLoading = false;
  bool isSubCategoryLoading = false;
  bool isBrandLoading = false;

  int selectedClientId = -1;
  int selectedCategoryId = -1;
  int selectedSubCategoryId = -1;
  int selectedBrandId = -1;

  List<ClientModel> clientData = [];
  List<CategoryModel> categoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  List<CategoryModel> subCategoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  List<SYS_BrandModel> brandData = [SYS_BrandModel( client: -1, id: -1, en_name: '', ar_name: '')];

  late ClientModel initialClientItem;
  late CategoryModel initialCategoryItem;
  late CategoryModel initialSubCategoryItem;
  late SYS_BrandModel initialBrandItem;
  void getClientData() async {
    await DatabaseHelper.getVisitClientList(clientId).then((value) {
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
    getUserData();

    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    storeEnName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;
    getClientData();

    getTransFreshnessOne();

    setState(() {});
  }

  Future<void> getTransFreshnessOne() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getTransFreshnessDataList(workingId,selectedClientId.toString(),selectedBrandId.toString(),selectedCategoryId.toString(),selectedSubCategoryId.toString())
        .then((value) async {
      transData = value.cast<TransFreshnessModel>();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName, () {
        Navigator.of(context).pop();
      }, true, true, false,(int getClient, int getCat, int getSubCat, int getBrand) {

        selectedClientId = getClient;
        selectedCategoryId = getCat;
        selectedSubCategoryId = getSubCat;
        selectedBrandId = getBrand;

        getTransFreshnessOne();

        setState(() {

        });
        Navigator.of(context).pop();
      }),
      body:isLoading? const Center(child: SizedBox(height: 60,width: 60,child: MyLoadingCircle(),)) : transData.isEmpty ? const Center(child: Text("No Data Available"),) : ListView.builder(
          shrinkWrap: true,
          itemCount: transData.length,
          itemBuilder: (ctx, i) {
            return  Padding(
              padding: const EdgeInsets.all(10),
              child: ExpiryCard(
                  onJanTap: (){
                    if(transData[i].jan >0) {
                      resetMonthEntry(
                          transData[i].sku_id, transData[i].year.toString(),
                          "Jan".toString().tr, languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                    }
                    },
                  onFebTap: (){
                    if(transData[i].feb >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Feb".toString().tr,
                                languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                          }
                        },
                  onMarTap: (){
                    if(transData[i].mar >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Mar".toString().tr,
                                languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                          }
                        },
                  onAprTap: (){
                    if(transData[i].apr >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Apr".toString().tr,
                                languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                          }
                        },
                  onMayTap: (){
                    if(transData[i].may >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "May".toString().tr,
                                languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                          }
                        },
                  onJunTap: (){
                    if(transData[i].jun >0) {
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Jun".toString().tr,
                                languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                          }
                        },
                  onJulTap: (){
                    if(transData[i].jul >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Jul".toString().tr,
                                languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                          }
                        },
                  onAugTap: (){
                    if(transData[i].aug >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Aug".toString().tr,
                                languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                          }
                        },
                  onSepTap: (){
                    if(transData[i].sep >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Sep".toString().tr,
                                languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                          }
                        },
                  onOctTap: (){
                    if(transData[i].oct >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Oct".toString().tr,
                                languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                          }
                        },
                  onNovTap: (){
                    if(transData[i].nov >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Nov".toString().tr,
                                languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                          }
                        },
                  onDecTap: (){
                    if(transData[i].dec >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Dec".toString().tr,
                                languageController.isEnglish.value ? transData[i].sku_en_name : transData[i].sku_ar_name);
                          }
                        },
                  sku_id: transData[i].sku_id,
                  year:  transData[i].year.toString(),
                  jan:  transData[i].jan.toString(),
                  feb:  transData[i].feb.toString(),
                  mar:  transData[i].mar.toString(),
                  apr:  transData[i].apr.toString(),
                  may:  transData[i].may.toString(),
                  jun:  transData[i].jun.toString(),
                  jul:  transData[i].jul.toString(),
                  aug:  transData[i].aug.toString(),
                  sep:  transData[i].sep.toString(),
                  oct:  transData[i].oct.toString(),
                  nov:  transData[i].nov.toString(),
                  dec:  transData[i].dec.toString(),
                  sku_en_name: languageController.isEnglish.value ? transData[i].sku_en_name:transData[i].sku_ar_name,
                   imageName:  "${imageBaseUrl}sku_pictures/${transData[i].imgName}",),
            );
          }),
    );
  }

  resetMonthEntry(int skuId,String year,String month,String skuName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text("Reset Freshness".tr),
          content:  Text('${"Are you sure you want to reset".tr} $month $year ${"for".tr} $skuName?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:  Text('No'.tr),
            ),
            TextButton(
              onPressed: ()async {
                  await DatabaseHelper.updateFreshnessAfterResetLocalData(workingId,skuId,month,year).then((value) {
                    Navigator.of(context).pop();
                    getTransFreshnessOne();

                  });
              },
              child: Text('Yes'.tr),
            ),
          ],
        );
      },
    );
  }


}
