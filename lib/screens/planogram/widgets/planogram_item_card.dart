import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/appcolor.dart';

class PlanogramItemCard extends StatelessWidget {
  const PlanogramItemCard(
      {super.key,
      required this.uploadStatus,
      required this.itemTime,
      required this.reason,
      required this.clientName,
      required this.brandName,
      required this.imageFile,
      required this.isAdherence,
      required this.onDelete});

  final File imageFile;
  final int uploadStatus;
  final String brandName;
  final String isAdherence;
  final String clientName;
  final String reason;
  final Function onDelete;
  final String itemTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Card(
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 110,
                      margin: const EdgeInsets.all( 5),
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                            topRight: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0),
                          ), // Image border
                          child: FittedBox(
                              fit: BoxFit.cover,
                              child: imageFile != null
                                  ? Image.file(
                                      imageFile,
                                      width: 80,
                                      height: 100,
                                      fit: BoxFit.fitWidth,
                                    )
                                  : Image.asset(
                                      "assets/images/camera.png",
                                      width: 80,
                                      height: 100,
                                    ))),
                    ),
                    isAdherence == "1"
                        ? Positioned(
                      left: 10,
                      top: 5,
                            child: Container(
                                margin:
                                    const EdgeInsets.only(top: 5, left: 5),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(100),
                                    color: MyColors.whiteColor),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: MyColors.appMainColor,
                                )),
                          )
                        : Positioned(
                      left: 10,
                      top: 5,
                          child: Container(
                              margin:
                                  const EdgeInsets.only(top: 5, left: 5),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(100),
                                  color: MyColors.whiteColor),
                              child: const Icon(
                                Icons.warning_amber,
                                color: MyColors.warningColor,
                              )),
                        )
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:const EdgeInsets.only(top: 10),
                          child: Text(
                            clientName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: MyColors.appMainColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/client_icon.png"),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                              brandName.isEmpty ? "-----" : brandName,
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        isAdherence == "1"
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: MyColors.appMainColor,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text(
                                    "Adherence",
                                    overflow: TextOverflow.ellipsis,
                                  ))
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("assets/icons/reason_icon.png"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text(
                                    reason,
                                    overflow: TextOverflow.ellipsis,
                                  ))
                                ],
                              )
                      ],
                    ),
                  ),
                ),
                if(uploadStatus != 1)
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        onDelete();
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                    )
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
                  itemTime,
                  style: const TextStyle(color: MyColors.whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
