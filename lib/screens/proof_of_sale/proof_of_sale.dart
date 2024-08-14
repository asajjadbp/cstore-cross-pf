import 'dart:io';

import 'package:cstore/Model/database_model/trans_add_proof_of_sale_model.dart';
import 'package:cstore/screens/proof_of_sale/show_proof_of_sale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/db_helper.dart';
import '../../Model/database_model/category_model.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/sys_photo_type.dart';
import '../promoplane/PromoPlan.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/drop_downs.dart';
import '../widget/image_selection_row_button.dart';
import 'package:path/path.dart' as path;

import '../widget/loading.dart';

class ProofOfSale extends StatefulWidget {
  static const routeName = "/proofOfSaleAdd";

  const ProofOfSale({super.key});

  @override
  State<ProofOfSale> createState() => _ProofOfSaleState();
}

class _ProofOfSaleState extends State<ProofOfSale> {
  String storeName = "";
  String workingId = "";
  TextEditingController valueControllerName = TextEditingController();
  TextEditingController valueControllerEmail = TextEditingController();
  TextEditingController valueControllerPhone = TextEditingController();
  TextEditingController valueControllerAmount = TextEditingController();
  TextEditingController valueControllerQuantity = TextEditingController();
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
  bool isLoading = false;
  String clientId = "";
  bool isBtnLoading = false;
  bool isSKusLoading = false;
  var imageName = "";
  File? imageFile;
  final GlobalKey<FormFieldState> categoryKey = GlobalKey<FormFieldState>();
  @override
  void initState() {
    getUserData();
    super.initState();
  }
  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    setState(() {});
    getClientData();
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
    skuDataList = [Sys_PhotoTypeModel(en_name: "", ar_name: "", id: -1)];
    setState(() {
      isSKusLoading = true;
    });

