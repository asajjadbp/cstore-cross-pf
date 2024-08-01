import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/drop_downs.dart';
import '../widget/loading.dart';
class FreshnessListCard extends StatelessWidget {
  FreshnessListCard(
      {super.key,
        required this.image,
        required this.proName,
        required this.catName,
        required this.brandName,
        required this.freshnessTaken,
        required this.rsp,
        required this.freshnessDate});

  final String image;
  final String proName;
  final String catName;
  final String brandName;
  final String rsp;
  final int freshnessTaken;
  final Function(String pieces, String month, int year) freshnessDate;
  TextEditingController valueControllerPieces = TextEditingController();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  String _selectedMonth = "";
  String _selectedYear = "";
  List<String> unitList = ['jan', 'feb', 'mar','apr','may','jun','jul','aug','sep','oct','nov','dec'];

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
          margin: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin:
                const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                padding: const EdgeInsets.all(6),
                child: CachedNetworkImage(
                  imageUrl: image,
                  width: 70,
                  height: 70,
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
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5,horizontal: 5),
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
                    Row(
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
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: MyColors.darkGreyColor),
                          ),
                        ),
                      ],
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
                          margin: const EdgeInsets.only(left: 5, top: 3,bottom: 8),
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
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
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
                            height: screenHeight / 2.36,
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
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: screenHeight/15,
                                          child: DropdownDatePicker(
                                            dateformatorder: OrderFormat.YDM, // default is myd
                                            inputDecoration: InputDecoration(
                                                enabledBorder: const OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10))), // optional
                                            isDropdownHideUnderline: true, // optional
                                            isFormValidator: true, // optional
                                            startYear: DateTime.now().year, // optional
                                            endYear: DateTime.now().year + 5, // optional
                                            width: 3, // optional
                                            showDay: false,
                                            showMonth: false,
                                            monthFlex: 1,
                                            textStyle: const TextStyle(fontSize: 12),
                                            // selectedDay: 14, // optional
                                            selectedMonth: 10, // optional
                                            // selectedYear: DateTime.now().year, // optional
                                            onChangedYear: (value) => _selectedYear=value!,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5,),
                                      Expanded(
                                        child: UnitDropDown(hintText: "Select Month", unitData: unitList, onChange: (value){
                                          _selectedMonth = value;
                                          print("Month is $_selectedMonth");
                                        }),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  color: Colors.white,
                                  child: TextField(
                                    showCursor: true,
                                    enableInteractiveSelection: false,
                                    onChanged: (value) {
                                    },
                                    controller: valueControllerPieces,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        prefixIconColor: MyColors.appMainColor,
                                        focusColor: MyColors.appMainColor,
                                        fillColor: MyColors.dropBorderColor,
                                        labelStyle: TextStyle(
                                            color: MyColors.appMainColor, height: 50.0),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: MyColors.appMainColor)),
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter Pieces'),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[0-9][0-9]*'))
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if(_selectedYear.isEmpty || _selectedMonth.isEmpty) {
                                      ToastMessage.errorMessage(context, "Please Select a valid year and month");
                                    } else {

                                      freshnessDate(valueControllerPieces.text,
                                          _selectedMonth,
                                          int.parse(_selectedYear));
                                    }
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
                  child: const Icon(
                    Icons.add_circle_rounded,
                    color: MyColors.greenColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 3,
          right: 3,
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
                    ? const Icon(Icons.check_circle, color: MyColors.greenColor,)
                    : const SizedBox()))
      ],
    );
  }
}

class DropdownDatePicke {
}
