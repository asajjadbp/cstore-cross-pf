// import 'package:cstore/haris/OtherPhoto.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class KnowledgeShareCard extends StatelessWidget {
  KnowledgeShareCard({super.key,

    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.pdf,
    required this.date,});

  final Function onTap;
  final String title;
  final String subtitle;

  final String pdf;
  final String date;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: screenWidth/1.23,
                    margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 6),
                    child: Text(title,
                      style: const TextStyle(fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: MyColors.appMainColor),)),
              ],
            ),
            Row(
              children: [
                Container(
                  width: screenWidth/1.23,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 6,vertical: 6),
                    child: Text(subtitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: MyColors.darkGreyColor,),)),
              ],
            ),
            const Divider(
                height: 00,
                thickness: 1,
                color: Colors.black12),
            Container(
              height: 35,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide.none),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)
                  )

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: Text(pdf,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:  MyColors.appMainColor,
                          )
                      )
                  ),

                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Text(DateFormat("dd/MM/yyyy").format(DateTime.parse(date)),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(68, 68, 68, 1)
                        )
                    ),
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}