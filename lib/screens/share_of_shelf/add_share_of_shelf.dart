
import 'package:cstore/Model/database_model/category_model.dart';
import 'package:cstore/Model/database_model/client_model.dart';
import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/screens/share_of_shelf/view_share_of_shelf.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/widget/drop_downs.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import '../../Model/database_model/sys_brand_model.dart';
import '../../Model/database_model/sys_unit.dart';
import '../../Model/database_model/trans_sos_model.dart';
import '../utils/appcolor.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';

class ShareOfShelf extends StatefulWidget {
  static const routeName = "/ShareOfShelf_route";
  const ShareOfShelf({super.key});

  @override
  State<ShareOfShelf> createState() => _ShareOfShelfState();
}

class _ShareOfShelfState extends State<ShareOfShelf> {

  List<ClientModel> clientData = [];
  List<SysUnitModel> unitData=[];
  List<CategoryModel> categoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  List<SYS_BrandModel> brandData = [SYS_BrandModel( client: -1, id: -1, en_name: '', ar_name: '')];
  int selectedClientId = -1;
  int selectedCategoryId = -1;
  int selectedUnitId=-1;
  bool isLoading = false;
  bool isInit = true;
  bool isBtnLoading = false;
  bool isCategoryLoading = false;
  bool isBrandLoading = false;
  int selectedBrandId = -1;
   TextEditingController valueControllerCatSpace=TextEditingController();
  TextEditingController valueControllerActual=TextEditingController();
  final GlobalKey<FormFieldState> clientKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> brandKey = GlobalKey<FormFieldState>();

