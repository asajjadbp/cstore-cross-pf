import 'package:cstore/screens/freshness/ViewFreshness.dart';
import 'package:cstore/screens/widget/elevated_buttons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/freshness_graph_count.dart';
import '../../Model/database_model/show_freshness_list_model.dart';
import '../../Model/database_model/sys_brand_model.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import 'widgets/freshnesscard.dart';

class Freshness_Screen extends StatefulWidget {
  static const routeName = "/FreshnessListScreen";

  const Freshness_Screen({super.key});

  @override
  State<Freshness_Screen> createState() => _Freshness_ScreenState();
}

class _Freshness_ScreenState extends State<Freshness_Screen> {
  List<FreshnessListShowModel> transData = [];
  List<FreshnessListShowModel> filterTransData = [];
  FreshnessGraphCountShowModel freshnessGraphCountShowModel = FreshnessGraphCountShowModel(totalFreshnessTaken: 0,totalVolume: 0,totalNotUploadCount: 0,totalUploadCount: 0);
  bool isLoading = false;
  bool isFilter = false;
  String workingId = "";
  String userId = "";
  String clientId = "";
  String storeEnName = '';
  String storeArName = '';
  final languageController = Get.put(LocalizationController());
  int totalPieces = 0;
  bool isCategoryLoading = false;
  bool isSubCategoryLoading = false;
  bool isBrandLoading = false;
  String month = "";
  String imageBaseUrl = "";
  int year = 0;
  String pieces = "";
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
  int selectedClientId = -1;
  int selectedCategoryId = -1;
  int selectedSubCategoryId = -1;
  int selectedBrandId = -1;

  late ClientModel initialClientItem;
  late CategoryModel initialCategoryItem;
  late CategoryModel initialSubCategoryItem;
  late SYS_BrandModel initialBrandItem;

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

