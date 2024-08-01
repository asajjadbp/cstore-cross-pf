import 'package:flutter/material.dart';

import '../../utils/appcolor.dart';

class PromoPlanCardRowItems extends StatelessWidget {
  const PromoPlanCardRowItems({super.key,required this.title,required this.value,required this.isWhiteBackGround});

 final String title;
  final String value;
  final bool isWhiteBackGround;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding:const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isWhiteBackGround ? MyColors.whiteColor : MyColors.background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/6),
                child: Text(title,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: MyColors.darkGreyColor),)),
          ),
           Expanded(child: Text(value,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)),
        ],
      ),);
  }
}
