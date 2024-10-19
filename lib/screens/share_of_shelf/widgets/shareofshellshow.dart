import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class shareofshellshow extends StatelessWidget {
  shareofshellshow(
      {super.key,
      required this.catName,
      required this.total,
      required this.actual,
      required this.unit,
      required this.onDelete,
      required this.brandName,});

  final String catName;
  final String total;
  final String actual;
  final String unit;
  final String brandName;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        InkWell(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const PriceCheck_Screen(),));
          },
          child: Card(
              semanticContainer: false,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12, width: 1),
                    borderRadius: BorderRadius.circular(7)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal:5),
                              child: Text(
                                catName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(68, 68, 68, 1),
                                fontWeight: FontWeight.bold),
                              )),
                        ),
                        IconButton(onPressed: (){
                          onDelete();
                        }, icon: const Icon(Icons.delete,color: MyColors.backbtnColor,))
                      ],
                    ),

                    Container(
                      margin:const  EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                total,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(68, 68, 68, 1)),
                              ),
                               Text(
                                "Total".tr,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(68, 68, 68, 1),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                actual,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(68, 68, 68, 1)),
                              ),
                               Text(
                                "Actual".tr,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(68, 68, 68, 1),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                unit,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(68, 68, 68, 1)),
                              ),
                               Text(
                                "Unit".tr,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(68, 68, 68, 1),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
             ),
        ),
    Positioned(
      top: 4,left:5,
      child: Container(
        height: screenHeight/40,
        width: screenWidth/4,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Color(0xFF1A5B8C),
            borderRadius: BorderRadius.only(topLeft:Radius.circular(5))
        ),
        child: Text(
          brandName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w400),
        ),
      ),
    )
    ],

    );
  }
}
