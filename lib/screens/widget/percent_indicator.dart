import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../utils/appcolor.dart';

class PercentIndicator extends StatelessWidget {
  const PercentIndicator({super.key,required this.isIcon,required this.percentColor,required this.titleText,required this.iconData,required this.percentValue,required this.percentText,required this.isSelected});

  final String titleText;
final IconData iconData;
final double percentValue;
final String percentText;
  final Color percentColor;
  final bool isIcon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? MyColors.appMainColor2 : MyColors.whiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color:  MyColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Column(
          children: [
             Row(
              mainAxisAlignment:isIcon? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
              children: [
                Text(titleText),
                if(isIcon)
                Icon(iconData,color: percentColor)],),
            const SizedBox(height: 2,),
            CircularPercentIndicator(
              radius: 35.0,
              lineWidth: 10.0,
              animationDuration: 2000,
              animation: true,
              percent: percentValue,
              center:  Text(percentText),
              progressColor: percentColor,
            ),
            const SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}
