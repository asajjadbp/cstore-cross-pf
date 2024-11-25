import 'dart:io';

import 'package:cstore/screens/survey/widget/survey_list_card.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/utils/services/take_image_and_save_to_folder.dart';
import 'package:cstore/screens/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import '../../Database/db_helper.dart';
import '../../Model/database_model/sys_survey_question_model.dart';
import '../../Model/database_model/sys_survey_question_option_model.dart';
import '../Language/localization_controller.dart';
import '../utils/app_constants.dart';
import '../utils/services/image_picker.dart';
import '../utils/toast/toast.dart';
import '../widget/app_bar_widgets.dart';

class SurveyScreen extends StatefulWidget {
  static const routeName = "surveyListScreen";

  const SurveyScreen({Key? key}) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int currentIndex = 0;
  Map<int, dynamic> answersRadio = {};
  Map<int, dynamic> answersCheckBox = {};
  TransSurveyModel transSurveyModel = TransSurveyModel(
    id: -1,questionId: -1,answerText: '',imageName: ''
  );
  List<File> imagesList =[];
  List<File> allImagesList =[];
  List<String> imagesNameList =[];
  String clientId = "";
  String workingId = "";
  String storeEnName = "";
  String storeArName = "";
  String userName = "";
  bool isImageLoading = false;
  bool isButtonLoading = false;
  bool isDataLoading = true;
  List<sysSurveyQuestionModel> surveyDataList = [];
  TextEditingController valueControllerComment = TextEditingController();
  final List<Map<String, dynamic>> surveyData = [
    {
      "question": "Select Your Favorite Ice Cream Flavor:",
      "answers": ["Vanilla", "Chocolate", "Strawberry", "Mint Chocolate Chip"],
      "type": "radio", // Single answer
    },
    {
      "question": "Which Ice Cream Brands Do You Like?",
      "answers": [
        "Baskin Robbins",
        "Ben & Jerry's",
        "Haagen-Dazs",
        "Blue Bell",
        "Dairy Queen"
      ],
      "type": "checkbox", // Multiple answers
    },
    {
      "question": "Select Baskin Robbins Ice Cream Sizes:",
      "answers": [
        "125 ML",
        "500 ML",
        "1 Liter",
        "2 Liters",
        "Cone",
        "Stick",
      ],
      "type": "checkbox", // Multiple answers
    },
  ];
  final languageController = Get.put(LocalizationController());
  @override
  void initState() {
    super.initState();
    getUserData();
  }
  Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    workingId = sharedPreferences.getString(AppConstants.workingId)!;
    clientId = sharedPreferences.getString(AppConstants.clientId)!;
    storeEnName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    storeArName = sharedPreferences.getString(AppConstants.storeArNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;

    getSurveyQuestion();
  }
  getSurveyQuestion() async {

    isDataLoading = true;

    await DatabaseHelper.getSurveyQuestionData().then((value) async {
      surveyDataList = value.cast<sysSurveyQuestionModel>();

      for(int i = 0; i<surveyDataList.length; i ++) {
        List<sysSurveyQuestionOptionModel> option = await DatabaseHelper.getSurveyAnswersData(surveyDataList[i].id);

        surveyDataList[i].answer_option = option;

        setState(() {

        });

      }
      print(surveyDataList);
      print("SURVEY DATA LIST LENGTH");
      getTransSurveyData();
      isDataLoading = false;

      setState(() {

      });
    });
  }

  Future<void> getImage() async {
    isImageLoading = true;
    await ImageTakingService.imageSelect().then((value) {
      if (value == null) {
        return;
      }
      print(value.path);
      imagesList.add(value);
      final String extension = path.extension(value.path);
      imagesNameList.add("${userName}_${DateTime.now().millisecondsSinceEpoch}$extension");

      print("---------------Images List -------------");
      print(imagesList);
      print(imagesNameList);
      print("----------------------------");
      isImageLoading = false;
      setState(() {

      });
    });
  }


  void _nextSurvey() async {
      if (currentIndex < surveyDataList.length - 1) {

        print("+=+++++++++++++++++");
        print(answersRadio[currentIndex]);
        print("+++++++++++++++++++++");

        String answerText = "";
        String imagesName = "";

        if (surveyDataList[currentIndex].answer_type == "radio") {
          if(answersRadio[currentIndex] == null) {
            ToastMessage.errorMessage(context, "Please Select one options please");
            return;
          }
          answerText = answersRadio[currentIndex];
        } else if(surveyDataList[currentIndex].answer_type == "text" || surveyDataList[currentIndex].answer_type == "number") {
          if(valueControllerComment.text.isEmpty) {
            ToastMessage.errorMessage(context, "Please add your response in field");
            return;
          }
          answerText = valueControllerComment.text;
        } else {
          if(imagesNameList.isEmpty || imagesList.isEmpty) {
            ToastMessage.errorMessage(context, "Please Take images from your camera");
            return;
          }
          answerText = "";
        }

        setState(() {
          isButtonLoading = true;
        });

        if(imagesList.isNotEmpty && imagesNameList.isNotEmpty && imagesNameList.length == imagesList.length) {
          imagesName = imagesNameList.join(',');
        }

        setState(() {

        });

        await insertSurveyAnswer(surveyDataList[currentIndex].id,answerText,imagesName);

        currentIndex++;
      setState(() {

      });
      }
  }

