import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyLoadingCircle extends StatefulWidget {
  const MyLoadingCircle({super.key});

  @override
  State<MyLoadingCircle> createState() => _MyLoadingCircleState();
}

class _MyLoadingCircleState extends State<MyLoadingCircle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: SpinKitCircle(
            // color: Colors.red,
            size: 60.0,
            itemBuilder: (BuildContext context, int index) {
              return const CircleAvatar();
              // return DecoratedBox(
              //   decoration: BoxDecoration(color: Colors.red
              //       // /:
              //       // Colors.green,
              //       ),
              // );
            },
            // controller: AnimationController(vsync: this.context, duration: const Duration(milliseconds: 1200)
            // )
          ),
        ),
      ),
    );
  }
}
