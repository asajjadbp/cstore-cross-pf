import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/loading.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:flutter/material.dart';
class FreshnessListCard extends StatelessWidget {
  FreshnessListCard(
      {super.key,
      required this.image,
      required this.proName,
      required this.catName,
      required this.brandName,
      required this.freshnessTaken,
      required this.rsp,
      required this.pricingValues});

  final String image;
  final String proName;
  final String catName;
  final String brandName;
  final String rsp;
  final int freshnessTaken;
  final Function(int regular, int promo) pricingValues;
  TextEditingController valueControllerPromo = TextEditingController();
  TextEditingController valueControllerRegular = TextEditingController();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  int _selectedDay = 14;
  int _selectedMonth = 10;
  int _selectedYear = 1993;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
              const Icon(Icons.check_circle),
              Container(
                margin:
                    const EdgeInsets.only(top: 8, left: 4, bottom: 8, right: 6),
                child: CachedNetworkImage(
                  imageUrl: image,
                  width: 85,
                  height: 100,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                            border: const Border(
                                top: BorderSide(color: MyColors.appMainColor)),
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
                        proName,
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
                          const Icon(
                            Icons.category,
                            color: MyColors.appMainColor,
                            size: 18.0,
                          ),
                          Container(
                            width: screenWidth / 2.2,
                            margin: const EdgeInsets.only(left: 5, top: 3),
                            child: Text(
                              catName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.darkGreyColor),
                            ),
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
                                                left: 15, top: 15),
                                            child: const Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Year",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: 'lato',
                                                    )),
                                                Text("Month",
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
                                                width: screenWidth / 1.1,
                                                child: Center(
                                                  child: DropdownDatePicker(
                                                    locale: "en",
                                                    dateformatorder: OrderFormat.YDM, // default is myd
                                                    // inputDecoration: InputDecoration(
                                                    //     enabledBorder: const OutlineInputBorder(
                                                    //       borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                    //     ),
                                                    //     helperText: '',
                                                    //     contentPadding: const EdgeInsets.all(8),
                                                    //     border: OutlineInputBorder(
                                                    //         borderRadius: BorderRadius.circular(10))), // optional
                                                    isDropdownHideUnderline: true, // optional
                                                    isFormValidator: true, // optional
                                                    startYear: 1900, // optional
                                                    endYear: 2020, // optional
                                                    width: 10, // optional
                                                    // selectedDay: _selectedDay, // optional
                                                    selectedMonth: _selectedMonth, // optional
                                                    selectedYear: _selectedYear, // optional
                                                    // onChangedDay: (value) {
                                                    //     _selectedDay = int.parse(value!);
                                                    //
                                                    //   print('onChangedDay: $value');
                                                    // },
                                                    onChangedMonth: (value) {

                                                        _selectedMonth = int.parse(value!);

                                                      print('onChangedMonth: $value');
                                                    },
                                                    onChangedYear: (value) {

                                                        _selectedYear = int.parse(value!);

                                                      print('onChangedYear: $value');
                                                    },
                                                    //boxDecoration: BoxDecoration(
                                                    // border: Border.all(color: Colors.grey, width: 1.0)), // optional
                                                    // showDay: false,// optional
                                                    // dayFlex: 2,// optional
                                                    // locale: "zh_CN",// optional
                                                    // hintDay: 'Day', // optional
                                                    // hintMonth: 'Month', // optional
                                                    // hintYear: 'Year', // optional
                                                    // hintTextStyle: TextStyle(color: Colors.grey), // optional
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
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
                                                    hintText: "Enter pieces"),
                                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*'))],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              pricingValues(int.parse(valueControllerRegular.text),int.parse(valueControllerPromo.text));
                                              Navigator.of(context).pop();
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
                                                    SizedBox(),
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
                            child: const Icon(
                              Icons.add_circle_rounded,
                              color: MyColors.greenColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.houseboat_rounded,
                            color: MyColors.appMainColor,
                            size: 20.0,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, top: 3),
                          child: Text(
                            brandName,
                            style: const TextStyle(
                                fontSize: 11,
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
        Positioned(
          bottom: 6,
          right: 6,
          child: Container(
            height: 20,
            width: 45,
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Center(
                child: Text(
              rsp,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
          ),
        ),
        Positioned(
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
                child: freshnessTaken != 0
                    ? SizedBox()
                    : SizedBox()))
      ],
    );
  }
}

class DropdownDatePicke {
}