    await DatabaseHelper.getBrandList(selectedClientId,selectedCategoryId.toString()).then((value) {
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

  @override
  void initState() {
    getUserData();
    getStoreDetails();
    super.initState();
  }

  getStoreDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      workingId = sharedPreferences.getString(AppConstants.workingId)!;
      storeEnName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
      storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
      clientId = sharedPreferences.getString(AppConstants.clientId)!;
      userId = sharedPreferences.getString(AppConstants.userName)!;
    });
    getClientData();
    getFreshnessListOne();
  }

  Future<void> getFreshnessListOne() async {
    await DatabaseHelper.getDataListFreshness(
            workingId,
            selectedClientId.toString(),
            clientId.toString(),
            selectedBrandId.toString(),
            selectedCategoryId.toString(),
            selectedSubCategoryId.toString())
        .then((value) async {
      transData = value;
      getFreshnessCountData();
      setState(() {});
    });
  }

  getFreshnessCountData() async {
    await DatabaseHelper.getFreshnessGraphCount(workingId,selectedClientId.toString(),clientId.toString(),selectedBrandId.toString(),selectedCategoryId.toString(),selectedSubCategoryId.toString()).then((value) {
      setState(() {
        freshnessGraphCountShowModel = value;
      });
    });
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;
    setState(() {});
  }

  void InsertTransFreshness(month, year, pieces, skuId) async {
    String startMonth = DateFormat('MMM - MM').format((DateTime.now()));
    int monthDifferenceValue = await monthDifference(startMonth,month);
    if (month == "" || year == 0 || pieces == "") {
      ToastMessage.errorMessage(context, "Please fill the form".tr);
      return;
    }

    if(year.toString() == DateTime.now().year.toString()) {
      if (monthDifferenceValue < 1) {
        ToastMessage.errorMessage(
            context, "You can not enter data for current or previous month".tr);
        return;
      }
    }

    setState(() {
      isLoading = false;
    });
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    String currentUserTimeStamp = "${userId}_$timeStamp";
    print(currentUserTimeStamp);
    await DatabaseHelper.insertTransFreshness(month, clientId,currentUserTimeStamp, year, skuId, workingId, int.parse(pieces))
        .then((_) {
      ToastMessage.succesMessage(context,"Data Saved Successfully".tr);
      Navigator.of(context).pop();
      year = 0;
      month = 0;
      pieces = 0;
      getFreshnessListOne();
    });
  }

  searchFilter() {

    if(isFilter) {
      isFilter = false;
    } else {
      isFilter = true;

      filterTransData =
          transData.where((element) => element.activity_status == 1).toList();
    }
    setState(() {

    });
  }

  Map<String, int> monthMap = {
    'Jan - 01': 1,
    'Feb - 02': 2,
    'Mar - 03': 3,
    'Apr - 04': 4,
    'May - 05': 5,
    'Jun - 06': 6,
    'Jul - 07': 7,
    'Aug - 08': 8,
    'Sep - 09': 9,
    'Oct - 10': 10,
    'Nov - 11': 11,
    'Dec - 12': 12,
  };


  int monthDifference(String startMonth, String endMonth) {

    int startMonthNumber = monthMap[startMonth] ?? 0;
    int endMonthNumber = monthMap[endMonth] ?? 0;

    if (startMonthNumber == 0 || endMonthNumber == 0) {
      throw ArgumentError('Invalid month name(s) provided.');
    }

    return endMonthNumber - startMonthNumber;
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: generalAppBar(context,  languageController.isEnglish.value ? storeEnName : storeArName, userId, () {
        Navigator.of(context).pop();
      }, true, true, false,(int getClient, int getCat, int getSubCat, int getBrand) {

        selectedClientId = getClient;
        selectedCategoryId = getCat;
        selectedSubCategoryId = getSubCat;
        selectedBrandId = getBrand;

        getFreshnessListOne();

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
                             Text("Freshness Skus".tr,maxLines: 1,overflow: TextOverflow.ellipsis,),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(FontAwesomeIcons.layerGroup,color: MyColors.greenColor,)),
                            Text("${freshnessGraphCountShowModel.totalFreshnessTaken}"),
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
                             Text("Freshness Pieces".tr,maxLines: 1,overflow: TextOverflow.ellipsis,),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const FaIcon(FontAwesomeIcons.cubesStacked,color: MyColors.savebtnColor,)),
                            Text("${freshnessGraphCountShowModel.totalVolume}"),
                          ],
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
          Expanded(
            child: isFilter ? filterTransData.isEmpty ?  Center(
              child: Text("No Data Found".tr),
            ) : ListView.builder(
                shrinkWrap: true,
                itemCount: filterTransData.length,
                itemBuilder: (ctx, i) {
                  return FreshnessListCard(
                    image:
                    "${imageBaseUrl}sku_pictures/${transData[i].img_name}",
                    proName:languageController.isEnglish.value ?  filterTransData[i].pro_en_name:filterTransData[i].pro_ar_name,
                    catName:languageController.isEnglish.value ?  filterTransData[i].cat_en_name:filterTransData[i].cat_ar_name,
                    rsp: filterTransData[i].rsp,
                    freshnessDate: (String pieces, String month, int year) {
                      InsertTransFreshness(
                          month, year, pieces, filterTransData[i].pro_id);
                      setState(() {});
                    },
                    freshnessTaken: filterTransData[i].activity_status,
                    brandName: languageController.isEnglish.value ?filterTransData[i].brand_en_name:filterTransData[i].brand_ar_name,
                  );
                }) : ListView.builder(
                shrinkWrap: true,
                itemCount: transData.length,
                itemBuilder: (ctx, i) {
                  return FreshnessListCard(
                    image:
                        "${imageBaseUrl}sku_pictures/${transData[i].img_name}",
                    proName:languageController.isEnglish.value ?  transData[i].pro_en_name:transData[i].pro_ar_name,
                    catName:languageController.isEnglish.value ?  transData[i].cat_en_name:transData[i].cat_ar_name,
                    rsp: transData[i].rsp,
                    freshnessDate: (String pieces, String month, int year) {
                      InsertTransFreshness(
                          month, year, pieces, transData[i].pro_id);
                      setState(() {});
                    },
                    freshnessTaken: transData[i].activity_status,
                    brandName:languageController.isEnglish.value ? transData[i].brand_en_name:transData[i].brand_ar_name,
                  );
                }),
          ),

         BigElevatedButton(
             buttonName: "View Freshness".tr,
             submit: (){
               Navigator.of(context)
                   .pushNamed(ViewFreshness_Screen.routeName);
             },
             isBlueColor: true)
        ]),
      ),
    );
  }
}
