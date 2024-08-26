import 'dart:io';
import 'package:cstore/Model/database_model/trans_rtv_one_plus_one.dart';
import 'package:cstore/screens/rtv_1+1/view_rtv_one_plus_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import '../../Database/db_helper.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/sys_photo_type.dart';
import '../../Model/database_model/sys_rtv_reason_model.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/drop_downs.dart';
import '../widget/elevated_buttons.dart';
import '../widget/loading.dart';
import 'package:intl/intl.dart';

class AddRtvOnePlusOne extends StatefulWidget {
  static const routeName = "/add_onePlusOne";
  const AddRtvOnePlusOne({super.key,});
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
  String userName = "";
  TextEditingController totalPieces = TextEditingController();
  TextEditingController edDocNumber = TextEditingController();
  TextEditingController edComment = TextEditingController();
  DateTime? pickedDate;
  late String formattedDate = "Select Date";
  int index = -1;
  String _selectedType = "";
  List<String> unitList = ['1+1'];

  int selectedSkuId = -1;
  final GlobalKey<FormFieldState> clientKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> skuKey = GlobalKey<FormFieldState>();
  int selectedClientId = -1;
  List<ClientModel> clientData = [];
  List<CategoryModel> categoryData = [CategoryModel( client: -1, id: -1, en_name: '', ar_name: '')];
  int selectedCategoryId = -1;
  bool isCategoryLoading = false;
  List<Sys_PhotoTypeModel> skuDataList = [
    Sys_PhotoTypeModel(id: -1, en_name: "", ar_name: "")
  ];
  bool isSKusLoading = false;
  final GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> typeKey = GlobalKey<FormFieldState>();

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
      getReasonData();
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
  void getSkusData(int catId) async {
    selectedSkuId = -1;
    skuKey.currentState!.reset();
    skuDataList = [Sys_PhotoTypeModel(en_name: "", ar_name: "", id: -1)];
    setState(() {
      isSKusLoading = true;
    });

    await DatabaseHelper.getSkusList(catId,workingId).then((value) {
      setState(() {
        isSKusLoading = false;
      });
      skuDataList = value;
    });
    print(skuDataList[0].en_name);
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
        imageName = "${userName}_${DateTime.now().millisecondsSinceEpoch}$extension";
      } else {
        docImageFile = value;
        final String docExtension = path.extension(docImageFile!.path);
        docImageName = "${userName}_${DateTime.now().millisecondsSinceEpoch}$docExtension";
      }
      setState(() {});
    });
  }

  void saveStorePhotoData() async {
    if (imageFile == null ||
        docImageFile == null ||
        _selectedType == "" ||
        edDocNumber.text.isEmpty ||
        totalPieces.text.isEmpty ||
        selectedSkuId == -1 || selectedCategoryId == -1 || selectedClientId == -1) {
      ToastMessage.errorMessage(context, "Please fill the form and take image");
      return;
    }
    setState(() {
      isBtnLoading = true;
    });
    try {
      await takePicture(
              context, imageFile, imageName, workingId, AppConstants.onePlusOne)
          .then((_) async {
        var now = DateTime.now();
        var formattedTime = DateFormat('HH:mm').format(now);
        await DatabaseHelper.insertTransRtvOnePlusOne(TransRtvOnePlusOneModel(
                sku_id: selectedSkuId,
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
      });

        await takePicture(context, docImageFile, docImageName, workingId, AppConstants.onePlusOne)
            .then((_) async {
          print("image add success $docImageFile");
          print("imageName add success $docImageName");
          totalPieces.clear();
          edComment.clear();
          selectedSkuId = -1;
          skuKey.currentState!.reset();
          setState(() {
            isBtnLoading = false;
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

    return Scaffold(
        backgroundColor: const Color(0xFFF4F7FD),
        appBar: generalAppBar(context, storeName, userName, () {
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
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "Client",
                                  style: TextStyle(
                                      color: MyColors.appMainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(" *",style: TextStyle(color: MyColors.backbtnColor),)
                              ],
                            ),
                            ClientListDropDown(
                                clientKey: clientKey,
                                hintText: "Client",
                                clientData: clientData,
                                onChange: (value) {
                                  selectedClientId = value.client_id;
                                  getCategoryData(selectedClientId);
                                  setState(() {});
                                }),
                          ],
                        ),
                      ),
                      Container(
                        color: MyColors.whiteColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "Category",
                                  style: TextStyle(
                                      color: MyColors.appMainColor,
                                      fontWeight: FontWeight.bold),
                                ),

                                Text(" *",style: TextStyle(color: MyColors.backbtnColor),)
                              ],
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
                              getSkusData(selectedCategoryId);
                              setState(() {

                              });
                            }),

                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "Sku's",
                                  style: TextStyle(
                                      color: MyColors.appMainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(" *",style: TextStyle(color: MyColors.backbtnColor),)
                              ],
                            ),
                            TypeDropDown(
                                typeKey: skuKey,
                                hintText: "Select sku",
                                photoData: skuDataList,
                                onChange: (value) {
                                  selectedSkuId = value.id;
                                  setState(() {});
                                }),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "Pieces",
                                      style: TextStyle(
                                          color: MyColors.appMainColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(" *",style: TextStyle(color: MyColors.backbtnColor),)
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    showCursor: true,
                                    enableInteractiveSelection: false,
                                    onChanged: (value) {},
                                    controller: totalPieces,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        prefixIconColor: MyColors.appMainColor,
                                        focusColor: MyColors.appMainColor,
                                        fillColor: MyColors.whiteColor,
                                        filled: true,
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
                          ),
                         const SizedBox(width: 5,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "Type",
                                      style: TextStyle(
                                          color: MyColors.appMainColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(" *",style: TextStyle(color: MyColors.backbtnColor),)
                                  ],
                                ),
                                UnitDropDown(
                                    hintText: "Select type",
                                    unitData: unitList,
                                    onChange: (value) {
                                      print(value);
                                      _selectedType = value;
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "Document No",
                                  style: TextStyle(
                                      color: MyColors.appMainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(" *",style: TextStyle(color: MyColors.backbtnColor),)
                              ],
                            ),
                            SizedBox(
                              height: 50,
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
                                      fillColor: MyColors.whiteColor,
                                      filled: true,
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
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Comment",
                                style: TextStyle(
                                    color: MyColors.appMainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
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
                                    fillColor: MyColors.whiteColor,
                                    filled: true,
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
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "1 + 1",
                                        style: TextStyle(
                                            color: MyColors.appMainColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(" *",style: TextStyle(color: MyColors.backbtnColor),)
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.2,
                                    height: 120,
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
                                  const Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Document Photo",
                                        style: TextStyle(
                                            color: MyColors.appMainColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(" *",style: TextStyle(color: MyColors.backbtnColor),)
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.2,
                                    height: 120,
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
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: isBtnLoading
                            ? const SizedBox(
                                width: 60,
                                height: 60,
                                child: MyLoadingCircle(),
                              )
                            : BigElevatedButton(
                            buttonName: "Save",
                            submit: (){
                              saveStorePhotoData();
                            },
                            isBlueColor: true),

                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: BigElevatedButton(
                    buttonName: "View 1 + 1",
                    submit: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewRtvOnePlusOneScreen(),
                        ),
                      );
                    },
                    isBlueColor: false),
              )
            ],
          ),
        ));
  }
}
