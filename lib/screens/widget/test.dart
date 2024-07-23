// import 'package:cstore/Model/database_model/dashboard_model.dart';
// import 'package:cstore/Model/database_model/trans_photo_model.dart';
// import 'package:cstore/database/db_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
//
// import '../../database/table_name.dart';
//
// class TestWidget extends StatefulWidget {
//   const TestWidget({super.key});
//
//   @override
//   State<TestWidget> createState() => _TestWidgetState();
// }
//
// class _TestWidgetState extends State<TestWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         margin: const EdgeInsets.only(top: 50),
//         child: Row(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 // await DatabaseHelper.delete_table(TableName.tbl_trans_photo);
//                 var st = await DatabaseHelper.getTransPhoto();
//                 print(st);
//                 // print(st[0].img_name);
//                 // DatabaseHelper.delete_table(TableName.tbl_agency_dashboard);
//                 // DatabaseHelper.insertAgencyDashboard(AgencyDashboardModel(
//                 //     en_name: 'Befor Fixing',
//                 //     ar_name: '',
//                 //     icon: 'box',
//                 //     start_date: '06/5/2024',
//                 //     end_date: '06/5/2024',
//                 //     status: 1));
//               },
//               child: const Text("Read"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await DatabaseHelper.delete_table(TableName.tbl_trans_photo);
//                 // var st = await DatabaseHelper.getCategoryList();
//                 // print(st.length);
//                 // await DatabaseHelper.insertTransPhoto(TransPhotoModel(
//                 //     client_id: 1,
//                 //     photo_type_id: 1,
//                 //     cat_id: 1,
//                 //     img_name: "22424",
//                 //     gcs_status: 0));
//                 // print(st);
//               },
//               child: const Text("Insert"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
