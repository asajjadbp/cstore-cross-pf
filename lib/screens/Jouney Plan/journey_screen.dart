import 'package:cstore/screens/Jouney%20Plan/journey_plan.dart';
import 'package:flutter/material.dart';

class VisitPoolScreen extends StatelessWidget {
  const VisitPoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journey Plan"),
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (ctx, i) {
            return const JourneyPlan();
          }),
    );
  }
}
