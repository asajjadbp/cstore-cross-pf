import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../promoplane/widgets/promo_plan_card_row_item.dart';
import '../../utils/appcolor.dart';

class ProofOfSaleCard extends StatelessWidget {
  ProofOfSaleCard({
    super.key,
    required this.imageName,
    required this.proName,
    required this.catName,
    required this.name,
    required this.phone,
    required this.amount,
    required this.upload_status,
    required this.Qty,
    required this.onDelete,
  });

  final File imageName;
  final String proName;
  final String catName;
  final String name;
  final String phone;
  final String amount;
  final int Qty;
  final int upload_status;
  final Function onDelete;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 3,
      color: MyColors.dropBorderColor,
      margin: const EdgeInsets.all(6),
      child: Container(
        decoration:  const BoxDecoration(
          border: Border(
            top: BorderSide(
                color:MyColors.appMainColor,width: 5),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight / 35,
                  width: screenWidth / 4.5,
                  decoration:  const BoxDecoration(
                      color: MyColors.appMainColor,
                      borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(10))),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 12, top: 3),
                    child: Text(
                      "",
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: screenWidth/1.5,
                    child: Text(
                      proName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: MyColors.appMainColor),
                    )),
                upload_status==0?InkWell(
                    onTap: () {
                      onDelete();
                    },
                    child: Container(
                        margin: const EdgeInsets.only(right: 3),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))):const SizedBox()
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          bottomLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0),
                        ), // Image border
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: imageName != null
                                ? Image.file(imageName)
                                : Container())),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            const Divider(
                height: 00,
                thickness: 1,
                color: Color.fromRGBO(26, 91, 140, 1)),
            PromoPlanCardRowItems(title: "Name",value: name,isWhiteBackGround: false,),
            const Divider(
                height: 00,
                thickness: 1,
                color: Color.fromRGBO(26, 91, 140, 1)),
            PromoPlanCardRowItems(title: "Quantity",value: Qty.toString(),isWhiteBackGround: true,),
            const Divider(
                height: 00,
                thickness: 1,
                color: Color.fromRGBO(26, 91, 140, 1)),
            PromoPlanCardRowItems(title: "Amount",value: amount.toString(),isWhiteBackGround: false,),
            const Divider(
                height: 00, thickness: 1, color: MyColors.appMainColor),
            PromoPlanCardRowItems(title: "Category",value: catName,isWhiteBackGround: true,),

          ],
        ),
      ),
    );
  }
}
