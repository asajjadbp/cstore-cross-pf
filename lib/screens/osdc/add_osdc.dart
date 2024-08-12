import 'dart:async';
import 'dart:io';
import 'package:cstore/Database/db_helper.dart';
import 'package:cstore/screens/osdc/view_osdc.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/widget/drop_downs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import '../../Model/database_model/sys_brand_model.dart';
import '../../Model/database_model/sys_osdc_reason_model.dart';
import '../../Model/database_model/sys_osdc_type_model.dart';
import '../../Model/database_model/trans_osdc_model.dart';
import '../Gallery/gallery_screen.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
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
      imagesList.add(value);
      final String extension = path.extension(value.path);
      imagesNameList.add("${userName}_${DateTime.now().millisecondsSinceEpoch}$extension");

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
        imageFile == null) {
      ToastMessage.errorMessage(context, "Please fill the form and take image");
      return;
    }
    setState(() {
      isBtnLoading = true;
    });
    try {
      await takePicture(
              context, imageFile, imageName, workingId, AppConstants.osdc)
          .then((_) async {
        imagesList.add(File(imageFile!.path));
        var now = DateTime.now();
        await DatabaseHelper.insertTransOSDC(TransOSDCModel(
          brand_id: selectedBrandId,
          type_id: selectedTypeId,
          client_id: int.parse(clientId),
          upload_status: 0,
          reason_id: selectedReasonId,
          quantity: int.parse(valueControllerQty.text),
          working_id: int.parse(workingId),
          date_time: now.toString(),
          gcs_status: 0,
        )).then((_) {
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
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                storeName,
                style: const TextStyle(fontSize: 16),
              ),
              const Text(
                "OSDC",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    OsdcBrandDropDown(
                        hintText: "Brand",
                        osdcBrandData: brandData,
                        onChange: (value) {
                          selectedBrandId = value.id;
                          setState(() {});
                        }),
                    const SizedBox(
                      height: 10,
                    ),
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
                    const SizedBox(
                      height: 10,
                    ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Quantity",
                      style: TextStyle(
                          color: MyColors.appMainColor,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: TextField(
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
                            hintText: 'Enter Qty*'),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9][0-9]*'))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ImageListButton(
                        imageFile: imagesList,
                        onGalleryList: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NearestStoreGalleryScreen(imagesList: imagesList,)));
                        },
                        onSelectImage: () {
                          getImage();
                        }),

                    const SizedBox(
                      height: 20,
                    ),

                    ElevatedButton(
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
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 39, 136, 42),
                          minimumSize: Size(screenWidth, 45),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        Navigator.of(context).pushNamed(ViewOSDC.routename);
                      },
                      child: const Text(
                        "View Before Fixing",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
