import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../Database/db_helper.dart';
import '../../utils/app_constants.dart';
import '../../utils/appcolor.dart';
import '../../utils/services/take_image_and_save_to_folder.dart';
import '../../utils/toast/toast.dart';
import '../../widget/drop_downs.dart';
import '../../widget/elevated_buttons.dart';
import '../../widget/loading.dart';

class PlanoguidesCard extends StatelessWidget {
  final String fieldValue1;
  final String labelName1;
  final String fieldValue2;
  final String labelName2;
  final String image;
  late final File? imageFile;
  final Function onSelectImage;
  final Function(String value) selectedUnit;
  final Function onSaveClick;
  final List<String> unitList;
  final String initialValue;
  BuildContext context;
  final bool isBtnLoading;
  final bool isActivity;
  final Function onImageTap;

  PlanoguidesCard(
      {super.key,
        required this.onImageTap,
        required this.isActivity,
      required this.fieldValue1,
      required this.labelName1,
      required this.fieldValue2,
      required this.labelName2,
      required this.image,
      required this.unitList,
      required this.selectedUnit,
      required this.onSaveClick,
      required this.imageFile,
      required this.initialValue,
     required this.context,
        required this.isBtnLoading,
      required this.onSelectImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color(0XFF00000026).withOpacity(0.10), width: 1)),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           Container(
               margin: const EdgeInsets.only(left: 5,),
               child: Icon(Icons.pending,color: isActivity ? MyColors.greenColor : MyColors.warningColor,)),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: TextFormField(
                readOnly: true,
                initialValue: fieldValue1,
                decoration: InputDecoration(
                  // hintText: hintName3,
                    labelText: labelName1,
                    labelStyle: const TextStyle(color: MyColors.darkGreyColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: MyColors.darkGreyColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        width: 2.0,
                        color: MyColors.darkGreyColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )
                ),
              )),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: TextFormField(
                readOnly: true,
                initialValue: fieldValue2,
                decoration: InputDecoration(
                  // hintText: hintName3,
                    labelText: labelName2,
                    labelStyle: const TextStyle(color: MyColors.darkGreyColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: MyColors.darkGreyColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        width: 2.0,
                        color: MyColors.darkGreyColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )
                ),
              )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: AdherenceDropDown(
                hintText: "Select Status".tr,
                unitData: unitList,
                initialValue: initialValue,
                onChange: (value) {
                  selectedUnit(value);
                }),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 8, left: 10, bottom: 5),
                          child:  Text(
                            "Model".tr,
                            style:const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          )),
                      InkWell(
                        onTap: (){
                          onImageTap();
                        },
                        child: Card(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width/2.2,
                            height: 155,
                            child: Card(
                              child: SvgPicture.asset("assets/images/pdf_icon.svg",height: 70,)
                            ),
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
                          margin: const EdgeInsets.only(top: 8, right: 115, bottom: 5),
                          child:  Text(
                            "Actual".tr,
                            style:const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width/2.2,
                        height: 160,
                        child: InkWell(
                          onTap: () {
                            onSelectImage();
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 1,
                            child: imageFile != null
                                ? Image.file(
                              File(imageFile!.path),
                              fit: BoxFit.fill,
                            )
                                : Image.asset("assets/icons/camera_icon.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isBtnLoading ? const Center(
            child: SizedBox(
              height: 60,
              child: MyLoadingCircle(),
            ),
          ): Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: BigElevatedButton(
                buttonName: "Save".tr,
                submit: (){
                 onSaveClick();
                },
                isBlueColor: true),
          ),
          // InkWell(
          //   onTap: () {
          //     onSaveClick();
          //     // Navigator.push(context, MaterialPageRoute(builder: (context) => const Shelf_Shares_Screen(),));
          //   },
          //   child: Container(
          //       margin: const EdgeInsets.only(left: 8, right: 8, top: 10),
          //       height: screenHeight / 18,
          //       width: screenWidth / 1,
          //       decoration: BoxDecoration(
          //           color: const Color.fromRGBO(26, 91, 140, 1),
          //           borderRadius: BorderRadius.circular(5)),
          //       child: Row(
          //         children: [
          //           Container(
          //               margin: EdgeInsets.only(left: screenWidth / 3),
          //               child: const Icon(
          //                 Icons.check_circle,
          //                 size: 25,
          //                 color: Colors.white,
          //               )),
          //           const SizedBox(
          //             width: 8,
          //           ),
          //           const Text(
          //             "Save",
          //             style: TextStyle(
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.w400,
          //                 color: Colors.white),
          //           )
          //         ],
          //       )),
          // ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

class DropButtonPlanoguides extends StatelessWidget {
  final String title;
  final String subtitle;

  DropButtonPlanoguides({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 8,
          ),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 5),
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF1A5B8C), width: 1),
              borderRadius: BorderRadius.circular(7)),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(7)),
            // color: Colors.white
            child: DropdownButton(
              underline: const SizedBox(),
              iconSize: 40,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                ),
              ),
              items: [],
              onChanged: (value) {},
            ),
          ),
        ),
      ],
    );
  }
}