  void _previousSurvey() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        getTransSurveyData();
      }
    });
  }

  void _toggleCheckbox(int index, String value) {
    setState(() {
      final selectedAnswers = answersCheckBox[index] as List<String>? ?? [];
      if (selectedAnswers.contains(value)) {
        selectedAnswers.remove(value);
      } else {
        selectedAnswers.add(value);
      }
      answersCheckBox[index] = selectedAnswers;
      print("CheckBox");
      print(answersCheckBox);
    });
  }

  void _selectRadio(int index, String value) {
    setState(() {
      answersRadio[index] = value;
      print("RadioButton");
      print(answersRadio[index]);
    });
  }


  insertSurveyAnswer(int questionId,String answerText,String imageNames) async {
    await DatabaseHelper
        .insertTransSurveyAnswer(
        workingId,questionId ,answerText,imageNames)
        .then((value) async {
          for(int i=0; i<imagesList.length; i++) {
            await takePicture(context, imagesList[i], imagesNameList[i], workingId, AppConstants.survey).then((value) => {

              if (currentIndex == surveyDataList.length)
              ToastMessage.succesMessage(context, "Data Saved Successfully".tr),

            }).catchError((e) => {
            ToastMessage.errorMessage(context, e.toString()),
            setState(() {
                isButtonLoading = false;
               }),
            });
          }

      imagesNameList.clear();
      imagesList.clear();
      valueControllerComment.clear();
      setState(() {
      isButtonLoading = false;
      });
    }).catchError((e) {
      print(e.toString());
      ToastMessage.errorMessage(
          context, e.toString());
      setState(() {});
    });
  }

  Future<void> getTransSurveyData() async {
    setState(() {
      isButtonLoading = true;
    });
    await DatabaseHelper.getSurveyAnswersDataFromTrans(workingId,surveyDataList[currentIndex].id).then((value) async {
      transSurveyModel = value;

      if (surveyDataList[currentIndex].answer_type == "radio") {
        answersRadio[currentIndex] = transSurveyModel.answerText;
      } else if(surveyDataList[currentIndex].answer_type == "text" || surveyDataList[currentIndex].answer_type == "number") {
        valueControllerComment.text = transSurveyModel.answerText;
      } else {
        valueControllerComment.text = "";
      }

      await _loadImages().then((value) {
        setTransPhoto();
      });
    }).catchError((e) {
      print(e.toString());
      setState(() {
        isButtonLoading = false;
      });
    });
  }

  Future<void> setTransPhoto() async {
    imagesNameList = transSurveyModel.imageName.split(",");
    print("Image Name List");
    print(imagesNameList);
    print("------------------");
    for (int i = 0; i<imagesNameList.length; i++) {
      for (int j = 0; j < allImagesList.length; j++) {
        if (allImagesList[j].path.endsWith(imagesNameList[i])) {
          imagesList.add(allImagesList[i]);
        }
      }

      for(int i =0; i< imagesList.length; i++) {
        if(imagesList[i] != null) {
          bool isImageCorrupt = await isImageCorrupted(XFile(imagesList[i].path));

          if(isImageCorrupt) {
            imagesList[i] = await convertAssetToFile("assets/images/no_image_found.png");
          }

        } else {
          imagesList[i] = await convertAssetToFile("assets/images/no_image_found.png");
        }
      }
    }
    print("TRANS");
    print(imagesList);
    setState(() {
      isButtonLoading = false;
    });
  }

  Future<void> _loadImages() async {
    setState(() {
      isButtonLoading = true;
    });
    try {
      final String dirPath = (await getExternalStorageDirectory())!.path;
      final String folderPath =
          '$dirPath/cstore/$workingId/${AppConstants.survey}';
      print("******************");
      print(folderPath);
      final Directory folder = Directory(folderPath);
      if (await folder.exists()) {
        final List<FileSystemEntity> files = folder.listSync();
        allImagesList = files.whereType<File>().toList();
      }
    } catch (e) {
      print('Error reading images: $e');
    }

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final survey = surveyDataList[currentIndex];
    // final question = surveyDataList[currentIndex].en_question;
    // final options = surveyDataList[currentIndex].answer_option;
    // final type = surveyDataList[currentIndex].answer_type;
    final selectedAnswerRadio = answersRadio[currentIndex];
    final selectedAnswerCheckBox = answersCheckBox[currentIndex];

    return Scaffold(
      appBar: generalAppBar(
          context,
          languageController.isEnglish.value
              ? storeEnName
              : storeArName,
         userName, () {
        Navigator.of(context).pop();
      }, true, false, false,
              (int getClient, int getCat, int getSubCat, int getBrand) {}),
      body: isDataLoading ? Center(child: SizedBox(
        height: 60,
        child: MyLoadingCircle(
      ),)) : Container(
        color: MyColors.background,
        child: Column(
          children: [
            Expanded(
              child: SurveyListCard(
                valueControllerComment: valueControllerComment,
                question: surveyDataList[currentIndex].en_question,
                answers: surveyDataList[currentIndex].answer_option,
                type: surveyDataList[currentIndex].answer_type,
                selectedAnswerRadio: selectedAnswerRadio,
                selectedAnswerCheckBox: selectedAnswerCheckBox,
                onCheckboxToggle: (value) =>
                    _toggleCheckbox(currentIndex, value),
                onRadioSelect: (value) => _selectRadio(currentIndex, value),
                number: currentIndex + 1,
                isImageLoading: isImageLoading,
                getImage: getImage,
                imagesList: imagesList,
              ),
            ),
            isButtonLoading ? const Center(child: SizedBox(
              height: 60,
              child: MyLoadingCircle(),),) : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: currentIndex > 0 ? _previousSurvey : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.appMainColor,
                        textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    child: const Text(
                      "Previous",
                      style: TextStyle(color: Colors.white),
                    )),
                ElevatedButton(
                  onPressed:
                      currentIndex < surveyDataList.length - 1 ? _nextSurvey : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.appMainColor,
                      textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
