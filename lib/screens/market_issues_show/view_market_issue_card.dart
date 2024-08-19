import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/appcolor.dart';

class ViewMarketIssueCard extends StatelessWidget {
  ViewMarketIssueCard({
    super.key,
    required this.imageName,
    required this.onDelete,
    required this.marketIssue,
    required this.comment,
  });

  final File imageName;
  final String marketIssue;
  final String comment;
  final Function onDelete;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9,vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(7)),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            margin: const EdgeInsets.all(5),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width:screenWidth/2,
                        margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                        child: Text(
                          marketIssue,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: MyColors.appMainColor),
                        )),
                    InkWell(
                        onTap: () {
                          onDelete();
                        },
                        child: Container(
                            margin: const EdgeInsets.only(right: 3),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                      child:const Icon(Icons.brightness_high_outlined,size: 20,color: MyColors.appMainColor,),
                    ),
                    Expanded(
                      child: Text(
                        comment,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
