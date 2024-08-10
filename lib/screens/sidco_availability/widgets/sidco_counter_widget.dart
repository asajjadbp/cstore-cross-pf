
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/appcolor.dart';

class SidcoCounterWidget extends StatefulWidget {
  const SidcoCounterWidget(
      {super.key,
      required this.title,
      required this.isButtonsActive,
      required this.onIncrement,
      required this.onDecrement,
      required this.valueController,
        required this.onChange,});

  final String title;
  final bool isButtonsActive;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Function (String value) onChange;
  final TextEditingController valueController;

  @override
  State<SidcoCounterWidget> createState() => _SidcoCounterWidgetState();
}

class _SidcoCounterWidgetState extends State<SidcoCounterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: MyColors.blackColor),
          ),
          Container(
            height: 30,
            width: 160,
            decoration: BoxDecoration(
              color: MyColors.whiteColor,
              border:
                  Border.all(width: 1, color: MyColors.whiteColor),
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: widget.isButtonsActive ? widget.onDecrement : null,
                  child: Image.asset(
                    "assets/icons/decre.png",
                    color: !widget.isButtonsActive ? MyColors.whiteColor : null,
                    cacheHeight: 20,
                    cacheWidth: 20,
                  ),
                ),
                Container(
                    height: 30,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      //color: AppColors.white,
                      border: Border(
                        left: BorderSide(
                          color: MyColors.whiteColor,
                          // Choose the color you want for the border
                          width: 3.0, // Adjust the width of the border
                        ),
                        right: BorderSide(
                          color: MyColors.whiteColor,
                          // Choose the color you want for the border
                          width: 3.0, // Adjust the width of the border
                        ),
                      ),
                    ),
                    child: TextFormField(
                      showCursor: widget.isButtonsActive,
                      enableInteractiveSelection:false,
                      readOnly:!widget.isButtonsActive,
                      onChanged: (value) {
                        print(value);
                        widget.onChange(value);
                      },
                      controller: widget.valueController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*'))],
                      style: const TextStyle(
                        color: MyColors.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                InkWell(
                  onTap:  widget.isButtonsActive ? widget.onIncrement : null,
                  child: Image.asset(
                    "assets/icons/incre.png",
                    color: !widget.isButtonsActive ? MyColors.whiteColor : null,
                    cacheHeight: 20,
                    cacheWidth: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          )
        ]);
  }
}
