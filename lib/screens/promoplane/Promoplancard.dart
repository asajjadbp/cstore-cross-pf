
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/screens/promoplane/widgets/promo_plan_card_row_item.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/widget/drop_downs.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Model/database_model/sys_osdc_reason_model.dart';
import '../widget/elevated_buttons.dart';

class PromoPlanCard extends StatelessWidget {
  PromoPlanCard({super.key,
    required this.promoReasonModel,required this.promoStatus,required this.actStatus,required this.modalImage,
   required this.isBtnLoading,required this.skuName,required this.skuImage,required this.categoryName,
  required this.brandName,required this.fromDate,required this.toDate,
    required this.osdType,required this.pieces,required this.promoScope,
    required this.promoPrice,required this.leftOverPieces,required this.imageFile,
    required this.promoReasonValue,
    required this.onSelectImage,required this.statusValue,required this.onSaveClick,
  });

  bool isBtnLoading;
  int actStatus;
  String skuName;
  String skuImage;
  String modalImage;
  String categoryName;
  String brandName;
  String fromDate;
  String toDate;
  String osdType;
  String pieces;
  String promoScope;
  String promoPrice;
  String leftOverPieces;
  String promoStatus;
  late final File? imageFile;
  final Function onSelectImage;
  Function (String value) statusValue;
  final Function onSaveClick;
  List<Sys_OSDCReasonModel> promoReasonModel=[];
  int selectedReasonId=-1;
  Function (int value) promoReasonValue;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
          color: MyColors.background,),
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            promoStatus == "Yes".tr ? const Icon(Icons.check_circle_rounded,color: MyColors.greenColor,) :  promoStatus == "No" ? const Icon(Icons.warning_amber_rounded,color: MyColors.backbtnColor,) : const Icon(Icons.pending,color: MyColors.warningColor,) ,
           Card(
             elevation: 2,
             shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20))),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Container(
                   alignment: Alignment.center,
                   width: screenWidth,
                   padding:const EdgeInsets.symmetric(vertical: 10),
                    decoration:const BoxDecoration(
                        border: Border(top: BorderSide(color: MyColors.appMainColor,width: 3) ),
                        color: MyColors.whiteColor),
                   child: Row(
                     children: [
                     Container(
                       height: 40,
                       width: 40,
                       margin: const EdgeInsets.symmetric(horizontal: 10),
                       child: CachedNetworkImage(
                       imageUrl: skuImage,
                       imageBuilder: (context, imageProvider) => Container(
                         decoration: BoxDecoration(
                           image: DecorationImage(
                             image: imageProvider,
                             fit: BoxFit.fill,),
                         ),
                         ),
                       ),
                     ),
                       Expanded(child: Text(skuName,maxLines:1,overflow: TextOverflow.ellipsis,style: const TextStyle(color: MyColors.appMainColor),)),
                     ],
                   ),
                 ),
                  PromoPlanCardRowItems(title: "Category".tr,value: categoryName,isWhiteBackGround: false,),
                  PromoPlanCardRowItems(title: "Brands".tr,value: brandName,isWhiteBackGround: true,),
                  PromoPlanCardRowItems(title: "From".tr,value: fromDate,isWhiteBackGround: false,),
                  PromoPlanCardRowItems(title: "To".tr,value: toDate,isWhiteBackGround: true,),
                  PromoPlanCardRowItems(title: "OSD Type".tr,value: osdType,isWhiteBackGround: false,),
                  PromoPlanCardRowItems(title: "Pieces".tr,value: pieces,isWhiteBackGround: true,),
                  PromoPlanCardRowItems(title: "Promo Scope".tr,value: promoScope,isWhiteBackGround: false,),
                  PromoPlanCardRowItems(title: "Promo Price".tr,value: "$promoPrice SAR",isWhiteBackGround: true,),
                  PromoPlanCardRowItems(title: "Left Over Action".tr,value: leftOverPieces,isWhiteBackGround: false,),
               ],
             ),
           ),

            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Deployed Status"),

                    AdherenceDropDown(hintText: "Select Status",initialValue: promoStatus, unitData: const ['Yes','No'], onChange: (value){statusValue(value);}),
                  ],
                )),

            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Reason"),
                    OsdcReasonDropDown(hintText: "Select Reason",
                        osdcReasonData: promoReasonModel, onChange: (value) {
                          selectedReasonId = value.id;
                          promoReasonValue(selectedReasonId);
                        }),
                  ],
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
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
                            child: const Text(
                              "Model",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            )),
                        Card(
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width/2.2,
                            height: 155,
                            child: CachedNetworkImage(
                              imageUrl: modalImage,
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,),
                                ),
                              ),
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
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
                            child: const Text(
                              "Actual",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                              child: imageFile!= null ? Image.file(
                            File(imageFile!.path),
                            fit: BoxFit.fill,
                          ) : Image.asset("assets/icons/camera_icon.png"),
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
                ? const Center(child: SizedBox(height: 60,child: MyLoadingCircle(),),)
                : BigElevatedButton(
                buttonName: "Save",
                submit: (){
                  onSaveClick();
                },
                isBlueColor: true),

            // InkWell(
            //   onTap: () {
            //     onSaveClick();
            //   },
            //   child: Container(
            //     alignment: Alignment.center,
            //       height: screenHeight / 18,
            //       width: screenWidth,
            //       margin:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            //       decoration: BoxDecoration(
            //           color: const Color.fromRGBO(26, 91, 140, 1),
            //           borderRadius: BorderRadius.circular(5)),
            //       child: const Text(
            //         "Save",
            //         style: TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.w400,
            //             color: Colors.white),
            //       )),
            // ),
          ],
        ),
      ),
    );
  }
}
