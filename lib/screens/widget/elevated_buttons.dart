import 'package:flutter/material.dart';

import '../utils/appcolor.dart';

class BigElevatedButton extends StatelessWidget {
  const BigElevatedButton({super.key,required this.buttonName,required this.submit,required this.isBlueColor});

  final Function submit;
  final String buttonName;
  final bool isBlueColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isBlueColor ? const Color.fromRGBO(0, 77, 145, 1) : const Color.fromARGB(255, 39, 136, 42),
        minimumSize: Size(MediaQuery.of(context).size.width, 45),
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10)),
      ),
      onPressed: (){
        submit();
      },
      child:  Text(
        buttonName,style:const TextStyle(color: MyColors.whiteColor),
      ),
    );
  }
}
