import 'dart:io';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import '../../../Model/database_model/sys_survey_question_option_model.dart';
import '../../dashboard/widgets/image_camera_selection_row.dart';
class SurveyListCard extends StatelessWidget {
  SurveyListCard({
    super.key,
    required this.question,
    required this.answers,
    required this.type,
    required this.selectedAnswerRadio,
    required this.selectedAnswerCheckBox,
    this.onCheckboxToggle,
    this.onRadioSelect,
    required this.number,
    required this.isImageLoading,
    required this.getImage,
    required this.imagesList,
    required this.valueControllerComment,
  });

  final String question;
  final int number;
  final List<sysSurveyQuestionOptionModel> answers;
  final List<File> imagesList;
  final String type;
  final bool isImageLoading;
  final dynamic selectedAnswerRadio;
  final dynamic selectedAnswerCheckBox;
  final Function getImage;
  final ValueChanged<String>? onCheckboxToggle;
  final ValueChanged<String>? onRadioSelect;
  final TextEditingController valueControllerComment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)), // Optional border
        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${number.toString()}) ",
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: MyColors.appMainColor
                      ),
                    ),
                    const SizedBox(width: 7,),
                    Expanded(
                      child: Text(
                        question,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (type == "radio")
                  Column(
                    children: answers.map((answer) {
                      return _buildStylishRadio(
                        value: answer.en_name.toString(),
                        groupValue: selectedAnswerRadio,
                        onSelected: onRadioSelect!,
                      );
                    }).toList(),
                  ),
                 if (type == "checkbox")
                  Column(
                    children: answers.map((answer) {
                      return _buildCheckbox(
                        value: answer.id.toString(),
                        isChecked: (selectedAnswerCheckBox as List<String>?)
                                ?.contains(answer) ??
                            false,
                        onToggle: onCheckboxToggle!,
                      );
                    }).toList(),
                  ),
                const SizedBox(height:16,),
                if(type == "text")
                TextField(
                  showCursor: true,
                  enableInteractiveSelection: false,
                  onChanged: (value) {
                    print(value);
                  },
                  controller: valueControllerComment,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      prefixIconColor: MyColors.appMainColor,
                      focusColor: MyColors.appMainColor,
                      fillColor: MyColors.appMainColor,
                      labelStyle:
                          TextStyle(color: MyColors.appMainColor, height: 50.0),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: MyColors.appMainColor)),
                      border: OutlineInputBorder(),
                      hintText: 'Enter your answer'),
                  
                ),
                if(type == "number")
                  TextField(
                    showCursor: true,
                    enableInteractiveSelection: false,
                    onChanged: (value) {
                      print(value);
                    },
                    controller: valueControllerComment,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        prefixIconColor: MyColors.appMainColor,
                        focusColor: MyColors.appMainColor,
                        fillColor: MyColors.appMainColor,
                        labelStyle:
                        TextStyle(color: MyColors.appMainColor, height: 50.0),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: MyColors.appMainColor)),
                        border: OutlineInputBorder(),
                        hintText: 'Enter your answer'),

                  ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 150,
                  width: double.infinity,
                  child: isImageLoading
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : ImageListButtonForSurvey(
                    imageFile: imagesList,
                    onSelectImage: () {
                      getImage();
                    },
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStylishRadio({
    required String value,
    required String? groupValue,
    required ValueChanged<String> onSelected,
  }) {
    final bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onSelected(value),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.green.withOpacity(0.2)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: MyColors.appMainColor2, width: 2),
            ),
            child: Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: MyColors.appMainColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? MyColors.appMainColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox({
    required String value,
    required bool isChecked,
    required ValueChanged<String> onToggle,
  }) {
    return GestureDetector(
      onTap: () => onToggle(value),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (_) => onToggle(value),
          ),
          Text(value),
        ],
      ),
    );
  }
}
