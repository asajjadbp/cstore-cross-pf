import 'dart:io';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Language/localization_controller.dart';
import '../../promoplane/widgets/promo_plan_card_row_item.dart';

class ViewrtvOnePlusOnecard extends StatelessWidget {
  ViewrtvOnePlusOnecard({
    super.key,
    required this.time,
    required this.proName,
    required this.docImage,
    required this.rtvImage,
    required this.docNumber,
    required this.comment,
    required this.type,
    required this.piece,
    required this.onDelete,
    required this.upload_status,
  });

  final String time;
  final int upload_status;
  final String proName;
  final File rtvImage;
  final File docImage;
  final String type;
  final String piece;
  final String comment;
  final String docNumber;
  final Function onDelete;
  final languageController = Get.put(LocalizationController());
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 3,
      color: MyColors.dropBorderColor,
      margin: const EdgeInsets.all(6),
      child: Container(
        decoration:  const BoxDecoration(
          border: Border(
            top: BorderSide(
                color:MyColors.appMainColor,width: 5),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration:  BoxDecoration(
                      color: MyColors.appMainColor,
                      borderRadius:
                      languageController .isEnglish.value ? const BorderRadius.only(bottomRight: Radius.circular(10)) :const BorderRadius.only(bottomLeft: Radius.circular(10))  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                    child: Text(
                      time,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      child: Text(
                        proName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: MyColors.appMainColor),
                      )),
                ),
                upload_status==0 ? InkWell(
                    onTap: () {
                      onDelete();
                    },
                    child: Container(
                        margin: const EdgeInsets.only(right: 3),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))):const SizedBox()
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          bottomLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0),
                        ), // Image border
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: rtvImage != null
                                ? Image.file(rtvImage)
                                : Container())),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          bottomLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0),
                        ), // Image border
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: docImage != null
                                ? Image.file(docImage)
                                : Container())),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            const Divider(
                height: 00,
                thickness: 1,
                color: Color.fromRGBO(26, 91, 140, 1)),
            PromoPlanCardRowItems(title: "Type".tr,value: type,isWhiteBackGround: false,),
            const Divider(
                height: 00,
                thickness: 1,
                color: Color.fromRGBO(26, 91, 140, 1)),
            PromoPlanCardRowItems(title: "Pieces".tr,value: piece,isWhiteBackGround: true,),
            const Divider(
                height: 00,
                thickness: 1,
                color: Color.fromRGBO(26, 91, 140, 1)),
            PromoPlanCardRowItems(title: "Document No".tr,value: docNumber,isWhiteBackGround: false,),
            const Divider(
                height: 00, thickness: 1, color: MyColors.appMainColor),
            PromoPlanCardRowItems(title: "Comment".tr,value: comment,isWhiteBackGround: true,),

          ],
        ),
      ),
    );
  }
}
