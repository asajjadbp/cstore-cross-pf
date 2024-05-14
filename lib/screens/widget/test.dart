import 'package:cstore/Model/database_model/dashboard_model.dart';
import 'package:cstore/database/db_helper.dart';
import 'package:flutter/material.dart';

import '../../database/table_name.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                DatabaseHelper.delete_table(TableName.tbl_agency_dashboard);
                // DatabaseHelper.insertAgencyDashboard(AgencyDashboardModel(
                //     en_name: 'Befor Fixing',
                //     ar_name: '',
                //     icon: 'box',
                //     start_date: '06/5/2024',
                //     end_date: '06/5/2024',
                //     status: 1));
              },
              child: const Text("Insert"),
            ),
            ElevatedButton(
              onPressed: () async {
                var st = await DatabaseHelper.getCategoryList();
                print(st.length);
                // print(st);
              },
              child: const Text("Read"),
            ),
          ],
        ),
      ),
    );
  }
}
