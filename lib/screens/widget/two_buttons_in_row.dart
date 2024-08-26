import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/appcolor.dart';

class RowButtons extends StatefulWidget {
  const RowButtons(
      {super.key, required this.onSaveTap, required this.onBackTap,required this.buttonText,required this.isNextActive});

  final Function onSaveTap;
  final Function onBackTap;
  final String buttonText;
  final bool isNextActive;

  @override
  State<RowButtons> createState() => _RowButtonsState();
}

class _RowButtonsState extends State<RowButtons> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.06,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              widget.onBackTap();
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                  color: MyColors.backbtnColor,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child:  Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Back".tr,
                    style:const TextStyle(
                        fontSize: 12,
                        color: MyColors.whiteColor,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: widget.isNextActive ?  () {
              widget.onSaveTap();
            } : null,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration:  BoxDecoration(
                  color: widget.isNextActive ? MyColors.savebtnColor : MyColors.disableColor,
                  // gradient: LinearGradient(
                  //   colors: [MyColors.primaryColor, AppColors.primaryColor],
                  // ),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                   Text(
                    widget.buttonText,
                    style: const TextStyle(
                        fontSize: 12,
                        color: MyColors.whiteColor,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
