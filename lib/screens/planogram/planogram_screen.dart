import 'dart:async';
import 'dart:io';

import 'package:cstore/Model/database_model/category_model.dart';
import 'package:cstore/Model/database_model/client_model.dart';
import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/Model/database_model/sys_brand_model.dart';
import 'package:cstore/screens/planogram/view_planogram_sreen.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/widget/image_selection_row_button.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/database_model/PlanogramReasonModel.dart';
import '../../Model/database_model/trans_planogram_model.dart';
import '../Language/localization_controller.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/drop_downs.dart';
import 'package:path/path.dart' as path;

import '../widget/elevated_buttons.dart';

class PlanogramScreen extends StatefulWidget {
  static const routeName = "/Planogramroute";
  const PlanogramScreen({super.key});

  @override
  State<PlanogramScreen> createState() => _PlanogramScreenState();
}

class _PlanogramScreenState extends State<PlanogramScreen> {
  List<ClientModel> clientData = [];
  List<ClientModel> statusDataList = [ClientModel(client_id: 1, client_name: "Adherence".tr),ClientModel(client_id: 0, client_name: "Not Adherence".tr)];
  List<CategoryModel> categoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  List<SYS_BrandModel> brandData = [SYS_BrandModel( client: -1, id: -1, en_name: '', ar_name: '')];
  List<PlanogramReasonModel> planogramReasonData = [PlanogramReasonModel(id: -1,status: -1,en_name: "",ar_name: "",)];

