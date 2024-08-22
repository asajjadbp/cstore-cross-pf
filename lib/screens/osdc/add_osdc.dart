import 'dart:async';
import 'dart:io';
import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/screens/osdc/view_osdc.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/widget/drop_downs.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import '../../Model/database_model/sys_brand_model.dart';
import '../../Model/database_model/sys_osdc_reason_model.dart';
import '../../Model/database_model/sys_osdc_type_model.dart';
import '../../Model/database_model/trans_osd_image_model.dart';
import '../../Model/database_model/trans_osdc_model.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/elevated_buttons.dart';
import '../widget/image_selection_row_button.dart';

class AddOSDC extends StatefulWidget {
  static const routeName = "/AddOSDCroute";

  const AddOSDC({super.key});

  @override
  State<AddOSDC> createState() => _AddOSDCState();
}

class _AddOSDCState extends State<AddOSDC> {
  List<SYS_BrandModel> brandData = [
    SYS_BrandModel(client: -1, id: -1, en_name: '', ar_name: '')
  ];
  List<Sys_OSDCReasonModel> reasonData = [];
  List<Sys_OSDCTypeModel> typeData = [];
  List<File> imagesList = [];
  List<String> imagesNameList = [];

  var imageName = "";
  File? imageFile;
  int selectedBrandId = -1;
  int selectedTypeId = -1;
  int selectedReasonId = -1;
  bool isInit = true;
  bool isBtnLoading = false;
  final GlobalKey<FormFieldState> brandKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> typeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> reasondKey = GlobalKey<FormFieldState>();
  String clientId = "";
  String workingId = "";
  String storeName = "";
  String userName = "";
  TextEditingController valueControllerQty = TextEditingController();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    getUserData();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;

