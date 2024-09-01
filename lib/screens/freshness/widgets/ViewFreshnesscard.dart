import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Language/localization_controller.dart';
import '../../utils/appcolor.dart';
import '../../widget/loading.dart';

class ExpiryCard extends StatelessWidget {
   ExpiryCard({
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
    required this.imageName,
    required this.onJanTap,
    required this.onFebTap,
    required this.onMarTap,
    required this.onAprTap,
    required this.onMayTap,
    required this.onJunTap,
    required this.onJulTap,
    required this.onAugTap,
    required this.onSepTap,
    required this.onOctTap,
    required this.onNovTap,
    required this.onDecTap,
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
  final String imageName;
  final Function onJanTap;
  final Function onFebTap;
  final Function onMarTap;
  final Function onAprTap;
  final Function onMayTap;
  final Function onJunTap;
  final Function onJulTap;
  final Function onAugTap;
  final Function onSepTap;
  final Function onOctTap;
  final Function onNovTap;
  final Function onDecTap;
  final languageController = Get.put(LocalizationController());
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                  decoration: BoxDecoration(
                      borderRadius:languageController.isEnglish.value ?const BorderRadius.only(bottomRight: Radius.circular(10)) : const BorderRadius.only(bottomLeft: Radius.circular(10)),
                      color: MyColors.appMainColor),
                  child: Text(year,style: const TextStyle(color: MyColors.whiteColor),),
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
                              CardWidget(title: "Jan".tr,data: jan,onCardTap: (){onJanTap();},),
                              CardWidget(title: "Feb".tr,data: feb,onCardTap: (){onFebTap();},),
                              CardWidget(title: "Mar".tr,data: mar,onCardTap: (){onMarTap();},),
                              CardWidget(title: "Apr".tr,data: apr,onCardTap: (){onAprTap();},),
                            ],
                        ),
                        Row(
                          children: [
                            CardWidget(title: "May".tr,data: may,onCardTap: (){onMayTap();},),
                            CardWidget(title: "Jun".tr,data: jun,onCardTap: (){onJunTap();},),
                            CardWidget(title: "Jul".tr,data: jul,onCardTap: (){onJulTap();},),
                            CardWidget(title: "Aug".tr,data: aug,onCardTap: (){onAugTap();},),
                          ],
                        ),
                        Row(
                          children: [
                            CardWidget(title: "Sep".tr,data: sep,onCardTap: (){onSepTap();},),
                            CardWidget(title: "Oct".tr,data: oct,onCardTap: (){onOctTap();},),
                            CardWidget(title: "Nov".tr,data: nov,onCardTap: (){onNovTap();},),
                            CardWidget(title: "Dec".tr,data: dec,onCardTap: (){onDecTap();},),
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
  final Function onCardTap;
  const CardWidget({super.key, required this.title, required this.data,required this.onCardTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onLongPress: () {
          onCardTap();
        },
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
      ),
    );
  }
}
