import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/sys_brand_model.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import 'drop_downs.dart';
import 'loading.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet(
      {super.key,required this.searchFilterData});
  final Function(int selectedClientId, int selectedCategoryId,
      int selectedSubCategoryId, int selectedBrandId) searchFilterData;

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}
class _SearchBottomSheetState extends State<SearchBottomSheet> {
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
  late ClientModel initialClientItem =
      ClientModel(client_id: -1, client_name: "");
  late CategoryModel initialCategoryItem =
      CategoryModel(id: 0, en_name: "", ar_name: "", client: -1);
  late CategoryModel initialSubCategoryItem =
      CategoryModel(id: 0, en_name: "", ar_name: "", client: -1);
  late SYS_BrandModel initialBrandItem =
      SYS_BrandModel(id: 0, en_name: "", ar_name: "", client: -1);
  bool isLoading = false;
  bool isFilter = false;
  int selectedClientId = -1;
  int selectedCategoryId = -1;
  int selectedSubCategoryId = -1;
  int selectedBrandId = -1;
  bool isCategoryLoading = false;
  bool isSubCategoryLoading = false;
  bool isBrandLoading = false;
  String clientId="";

  @override
  void initState() {
    super.initState();
    getStoreData();


  }
  getStoreData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    getClientData(clientId);
  }

  void getClientData(String clientId) async {
    await DatabaseHelper.getVisitClientList(clientId).then((value) {
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
      brandData.insert(0,
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

  void getBrandData(int getClient, StateSetter menuState) async {
    brandKey.currentState!.reset();
    selectedBrandId = -1;
    menuState(() {
      isBrandLoading = true;
    });
    await DatabaseHelper.getBrandList(getClient,selectedCategoryId.toString()).then((value) {
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return IconButton(
        onPressed: () {

          showModalBottomSheet(
            isDismissible: false,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(onWillPop: () async {
                return false;
              }, child: StatefulBuilder(
                  builder: (BuildContext context1, StateSetter menuState) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.90,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                  margin:
                      const EdgeInsets.only(right: 10, left: 10, bottom: 10),
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
                                    initialSubCategoryItem = subCategoryData[0];
                                    initialBrandItem = brandData[0];
                                  });
                                },
                                child: const Text(
                                  "Reset Filter",
                                  style: TextStyle(color: MyColors.whiteColor),
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
                        ClientListDropDownWithInitialValue(
                            clientKey: clientKey,
                            initialValue: initialClientItem,
                            hintText: "Client",
                            clientData: clientData,
                            onChange: (value) {
                              selectedClientId = value.client_id;
                              initialClientItem = value;
                              getBrandData(selectedClientId, menuState);
                              getCategoryData(selectedClientId, menuState);
                              getSubCategoryData(selectedClientId, menuState);
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
                              print("check brand id $selectedBrandId");
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
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
                            widget.searchFilterData(
                                selectedClientId,
                                selectedCategoryId,
                                selectedSubCategoryId,
                                selectedBrandId);

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
        ));
  }
}
