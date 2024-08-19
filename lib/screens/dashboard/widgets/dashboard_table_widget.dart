import 'package:flutter/material.dart';

import '../../utils/appcolor.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({super.key,
    required this.jpPlanned,
    required this.specialPlanned,
    required this.jpHours,
    required this.totalPlanned,
    required this.jpFinished,
    required this.specialFinished,
    required this.totalFinished,
    required this.totalHours,
  });

  final int jpPlanned;
  final int jpHours;
  final int specialPlanned;
  final int totalPlanned;
  final int jpFinished;
  final int specialFinished;
  final int totalFinished;
  final int totalHours;

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
          borderRadius:
          const BorderRadius.all(Radius.circular(7)),
          color: MyColors.appMainColor),
      children: [
        const TableRow(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5)),

                color: MyColors.appMainColor),
            children: [
              Padding(
                padding: EdgeInsets.all(9.0),
                child: Text(
                  "Visits",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Planned",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Finished",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Hours",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ]),
        TableRow(children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              'JP',
            ),
          ),
          Padding(
            padding:  const EdgeInsets.all(8.0),
            child: Text(widget.jpPlanned.toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.jpFinished.toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.jpHours
                .toString()),
          ),
        ]),
        TableRow(children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text('Special'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.specialPlanned
                .toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.specialFinished.toString()),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(""),
          ),
        ]),
        TableRow(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                color: MyColors.appMainColor2),
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, top: 8.0),
                child: Text(
                  'Total',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.totalPlanned.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.totalFinished.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.totalHours.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ]),
      ],
    );
  }
}
