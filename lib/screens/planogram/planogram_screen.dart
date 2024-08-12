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
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/database_model/PlanogramReasonModel.dart';
import '../../Model/database_model/trans_planogram_model.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/drop_downs.dart';
import 'package:path/path.dart' as path;

class PlanogramScreen extends StatefulWidget {
  static const routeName = "/Planogramroute";
  const PlanogramScreen({super.key});

  @override
  State<PlanogramScreen> createState() => _PlanogramScreenState();
}

class _PlanogramScreenState extends State<PlanogramScreen> {
  List<ClientModel> clientData = [];
  List<ClientModel> statusDataList = [ClientModel(client_id: 1, client_name: "Adherence"),ClientModel(client_id: 0, client_name: "No Adherence")];
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
  String storeName = "";
  String userName = "";

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    getUserData();
  }
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getClientData();
  //   getCategoryData();
  // }

  getUserData()async {
    SharedPreferences sharedPreferences  = await SharedPreferences.getInstance();

    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;

    if (isInit) {
      getReasonData();
      getClientData();

      // getCategoryData();
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
      // _takePhoto(value);
    });
  }

  // void _takePhoto(File recordedImage) async {
  //   // if (recordedImage != null && recordedImage.path != null) {
  //   // setState(() {
  //   //   firstButtonText = 'saving in progress...';
  //   // });
  //   GallerySaver.saveImage(recordedImage.path).then((path) {
  //     // setState(() {
  //     //   firstButtonText = 'image saved!';
  //     // });
  //   });
  //   // }
  // }


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
      ToastMessage.errorMessage(context, "Please fill the form and take image");
      return;
    }
    if(selectedStatusId == 0) {
      if(selectedPlanogramReasonId == -1) {
        ToastMessage.errorMessage(
            context, "Please select any reason from list");
        return;
      }
    }
    // print(selectedCategoryId);
    // print(selectedClientId);
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
          ToastMessage.succesMessage(context, "Data store successfully");
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: generalAppBar(context, storeName, userName, (){
        Navigator.of(context).pop();
      }, (){print("filter Click");}, true, false, false),
      body: Stack(
        children: [
          isLoading
              ? Center(
            child: const MyLoadingCircle(),
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
                        ClientListDropDown(
                            clientKey: clientKey,
                            hintText: "Client", clientData: clientData, onChange: (value){
                          selectedClientId = value.client_id;
                          getCategoryData(selectedClientId);
                          getBrandData(selectedClientId,selectedCategoryId.toString());
                          setState(() {

                          });
                        }),
                        const SizedBox(
                          height: 5,
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
                        CategoryDropDown(categoryKey:categoryKey,hintText: "Category", categoryData: categoryData, onChange: (value){
                          selectedCategoryId = value.id;
                          getBrandData(selectedClientId,selectedCategoryId.toString());
                          setState(() {

                          });
                        }),
                        const SizedBox(
                          height: 5,
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
                          height: 5,
                        ),
                        const Text(
                          "Status",
                          style: TextStyle(
                              color: MyColors.appMainColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ClientListDropDown(
                            clientKey: clientKey1,
                            hintText: "Status", clientData: statusDataList, onChange: (value){
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
                           const Text(
                             "Reason",
                             style: TextStyle(
                                 color: MyColors.appMainColor,
                                 fontWeight: FontWeight.bold),
                           ),
                           const SizedBox(
                             height: 5,
                           ),

                           PlanoReasonDropDown(hintText: "Reason", reasonData: planogramReasonData, onChange: (value){
                             selectedPlanogramReasonId = value.id;
                             setState(() {

                             });
                           }),
                         ],
                       ),
                        const SizedBox(
                          height: 10,
                        ),


                        ImageRowButton(imageFile: imageFile, onSelectImage: (){
                          getImage();
                        }),

                        const SizedBox(
                          height: 20,
                        ),
                        isBtnLoading
                            ? Container(
                          height: 60,
                          child: Center(
                            child: Container(
                              height: 60,
                              child: const MyLoadingCircle(),
                            ),
                          ),
                        )
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.appMainColor,
                              minimumSize: Size(screenWidth, 45),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            saveStorePhotoData();
                            // Navigator.of(context).pushNamed();
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child:  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 39, 136, 42),
                        minimumSize: Size(screenWidth, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(ViewPlanogramScreen.routename);
                    },
                    child: const Text(
                      "View Planogram",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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