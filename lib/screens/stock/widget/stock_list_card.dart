import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../Language/localization_controller.dart';
import '../../widget/elevated_buttons.dart';
import '../../widget/loading.dart';

class StockListCard extends StatelessWidget {

  StockListCard({super.key,
    required this.image,
    required this.proName,
    required this.pieces,
    required this.actStatus,
    required this.cases,
    required this.outer,
    required this.stockCheckValues,
    required this.onDeleteTap,
    required this.rsp});


  final String image;
  final String proName;
  final int cases;
  final int actStatus;
  final int outer;
  final int pieces;
  final String rsp;
  final Function onDeleteTap;
  final Function(String cases,String outer,String pieces) stockCheckValues;
  TextEditingController valueControllerCases=TextEditingController();
  TextEditingController valueControllerOuter=TextEditingController();
  TextEditingController valueControllerPieces=TextEditingController();
  final languageController = Get.put(LocalizationController());
  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return InkWell(
      onTap: () {
        valueControllerCases.text = "0";
        valueControllerOuter.text = "0";
        valueControllerPieces.text = "0";

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFFF4F7FD),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              )),
          builder: (context) {
            // valueControllerCases.text = cases.toString();
            // valueControllerOuter.text = outer.toString();
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                height: screenHeight / 2.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: screenWidth / 1.24,
                            child: Text(
                              proName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'lato',
                                  color:
                                  MyColors.appMainColor),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: MyColors.backbtnColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth / 1.2,
                      margin: const EdgeInsets.only(left: 15, top: 15),
                      child:  Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Cases".tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                          Text("Outer".tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                          Text("Pieces".tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(5),
                              border: Border.all(
                                  width: 0,
                                  color:
                                  MyColors.appMainColor)),
                          height: screenHeight / 15,
                          width: screenWidth / 3.5,
                          child: Center(
                            child: TextField(
                              showCursor: true,
                              enableInteractiveSelection:
                              false,
                              onChanged: (value) {
                                print(value);
                              },
                              controller:
                              valueControllerCases,
                              keyboardType:
                              TextInputType.number,
                              decoration: const InputDecoration(
                                  prefixIconColor:
                                  MyColors.appMainColor,
                                  focusColor:
                                  MyColors.appMainColor,
                                  fillColor: MyColors
                                      .dropBorderColor,
                                  labelStyle: TextStyle(
                                      color: MyColors
                                          .appMainColor),
                                  focusedBorder:
                                  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: MyColors
                                              .appMainColor)),
                                  border:
                                  OutlineInputBorder(),
                                  hintText: ""),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(5),
                              border: Border.all(
                                  width: 0,
                                  color:
                                  MyColors.appMainColor)),
                          height: screenHeight / 15,
                          width: screenWidth / 3.5,
                          child: Center(
                            child: TextField(
                              showCursor: true,
                              enableInteractiveSelection:
                              false,
                              onChanged: (value) {
                                print(value);
                              },
                              controller:
                              valueControllerOuter,
                              keyboardType:
                              TextInputType.number,
                              decoration: const InputDecoration(
                                  prefixIconColor:
                                  MyColors.appMainColor,
                                  focusColor:
                                  MyColors.appMainColor,
                                  fillColor: MyColors
                                      .dropBorderColor,
                                  labelStyle: TextStyle(
                                      color: MyColors
                                          .appMainColor),
                                  focusedBorder:
                                  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: MyColors
                                              .appMainColor)),
                                  border:
                                  OutlineInputBorder(),
                                  hintText: ""),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(5),
                              border: Border.all(
                                  width: 0,
                                  color:
                                  MyColors.appMainColor)),
                          height: screenHeight / 15,
                          width: screenWidth / 3.5,
                          child: Center(
                            child: TextField(
                              showCursor: true,
                              enableInteractiveSelection:
                              false,
                              onChanged: (value) {
                                print(value);
                              },
                              controller:
                              valueControllerPieces,
                              keyboardType:
                              TextInputType.number,
                              decoration: const InputDecoration(
                                  prefixIconColor:
                                  MyColors.appMainColor,
                                  focusColor:
                                  MyColors.appMainColor,
                                  fillColor: MyColors
                                      .dropBorderColor,
                                  labelStyle: TextStyle(
                                      color: MyColors
                                          .appMainColor),
                                  focusedBorder:
                                  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: MyColors
                                              .appMainColor)),
                                  border:
                                  OutlineInputBorder(),
                                  hintText: ""),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: BigElevatedButton(
                          buttonName: "Save",
                          submit: (){
                            stockCheckValues(valueControllerCases.text,valueControllerOuter.text,valueControllerPieces.text,);
                          },
                          isBlueColor: true),
                    ),

                  ],
                ),
              ),
            );
          },
        );
      },
      child: Card(
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  margin:
                  const EdgeInsets.only(top: 12, left: 12, bottom: 4,right: 4),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    width: 79,
                    height: 85,
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
                    placeholder: (context, url) =>
                    const SizedBox(
                        width: 20, height: 10, child: MyLoadingCircle()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                proName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'lato',
                                    color: MyColors.appMainColor),
                              ),
                            ),
                            if((cases + pieces + outer) > 0)
                            InkWell(
                                onTap: () {
                                    onDeleteTap();
                                },
                                child:const Icon(Icons.delete,color: MyColors.backbtnColor,))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 3,bottom: 8,top: 4),
                        child: Row(
                          children: [
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        cases != 0 ? cases.toString() : "___",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'lato',
                                            fontWeight: FontWeight.w500,
                                            color: MyColors.appMainColor),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text(
                                      "Cases ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'lato',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        outer != 0 ? outer.toString() : "_ _ _",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'lato',
                                            fontWeight: FontWeight.w500,
                                            color: MyColors.appMainColor),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text(
                                      "Outer ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'lato',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        pieces != 0 ? pieces.toString() : "_ _ _",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'lato',
                                            fontWeight: FontWeight.w500,
                                            color: MyColors.appMainColor),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text(
                                      "Pieces ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'lato',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                decoration: const BoxDecoration(
                    color: MyColors.appMainColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5))),
                child: Center(
                    child: Text(
                      "RSP $rsp",
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    )),
              ),
            ),
            languageController.isEnglish.value ? Positioned(
                top: 5,
                left: 5,
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        )),
                    child: actStatus != 0
                        ? const Icon(Icons.check_circle, color: MyColors.greenColor)
                        : const SizedBox())): Positioned(
                top: 5,
                right: 5,
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        )),
                    child: actStatus != 0
                        ? const Icon(Icons.check_circle, color: MyColors.greenColor)
                        : const SizedBox()))
          ],
        ),
      ),
    );
  }
}