    await DatabaseHelper.getSkusList(catId).then((value) {
      setState(() {
        isSKusLoading = false;
      });
      skuDataList = value;
    });
    print(skuDataList[0].en_name);
  }
  Future<void> getImage() async {
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        return;
      }
      imageFile = value;

      final String extension = path.extension(imageFile!.path);
      imageName = "${DateTime.now().millisecondsSinceEpoch}$extension";
      setState(() {});
      // _takePhoto(value);
    });
  }
  void saveStorePhotoData() async {
    if (selectedClientId == -1 ||
        selectedSkuId == -1 ||
        valueControllerName == "" ||
        valueControllerEmail == "" ||
        valueControllerPhone == "" ||
        valueControllerQuantity == "" ||
        valueControllerAmount == "" ||
        imageFile == null) {
      ToastMessage.errorMessage(context, "Please fill the form and take image");
      return;
    }
    setState(() {
      isBtnLoading = true;
    });
    try {
      await takePicture(context, imageFile, imageName, workingId,
              AppConstants.pos)
          .then((_) async {
        var now = DateTime.now();
        await DatabaseHelper.insertTransPOS(TransAddProfOfSale(
                name: valueControllerName.text,
                email: valueControllerEmail.text,
                phone: valueControllerPhone.text,
                client_id: selectedClientId,
                cat_id: selectedClientId,
                qty: int.parse(valueControllerQuantity.text),
                sku_id: selectedSkuId,
                Amount: valueControllerAmount.text,
                image_name: imageName,
                upload_status: 0,
                gcs_status: 0,
                date_time: now.toString(),
                working_id: int.parse(workingId)))
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: generalAppBar(context, storeName, "Add POS", () {
        Navigator.of(context).pop();
      }, () {

      }, true, false, false),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name*",
                          style: TextStyle(
                              color: MyColors.appMainColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          height: 55,
                          color: Colors.white,
                          child: TextField(
                            showCursor: true,
                            enableInteractiveSelection: false,
                            onChanged: (value) {},
                            controller: valueControllerName,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                prefixIconColor: MyColors.appMainColor,
                                focusColor: MyColors.appMainColor,
                                fillColor: MyColors.dropBorderColor,
                                labelStyle:
                                    TextStyle(color: MyColors.appMainColor),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors.appMainColor)),
                                border: OutlineInputBorder(),
                                hintText: 'Enter name'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email*",
                          style: TextStyle(
                              color: MyColors.appMainColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          height: 55,
                          color: Colors.white,
                          child: TextField(
                            showCursor: true,
                            enableInteractiveSelection: false,
                            onChanged: (value) {},
                            controller: valueControllerEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                prefixIconColor: MyColors.appMainColor,
                                focusColor: MyColors.appMainColor,
                                fillColor: MyColors.dropBorderColor,
                                labelStyle:
                                    TextStyle(color: MyColors.appMainColor),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors.appMainColor)),
                                border: OutlineInputBorder(),
                                hintText: 'Enter email'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Phone Number*",
                          style: TextStyle(
                              color: MyColors.appMainColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          height: 55,
                          color: Colors.white,
                          child: TextField(
                            showCursor: true,
                            enableInteractiveSelection: false,
                            onChanged: (value) {},
                            controller: valueControllerPhone,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixIconColor: MyColors.appMainColor,
                                focusColor: MyColors.appMainColor,
                                fillColor: MyColors.dropBorderColor,
                                labelStyle:
                                    TextStyle(color: MyColors.appMainColor),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors.appMainColor)),
                                border: OutlineInputBorder(),
                                hintText: 'Enter phone'),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9][0-9]*'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Quantity*",
                          style: TextStyle(
                              color: MyColors.appMainColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          height: 55,
                          color: Colors.white,
                          child: TextField(
                            showCursor: true,
                            enableInteractiveSelection: false,
                            onChanged: (value) {},
                            controller: valueControllerQuantity,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixIconColor: MyColors.appMainColor,
                                focusColor: MyColors.appMainColor,
                                fillColor: MyColors.dropBorderColor,
                                labelStyle:
                                    TextStyle(color: MyColors.appMainColor),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors.appMainColor)),
                                border: OutlineInputBorder(),
                                hintText: 'Enter qty*'),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9][0-9]*'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Phone Amount*",
                          style: TextStyle(
                              color: MyColors.appMainColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          height: 55,
                          color: Colors.white,
                          child: TextField(
                            showCursor: true,
                            enableInteractiveSelection: false,
                            onChanged: (value) {},
                            controller: valueControllerAmount,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixIconColor: MyColors.appMainColor,
                                focusColor: MyColors.appMainColor,
                                fillColor: MyColors.dropBorderColor,
                                labelStyle:
                                TextStyle(color: MyColors.appMainColor),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors.appMainColor)),
                                border: OutlineInputBorder(),
                                hintText: 'Enter amount'),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9][0-9]*'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Client*",
                          style: TextStyle(
                              color: MyColors.appMainColor,
                              fontWeight: FontWeight.bold),
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
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Category*",
                    style: TextStyle(
                        color: MyColors.appMainColor,
                        fontWeight: FontWeight.bold),
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
              const SizedBox(
                height: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sku's*",
                    style: TextStyle(
                        color: MyColors.appMainColor,
                        fontWeight: FontWeight.bold),
                  ),
                  TypeDropDown(
                      hintText: "Select sku",
                      photoData: skuDataList,
                      onChange: (value) {
                        selectedSkuId = value.id;
                        setState(() {});
                      }),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              ImageRowButton(
                  imageFile: imageFile,
                  onSelectImage: () {
                    getImage();
                  },
                isRequired: false,),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.appMainColor,
                    minimumSize: Size(screenWidth, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  // Navigator.of(context).pushNamed();
                  saveStorePhotoData();
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.greenColor,
                    minimumSize: Size(screenWidth, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Navigator.of(context).pushNamed(ShowProofOfSaleScreen.routename);
                },
                child: const Text(
                  "Show",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
