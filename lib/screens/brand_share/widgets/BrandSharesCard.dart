import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/appcolor.dart';
import '../../widget/check_list_comment_field.dart';
import '../../widget/elevated_buttons.dart';
import '../../widget/loading.dart';

class Shelf_SharesCard extends StatelessWidget {
  final String fieldName1;
  final String labelName1;
  final String fieldName2;
  final String labelName2;
  final String fieldName3;
  final String labelName3;
  final String fieldName4;
  final String labelName4;
  final Function onSaveClick;
  final Function(String value) onActualValue;
  BuildContext context;
  final bool isBtnLoading;
  final bool isDone;

   Shelf_SharesCard({super.key,
     required this.isDone,
    required this.fieldName1,
    required this.labelName1,
    required this.fieldName2,
    required this.labelName2,
    required this.fieldName3,
    required this.labelName3,
    required this.fieldName4,
    required this.labelName4,
     required this.context,
     required this.isBtnLoading,
     required this.onSaveClick,
     required this.onActualValue
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return
      Container(
        decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color:const Color(0XFF00000026).withOpacity(0.10),width: 1)
        ),
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(left: 5),
                child: isDone ? const Icon(Icons.check_circle,color: MyColors.greenColor,) : const Icon(Icons.pending,color: MyColors.warningColor,)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: TextFormField(
                  readOnly: true,
                  initialValue: fieldName1,
                  decoration: InputDecoration(
                      // hintText: hintName1,
                      labelText: labelName1,
                      labelStyle: const TextStyle(color: MyColors.darkGreyColor),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: MyColors.darkGreyColor,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: MyColors.darkGreyColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),

                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: TextFormField(
                  readOnly: true,
                  initialValue: fieldName2,
                  decoration: InputDecoration(
                      // hintText: hintName2,
                      labelText: labelName2,
                      labelStyle: const TextStyle(color: MyColors.darkGreyColor),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: MyColors.darkGreyColor,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: MyColors.darkGreyColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),

                )
            ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   Expanded(
                     child: Container(
                         margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                         child: TextFormField(
                           readOnly: true,
                           initialValue: fieldName3,
                           decoration: InputDecoration(
                               // hintText: hintName3,
                               labelText: labelName3,
                               labelStyle: const TextStyle(color: MyColors.darkGreyColor),
                               focusedBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(5.0),
                                 borderSide: const BorderSide(
                                   color: MyColors.darkGreyColor,
                                   width: 2.0,
                                 ),
                               ),
                               enabledBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(5.0),
                                 borderSide: const BorderSide(
                                   width: 2.0,
                                   color: MyColors.darkGreyColor,
                                 ),
                               ),
                               border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(5),
                               )
                           ),

                         )
                     ),
                   ),
                   Expanded(
                     child: Container(
                         margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                       child: ActualFacesTextField(
                         initialValue: fieldName4,
                         onChangeValue: (value) {
                           onActualValue(value);
                         },
                       ),
                     ),
                   ),
                 ],
               ),
            const SizedBox(height: 10,),
            isBtnLoading
                ? const Center(
              child: SizedBox(
                height: 60,
                child: MyLoadingCircle(),
              ),
            )
                : Container(
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: BigElevatedButton(
                      isBlueColor: false,
                      buttonName: "Save",
                      submit: (){
                        onSaveClick();
                      })
                ),

          ],
        ),
      );

  }
}