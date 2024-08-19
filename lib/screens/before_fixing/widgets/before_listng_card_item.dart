import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../utils/appcolor.dart';

class BeforeFixingCardItem extends StatelessWidget {
  const BeforeFixingCardItem({super.key,required this.imageFile,
    required this.clientName,
    required this.categoryEnName,
    required this.uploadStatus,
    required this.dateTime,
    required this.onDeleteTap});

  final File imageFile;
  final String clientName;
  final String categoryEnName;
  final int uploadStatus;
  final String dateTime;
  final Function onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
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
                width: 80,
                height: 80,
                padding: const EdgeInsets.only(
                  left: 5,
                  top: 5,
                  bottom: 5.0,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6.0),
                      bottomLeft: Radius.circular(6.0),
                      topRight: Radius.circular(6.0),
                      bottomRight: Radius.circular(6.0),
                    ), // Image border
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.file(
                            imageFile)
                    )),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                            "assets/icons/client_icon.png"),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Text(
                              clientName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/Component 13.svg",
                          width: 10,
                          height: 12,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Text(
                                categoryEnName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)))
                      ],
                    ),
                  ],
                ),
              ),
              if(uploadStatus != 1)
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        onDeleteTap();
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ))
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: MyColors.appMainColor,
                  borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text(
                DateFormat('hh:mm aa').format(DateTime.parse(dateTime)),
                style: const TextStyle(color: MyColors.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
