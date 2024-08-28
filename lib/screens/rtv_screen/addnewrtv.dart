import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import '../../Database/db_helper.dart';
import '../../Model/database_model/sys_rtv_reason_model.dart';
import '../../Model/database_model/trans_rtv_model.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/appcolor.dart';
import '../utils/services/image_picker.dart';
import '../utils/services/take_image_and_save_to_folder.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';
import '../widget/drop_downs.dart';
import '../widget/image_selection_row_button.dart';
import '../widget/loading.dart';
import 'package:intl/intl.dart';
class addnewrtvscreen extends StatefulWidget {
  addnewrtvscreen({super.key, required this.sku_id, required this.imageName,required this.SkuName});
  int sku_id;
  String imageName;
  String SkuName;

  @override
  State<addnewrtvscreen> createState() => _addnewrtvscreenState();
}

class _addnewrtvscreenState extends State<addnewrtvscreen> {

  final languageController = Get.put(LocalizationController());

  List<Sys_RTVReasonModel> reasonData = [];
  int selectedReasonId = -1;
  bool isInit = true;
  var imageName = "";
  File? imageFile;
  bool isLoading = false;
  bool isBtnLoading = false;
  String clientId = "";
  String workingId = "";
  String storeEnName = "";
  String storeArName = "";
  String userName = "";
  TextEditingController totalPieces = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  DateTime? pickedDate;
  String formattedDate = "Select Date".tr;
  int index=-1;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    getUserData();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    storeEnName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;

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

  Future<void> getImage() async {
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        return;
      }
      imageFile = value;

      final String extension = path.extension(imageFile!.path);
      imageName = "${userName}_${DateTime.now().millisecondsSinceEpoch}$extension";
      setState(() {});
      // _takePhoto(value);
    });
  }

  void saveStorePhotoData() async {
    if (imageFile == null || selectedReasonId==-1) {
      ToastMessage.errorMessage(context, "Please fill the form and take image".tr);
      return;
    }
    setState(() {
      isBtnLoading = true;
    });
    try {
      await takePicture(context, imageFile, imageName, workingId, AppConstants.rtv)
          .then((_) async {
        var now = DateTime.now();

        var formattedTime = DateFormat('HH:mm:ss').format(now);
        await DatabaseHelper.insertTransRtvData(TransRtvModel(
                sku_id: widget.sku_id,
                pieces: int.parse( totalPieces.text),
                reason: selectedReasonId,
                expire_date: formattedDate,
                image_name: imageName,
                act_status: 1,
                gcs_status: 0,
                date_time: formattedTime.toString(),
                upload_status: 0,
                working_id: int.parse(workingId)))
            .then((_) {
          ToastMessage.succesMessage(context, "Data Saved Successfully".tr);
          totalPieces.text = "";
          formattedDate="Select Date";
          imageFile = null;

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color(0xFFF4F7FD),
        appBar: generalAppBar(context, languageController.isEnglish.value ? storeEnName : storeArName, userName, (){
          Navigator.of(context).pop();
        }, true, false, false,(int getClient, int getCat, int getSubCat, int getBrand) {
        }),
        body: SingleChildScrollView(
          child: Container(
            margin:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Column(
              children: [
                Container(
                  height: screenHeight/7.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300,width: 1),
                    borderRadius: const BorderRadius.all( Radius.circular(7)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.imageName,
                        width: 100,
                        height: 110,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6.0),
                                    bottomLeft: Radius.circular(6.0),
                                    topRight: Radius.circular(6.0),
                                    bottomRight: Radius.circular(6.0),
                                  ),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitWidth)));
                        },
                        placeholder: (context, url) => const SizedBox(
                            width: 20, height: 10, child: MyLoadingCircle()),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                       SizedBox(
                         width:screenWidth/1.9 ,
                         child: Text(widget.SkuName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Color(0xFF1A5B8C,),
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                      ),
                       ),
                      const SizedBox(width: 5,),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight / 60,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reason".tr,
                      style:const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    RtvReasonDropDown(
                        hintText: "RTV ${"Reason".tr}",
                        reasonData: reasonData,
                        onChange: (value) {
                          selectedReasonId = value.id;
                         index= int.parse(value.calendar);
                          setState(() {});
                        }),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pieces".tr,
                      style:const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      height: 55,
                      color: Colors.white,
                      child: TextField(
                        showCursor: true,
                        enableInteractiveSelection: false,
                        onChanged: (value) {
                          print(value);
                        },
                        controller: totalPieces,
                        keyboardType: TextInputType.number,
                        decoration:  InputDecoration(
                            prefixIconColor: MyColors.appMainColor,
                            focusColor: MyColors.appMainColor,
                            fillColor: MyColors.dropBorderColor,
                            labelStyle:const TextStyle(
                                color: MyColors.appMainColor, height: 50.0),
                            focusedBorder:const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: MyColors.appMainColor)),
                            border:const OutlineInputBorder(),
                            hintText: 'Enter Pieces'.tr),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9][0-9]*'))
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight / 60,
                ),
               index==1? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 14, bottom: 8),
                        child:  Text(
                          "Date".tr,
                          style:const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )),
                    Container(
                      height: 55,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: MyColors.darkGreyColor, width: 1)),
                      child: InkWell(
                          onTap: () async {
                            pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate!);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                dateInput.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                          child: Container(
                            alignment: languageController.isEnglish.value ? Alignment.centerLeft  : Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                formattedDate.isNotEmpty || formattedDate != null  ? formattedDate.toString() : languageController.isEnglish.value ? "Select Date" : "حدد التاريخ",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ))),
                    ),
                  ],
                ):const SizedBox(height: 5,),
                SizedBox(
                  height: screenHeight / 60,
                ),
                ImageRowButton(
                    imageFile: imageFile,
                    isRequired: false,
                    onSelectImage: () {
                      getImage();
                    }),
                SizedBox(
                  height: screenHeight / 46,
                ),
                isBtnLoading ? const SizedBox(
                  width: 60,
                  height: 60,
                  child: MyLoadingCircle(),)  : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                      Navigator.of(context).pop();
                      },
                      child: Container(
                          margin: const EdgeInsets.only(
                            left: 15,
                          ),
                          height: screenHeight / 18,
                          width: screenWidth / 3,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(234, 70, 86, 1),
                              borderRadius: BorderRadius.circular(5)),
                          child:  Row(
                            children: [
                              const  SizedBox(
                                width: 15,
                              ),
                              const Icon(
                                Icons.arrow_circle_left,
                                size: 35,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Back".tr,
                                style:const TextStyle(
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
                          child:  Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              const  Icon(
                                Icons.check_circle,
                                size: 35,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Save".tr,
                                style:const TextStyle(
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
          ),
        ));
  }
}
