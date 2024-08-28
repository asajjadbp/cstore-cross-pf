import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class ActualFacesTextField extends StatelessWidget {
  const ActualFacesTextField({Key? key,required this.initialValue,required this.onChangeValue}) : super(key: key);
 final String initialValue;
 final Function(String value) onChangeValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (String value) {
        onChangeValue(value);
      },
      initialValue: initialValue,
      decoration:  InputDecoration(
        enabledBorder:const  OutlineInputBorder(
          borderRadius:  BorderRadius.all(Radius.circular(5.0)),
          borderSide:  BorderSide(
            color: MyColors.appMainColor,
          ),
        ),
        focusedBorder:const  OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(5.0)),
            borderSide:  BorderSide(
              color: MyColors.appMainColor,
              width: 2.0,
            )),
        border:const OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(

                color: MyColors.appMainColor, width: 1.0)),
        labelText: 'Actual Faces'.tr,
        alignLabelWithHint: true,
        labelStyle:const TextStyle(color: MyColors.appMainColor,),
        hintText: 'Enter Actual Faces'.tr,
        hintStyle:const TextStyle(color: MyColors.appMainColor,),),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*'))],

      style: const TextStyle(color: MyColors.appMainColor,),
    );
  }
}
