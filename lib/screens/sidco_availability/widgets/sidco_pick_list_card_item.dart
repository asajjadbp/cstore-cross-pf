import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../utils/appcolor.dart';
import '../../widget/drop_downs.dart';
import '../../widget/loading.dart';
import 'sidco_counter_widget.dart';

class SidcoPickListCardItem extends StatefulWidget {
  SidcoPickListCardItem({
    super.key,
    required this.imageName,
    required this.brandName,
    required this.pickerName,
    required this.skuName,
    required this.isButtonActive,
    required this.isReasonShow,
    required this.requiredPickItems,
    required this.onChange,
    required this.isAvailable,
    required this.onItemSelected,
    required this.dropdownList,
    required this.textEditingController,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSaveClick,
    required this.pickListSendTime,
    required this.pickListReceiveTime,
    required this.reasonValue,
  });

  final String imageName;
  final String brandName;
  final String skuName;
  final String pickerName;
  final bool isAvailable;
  final bool isButtonActive;
  final bool isReasonShow;
  final String requiredPickItems;
  final Function(dynamic value) onChange;
  final Function(dynamic value) onItemSelected;
  final List<String> dropdownList;
  final List<String> reasonValue;

  final TextEditingController textEditingController;
  final Function onIncrement;
  final Function onSaveClick;
  final Function onDecrement;
  final String pickListSendTime;
  final String pickListReceiveTime;

  @override
  State<SidcoPickListCardItem> createState() => _SidcoPickListCardItemPickListCardItemState();
}

class _SidcoPickListCardItemPickListCardItemState extends State<SidcoPickListCardItem> {
  bool isVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: CachedNetworkImage(
                  imageUrl: widget.imageName,
                  width: 80,
                  height: 100,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fitWidth)));
                  },
                  placeholder: (context, url) => const SizedBox(
                      width: 20, height: 10, child: MyLoadingCircle()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          widget.skuName,
                          style: const TextStyle(
                              color: MyColors.appMainColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.brandName,
                              style: const TextStyle(
                                  color: MyColors.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      if(widget.isButtonActive)
                        SidcoCounterWidget(
                          isButtonsActive: widget.isButtonActive,
                          title: "Ready pieces",
                          onIncrement: () {
                            widget.onIncrement();
                          },
                          onDecrement: () {
                            widget.onDecrement();
                          },
                          valueController: widget.textEditingController,
                          onChange: (value) {
                            widget.onChange(value);
                          }),
                      if(!widget.isButtonActive)
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: MyColors.disableColor,
                            borderRadius: BorderRadius.all(Radius.circular(3))
                        ),
                        child: Row(
                          children: [
                            const Text("Ready Pieces",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12),),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: MyColors.appMainColor,
                                  borderRadius: BorderRadius.all(Radius.circular(100))
                              ),
                              child: Text(widget.textEditingController.text,
                                style: const TextStyle(color: MyColors.whiteColor,fontSize: 11,fontWeight: FontWeight.w500),),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.pickerName.isNotEmpty,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.pickerName,
                                style: const TextStyle(
                                    color: MyColors.blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Expanded(child: Row(
                              children: [
                                const Icon(Icons.schedule_send_rounded,color: MyColors.appMainColor2,),
                                Expanded(child: Text(": ${widget.pickListSendTime}"))
                              ],
                            )),
                            const SizedBox(width: 5,),
                            Expanded(child: Row(
                              children: [
                                const Icon(Icons.access_time,color: MyColors.appMainColor2,),
                                Expanded(child: Text(": ${widget.pickListReceiveTime}"))
                              ],
                            )),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.isReasonShow,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: UnitDropDownWithInitialValue(
                            initialValue: widget.reasonValue,
                              hintText: "Reason",
                              unitData: widget.dropdownList,
                              onChange: (value) {
                                widget.onItemSelected(value);
                              }),
                        ),
                      ),
                      if(widget.isButtonActive)
                        InkWell(
                          onTap: widget.isButtonActive
                              ? () {
                            widget.onSaveClick();
                          }
                              : null,
                          child: Container(
                              alignment: Alignment.center,
                              height: widget.isButtonActive ? 35 : 0,
                              margin: const EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                  color: widget.isButtonActive
                                      ? MyColors.appMainColor
                                      : MyColors.whiteColor,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    color: MyColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                    ],
                  ))
            ],
          ),
          Positioned(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: MyColors.backbtnColor,
                        borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(10))),
                    child: Text(
                      "Req ${widget.requiredPickItems} pc",
                      style: const TextStyle(color: MyColors.whiteColor,fontSize: 12,fontWeight: FontWeight.bold),
                    ),
                  ),
                  widget.isAvailable
                      ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                      : const Icon(
                    Icons.pending,
                    color: Colors.red,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
