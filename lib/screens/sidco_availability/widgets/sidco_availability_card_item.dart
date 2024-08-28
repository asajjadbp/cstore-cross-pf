import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../utils/appcolor.dart';

class SidcoAvailabilityItem extends StatelessWidget {
  const SidcoAvailabilityItem({super.key,
    required this.imageName,
    required this.onImageTap,
    required this.onTapPickList,
    required this.isAvailable,
    required this.brandName,
    required this.categoryName,
    required this.pickListText,
    required this.onAvailable,
    required this.onNotAvailable,});

  final String imageName;
  final String brandName;
  final int isAvailable;
  final String categoryName;
  final String pickListText;
  final Function onNotAvailable;
  final Function onAvailable;
  final Function onTapPickList;
  final Function onImageTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Row(
        children: [
          InkWell(
            onTap: (){
              onImageTap();
            },
            child: Container(
              margin: const EdgeInsets.all(10),
                  child: CachedNetworkImage(
                    imageUrl: imageName,
                    width: 80,
                    height: 100,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fitWidth)));
                    },
                    placeholder: (context, url) =>
                    const SizedBox(
                        width: 20,
                        height: 10,
                        child: MyLoadingCircle()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
            ),
          ),
          Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(brandName,style: const TextStyle(color: MyColors.appMainColor,
                       fontSize: 13,fontWeight: FontWeight.w600)),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/icons/category_icon.svg"),
                        const SizedBox(width: 10,),
                         Expanded(
                           child: Text(categoryName,overflow: TextOverflow.ellipsis,
                           style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                         ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          onTapPickList();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: MyColors.warningColor,
                              borderRadius: BorderRadius.all(Radius.circular(3))
                          ),
                          child: Row(
                            children: [
                              Text("Required".tr,style:const TextStyle(fontWeight: FontWeight.w600,fontSize: 12),),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: MyColors.appMainColor,
                                    borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                                child: Text(pickListText,
                                  style: const TextStyle(color: MyColors.whiteColor,fontSize: 11,fontWeight: FontWeight.w500),),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          if(isAvailable != 0) {
                            onNotAvailable();
                          }
                        },
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                          decoration:  BoxDecoration(
                              color: isAvailable == 0 ?
                              MyColors.backbtnColor  : MyColors.disableColor,
                              borderRadius: const BorderRadius.all(Radius.circular(2))
                          ),
                          child:  Center(
                            child: Icon(Icons.close,color:isAvailable == 0 ?
                            MyColors.whiteColor : MyColors.blackColor,),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          if(isAvailable != 1) {
                        onAvailable();
                      }
                    },
                        child: Container(
                          width: 50,
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                          decoration: BoxDecoration(
                              color: isAvailable == 1 ? MyColors.greenColor  : MyColors.disableColor,
                              borderRadius: const BorderRadius.all(Radius.circular(2))
                          ),
                          child: Center(child: Icon(Icons.check,color:isAvailable == 1 ? MyColors.whiteColor : MyColors.blackColor,)),
                        ),
                      ),
                      SizedBox(width:3,),
                    ],
                  )
                ],))
        ],
      ),
    );
  }
}
