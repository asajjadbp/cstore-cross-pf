import 'dart:async';
import 'dart:io';

import 'package:cstore/Model/database_model/category_model.dart';
import 'package:cstore/Model/database_model/client_model.dart';
import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/screens/before_fixing/view_before_fixing.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/widget/drop_downs.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

import '../../Model/database_model/trans_before_faxing.dart';
import '../Language/localization_controller.dart';
import '../camera/camera_screen.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/elevated_buttons.dart';
import '../widget/image_selection_row_button.dart';

class BeforeFixing extends StatefulWidget {
  static const routeName = "/BeforeFixingroute";
  const BeforeFixing({super.key});

  @override
  State<BeforeFixing> createState() => _BeforeFixingState();
}

class _BeforeFixingState extends State<BeforeFixing> {

  final languageController = Get.put(LocalizationController());

  List<ClientModel> clientData = [];
  List<CategoryModel> categoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  var imageName = "";
  File? imageFile;
  int selectedClientId = -1;
  int selectedCategoryId = -1;
  bool isLoading = false;
  bool isInit = true;
  bool isBtnLoading = false;
  bool isCategoryLoading = false;
  final GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> clientKey = GlobalKey<FormFieldState>();
  String clientId = "";
  String workingId = "";
  String storeEnName = '';
  String storeArName = '';
  String userName = "";

  late SingleValueDropDownController categoryDropDownController;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    categoryDropDownController = SingleValueDropDownController();
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
      // getCategoryData();
    }
    isInit = false;

  }

  Future<void> getImage() async {

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CameraPage(
    //       onImageCaptured: (XFile image) {
    //         // Handle the captured image here
    //         if (image == null) {
    //           return;
    //         }
    //         imageFile = File(image.path);
    //
    //         final String extension = path.extension(imageFile!.path);
    //         imageName = "${userName}_${DateTime.now().millisecondsSinceEpoch}$extension";
    //         setState(() {
    //
    //         });
    //       },
    //     ),
    //   ),
    // );

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
    // categoryDropDownController.clearDropDown();
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

  void saveStorePhotoData() async {
    if (selectedClientId == -1 ||
        selectedCategoryId == -1 ||
        imageFile == null) {
      showAnimatedToastMessage("Error!".tr, "Please fill the form and take image".tr, false);
      return;
    }
    // print(selectedCategoryId);
    // print(selectedClientId);
    setState(() {
      isBtnLoading = true;
    });
    try {
      await takePicture(context,imageFile,imageName,workingId,AppConstants.beforeFixing).then((_) async {
        var now = DateTime.now();
        await DatabaseHelper.insertBeforeFaxing(TransBeforeFaxingModel(
                client_id: selectedClientId,
                photo_type_id: 1,
                cat_id: selectedCategoryId,
                img_name: imageName,
                working_id: int.parse(workingId),
                upload_status: 0,
                gcs_status: 0,
                date_time: now.toString()))
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName, (){
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {
      }),
      body: isLoading
          ? const Center(
              child: SizedBox(
                height: 60,
                child: MyLoadingCircle(),
              ),
            )
          : Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Client".tr,
                                style:const TextStyle(
                                    color: MyColors.appMainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ClientListDropDown(
                                  clientKey: clientKey,
                                  hintText: "Client".tr,
                                  clientData: clientData,
                                  onChange: (value){
                                selectedClientId = value.client_id;
                                getCategoryData(selectedClientId);
                                setState(() {

                                });
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              "Category".tr,
                              style:const TextStyle(
                                  color: MyColors.appMainColor,
                                  fontWeight: FontWeight.bold),
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
                                :
                            // ProductDropDownList(
                            //         categoryData: categoryData,
                            //         valueDropDownController: categoryDropDownController,
                            //         selectedId: (int value) {
                            //       print(value);
                            //       print("------------------");
                            // }, categoryKey: categoryKey)

                            CategoryDropDown(
                                categoryKey:categoryKey,
                                hintText: "Category".tr,
                                categoryData: categoryData,
                                onChange: (value){
                              selectedCategoryId = value.id;
                              setState(() {

                              });
                            }),
                          ],
                        ),

                        Container(
                          margin:const EdgeInsets.symmetric(vertical: 10),
                          child: ImageRowButton(
                              isRequired: false,
                              imageFile: imageFile, onSelectImage: (){
                            getImage();
                          }),
                        ),
                        isBtnLoading
                            ? const Center(
                          child: SizedBox(
                            height: 60,
                            child: MyLoadingCircle(),
                          ),
                        )
                            : BigElevatedButton(
                            isBlueColor: true,
                            buttonName:  "Save".tr,
                            submit: (){
                              saveStorePhotoData();
                            })

                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: BigElevatedButton(
                        isBlueColor: false,
                        buttonName: "View Before Fixing".tr,
                        submit: (){
                          Navigator.of(context)
                              .pushNamed(ViewBeforeFixing.routename);
                        })

                  ),
                ],
              ),
            ),
    );
  }
}
