import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/appcolor.dart';

class ViewOSDcard extends StatelessWidget {


  ViewOSDcard({
    super.key,
    required this.uploadStatus,
    required this.imageName,
    required this.brandName,
    required this.icon1,
    required this.OSDCReason,
    required this.icon2,
    required this.OSDCType,
    required this.icon3,
    required this.Qty,
    required this.onDelete,
  });

  final File imageName;
  final String brandName;
  final int uploadStatus;
  final String icon1;
  final String OSDCReason;
  final String icon2;
  final String OSDCType;
  final String icon3;
  final int Qty;
  final Function onDelete;
  //  final String time;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              border: Border.all(color: MyColors.dropBorderColor, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(left: 5),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6.0),
                      bottomLeft: Radius.circular(6.0),
                      topRight: Radius.circular(6.0),
                      bottomRight: Radius.circular(6.0),
                    ), // Image border
                    child: FittedBox(
                        fit: BoxFit.cover, child: Image.file(imageName))),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            margin:const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              brandName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(17, 93, 144, 1)),
                            ),
                          ),
                        ),
                        if(uploadStatus != 1)
                        InkWell(
                            onTap: () {
                              onDelete();
                            },
                            child:  const Icon(
                                Icons.delete,
                                color: Colors.red,
                            ))
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 13),
                            child: SvgPicture.asset(
                              icon1,
                              width: 10,
                              height: 12,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              OSDCReason,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(68, 68, 68, 1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 13),
                          child: SvgPicture.asset(
                            icon2,
                            width: 10,
                            height: 12,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            OSDCType,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(68, 68, 68, 1)),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 13),
                            child: SvgPicture.asset(
                              icon3,
                              width: 10,
                              height: 12,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              Qty.toString(),
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(68, 68, 68, 1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
