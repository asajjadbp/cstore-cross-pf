import 'dart:io';
import 'package:cstore/Model/database_model/trans_rtv_one_plus_one.dart';
import 'package:cstore/screens/rtv_1+1/view_rtv_one_plus_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import '../../Database/db_helper.dart';
import '../../Model/database_model/sys_rtv_reason_model.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/drop_downs.dart';
import '../widget/loading.dart';
import 'package:intl/intl.dart';

class AddRtvOnePlusOne extends StatefulWidget {
  static const routeName = "/add_onePlusOne";
  AddRtvOnePlusOne({super.key, required this.sku_id, required this.SkuName});

  int sku_id;
  String SkuName;

  @override
  State<AddRtvOnePlusOne> createState() => _AddRtvOnePlusOneState();
}

class _AddRtvOnePlusOneState extends State<AddRtvOnePlusOne> {
  List<Sys_RTVReasonModel> reasonData = [];
  bool isInit = true;
  var imageName = "";
  var docImageName = "";
  File? imageFile;
  File? docImageFile;
  bool isLoading = false;
  bool isBtnLoading = false;
  String clientId = "";
  String workingId = "";
  String storeName = "";
  TextEditingController totalPieces = TextEditingController();
  TextEditingController edDocNumber = TextEditingController();
  TextEditingController edComment = TextEditingController();
  DateTime? pickedDate;
  late String formattedDate = "Select Date";
  int index = -1;
  String _selectedType = "";
  List<String> unitList = ['1+1'];

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

    if (isInit) {
      getReasonData();
    }
    isInit = false;
  }

  void getReasonData() async {
    setState(() {});
    await DatabaseHelper.getRtvReasonList().then((value) {
      setState(() {});
      reasonData = value;
    });
    print("TRV Reason ScreenList");
    print(reasonData[0].en_name);
  }

  Future<void> getImage(String name) async {
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        return;
      }
      if (name == "rtv") {
        imageFile = value;
        final String extension = path.extension(imageFile!.path);
        imageName = "${DateTime.now().millisecondsSinceEpoch}$extension";
      } else {
        docImageFile = value;
        final String docExtension = path.extension(docImageFile!.path);
        docImageName = "${DateTime.now().millisecondsSinceEpoch}$docExtension";
      }
      setState(() {});
    });
  }

  void saveStorePhotoData() async {
    if (imageFile == null ||
        docImageFile == null ||
        _selectedType == "" ||
        edDocNumber.text == null ||
        totalPieces.text == null ||
        totalPieces.text == null) {
      ToastMessage.errorMessage(context, "Please fill the form and take image");
      return;
    }
    setState(() {
      isBtnLoading = true;
    });
    try {
      await takePicture(
              context, imageFile, imageName, workingId, AppConstants.rtv)
          .then((_) async {
        var now = DateTime.now();
        var formattedTime = DateFormat('hh:mm:ss').format(now);
        await DatabaseHelper.insertTransRtvOnePlusOne(TransRtvOnePlusOneModel(
                sku_id: widget.sku_id,
                pieces: int.parse(totalPieces.text),
                act_status: 1,
                gcs_status: 0,
                date_time: formattedTime,
                upload_status: 0,
                working_id: int.parse(workingId),
                image_name: imageName,
                comment: edComment.text,
                type: _selectedType,
                doc_no: edDocNumber.text,
                doc_image_name: docImageName))
            .then((_) {
          ToastMessage.succesMessage(context, "Data store successfully");
          takePicture(context, docImageFile, docImageName, workingId,
                  AppConstants.rtv)
              .then((_) async {
            print("image add success $docImageFile");
            print("imageName add success $docImageName");
            _selectedType = "";
            totalPieces.text = "";
            edComment.text = "";
            imageFile = null;
            docImageFile = null;
            setState(() {
              isBtnLoading = false;
            });
          });
        });
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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color(0xFFF4F7FD),
        appBar: generalAppBar(context, storeName, "Add 1+1", () {
          Navigator.of(context).pop();
        }, () {}, true, false, false),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Text(
                  widget.SkuName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      color: MyColors.appMainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: const Text(
                        "Pieces",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      )),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    child: TextField(
                      showCursor: true,
                      enableInteractiveSelection: false,
                      onChanged: (value) {},
                      controller: totalPieces,
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
                          hintText: 'Enter Pieces'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[0-9][0-9]*'))
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: const Text(
                        "Type",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      )),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    child: UnitDropDown(
                        hintText: "Select type",
                        unitData: unitList,
                        onChange: (value) {
                          _selectedType = value;
                        }),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: const Text(
                        "Document No",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      )),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    child: TextField(
                        showCursor: true,
                        enableInteractiveSelection: false,
                        onChanged: (value) {
                          print(value);
                        },
                        controller: edDocNumber,
                        keyboardType: TextInputType.text,
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
                            hintText: 'Enter document')),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: const Text(
                        "Comment",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      )),
                  Container(
                    height: 100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    child: TextField(
                        showCursor: true,
                        enableInteractiveSelection: false,
                        onChanged: (value) {
                          print(value);
                        },
                        controller: edComment,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            prefixIconColor: MyColors.appMainColor,
                            focusColor: MyColors.appMainColor,
                            fillColor: MyColors.dropBorderColor,
                            labelStyle: TextStyle(
                                color: MyColors.appMainColor, height: 100.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: MyColors.appMainColor)),
                            border: OutlineInputBorder(),
                            hintText: 'Enter comment')),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: const Text(
                                "1+1",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            height: 160,
                            child: InkWell(
                              onTap: () {
                                getImage("rtv");
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 1,
                                child: imageFile != null
                                    ? Image.file(
                                        File(imageFile!.path),
                                        fit: BoxFit.fill,
                                      )
                                    : Image.asset(
                                        "assets/icons/camera_icon.png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: const Text(
                                "Document Photo",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            height: 160,
                            child: InkWell(
                              onTap: () {
                                getImage("doc");
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 1,
                                child: docImageFile != null
                                    ? Image.file(
                                        File(docImageFile!.path),
                                        fit: BoxFit.fill,
                                      )
                                    : Image.asset(
                                        "assets/icons/camera_icon.png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isBtnLoading
                  ? const SizedBox(
                      width: 60,
                      height: 60,
                      child: MyLoadingCircle(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(ViewRtvOnePlusOneScreen.routeName);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(
                                left: 15,
                              ),
                              height: screenHeight / 18,
                              width: screenWidth / 3,
                              decoration: BoxDecoration(
                                  color: MyColors.greenColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Show",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  )
                                ],
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            saveStorePhotoData();
                          },
                          child: Container(
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              height: screenHeight / 18,
                              width: screenWidth / 3,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(26, 91, 140, 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(
                                    Icons.check_circle,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Save",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
