import 'package:flutter/material.dart';

class DropButtonPlanogram extends StatelessWidget {
  final String title;
  final String subtitle;
  
  

  DropButtonPlanogram({
    required this.title,
    required this.subtitle,
    
  });

  @override
  Widget build(BuildContext context) {
    return
      Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Container(
         margin: EdgeInsets.only(left: 14,),
           child: Text(title ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xFF333333)),)),
      Container(
        margin: EdgeInsets.only(left: 12,right: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF1A5B8C),width: 1),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Container(
          decoration: BoxDecoration(
            color:Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(7)
          ),
          // color: Colors.white
          child: DropdownButton(

            underline: SizedBox(),
            iconSize: 40,
            icon: Icon(Icons.arrow_drop_down,color:Colors.black54),
            isExpanded: true,

            hint: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(subtitle,style: TextStyle(fontSize: 14,fontWeight:FontWeight.w500,color: Colors.black54),),
            ),
            items:[],

           onChanged: (value) {

          },
          ),
        ),
      ),
    ],
    );
  }
}