import 'package:cstore/Model/database_model/trans_freshness_model.dart';
import 'package:cstore/screens/freshness/ViewFreshness.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/freshness_graph_count.dart';
import '../../Model/database_model/rtv_show_model.dart';
import '../../Model/database_model/show_freshness_list_model.dart';
import '../../Model/database_model/sys_brand_model.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/drop_downs.dart';
import '../widget/loading.dart';
import 'freshnesscard.dart';

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
  String storeName = '';
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
      storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
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

    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    imageBaseUrl = sharedPreferences.getString(AppConstants.imageBaseUrl)!;

    setState(() {});
    print(storeName);
  }

  void InsertTransFreshness(month, year, pieces, skuId) async {
    String startMonth = DateFormat('MMM - MM').format((DateTime.now()));
    int monthDifferenceValue = await monthDifference(startMonth,month);
    print(startMonth);
    print(month);
    print(monthDifferenceValue);
    print(DateTime.now().year);
    print(year);
    print(year.toString() == DateTime.now().year.toString());
    print(monthDifferenceValue > 1);
    print("Month ");

    if (month == "" || year == 0 || pieces == "") {
      ToastMessage.errorMessage(context, "Please fill the form");
      return;
    }

    if(year.toString() == DateTime.now().year.toString()) {
      if (monthDifferenceValue < 1) {
        ToastMessage.errorMessage(
            context, "You can not enter data for current or previous month");
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
      ToastMessage.succesMessage(context,"Data store successfully");
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
      appBar: generalAppBar(context, storeName, userId, () {
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
                                  getFreshnessListOne();
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
                            const Text("Freshness Sku's"),
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
                            const Text("Freshness Pieces"),
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
              // Card(
              //     elevation: 2,
              //     child: Container(
              //       height: screenHeight / 7,
              //       width: screenWidth / 3.4,
              //       decoration: BoxDecoration(
              //           color: const Color(0xFFFFFFFF),
              //           borderRadius: BorderRadius.circular(10),
              //           border:
              //               Border.all(width: 1, color: Color(0xFF00000026))),
              //       child: Column(
              //         children: [
              //           Container(
              //               margin: const EdgeInsets.only(top: 5),
              //               child: const Text(
              //                 "Scan Now",
              //                 style: TextStyle(
              //                     color: Color.fromRGBO(0, 78, 180, 1),
              //                     fontSize: 15,
              //                     fontWeight: FontWeight.w400),
              //               )),
              //           SizedBox(height: screenHeight / 50),
              //           const Icon(Icons.document_scanner_outlined, size: 40),
              //         ],
              //       ),
              //     )),
            ],
          ),
          Expanded(
            child: isFilter ? filterTransData.isEmpty ? const Center(
              child: Text("No data found"),
            ) : ListView.builder(
                shrinkWrap: true,
                itemCount: filterTransData.length,
                itemBuilder: (ctx, i) {
                  return FreshnessListCard(
                    image:
                    "${imageBaseUrl}sku_pictures/${transData[i].img_name}",
                    proName: filterTransData[i].pro_en_name,
                    catName: filterTransData[i].cat_en_name,
                    rsp: filterTransData[i].rsp,
                    freshnessDate: (String pieces, String month, int year) {
                      InsertTransFreshness(
                          month, year, pieces, filterTransData[i].pro_id);
                      print("fun is last $month,$year,$pieces");
                      setState(() {});
                    },
                    freshnessTaken: filterTransData[i].activity_status,
                    brandName: filterTransData[i].brand_en_name,
                  );
                }) : ListView.builder(
                shrinkWrap: true,
                itemCount: transData.length,
                itemBuilder: (ctx, i) {
                  return FreshnessListCard(
                    image:
                        "${imageBaseUrl}sku_pictures/${transData[i].img_name}",
                    proName: transData[i].pro_en_name,
                    catName: transData[i].cat_en_name,
                    rsp: transData[i].rsp,
                    freshnessDate: (String pieces, String month, int year) {
                      InsertTransFreshness(
                          month, year, pieces, transData[i].pro_id);
                      print("fun is last $month,$year,$pieces");
                      setState(() {});
                    },
                    freshnessTaken: transData[i].activity_status,
                    brandName: transData[i].brand_en_name,
                  );
                }),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 77, 145, 1),
              minimumSize: Size(MediaQuery.of(context).size.width/1.1, 45),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {

              Navigator.of(context)
                  .pushNamed(ViewFreshness_Screen.routeName);
            },
            child: const Text(
              "View Freshness",style: TextStyle(color: MyColors.whiteColor),
            ),
          )
        ]),
      ),
    );
  }
}