  var imageName = "";
  File? imageFile;
  int selectedClientId = -1;
  int selectedCategoryId = -1;
  int selectedBrandId = -1;
  int selectedPlanogramReasonId = -1;
  int selectedStatusId = -1;
  bool isLoading = false;
  bool isInit = true;
  bool isBtnLoading = false;
  bool isCategoryLoading = false;
  bool isReasonLoading = false;
  bool isBrandLoading = false;
  final GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> brandKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> clientKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> clientKey1 = GlobalKey<FormFieldState>();
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
      getReasonData();
      getClientData();
    }
    isInit = false;
  }
  Future<void> getImage() async {
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        return;
      }
      imageFile = value;
      final String extension = path.extension(imageFile!.path);
      imageName = "${userName}_${DateTime.now().millisecondsSinceEpoch}$extension";

      setState(() {

      });
    });
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
  }
  getReasonData() async {
    planogramReasonData = [PlanogramReasonModel(en_name: "", ar_name: "",id: -1,status: -1)];
    setState(() {
      isReasonLoading = true;
    });
    await DatabaseHelper.getPlanogramReason().then((value) {
      planogramReasonData = value;
      isReasonLoading = false;
      setState(() {

      });
    }).catchError((e){
      print(e.toString());
    });
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

  void getBrandData(int clientId,String categoryId) async {
    brandKey.currentState!.reset();
    selectedBrandId = -1;
    brandData = [SYS_BrandModel(en_name: "",ar_name: "",id: -1, client: -1)];
    setState(() {
      isBrandLoading = true;
    });

    await DatabaseHelper.getBrandList(selectedClientId,categoryId).then((value) {
      setState(() {
        isBrandLoading = false;
      });
      brandData = value;
    });
    print(categoryData[0].en_name);
  }
  void saveStorePhotoData() async {
    if (selectedClientId == -1 ||
        selectedCategoryId == -1 ||
        selectedStatusId == -1 ||
        imageFile == null) {
      ToastMessage.errorMessage(context, "Please fill the form and take image".tr);
      return;
    }
    if(selectedStatusId == 0) {
      if(selectedPlanogramReasonId == -1) {
        ToastMessage.errorMessage(
            context, "Please select any reason from list".tr);
        return;
      }
    }
    setState(() {
      isBtnLoading = true;
    });
    try {
      await takePicture(context,imageFile,imageName,workingId,AppConstants.planogram).then((_) async {
        var now= DateTime.now();
        await DatabaseHelper.insertTransPlanogram(TransPlanogramModel(
            client_id: selectedClientId,
            cat_id: selectedCategoryId,
            brand_id: selectedBrandId,
            image_name: imageName,
            is_adherence: selectedStatusId,
            reason: selectedStatusId == 0 ? selectedPlanogramReasonId : 0,
            working_id: int.parse(workingId),
            gcs_status: 0,
            upload_status: 0,
            date_time: now.toString(),
        ))
            .then((_) {
          ToastMessage.succesMessage(context, "Data Saved Successfully".tr);
          imageFile = null;
        });
      });
      setState(() {
        isBtnLoading = false;
      });
    } catch (error) {
      setState(() {
        isBtnLoading = false;
      });
      ToastMessage.errorMessage(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName, (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: Stack(
        children: [
          isLoading
              ? const Center(
            child: MyLoadingCircle(),
          )
              : Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                         Row(
                          children: [
                            Text(
                              "Client".tr,
                              style:const TextStyle(
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
                          getBrandData(selectedClientId,selectedCategoryId.toString());
                          setState(() {

                          });
                        }),
                        const SizedBox(
                          height: 5,
                        ),
                         Row(
                          children: [
                            Text(
                              "Category".tr,
                              style:const TextStyle(
                                  color: MyColors.appMainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const   Text(" * ", style: TextStyle(
                                color: MyColors.backbtnColor,
                                fontWeight: FontWeight.bold,fontSize: 14),)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CategoryDropDown(categoryKey:categoryKey,hintText: "Category".tr, categoryData: categoryData, onChange: (value){
                          selectedCategoryId = value.id;
                          getBrandData(selectedClientId,selectedCategoryId.toString());
                          setState(() {

                          });
                        }),
                        const SizedBox(
                          height: 5,
                        ),
                       Text(
                          "Brand".tr,
                          style:const TextStyle(
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
                          height: 5,
                        ),
                         Row(
                          children: [
                            Text(
                              "Status".tr,
                              style:const TextStyle(
                                  color: MyColors.appMainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const  Text(" * ", style: TextStyle(
                                color: MyColors.backbtnColor,
                                fontWeight: FontWeight.bold,fontSize: 14),)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ClientListDropDown(
                            clientKey: clientKey1,
                            hintText: "Status".tr, clientData: statusDataList, onChange: (value){
                          selectedStatusId = value.client_id;
                            setState(() {

                            });
                        }),
                        const SizedBox(
                          height: 5,
                        ),
                       if(selectedStatusId == 0)
                       Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                            Text(
                             "Reason".tr,
                             style:const TextStyle(
                                 color: MyColors.appMainColor,
                                 fontWeight: FontWeight.bold),
                           ),
                           const SizedBox(
                             height: 5,
                           ),

                           PlanoReasonDropDown(hintText: "Reason".tr, reasonData: planogramReasonData, onChange: (value){
                             selectedPlanogramReasonId = value.id;
                             setState(() {

                             });
                           }),
                         ],
                       ),

                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ImageRowButton(
                              isRequired: true,
                              imageFile: imageFile, onSelectImage: (){
                            getImage();
                          }),
                        ),


                        isBtnLoading
                            ? const SizedBox(
                          height: 60,
                          child: MyLoadingCircle(),
                        )
                            : BigElevatedButton(
                            buttonName: "Save".tr,
                            submit: (){
                              saveStorePhotoData();
                            },
                            isBlueColor: true),


                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child:  BigElevatedButton(
                      buttonName: "View Planogram".tr,
                      submit: (){
                        Navigator.of(context).pushNamed(ViewPlanogramScreen.routename);
                      },
                      isBlueColor: false),

                )
              ],
            ),
          ),
          if(isCategoryLoading || isBrandLoading)
           const Center(child:  MyLoadingCircle(),)
        ],
      ),
    );
  }
}