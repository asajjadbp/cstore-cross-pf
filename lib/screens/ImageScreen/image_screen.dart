import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key,required this.pdfUrl});

  final String pdfUrl;

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  String storeName = "";
  String userName = "";

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    storeName = sharedPreferences.getString(AppConstants.storeEnNAme)!;
    userName = sharedPreferences.getString(AppConstants.userName)!;
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    print("PDF Viewer List");
    print(widget.pdfUrl);
    return Scaffold(
      appBar: generalAppBar(context, storeName, userName , (){
        Navigator.of(context).pop();
      }, (){
      }, true, false, false),
      body: Container(
        margin: const EdgeInsets.all(5),
        color: MyColors.whiteColor,
        child: SfPdfViewer.network(
            widget.pdfUrl,
          key: _pdfViewerKey,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails pdfDocumentLoadFailedDetails) {
          Navigator.of(context).pop();
          print(pdfDocumentLoadFailedDetails.error.toString());
          ToastMessage.errorMessage(context, "Pdf Not Found");
        },
        )
      ),
    );
  }
}