    if (isInit) {
      getTypeData();
      getReasonData();
      getBrandData();
    }
    isInit = false;
  }

  Future<void> getImage() async {
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        return;
      }
      print(value.path);
      imagesList.add(value);
      final String extension = path.extension(value.path);
      imagesNameList.add("${userName}_${DateTime.now().millisecondsSinceEpoch}$extension");

      setState(() {});
      // _takePhoto(value);
    });
  }

  Future<void> galleyImage() async {
    await ImageTakingService.galleryImageSelect().then((value) {
      if (value == null || value.isEmpty) {
        return;
      }
      for(int i = 0; i < value.length; i++) {
        imagesList.add(value[i]!);
        final String extension = path.extension(value[i]!.path);
        imagesNameList.add("${userName}_${DateTime.now().millisecondsSinceEpoch}_$i$extension");
      }
      setState(() {});
      // _takePhoto(value);
    });
  }
  void getReasonData() async {
    setState(() {});
    await DatabaseHelper.getOsdcReasonList().then((value) {
      setState(() {});
      reasonData = value;
    });
    print(reasonData[0].en_name);
  }

  void getTypeData() async {
    setState(() {});
    await DatabaseHelper.getOsdcTypeList().then((value) {
      setState(() {
        isBtnLoading = false;
      });
      typeData = value;
    });
    print(typeData[0].en_name);
  }

  void getBrandData() async {
    setState(() {});
    await DatabaseHelper.getBrandListOSDC().then((value) {
      setState(() {});
      brandData = value;
    });
    print(brandData[0].en_name);
  }

  void saveStorePhotoData() async {

    if (selectedBrandId == -1 ||
        selectedTypeId == -1 ||
        selectedReasonId == -1 ||
        imagesList.isEmpty) {
      ToastMessage.errorMessage(context, "Please fill the form and take image");
      return;
    }
    setState(() {
      isBtnLoading = true;
    });
    try {
      var now = DateTime.now();
      String osdcId = "";

      await DatabaseHelper.insertTransOSDC(TransOSDCModel(
        brand_id: selectedBrandId,
        type_id: selectedTypeId,
        client_id: clientId,
        upload_status: 0,
        reason_id: selectedReasonId,
        quantity: int.parse(valueControllerQty.text),
        working_id: int.parse(workingId),
        date_time: now.toString(),
        gcs_status: 0,
      )).then((value) {
        print("______________ osdc data Saving _________________");
        print(value);
        osdcId = value.toString();
        print("_________________________________________________");
      });
     for(int i = 0; i<imagesList.length; i++) {
       await takePicture(
           context, imagesList[i], imagesNameList[i], workingId, AppConstants.osdc)
           .then((_) async {
             print("IMAGE SAVE TO LOCAL FOLLDER");


         ///image name storing
         await DatabaseHelper.insertTransOSDCImage(TransOSDCImagesModel(
           main_osd_id: osdcId,
           image_name: imagesNameList[i],
           working_id: int.parse(workingId),
         )).then((_) {

         });
       });

     }

     ToastMessage.succesMessage(context, "Data store successfully");
     imagesList.clear();
     imagesNameList.clear();
     valueControllerQty.clear();

      setState(() {
        isBtnLoading = false;
      });
    } catch (error) {
      setState(() {
        isBtnLoading = false;
      });
      print(error);
      ToastMessage.errorMessage(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: generalAppBar(context, storeName, userName, (){
          Navigator.of(context).pop();
        }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

        }),
        body: Container(
          margin:const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Container(
                             margin:const EdgeInsets.symmetric(vertical: 10),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 const Text(
                                   "Brand",
                                   style: TextStyle(
                                       color: MyColors.appMainColor,
                                       fontWeight: FontWeight.bold),
                                 ),
                                 const SizedBox(
                                   height: 5,
                                 ),
                                 OsdcBrandDropDown(
                                     hintText: "Brand",
                                     osdcBrandData: brandData,
                                     onChange: (value) {
                                       selectedBrandId = value.id;
                                       setState(() {});
                                     }),
                               ],
                             ),
                           ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Type",
                                  style: TextStyle(
                                      color: MyColors.appMainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                OsdcTypeDropDown(
                                    hintText: "OSDC Type",
                                    osdcTypeData: typeData,
                                    onChange: (value) {
                                      selectedTypeId = value.id;
                                      setState(() {});
                                    }),
                              ],
                            ),

                            Container(
                              margin:const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                  OsdcReasonDropDown(
                                      hintText: "OSDC Reason",
                                      osdcReasonData: reasonData,
                                      onChange: (value) {
                                        selectedReasonId = value.id;
                                        setState(() {});
                                      }),
                                ],
                              ),
                            ),
                           Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const Text(
                                 "Quantity",
                                 style: TextStyle(
                                     color: MyColors.appMainColor,
                                     fontWeight: FontWeight.bold),
                               ),
                               const SizedBox(
                                 height: 5,
                               ),
                               TextField(
                                 showCursor: true,
                                 enableInteractiveSelection: false,
                                 onChanged: (value) {
                                   print(value);
                                 },
                                 controller: valueControllerQty,
                                 keyboardType: TextInputType.number,
                                 decoration: const InputDecoration(
                                     prefixIconColor: MyColors.appMainColor,
                                     focusColor: MyColors.appMainColor,
                                     fillColor: MyColors.dropBorderColor,
                                     labelStyle: TextStyle(
                                         color: MyColors.appMainColor, height: 50.0),
                                     focusedBorder: OutlineInputBorder(
                                         borderSide: BorderSide(
                                             width: 1, color: MyColors.appMainColor)),
                                     border: OutlineInputBorder(),
                                     hintText: 'Enter Qty'),
                                 inputFormatters: [
                                   FilteringTextInputFormatter.allow(
                                       RegExp(r'^[0-9][0-9]*'))
                                 ],
                               ),
                             ],
                           ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ImageListButton(
                                  imageFile: imagesList,
                                  onGalleryList: (){
                                    galleyImage();
                                  },
                                  onSelectImage: () {
                                    getImage();
                                  }),
                            ),

                            isBtnLoading ? const SizedBox(
                              height: 60,
                              child:  MyLoadingCircle(),
                            ) : BigElevatedButton(
                                buttonName: "Save",
                                submit: (){
                                  saveStorePhotoData();
                                },
                                isBlueColor: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin:const EdgeInsets.symmetric(vertical: 10),
                child: BigElevatedButton(
                    buttonName: "View OSD",
                    submit: (){
                      Navigator.of(context).pushNamed(ViewOSDC.routename);
                    },
                    isBlueColor: false),
              ),
            ],
          ),
        ));
  }
}
