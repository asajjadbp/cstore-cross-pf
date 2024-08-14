import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstore/screens/utils/app_constants.dart';
import 'package:cstore/screens/utils/appcolor.dart';
import 'package:cstore/screens/utils/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';

import '../widget/app_bar_widgets.dart';
import '../widget/loading.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key,required this.pdfUrl,required this.type});

  final String pdfUrl;
  final String type;


  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  String storeName = "";
  String userName = "";

  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          widget.pdfUrl),
      // closedCaptionFile: _loadCaptions(),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generalAppBar(context, storeName, userName , (){
        Navigator.of(context).pop();
      }, (){
      }, true, false, false),
      body: Container(
        margin: const EdgeInsets.all(5),
        color: MyColors.whiteColor,
        child: widget.type == "PDF" ? SfPdfViewer.network(
            widget.pdfUrl,
          key: _pdfViewerKey,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails pdfDocumentLoadFailedDetails) {
          Navigator.of(context).pop();
          print(pdfDocumentLoadFailedDetails.error.toString());
          ToastMessage.errorMessage(context, "Pdf Not Found");
        },
        ) : widget.type == "IMAGE" ? CachedNetworkImage(
          imageUrl: widget.pdfUrl,
          fit: BoxFit.cover,
          imageBuilder: (context, imageProvider) {
            return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fitWidth)));
          },
          placeholder: (context, url) => Container(
              width: 20,
              height: 10,
              alignment: Alignment.center,
              child: MyLoadingCircle()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ) : Container(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                ClosedCaption(text: _controller.value.caption.text),
                _ControlsOverlay(controller: _controller),
                VideoProgressIndicator(_controller, colors: const VideoProgressColors(bufferedColor: MyColors.disableColor,playedColor:MyColors.appMainColor2),allowScrubbing: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
