
import 'package:cstore/Model/database_model/category_model.dart';
import 'package:cstore/Model/database_model/client_model.dart';
import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/screens/share_of_shelf/view_share_of_shelf.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/widget/drop_downs.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import '../../Model/database_model/sys_brand_model.dart';
import '../../Model/database_model/sys_osdc_reason_model.dart';
import '../../Model/database_model/sys_unit.dart';
import '../../Model/database_model/trans_sos_model.dart';
import '../Language/localization_controller.dart';
import '../utils/appcolor.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/elevated_buttons.dart';

class ShareOfShelf extends StatefulWidget {
  static const routeName = "/ShareOfShelf_route";
  const ShareOfShelf({super.key});

  @override
  State<ShareOfShelf> createState() => _ShareOfShelfState();
}

class _ShareOfShelfState extends State<ShareOfShelf> {

  List<ClientModel> clientData = [];
  List<Sys_OSDCReasonModel> unitData=[Sys_OSDCReasonModel(id: -1, en_name: "", ar_name: "")];
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

  int _selectedUnit= -1;
  String clientId = "";
  String workingId = "";
  String storeEnName = '';
  String storeArName = '';
  final languageController = Get.put(LocalizationController());
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
    storeEnName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;

    if (isInit) {
      getClientData();
      getUnitData();
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


    await DatabaseHelper.getBrandList(selectedClientId,selectedCategoryId.toString(),"-1").then((value) {
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
    await DatabaseHelper.getSosUnitListData().then((value) {
      setState(() {
        isLoading = false;
      });
      unitData = value;
    });
    print(unitData[0].en_name);
  }

  void storeUnitDataDB() async {
    try {
      if (selectedClientId == -1 ||
          selectedCategoryId == -1 ||
          _selectedUnit == -1 ||
          valueControllerActual.text == "" ||
          valueControllerCatSpace.text == "") {
        showAnimatedToastMessage("Error!".tr, "Please fill the form".tr, false);
        return;
      }
      if ((double.parse(valueControllerActual.text)) >
          (double.parse(valueControllerCatSpace.text))) {
        showAnimatedToastMessage("Error!".tr, "Actual Space cannot be greater or equal than category space".tr, false);
        return;
      }
      setState(() {
        isBtnLoading = true;
      });
      var now = DateTime.now();
      await DatabaseHelper.insertTransSOS(TransSOSModel(
          client_id: selectedClientId,
          cat_id: selectedCategoryId,
          brand_id: selectedBrandId,
          category_space: valueControllerCatSpace.text,
          actual_space: valueControllerActual.text,
          unit: _selectedUnit.toString(),
          date_time: now.toString(),
          uploadStatus: 0,
          working_id: int.parse(workingId)))
          .then((_) {
        showAnimatedToastMessage("Success".tr, "Data Store SuccessFully".tr, true);
        valueControllerActual.clear();
        valueControllerCatSpace.clear();
        isBtnLoading = false;

        setState(() {

        });
      });
    } catch (e) {
      isBtnLoading = false;
      showAnimatedToastMessage("Error!".tr, e.toString(), false);
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName, (){
        Navigator.of(context).pop();
      }, true, false, false, (int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    isLoading
                        ? const Center(
                      child: SizedBox(
                        height: 60,
                        child: MyLoadingCircle(),
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
                           Row(
                            children: [
                              Text(
                                "Client".tr,
                                style: const TextStyle(
                                    color: MyColors.appMainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(" * ", style: TextStyle(
                                  color: MyColors.backbtnColor,
                                  fontWeight: FontWeight.bold,fontSize: 14),)
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ClientListDropDown(
                              clientKey: clientKey,
                              hintText: "Client".tr, clientData: clientData, onChange: (value){
                            selectedClientId = value.client_id;
                            getCategoryData(selectedClientId);
                            getBrandData(selectedClientId);
                            setState(() {
                            });
                          }),
                          const SizedBox(
                            height: 10,
                          ),
                           Row(
                            children: [
                              Text(
                                "Category".tr,
                                style: const TextStyle(
                                    color: MyColors.appMainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(" * ", style: TextStyle(
                                  color: MyColors.backbtnColor,
                                  fontWeight: FontWeight.bold,fontSize: 14),)
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          isCategoryLoading
                              ? const Center(
                            child: SizedBox(
                              height: 60,
                              child: MyLoadingCircle(),
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
                           Text(
                            "Brand".tr,
                            style: const TextStyle(
                                color: MyColors.appMainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SysBrandDropDown(brandKey:brandKey,hintText: "Brand".tr, brandData: brandData, onChange: (value){
                            selectedBrandId = value.id;
                          }),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(child: Column(
                                children: [
                                   Row(
                                    children: [
                                      Text(
                                        "Category Space".tr,
                                        style: const TextStyle(
                                            color: MyColors.appMainColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text(" * ", style: TextStyle(
                                          color: MyColors.backbtnColor,
                                          fontWeight: FontWeight.bold,fontSize: 14),)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 55,
                                    child: TextField(
                                      showCursor: true,
                                      enableInteractiveSelection:false,
                                      onChanged: (value) {
                                        print(value);
                                      },
                                      controller: valueControllerCatSpace,
                                      keyboardType: TextInputType.number,
                                      decoration:  InputDecoration(
                                          prefixIconColor: MyColors.appMainColor,
                                          focusColor: MyColors.appMainColor,
                                          fillColor:MyColors.dropBorderColor,
                                          labelStyle: const TextStyle(color: MyColors.appMainColor),
                                          focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: MyColors.appMainColor)),
                                          border: const OutlineInputBorder(),
                                          hintText: 'Enter Total'.tr),
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))],
                                    ),
                                  ),
                                ],
                              )),
                              const SizedBox(width: 5,),
                              Expanded(child: Column(
                                children: [
                                   Row(
                                    children: [
                                      Text(
                                        "Actual Space".tr,
                                        style: const TextStyle(
                                            color: MyColors.appMainColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text("*", style: TextStyle(
                                          color: MyColors.backbtnColor,
                                          fontWeight: FontWeight.bold,fontSize: 14),)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 55,
                                    child: TextField(
                                      showCursor: true,
                                      enableInteractiveSelection:false,
                                      onChanged: (value) {
                                        print(value);
                                      },
                                      controller: valueControllerActual,
                                      keyboardType: TextInputType.number,
                                      decoration:  InputDecoration(
                                          prefixIconColor: MyColors.appMainColor,
                                          focusColor: MyColors.appMainColor,
                                          fillColor:MyColors.dropBorderColor,
                                          labelStyle: const TextStyle(color: MyColors.appMainColor,
                                              height: 50.0),
                                          focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: MyColors.appMainColor)),
                                          border: const OutlineInputBorder(),
                                          hintText: 'Enter Actual Faces'.tr),
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
                           Row(
                            children: [
                              Text(
                                "Select Unit".tr,
                                style: const TextStyle(
                                    color: MyColors.appMainColor,
                                    fontWeight: FontWeight.bold),
                              ),

                              const Text("*", style: TextStyle(
                                  color: MyColors.backbtnColor,
                                  fontWeight: FontWeight.bold,fontSize: 14),)
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          OsdcReasonDropDown(hintText: "Select Unit".tr,
                              osdcReasonData: unitData, onChange: (value) {
                                _selectedUnit = value.id;
                                setState(() {});
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          isBtnLoading
                              ? const Center(
                            child: SizedBox(
                              height: 60,
                              child: MyLoadingCircle(),
                            ),
                          )
                              :  BigElevatedButton(
                              buttonName: "Save".tr,
                              submit: (){
                                storeUnitDataDB();
                              },
                              isBlueColor: true),

                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
          Container(
            margin:const  EdgeInsets.only(bottom: 10,left: 5,right: 5),
            child: BigElevatedButton(
                buttonName: "View Share Of Shelf".tr,
                submit: (){
                  Navigator.of(context)
                      .pushNamed(ViewShareOfShelf.routename);
                },
                isBlueColor: false),

            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color.fromARGB(255, 39, 136, 42),
            //       minimumSize: Size(screenWidth, 50),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5))),
            //   onPressed: () {
            //     Navigator.of(context)
            //         .pushNamed(ViewShareOfShelf.routename);
            //   },
            //   child: const Text(
            //     "View Share Of Shelf",
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}