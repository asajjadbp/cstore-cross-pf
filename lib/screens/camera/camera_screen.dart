// import 'package:cstore/screens/utils/appcolor.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
//
// class CameraPage extends StatefulWidget {
//   final Function(XFile) onImageCaptured;
//
//   const CameraPage({super.key, required this.onImageCaptured});
//
//   @override
//   _CameraPageState createState() => _CameraPageState();
// }
//
// class _CameraPageState extends State<CameraPage> {
//   late CameraController _controller;
//   late Future<void> _initializeCameraFuture;
//   int _cameraIndex = 0; // 0 for rear camera, 1 for front camera
//
//   bool isLoading = true;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     setState(() {
//       isLoading = true;
//     });
//     final cameras = await availableCameras();
//     _controller = CameraController(cameras[_cameraIndex], ResolutionPreset.high);
//     _initializeCameraFuture =  _controller.initialize();
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   void _toggleCamera() async {
//     setState(() {
//       isLoading = true;
//     });
//     final cameras = await availableCameras();
//     _cameraIndex = (_cameraIndex + 1) % cameras.length;
//     await _controller.dispose();
//     _controller = CameraController(cameras[_cameraIndex], ResolutionPreset.medium);
//     await _controller.initialize();
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Camera'),
//       ),
//       body: isLoading ? Container(
//         color: MyColors.blackColor,
//         margin:const EdgeInsets.all(20),
//         height: MediaQuery.of(context).size.height/1.3,
//       ) : Column(
//         children: [
//           Expanded(
//             child: Container(
//               margin:const EdgeInsets.all(20),
//               child: FutureBuilder<void>(
//                 future: _initializeCameraFuture,
//                 builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     return CameraPreview(_controller);
//                   } else {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                 },
//               ),
//             ),
//           ),
//           Container(
//             margin:const EdgeInsets.all(10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FloatingActionButton(
//                   backgroundColor: MyColors.appMainColor,
//                   onPressed: _toggleCamera,
//                   child: const Icon(Icons.cameraswitch),
//                 ),
//                 const SizedBox(width: 20),
//                 FloatingActionButton(
//                   backgroundColor: MyColors.appMainColor,
//                   onPressed: _takePicture,
//                   child: const Icon(Icons.camera_alt),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Future<void> _takePicture() async {
//     if (!_controller.value.isInitialized) {
//       return;
//     }
//     if (!_controller.value.isTakingPicture) {
//       final XFile picture = await _controller.takePicture();
//       widget.onImageCaptured(picture);
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
// }