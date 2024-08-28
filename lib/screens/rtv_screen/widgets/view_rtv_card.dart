import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Language/localization_controller.dart';
import '../../widget/loading.dart';

class Viewrtvcard extends StatelessWidget {
   Viewrtvcard({
    super.key,
    required this.time,
    required this.title,
    required this.proImage,
    required this.rtvImage,
    required this.type,
    required this.piece,
    required this.onDelete,
    required this.expdate,
    required this.uploadStatus,
  });

  final String time;
  final String title;
  final String proImage;
  final File rtvImage;
  final String type;
  final String piece;
  final String expdate;
  final int uploadStatus;
  final Function onDelete;

  final languageController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: MyColors.dropBorderColor,
      margin: const EdgeInsets.all(6),
      child: Container(
        decoration:  BoxDecoration(
          border: Border(
            top: BorderSide(
                color: expdate!="Select Date"?MyColors.appMainColor:MyColors.backbtnColor,width: 5),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                 padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                  decoration:  BoxDecoration(
                      color: MyColors.appMainColor,
                      borderRadius: languageController.isEnglish.value ? const BorderRadius.only(bottomRight: Radius.circular(10)) : const BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Text(
                    time,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(top: 5,left: 10,right: 10),
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: MyColors.appMainColor),
                      )),
                ),
               uploadStatus==0?InkWell(
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
                    width: 130,
                    height: 110,
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
                    width: 130,
                    height: 110,
                    child: CachedNetworkImage(
                      imageUrl: proImage,
                      width: 80,
                      height: 100,
                      imageBuilder: (context, imageProvider) {
                        return Container(
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
            Container(
              height: 35,
              decoration: const BoxDecoration(
                  color: Colors.white, border: Border(top: BorderSide.none)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      child:  Text('Type'.tr,
                          style:const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black))),
                  const SizedBox(
                    width: 110,
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                        right: 90,
                      ),
                      child: Text(type,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)))
                ],
              ),
            ),
            const Divider(
                height: 00,
                thickness: 1,
                color: Color.fromRGBO(26, 91, 140, 1)),
            Container(
              height: 35,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(244, 247, 253, 1),
                  border: Border(top: BorderSide.none)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 15),
                      child:  Text('Pieces'.tr,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black))),
                  const SizedBox(
                    width: 110,
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                        right: 120,
                      ),
                      child: Text(piece,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)))
                ],
              ),
            ),
            const Divider(
                height: 00, thickness: 1, color: MyColors.appMainColor),
            expdate != "Select Date"
                ? Container(
                    height: 35,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide.none),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 20),
                            child:  Text('Exp Date'.tr,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black))),
                        const SizedBox(
                          width: 110,
                        ),
                        Text(expdate,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black))
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
