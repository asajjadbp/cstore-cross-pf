import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Language/localization_controller.dart';
import '../../utils/appcolor.dart';

class OtherPhotoCard extends StatefulWidget {
   OtherPhotoCard({super.key,
    required this.imageFile,
    required this.clientName,
    required this.categoryName,
    required this.typeName,
    required this.uploadStatus,
    required this.dateTime,
    required this.onDeleteTap,
  });

  final File imageFile;
  final String clientName;
  final String categoryName;
  final String typeName;
  final int uploadStatus;
  final String dateTime;
  final Function onDeleteTap;
  final languageController = Get.put(LocalizationController());
  @override
  State<OtherPhotoCard> createState() => _OtherPhotoCardState();
}

class _OtherPhotoCardState extends State<OtherPhotoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 96,
                height: 100,
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6.0),
                      bottomLeft: Radius.circular(6.0),
                      topRight: Radius.circular(6.0),
                      bottomRight: Radius.circular(6.0),
                    ), // Image border
                    child: FittedBox(
                        fit: BoxFit.cover, child: Image.file(widget.imageFile))),
              ),
              const SizedBox(width: 5,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/client_icon.png"),
                        const SizedBox(width: 10,),
                        Expanded(child: Text(widget.clientName,overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500)))
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Component 13.svg",
                            width: 10,
                            height: 12,
                          ),
                          const SizedBox(width: 5,),
                          Expanded(child: Text(widget.categoryName,overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500)))
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/pick_list_icon_blue.png",width: 14,height: 14,),
                        const SizedBox(width: 5,),
                        Expanded(child: Text(widget.typeName,overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),))
                      ],
                    ),
                  ],
                ),
              ),
              if(widget.uploadStatus != 1)
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:  Text(
                                "Are you sure you want to delete this item Permanently".tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child:  Text("No".tr),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                                TextButton(
                                  child:  Text("Yes".tr),
                                  onPressed: () {
                                    widget.onDeleteTap();
                                  },
                                )
                              ],
                            );
                          },
                        );

                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  // Icon(
                  //   Icons.delete,
                  //   color: Colors.red,
                  // ),
                )
            ],
          ),
          widget.languageController.isEnglish.value ? Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: MyColors.appMainColor,
                  borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text(
                DateFormat('hh:mm aa').format(DateTime.parse(widget.dateTime)),
                style: const TextStyle(color: MyColors.whiteColor),
              ),
            ),
          ) : Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: MyColors.appMainColor,
                  borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text(
                DateFormat('hh:mm aa').format(DateTime.parse(widget.dateTime)),
                style: const TextStyle(color: MyColors.whiteColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
