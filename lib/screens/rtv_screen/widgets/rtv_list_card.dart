import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Language/localization_controller.dart';
import '../../widget/loading.dart';

class Rtvcard extends StatelessWidget {
  Rtvcard({
    super.key,
    required this.imageName,
    required this.productName,
    required this.icon1,
    required this.category,
    required this.icon2,
    required this.brandName,
    required this.rsp,
    required this.skuId,
    required this.activityStatus,
  });
  final languageController = Get.put(LocalizationController());
  final String imageName;
  final String productName;
  final Icon icon1;
  final String category;
  final Icon icon2;
  final String brandName;
  final String rsp;
  int activityStatus;
  int skuId;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(7)),
          margin: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 15, left: 22, bottom: 8, right: 8),
                child: CachedNetworkImage(
                  imageUrl: imageName,
                  width: 90,
                  height: 100,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fitWidth,
                            )));
                  },
                  placeholder: (context, url) => const SizedBox(
                      width: 20, height: 10, child: MyLoadingCircle()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 15, left: 6, bottom: 4, right: 8),
                      child: Text(
                        productName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: MyColors.appMainColor),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.category,
                                color: MyColors.appMainColor,
                                size: 18.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth / 2,
                            child: Text(
                              category,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.darkGreyColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.houseboat_rounded,
                              color: MyColors.appMainColor,
                              size: 20.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 5, left: 1),
                          child: Text(
                            brandName,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: MyColors.appMainColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
       languageController.isEnglish.value ? Positioned(
          bottom: 6,
          right: 6,
          child: Container(
            height: 20,
            padding:const  EdgeInsets.symmetric(horizontal: 5,vertical: 3),
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Center(
                child: Text(
              "RSP $rsp",
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
          ),
        ) : Positioned(
          bottom: 6,
          left: 6,
          child: Container(
            height: 20,
            padding:const  EdgeInsets.symmetric(horizontal: 5,vertical: 3),
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5))),
            child: Center(
                child: Text(
              "RSP $rsp",
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
          ),
        ),
        languageController.isEnglish.value ? Positioned(
            top: 8,
            left: 8,
            child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                )),
                child: activityStatus != 0
                    ? const Icon(Icons.check_circle, color: MyColors.greenColor)
                    : const SizedBox())) : Positioned(
            top: 8,
            right: 8,
            child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                )),
                child: activityStatus != 0
                    ? const Icon(Icons.check_circle, color: MyColors.greenColor)
                    : const SizedBox()))
      ],
    );
  }
}
