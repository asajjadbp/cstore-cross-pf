import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/db_helper.dart';
import '../../Model/database_model/client_model.dart';
import '../../Model/database_model/sys_market_issue_model.dart';
import '../../Model/database_model/trans_market_issue_model.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/drop_downs.dart';
import '../widget/image_selection_row_button.dart';
import 'package:path/path.dart' as path;
import 'market_issues_show.dart';

class AddMarketIssue extends StatefulWidget {
  static const routeName = "/add_market_issue";

  const AddMarketIssue({super.key});

  @override
  State<AddMarketIssue> createState() => _AddMarketIssueState();
}

class _AddMarketIssueState extends State<AddMarketIssue> {
  String storeName = "";
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
    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
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
        valueControllerComment == "" ||
        imageFile == null) {
      ToastMessage.errorMessage(context, "Please fill the form and take image");
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
                client_id: clientId,
                comment: valueControllerComment.text,
                gcs_status: 0,
                upload_status: 0,
                date_time: now.toString(),
                working_id: int.parse(workingId),
            imageName: imageName))
            .then((_) {
          ToastMessage.succesMessage(context, "Data store successfully");
           selectedIssueId=-1;
           selectedClientId=-1;
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
      ToastMessage.errorMessage(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: generalAppBar(context, storeName, "Add Market Isue", () {
        Navigator.of(context).pop();
      }, () {}, true, false, false),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
          child: Column(
            children: [
              Column(
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
                        setState(() {});
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
                    "Market Issue*",
                    style: TextStyle(
                        color: MyColors.appMainColor,
                        fontWeight: FontWeight.bold),
                  ),
                  MarketIssueDropdown(hintText: "Select issue",
                      markeIsueModels: marketIssueModel,
                      onChange:  (value) {
                        selectedIssueId = value.id;
                        setState(() {});
                      })
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
                    "Comment",
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
                        controller: valueControllerComment,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            prefixIconColor: MyColors.appMainColor,
                            focusColor: MyColors.appMainColor,
                            fillColor: MyColors.dropBorderColor,
                            labelStyle: TextStyle(color: MyColors.appMainColor),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: MyColors.appMainColor)),
                            border: OutlineInputBorder(),
                            hintText: 'Enter comment')),
                  ),
                ],
              ),
              ImageRowButton(
                  imageFile: imageFile,
                  onSelectImage: () {
                    getImage();
                  }),
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
                  Navigator.of(context)
                      .pushNamed(ViewMarketIssueScreen.routename);
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
