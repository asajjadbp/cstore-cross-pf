import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/sys_market_issue_model.dart';
import '../../Model/database_model/trans_market_issue_model.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/drop_downs.dart';
import '../widget/elevated_buttons.dart';
import '../widget/image_selection_row_button.dart';
import 'package:path/path.dart' as path;
import '../widget/loading.dart';
import 'market_issues_show.dart';

class AddMarketIssue extends StatefulWidget {
  static const routeName = "/add_market_issue";

  const AddMarketIssue({super.key});

  @override
  State<AddMarketIssue> createState() => _AddMarketIssueState();
}

class _AddMarketIssueState extends State<AddMarketIssue> {
  final languageController = Get.put(LocalizationController());
  String storeEnName = "";
  String storeArName = "";
  String workingId = "";
  TextEditingController valueControllerComment = TextEditingController();
  final GlobalKey<FormFieldState> clientKey = GlobalKey<FormFieldState>();
  int selectedClientId = -1;
  int selectedIssueId = -1;
  List<ClientModel> clientData = [];
  List<sysMarketIssueModel> marketIssueModel = [];
  bool isLoading = false;
  bool isIssueLoading = false;
  String clientId = "";
  bool isBtnLoading = false;
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
    storeEnName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    setState(() {});
    getClientData();
    getMarketIssueData();
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
  void getMarketIssueData() async {
    setState(() {
      isLoading = true;
    });
    await DatabaseHelper.getMarketIssueDropDownList().then((value) {
      setState(() {
        isLoading = false;
      });
      marketIssueModel = value;
      print("market issue $marketIssueModel");
    });
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
        selectedIssueId == -1 ||
        imageFile == null) {
      showAnimatedToastMessage("Error!".tr,"Please fill the form and take image".tr, false);
      return;
    }
    setState(() {
      isBtnLoading = true;
    });
    try {
      await takePicture(
              context, imageFile, imageName, workingId, AppConstants.marketIssues)
          .then((_) async {
        var now = DateTime.now();
        await DatabaseHelper.insertTransMarketIssue(TransMarketIssueModel(
                issue_id: selectedIssueId,
                client_id: selectedClientId.toString(),
                comment: valueControllerComment.text,
                gcs_status: 0,
                upload_status: 0,
                date_time: now.toString(),
                working_id: int.parse(workingId),
            imageName: imageName))
            .then((_) {
          showAnimatedToastMessage("Success".tr,"Data Saved Successfully".tr, true);
           valueControllerComment.text="";
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
      showAnimatedToastMessage("Error!".tr,error.toString().tr, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: generalAppBar(context,  languageController.isEnglish.value ? storeEnName :storeArName, "Add Market Issue", () {
        Navigator.of(context).pop();
      }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {

      }),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                          children: [
                            Text(
                              "Client".tr,
                              style: const TextStyle(
                                  color: MyColors.appMainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              " *",
                              style: TextStyle(
                                  color: MyColors.backbtnColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ClientListDropDown(
                            clientKey: clientKey,
                            hintText: "Client".tr,
                            clientData: clientData,
                            onChange: (value) {
                              selectedClientId = value.client_id;
                              setState(() {});
                            }),
                      ],
                    ),
                    Container(
                      margin:const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Row(
                            children: [
                              Text(
                                "Market Issue".tr,
                                style: const TextStyle(
                                    color: MyColors.appMainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                " *",
                                style: TextStyle(
                                    color: MyColors.backbtnColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          MarketIssueDropDown(hintText: "Select issue".tr,
                              reasonData: marketIssueModel,
                              onChange:  (value) {
                                selectedIssueId = value.id;
                                setState(() {});
                              })
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          "Comment".tr,
                          style: const TextStyle(
                              color: MyColors.appMainColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          color: Colors.white,
                          child: TextField(
                              showCursor: true,
                              enableInteractiveSelection: false,
                              onChanged: (value) {},
                              controller: valueControllerComment,
                              keyboardType: TextInputType.text,
                              decoration:  InputDecoration(
                                  prefixIconColor: MyColors.appMainColor,
                                  focusColor: MyColors.appMainColor,
                                  fillColor: MyColors.dropBorderColor,
                                  labelStyle: const TextStyle(color: MyColors.appMainColor),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: MyColors.appMainColor)),
                                  border: const OutlineInputBorder(),
                                  hintText: 'Enter comment'.tr)),
                        ),
                      ],
                    ),
                    Container(
                      margin:const EdgeInsets.symmetric(vertical: 5),
                      child: ImageRowButton(
                          isRequired: true,
                          imageFile: imageFile,
                          onSelectImage: () {
                            getImage();
                          }),
                    ),
                    isBtnLoading ? const SizedBox(height: 60,width: 60,child: MyLoadingCircle(),) : BigElevatedButton(
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
              child: BigElevatedButton(
                  buttonName: "View Market Issue".tr,
                  submit: (){
                    Navigator.of(context)
                        .pushNamed(ViewMarketIssueScreen.routename);
                  },
                  isBlueColor: false),
            ),
          ],
        ),
      ),
    );
  }
}
