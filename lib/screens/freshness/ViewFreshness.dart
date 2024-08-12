import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/sys_brand_model.dart';
import '../../Model/database_model/trans_freshness_model.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/drop_downs.dart';
import '../widget/loading.dart';
import 'ViewFreshnesscard.dart';

class ViewFreshness_Screen extends StatefulWidget {
  static const routeName = "/FreshnessViewScreen";

  const ViewFreshness_Screen({super.key});

  @override
  State<ViewFreshness_Screen> createState() => _ViewFreshness_ScreenState();
}

class _ViewFreshness_ScreenState extends State<ViewFreshness_Screen> {
  String storeName = "";
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

    // setState(() {
    //   isLoading = true;
    // });
    await DatabaseHelper.getVisitClientList(clientId).then((value) {
      // setState(() {
      //   isLoading = false;
      // });
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
    getUserData();

    super.initState();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: generalAppBar(context, storeName, userName, () {
        Navigator.of(context).pop();
      }, () {
        showModalBottomSheet<void>(
          isDismissible: false,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),
          // context and builder are
          // required properties in this widget
          context: context,
          builder: (BuildContext context) {
            // we set up a container inside which
            // we create center column and display text

            // Returning SizedBox instead of a Container
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
                                getSubCategoryData(
                                    selectedClientId, menuState);
                                getBrandData(selectedClientId,menuState);
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
                                  getTransFreshnessOne();
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
      }, true, true, false),
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
                          "Jan".toString(), transData[i].sku_en_name);
                    }
                    },
                  onFebTap: (){
                    if(transData[i].feb >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Feb".toString(),
                                transData[i].sku_en_name);
                          }
                        },
                  onMarTap: (){
                    if(transData[i].mar >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Mar".toString(),
                                transData[i].sku_en_name);
                          }
                        },
                  onAprTap: (){
                    if(transData[i].apr >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Apr".toString(),
                                transData[i].sku_en_name);
                          }
                        },
                  onMayTap: (){
                    if(transData[i].may >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "May".toString(),
                                transData[i].sku_en_name);
                          }
                        },
                  onJunTap: (){
                    if(transData[i].jun >0) {
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Jun".toString(),
                                transData[i].sku_en_name);
                          }
                        },
                  onJulTap: (){
                    if(transData[i].jul >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Jul".toString(),
                                transData[i].sku_en_name);
                          }
                        },
                  onAugTap: (){
                    if(transData[i].aug >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Aug".toString(),
                                transData[i].sku_en_name);
                          }
                        },
                  onSepTap: (){
                    if(transData[i].sep >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Sep".toString(),
                                transData[i].sku_en_name);
                          }
                        },
                  onOctTap: (){
                    if(transData[i].oct >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Oct".toString(),
                                transData[i].sku_en_name);
                          }
                        },
                  onNovTap: (){
                    if(transData[i].nov >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Nov".toString(),
                                transData[i].sku_en_name);
                          }
                        },
                  onDecTap: (){
                    if(transData[i].dec >0){
                            resetMonthEntry(
                                transData[i].sku_id,
                                transData[i].year.toString(),
                                "Dec".toString(),
                                transData[i].sku_en_name);
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
                  sku_en_name:  transData[i].sku_en_name,
                  sku_ar_name:  transData[i].sku_ar_name,
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
          title: const Text("Reset Freshness"),
          content:  Text('Are you sure you want to reset $month $year for $skuName?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: ()async {
                  await DatabaseHelper.updateFreshnessAfterResetLocalData(workingId,skuId,month,year).then((value) {
                    Navigator.of(context).pop();
                    getTransFreshnessOne();

                  });
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }


}