  List<String> unitList = ['Faces', 'CM', 'Meter']; // Option 2
  String _selectedUnit= "";
  String clientId = "";
  String workingId = "";
  String storeName = "";
  String userName = "";

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    getUserData();
  }
  getUserData()async {
    SharedPreferences sharedPreferences  = await SharedPreferences.getInstance();

    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;

    if (isInit) {
      getClientData();
    }
    isInit = false;

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
    });
    print(clientData[0].client_name);
  }

  void getCategoryData(int clientId) async {
    categoryKey.currentState!.reset();
    selectedCategoryId = -1;
    categoryData = [CategoryModel(en_name: "",ar_name: "",id: -1, client: -1)];
    setState(() {
      isCategoryLoading = true;
    });

    await DatabaseHelper.getCategoryList(selectedClientId).then((value) {
      setState(() {
        isCategoryLoading = false;
      });
      categoryData = value;
    });
    print(categoryData[0].en_name);
  }

  void getBrandData(int clientId) async {
    brandKey.currentState!.reset();
    selectedBrandId = -1;
    brandData = [SYS_BrandModel(en_name: "",ar_name: "",id: -1, client: -1)];
    setState(() {
      isBrandLoading = true;
    });


    await DatabaseHelper.getBrandList(selectedClientId,selectedCategoryId.toString()).then((value) {
      setState(() {
        isBrandLoading = false;
      });
      brandData = value;
    });
    print(categoryData[0].en_name);

  }
  void getUnitData() async {

    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getVisitClientList(clientId).then((value) {
      setState(() {
        isLoading = false;
      });
      clientData = value;
    });
    print(clientData[0].client_name);
  }
  void StoreUnitDataDB() async{
    if (selectedClientId == -1 ||
        selectedCategoryId == -1 ||
        _selectedUnit == ""||
        valueControllerActual.text==""||valueControllerCatSpace.text=="" ) {
      ToastMessage.errorMessage(context, "Please fill the form");
      return;
    }
    if((double.parse( valueControllerActual.text)) > (double.parse(valueControllerCatSpace.text))) {
      ToastMessage.errorMessage(context, "Actual Space cannot be greater or equal than category space");
      return;
    }
    setState(() {
      isBtnLoading = false;
    });
    var now= DateTime.now();
    await DatabaseHelper.insertTransSOS(TransSOSModel(
        client_id: selectedClientId,
        cat_id: selectedCategoryId,
        brand_id: selectedBrandId,
        category_space: valueControllerCatSpace.text,
        actual_space: valueControllerActual.text,
        unit: _selectedUnit,
        date_time: now.toString(),
        uploadStatus: 0,
        working_id: int.parse(workingId)))
        .then((_) {
      ToastMessage.succesMessage(context, "Data store successfully");
      // selectedCategoryId = -1;
      // selectedClientId = -1;
      // selectedBrandId=-1;
      // _selectedUnit="";
      valueControllerActual.clear();
      valueControllerCatSpace.clear();
      isBrandLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: generalAppBar(context, storeName, userName, (){
        Navigator.of(context).pop();
      }, (){print("filter Click");}, true, false, false),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    isLoading
                        ? Center(
                      child: Container(
                        height: 60,
                        child: const MyLoadingCircle(),
                      ),
                    )
                        : Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            children: [
                              Text(
                                "Client ",
                                style: TextStyle(
                                    color: MyColors.appMainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("*", style: TextStyle(
                                  color: MyColors.backbtnColor,
                                  fontWeight: FontWeight.bold,fontSize: 14),)
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // dropdownwidget("Company Name"),
                          ClientListDropDown(
                              clientKey: clientKey,
                              hintText: "Client", clientData: clientData, onChange: (value){
                            selectedClientId = value.client_id;
                            getCategoryData(selectedClientId);
                            getBrandData(selectedClientId);
                            setState(() {
                            });
                          }),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              Text(
                                "Category ",
                                style: TextStyle(
                                    color: MyColors.appMainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("*", style: TextStyle(
                                  color: MyColors.backbtnColor,
                                  fontWeight: FontWeight.bold,fontSize: 14),)
                            ],
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
                              : CategoryDropDown(categoryKey:categoryKey,hintText: "Category", categoryData: categoryData, onChange: (value){
                            selectedCategoryId = value.id;
                            getBrandData(selectedClientId);
                            setState(() {

                            });
                          }),
                          const SizedBox(
                            height: 20,
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
                          SysBrandDropDown(brandKey:brandKey,hintText: "Brand", brandData: brandData, onChange: (value){
                            selectedBrandId = value.id;
                          }),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        "Category Space ",
                                        style: TextStyle(
                                            color: MyColors.appMainColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("*", style: TextStyle(
                                          color: MyColors.backbtnColor,
                                          fontWeight: FontWeight.bold,fontSize: 14),)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                    child: TextField(
                                      showCursor: true,
                                      enableInteractiveSelection:false,
                                      onChanged: (value) {
                                        print(value);
                                      },
                                      controller: valueControllerCatSpace,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          prefixIconColor: MyColors.appMainColor,
                                          focusColor: MyColors.appMainColor,
                                          fillColor:MyColors.dropBorderColor,
                                          labelStyle: TextStyle(color: MyColors.appMainColor),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: MyColors.appMainColor)),
                                          border: OutlineInputBorder(),
                                          hintText: 'Enter Total'),
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))],
                                    ),
                                  ),
                                ],
                              )),
                              const SizedBox(width: 5,),
                              Expanded(child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        "Actual Space ",
                                        style: TextStyle(
                                            color: MyColors.appMainColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("*", style: TextStyle(
                                          color: MyColors.backbtnColor,
                                          fontWeight: FontWeight.bold,fontSize: 14),)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                    child: TextField(
                                      showCursor: true,
                                      enableInteractiveSelection:false,
                                      onChanged: (value) {
                                        print(value);
                                      },
                                      controller: valueControllerActual,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          prefixIconColor: MyColors.appMainColor,
                                          focusColor: MyColors.appMainColor,
                                          fillColor:MyColors.dropBorderColor,
                                          labelStyle: TextStyle(color: MyColors.appMainColor,
                                              height: 50.0),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: MyColors.appMainColor)),
                                          border: OutlineInputBorder(),
                                          hintText: 'Enter Actual'),
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))],
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Row(
                            children: [
                              Text(
                                "Select Unit ",
                                style: TextStyle(
                                    color: MyColors.appMainColor,
                                    fontWeight: FontWeight.bold),
                              ),

                              Text("*", style: TextStyle(
                                  color: MyColors.backbtnColor,
                                  fontWeight: FontWeight.bold,fontSize: 14),)
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          UnitDropDown(hintText: "Select Unit", unitData: unitList, onChange: (value){
                            _selectedUnit = value;
                          }),
                          const SizedBox(
                            height: 20,
                          ),
                          isBtnLoading
                              ? Center(
                            child: Container(
                              height: 60,
                              child: const MyLoadingCircle(),
                            ),
                          )
                              : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors.appMainColor,
                                minimumSize: Size(screenWidth, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {
                              StoreUnitDataDB();
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
          Container(
            margin:const  EdgeInsets.only(bottom: 10,left: 5,right: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 39, 136, 42),
                  minimumSize: Size(screenWidth, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ViewShareOfShelf.routename);
              },
              child: const Text(
                "View Share Of Shelf",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}