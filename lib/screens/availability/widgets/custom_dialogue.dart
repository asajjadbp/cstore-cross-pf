import 'dart:io';

import 'package:cstore/screens/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'counter_widget.dart';

class CustomDialog extends StatefulWidget {
  final int badgeNumber;
  final String title;
  final bool isButtonActive;
  final TextEditingController textEditingController;
  final Function(String value) pickListValue;

  CustomDialog({
    required this.badgeNumber,
    required this.isButtonActive,
    required this.title,
    required this.textEditingController,
    required this.pickListValue,
  });

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 150,
        width: 100,
        decoration: const BoxDecoration(
          color: MyColors.whiteColor,
        ),
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: MyColors.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    "assets/icons/close.svg",
                    height: 30,
                    width: 30,
                  ),
                )
              ],
            ),
            CounterWidget(
              isButtonsActive: widget.isButtonActive,
              title: '',
              onIncrement: () {
                widget.textEditingController.text = (int.parse(widget.textEditingController.text) + 1).toString();
              },
              onDecrement: () {
                if(int.parse(widget.textEditingController.text) > 0) {
                  widget.textEditingController.text = (int.parse(widget.textEditingController.text) - 1).toString();
                }
              },
              valueController: widget.textEditingController,
              onChange: (value){
                widget.textEditingController.text = value;
              },
            ),
            InkWell(
              onTap: widget.isButtonActive ? () {
                widget.pickListValue(widget.textEditingController.text);
              } : null,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration:  BoxDecoration(
                    color: widget.isButtonActive ? MyColors.appMainColor : MyColors.darkGreyColor ,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                alignment: Alignment.center,
                child: const Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: MyColors.whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDetailsDialogue extends StatefulWidget {
  const CustomDetailsDialogue({super.key,
    required this.title,
    required this.shelfNo,
    required this.bayNo,
    required this.hFacings,
    required this.vFacings,
    required this.dFacings,
    required this.pog,
    required this.pogOnTap,
  });

  final String title;

  final String shelfNo;
  final String bayNo;
  final String hFacings;
  final String vFacings;
  final String dFacings;
  final String pog;
  final Function pogOnTap;

  @override
  State<CustomDetailsDialogue> createState() => _CustomDetailsDialogueState();
}

class _CustomDetailsDialogueState extends State<CustomDetailsDialogue> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height/3.5,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: MyColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: MyColors.blackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset(
                      "assets/icons/close.svg",
                      height: 30,
                      width: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Container(
               margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  elevation: 5,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(color: MyColors.whiteColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                         const Text("Shelf No:",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                          Text(widget.shelfNo,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)
                        ],),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(color: MyColors.rowGreyishColor),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("Bay No:",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                          Text(widget.bayNo,style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)
                        ],),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(color: MyColors.whiteColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("H Facings:",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                          Text(widget.hFacings,style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)
                        ],),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(color: MyColors.rowGreyishColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("V Facings:",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                          Text(widget.vFacings,style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)
                        ],),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(color: MyColors.whiteColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("D Facings:",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                          Text(widget.dFacings,style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w400),)
                        ],),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(color: MyColors.rowGreyishColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("POG:",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                          InkWell(
                              onTap: () {
                                widget.pogOnTap();
                              },
                              child: Text(widget.pog,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize: 12,fontWeight: FontWeight.w400),))
                        ],),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
