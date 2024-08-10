import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../utils/appcolor.dart';
import '../widget/loading.dart';

class ExpiryCard extends StatelessWidget {
  const ExpiryCard({
    super.key,
    required this.sku_id,
    required this.year,
    required this.jan,
    required this.feb,
    required this.mar,
    required this.apr,
    required this.may,
    required this.jun,
    required this.jul,
    required this.aug,
    required this.sep,
    required this.oct,
    required this.nov,
    required this.dec,
    required this.sku_en_name,
    required this.sku_ar_name,
    required this.imageName,
  });

  final int sku_id;
  final String year;
  final String jan;
  final String feb;
  final String mar;
  final String apr;
  final String may;
  final String jun;
  final String jul;
  final String aug;
  final String sep;
  final String oct;
  final String nov;
  final String dec;
  final String sku_en_name;
  final String sku_ar_name;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    print("check month is:: $mar");
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 1,
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(children: [
             Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  margin: const EdgeInsets.only(right: 5),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                      color: MyColors.appMainColor),
                  child: Text(year,style: TextStyle(color: MyColors.whiteColor),),
                ),
                Expanded(
                  child: Container(
                    width:screenWidth/1.2,
                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                    child: Text(
                      sku_en_name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: MyColors.appMainColor,
                          fontFamily: 'lato'),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CachedNetworkImage(
                      imageUrl: imageName,
                      width: 70,
                      height: 70,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6.0),
                                  bottomLeft: Radius.circular(6.0),
                                  topRight: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0),
                                ),
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fitWidth)));
                      },
                      placeholder: (context, url) => const SizedBox(
                          width: 20, height: 10, child: MyLoadingCircle()),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                            children: [
                              CardWidget(title: "Jan",data: jan,),
                              CardWidget(title: "Feb",data: feb,),
                              CardWidget(title: "Mar",data: mar,),
                              CardWidget(title: "Apr",data: apr,),
                            ],
                        ),
                        Row(
                          children: [
                            CardWidget(title: "May",data: may,),
                            CardWidget(title: "Jun",data: jun,),
                            CardWidget(title: "Jul",data: jul,),
                            CardWidget(title: "Aug",data: aug,),
                          ],
                        ),
                        Row(
                          children: [
                            CardWidget(title: "Sep",data: sep,),
                            CardWidget(title: "Oct",data: oct,),
                            CardWidget(title: "Nov",data: nov,),
                            CardWidget(title: "Dec",data: dec,),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ])),
    );
  }
}
class CardWidget extends StatelessWidget {
  final String title;
  final String data;
  CardWidget({super.key, required this.title, required this.data});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: data !="" ? MyColors.appMainColor : Colors.grey.withOpacity(0.2),width: 3),
            bottom: BorderSide(color: data !="" ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.2),width: 3),
            left: BorderSide(color: data !="" ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.2),width: 3),
            right: BorderSide(color: data !="" ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.2),width: 3)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.3,
              blurRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],

        ),
        margin: const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
        child: Column(
          children: [
            Text(
             title,
             style: const TextStyle(
               fontSize: 10.0,
               fontWeight: FontWeight.w600,
               color: MyColors.appMainColor,
             ),
                ),
                const SizedBox(height: 5,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
             child: Container(
               padding:const EdgeInsets.all(5),
               child: Text(
                 data!="" ? data: '--',
                 maxLines: 1,
                 style: const TextStyle(
                   fontSize: 11.0,
                   color: Colors.black,
                   fontFamily: 'lato',
                   fontWeight: FontWeight.w500,
                 ),
               ),
             ),
                ),
          ],
        ),
      ),
    );
  }
}
