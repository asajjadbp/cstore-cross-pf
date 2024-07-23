import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
      decoration: const InputDecoration(
        enabledBorder:  OutlineInputBorder(
          borderRadius:  BorderRadius.all(Radius.circular(5.0)),
          borderSide:  BorderSide(
            color: MyColors.appMainColor,
          ),
        ),
        focusedBorder:  OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(5.0)),
            borderSide:  BorderSide(
              color: MyColors.appMainColor,
              width: 2.0,
            )),
        border: OutlineInputBorder(
            borderRadius:  BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(

                color: MyColors.appMainColor, width: 1.0)),
        labelText: 'Actual Faces',
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: MyColors.appMainColor,),
        hintText: 'Enter Actual Faces',
        hintStyle: TextStyle(color: MyColors.appMainColor,),),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*'))],

      style: const TextStyle(color: MyColors.appMainColor,),
    );
  }
}
