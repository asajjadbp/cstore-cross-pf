import 'package:flutter/material.dart';

import '../utils/appcolor.dart';

class RowButtons extends StatelessWidget {
  const RowButtons(
      {super.key, required this.onSaveTap, required this.onBackTap});

  final Function onSaveTap;
  final Function onBackTap;

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
              onBackTap();
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: const BoxDecoration(
                  color: MyColors.backbtnColor,
                  // gradient: LinearGradient(
                  //   colors: [
                  //     AppColors.gradientColor2,
                  //     AppColors.gradientColor2
                  //   ],
                  // ),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(3),
                  //   decoration: BoxDecoration(
                  //     color: MyColors.whiteColor,
                  //     borderRadius: BorderRadius.circular(100),
                  //   ),
                  //   child: const Icon(
                  //     Icons.arrow_back,
                  //     size: 24,
                  //   ),
                  // ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Back",
                    style: TextStyle(
                        fontSize: 18,
                        color: MyColors.whiteColor,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              onSaveTap();
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(
                  color: MyColors.savebtnColor,
                  // gradient: LinearGradient(
                  //   colors: [MyColors.primaryColor, AppColors.primaryColor],
                  // ),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(3),
                  //   decoration: BoxDecoration(
                  //     color: MyColors.whiteColor,
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child:  Icon(

                  //     Icons.check,
                  //     size: 24,
                  //   ),
                  // ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Save",
                    style: TextStyle(
                        fontSize: 18,
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
