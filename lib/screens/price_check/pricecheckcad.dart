import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/loading.dart';

class pricecheckcard extends StatelessWidget {
  pricecheckcard({super.key,
    required this.image,
    required this.proName,
    required this.regular,
    required this.actStatus,
    required this.promo,
    required this.pricingValues,
    required this.valueControllerPromo,
    required this.valueControllerRegular,
    required this.rsp});

  final String image;
  final String proName;
  final String regular;
  final int actStatus;
  final String promo;
  final String rsp;
  final Function(String regular,String promo) pricingValues;
  final TextEditingController valueControllerPromo;
  final TextEditingController valueControllerRegular;

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
    return Stack(
      children: [
        Container(
          height: screenHeight / 7,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(7)),
          child: Row(
            children: [
              Container(
                margin:
                const EdgeInsets.only(top: 7, left: 5, bottom: 4, right: 3),
                child: CachedNetworkImage(
                  imageUrl: image,
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
                  placeholder: (context, url) =>
                  const SizedBox(
                      width: 20, height: 10, child: MyLoadingCircle()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 7, top: 5),
                    width: screenWidth / 1.7,
                    child: Text(
                      proName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'lato',
                          color: MyColors.appMainColor),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              regular != "" ? regular.toString() : "_ _ _",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.appMainColor),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const Text(
                              "Regular ",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'lato',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: screenWidth / 9,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              promo != "" ? promo.toString() : "_ _ _",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'lato',
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.appMainColor),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const Text(
                              "Promo ",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'lato',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: screenWidth / 7.2,
                        ),
                        InkWell(
                          onTap: () {
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
                                valueControllerPromo.text = promo;
                                valueControllerRegular.text = regular;
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
                                          width: screenWidth / 1.4,
                                          margin: const EdgeInsets.only(
                                              left: 15, top: 35),
                                          child: const Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Regular Price",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'lato',
                                                  )),
                                              Text("Promo Price",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'lato',
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 15, bottom: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 0,
                                                      color:
                                                      MyColors.appMainColor)),
                                              height: screenHeight / 15,
                                              width: screenWidth / 2.3,
                                              child: Center(
                                                child: TextField(
                                                  showCursor: true,
                                                  enableInteractiveSelection:
                                                  false,
                                                  onChanged: (value) {
                                                    print(value);
                                                  },
                                                  controller:
                                                  valueControllerRegular,
                                                  keyboardType:
                                                  TextInputType.number,
                                                  decoration: InputDecoration(
                                                      prefixIconColor:
                                                      MyColors.appMainColor,
                                                      focusColor:
                                                      MyColors.appMainColor,
                                                      fillColor: MyColors
                                                          .dropBorderColor,
                                                      labelStyle: const TextStyle(
                                                          color: MyColors
                                                              .appMainColor),
                                                      focusedBorder:
                                                      const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 1,
                                                              color: MyColors
                                                                  .appMainColor)),
                                                      border:
                                                      const OutlineInputBorder(),
                                                      hintText: regular != ""
                                                          ? regular.toString()
                                                          : "Enter regular"),
                                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 15, bottom: 5),
                                              decoration: BoxDecoration(
                                                  color: const Color(0xFFFFFFFF),
                                                  borderRadius:
                                                  BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 0,
                                                      color: const Color(
                                                          0xFF1A5B8C))),
                                              height: screenHeight / 15,
                                              width: screenWidth / 2.3,
                                              child: Center(
                                                child: TextField(
                                                  showCursor: true,
                                                  enableInteractiveSelection:
                                                  false,
                                                  onChanged: (value) {
                                                    print(value);
                                                  },
                                                  controller: valueControllerPromo,
                                                  keyboardType:
                                                  TextInputType.number,
                                                  decoration: const InputDecoration(
                                                      prefixIconColor:
                                                      MyColors.appMainColor,
                                                      focusColor:MyColors.appMainColor,
                                                      fillColor: MyColors
                                                          .dropBorderColor,
                                                      labelStyle: TextStyle(
                                                          color: MyColors.appMainColor),
                                                      focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 1,
                                                              color: MyColors.appMainColor)),
                                                      border:
                                                      OutlineInputBorder(),
                                                      hintText: 'Enter promo..'),
                                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*'))],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            pricingValues(valueControllerRegular.text,valueControllerPromo.text);
                                          },
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 15, right: 15, top: 10),
                                              height: screenHeight / 15,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      26, 91, 140, 1),
                                                  borderRadius:
                                                  BorderRadius.circular(5)),
                                              child: const Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    size: 35,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Save",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              actStatus==0?const Icon(
                                Icons.add_circle,
                                size: 30,
                                color: MyColors.greenColor,
                              ):const Icon(
                                Icons.edit,
                                size: 24,
                                color: MyColors.greenColor,
                              ),
                              SizedBox(
                                height: screenHeight / 29,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Container(
            height: 20,
            width: 49,
            decoration: const BoxDecoration(
                color: MyColors.appMainColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Center(
                child: Text(
                  "RSP $rsp",
                  style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                )),
          ),
        )
      ],
    );
  }
}
